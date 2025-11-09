# Conference Paper Generation Workflow

This repository contains a complete workflow for generating IEEE-format conference papers from Markdown manuscripts.

## Overview

- **Source manuscript:** `paper.md` (Markdown format)
- **Output document:** `build/paper.docx` (IEEE two-column format, A4)
- **Template:** `template-a4.docx` (IEEE conference reference document)
- **Conversion tool:** Pandoc + PowerShell post-processing
- **Verification:** Python script to check format compliance

## Quick Start

### 1. Edit the Paper

Edit `paper.md` with your content. Follow the IEEE conference format:

```markdown
Paper Title Here

First Author Name
*Department*
*Institution*
City, Country
email@example.com

*Abstract*—Your abstract text here (150-200 words).

*Keywords*—keyword1, keyword2, keyword3

# Introduction

Your introduction text...

# Method

Your method description...

# Conclusion

Your conclusion...

##### References

1. Reference one...
2. Reference two...
```

### 2. Convert to DOCX

Run the conversion script:

```powershell
.\convert_to_docx.ps1
```

This will:
- Generate `build/paper.docx` with IEEE two-column formatting
- Record conversion metadata in `build/export-command.txt`
- Apply A4 paper size and template styles

### 3. Verify Format

Check that the output meets IEEE requirements:

```powershell
python verify_format.py .\build\paper.docx
```

## Files in This Repository

### Source Files
- `paper.md` — Main manuscript in Markdown format
- `template-a4.docx` — IEEE conference Word template (A4 paper)
- `template-a4.dotx` — Template source file

### Scripts
- `convert_to_docx.ps1` — PowerShell conversion script
- `verify_format.py` — Python format verification script

### Documentation
- `.github/copilot-instructions.md` — Detailed instructions for AI coding agents
- `README.md` — This file

### Output (Generated)
- `build/paper.docx` — Final conference paper
- `build/export-command.txt` — Reproducibility metadata
- `build/docx_tmp/` — Temporary extraction directory (auto-cleaned)
- `build/docx_check/` — Verification extraction directory (auto-cleaned)

## Format Requirements

### Paper Structure
- **Title:** Plain text at top (no YAML front matter)
- **Author block:** Name, affiliation, location, email
- **Abstract:** Prefixed with "*Abstract*—" in italics
- **Keywords:** Prefixed with "*Keywords*—" in italics
- **Sections:** Use `#` for main headings (Introduction, Method, etc.)
- **Subsections:** Use `##`, `###`, etc.
- **References:** Use `#####` heading level

### Page Layout
- **Paper size:** A4 (210mm × 297mm)
- **Columns:** Two columns with 708 twips spacing
- **Margins:** Per IEEE conference template
- **Page limit:** Target 6-7 pages

### Content Guidelines
- Keep sections concise (3-5 sentences per paragraph)
- Include 2-3 figures or tables maximum
- Abstract: 150-200 words
- Avoid first-person unless consistently used in source material

## Workflow Stages

The conversion process follows a verified workflow:

### Planning
- Understand IEEE format requirements
- Structure content in Markdown
- Organize figures and references

### Build
- Write `paper.md` following IEEE format
- Run `convert_to_docx.ps1`
- Generate initial output

### Evaluate
- Review output in Word
- Check visual formatting
- Iterate on content

### Verify
- Run `verify_format.py`
- Confirm two-column layout
- Check section structure
- Validate content length

### Release
- Final output in `build/paper.docx`
- Metadata in `build/export-command.txt`
- Ready for conference submission

## Technical Details

### Pandoc Conversion

The conversion uses:
```powershell
pandoc .\paper.md -o .\build\paper.docx \
  --from markdown \
  --reference-location=block \
  --reference-doc="template-a4.docx"
```

Key options:
- `--from markdown`: Use standard Markdown parser (not GFM which requires YAML)
- `--reference-doc`: Apply IEEE template styles
- `--reference-location=block`: Place references at end

### Post-Processing

After Pandoc conversion, the script:
1. Extracts the .docx file (ZIP archive)
2. Modifies `word/document.xml`
3. Sets `<w:cols w:num="2" w:space="708" w:sep="0" />`
4. Re-packages the document

This ensures proper two-column layout even if the template doesn't apply it automatically.

### Verification Checks

The verification script validates:
- ✓ Two-column layout (`w:num="2"`)
- ✓ Abstract section present
- ✓ References section present
- ✓ Sufficient content length (>5000 characters)
- ⚠ Major sections present (non-critical)

## Reproducibility

Every conversion is logged in `build/export-command.txt` with:
- Timestamp
- Exact Pandoc command
- Template file path
- Output file path

This ensures the conversion can be exactly reproduced.

## Troubleshooting

### Pandoc Not Found
Install Pandoc from: https://pandoc.org/installing.html

### YAML Parsing Error
Remove any YAML front matter (lines starting with `---`). Use plain text for title and author.

### Wrong Column Count
The post-processing script should fix this automatically. If not, check that `word/document.xml` contains:
```xml
<w:cols w:num="2" w:space="708" w:sep="0" />
```

### Python Verification Fails
Ensure Python 3 is installed and in PATH. The script uses only standard library modules.

### Template Not Found
Ensure `template-a4.docx` exists in the repository root. Do not use `template-a4.dotx` directly.

## References

- IEEE Conference Template: https://www.ieee.org/conferences/publishing/templates.html
- Pandoc Manual: https://pandoc.org/MANUAL.html
- Word XML Reference: https://learn.microsoft.com/en-us/office/open-xml/

## License

This workflow and scripts are provided as-is for academic and conference paper preparation.
