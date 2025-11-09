# Ensure the build directory exists
mkdir -Force .\build

# Path to the conference reference template (A4)
$templatePath = Join-Path -Path (Get-Location) -ChildPath 'template-a4.docx'

# Build the Pandoc command. If the template exists, use it as a reference doc so Word styles/margins are applied.
if (Test-Path $templatePath) {
	$pandocCmd = 'pandoc .\paper.md -o .\build\paper.docx --from gfm --toc --reference-location=block --reference-doc="' + $templatePath + '"'
	Write-Host "Using reference template: $templatePath"
} else {
	$pandocCmd = "pandoc .\paper.md -o .\build\paper.docx --from gfm --toc --reference-location=block"
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
} else {
	Write-Host "Pandoc did not produce .\build\paper.docx. Check Pandoc installation and the command in .\build\export-command.txt" -ForegroundColor Red
	exit 1
}