# Ensure the build directory exists
mkdir -Force .\build

# Path to the conference reference template (A4)
$templatePath = Join-Path -Path (Get-Location) -ChildPath 'template-a4.docx'

# Build the Pandoc command. If the template exists, use it as a reference doc so Word styles/margins are applied.
if (Test-Path $templatePath) {
	# Use the conference template with markdown format (not gfm) to better handle the IEEE format
	# --reference-location=block keeps references at the end in a block
	# --columns=2 hints at two-column layout (though mainly handled by template)
	$pandocCmd = 'pandoc .\paper.md -o .\build\paper.docx --from markdown --reference-location=block --reference-doc="' + $templatePath + '"'
	Write-Host "Using reference template: $templatePath"
} else {
	# Fallback plain conversion without template
	$pandocCmd = 'pandoc .\paper.md -o .\build\paper.docx --from markdown --reference-location=block'
	Write-Host "Reference template not found at $templatePath. Producing docx without template." -ForegroundColor Yellow
}

# Run the command
Write-Host "Running Pandoc..."

# Remove existing output if present to avoid permission errors when overwriting
$outPath = Join-Path -Path (Get-Location) -ChildPath '.\build\paper.docx'
if (Test-Path $outPath) {
	try {
		Remove-Item -LiteralPath $outPath -Force -ErrorAction Stop
	} catch {
		Write-Host "Warning: could not remove existing output file $outPath. Proceeding to run Pandoc." -ForegroundColor Yellow
	}
}

Invoke-Expression $pandocCmd

# Record reproducible export metadata
$exportRecord = [PSCustomObject]@{
	Timestamp = (Get-Date).ToString('u')
	Command = $pandocCmd
	Template = $(if (Test-Path $templatePath) { $templatePath } else { 'none' })
	Output = (Resolve-Path -LiteralPath .\build\paper.docx -ErrorAction SilentlyContinue | ForEach-Object { $_.Path } )
}

$exportRecordString = "$($exportRecord.Timestamp)`nCommand: $($exportRecord.Command)`nTemplate: $($exportRecord.Template)`nOutput: $($exportRecord.Output)`n"
$exportRecordString | Out-File -FilePath .\build\export-command.txt -Encoding utf8

if (Test-Path .\build\paper.docx) {
	Write-Host "Conversion complete. The output file is located at .\build\paper.docx" -ForegroundColor Green

	# Post-process the generated DOCX to enforce two-column layout by editing the Word document XML.
	# DOCX files are ZIP archives. We'll use .NET's System.IO.Compression instead of PowerShell cmdlets.
	try {
		Add-Type -AssemblyName System.IO.Compression.FileSystem
		
		$outDocx = Resolve-Path -LiteralPath .\build\paper.docx | Select-Object -First 1 -ExpandProperty Path
		$tmpDir = Join-Path -Path (Get-Location) -ChildPath (Join-Path -Path 'build' -ChildPath 'docx_tmp')
		if (Test-Path $tmpDir) { Remove-Item -LiteralPath $tmpDir -Recurse -Force }
		New-Item -ItemType Directory -Path $tmpDir | Out-Null

		Write-Host "Post-processing DOCX to set two-column layout..."
		
		# Extract the DOCX (which is a ZIP archive)
		[System.IO.Compression.ZipFile]::ExtractToDirectory($outDocx, $tmpDir)

		$docXmlPath = Join-Path -Path $tmpDir -ChildPath 'word\document.xml'
		if (Test-Path $docXmlPath) {
			$doc = Get-Content -Path $docXmlPath -Raw -Encoding UTF8

			# Check if columns element exists
			if ($doc -match '<w:cols[^>]*>') {
				# Replace any existing cols element with a proper two-column specification
				$doc = [regex]::Replace($doc, '<w:cols[^/]*/>', '<w:cols w:num="2" w:space="708" w:sep="0" />')
				Write-Host "Updated existing column specification to two columns"
			} elseif ($doc -match '</w:sectPr>') {
				# Insert cols element before the closing sectPr tag
				$doc = $doc -replace '</w:sectPr>', '<w:cols w:num="2" w:space="708" w:sep="0" /></w:sectPr>'
				Write-Host "Added two-column layout specification to document.xml"
			} else {
				# Fallback: append a sectPr with cols before </w:body>
				$doc = $doc -replace '</w:body>', '<w:sectPr><w:cols w:num="2" w:space="708" w:sep="0" /></w:sectPr></w:body>'
				Write-Host "Added sectPr with two-column layout to document.xml"
			}

			# Write back the modified document.xml
			[System.IO.File]::WriteAllText($docXmlPath, $doc, [System.Text.Encoding]::UTF8)

			# Repack the DOCX
			$tempRepacked = Join-Path -Path (Get-Location) -ChildPath '.\build\paper_two_col.zip'
			if (Test-Path $tempRepacked) { Remove-Item -LiteralPath $tempRepacked -Force }
			
			# Create ZIP archive from the extracted and modified contents
			[System.IO.Compression.ZipFile]::CreateFromDirectory($tmpDir, $tempRepacked)
			
			# Replace original output with the two-column version (rename .zip to .docx)
			if (Test-Path $outDocx) { Remove-Item -LiteralPath $outDocx -Force }
			Rename-Item -LiteralPath $tempRepacked -NewName 'paper.docx'

			Write-Host "Two-column layout applied to .\build\paper.docx" -ForegroundColor Green
		} else {
			Write-Host "Warning: could not find word/document.xml inside the generated DOCX; skipping two-column post-processing." -ForegroundColor Yellow
		}

		# Cleanup
		if (Test-Path $tmpDir) { Remove-Item -LiteralPath $tmpDir -Recurse -Force }
	} catch {
		Write-Host "Warning: failed to post-process DOCX for two-column layout: $($_.Exception.Message)" -ForegroundColor Yellow
		Write-Host "The document has been created but may need manual column formatting in Word." -ForegroundColor Yellow
	}
} else {
	Write-Host "Pandoc did not produce .\build\paper.docx. Check Pandoc installation and the command in .\build\export-command.txt" -ForegroundColor Red
	exit 1
}