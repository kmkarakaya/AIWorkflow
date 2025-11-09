## AI coding agent guide for this repo

This repository is a single-paper workspace. Your job is to turn the two draft PDFs into a concise 6–7 page conference paper written in Markdown (`paper.md`) and export a `.docx` file using a Python-based Markdown→Docx converter available on this machine (Windows, PowerShell).

### Big picture

- Source of truth for content: `From Vibe Coding to Verifiable Workflows_v00.pdf` and `From Vibe Coding to Verifiable Workflows_v01.pdf`.
- Working manuscript: `paper.md` at repo root. Keep all writing here.
- Output: `build/paper.docx` (create the `build/` folder if absent).
- Page budget: 6–7 pages total (target 2–3 figures or tables and tight prose). Prioritize clarity and verifiability of the workflow.

### Key files and roles

- `paper.md` — main manuscript (currently empty; you will populate it).
- `From Vibe Coding to Verifiable Workflows_v00.pdf` and `_v01.pdf` — consider these drafts to mine, condense, and reorganize.

### Writing conventions (specific to this project)

- Structure (use H2 for top-level sections):
  - `## Abstract` (150–200 words) → concise problem, approach, contribution.
  - `## Introduction` → motivation, problem, contributions (bulleted), summary of results.
  - `## Method` → “AI workflow” pipeline; name stages and provide rationale; include a small diagram later if provided as an image.
  - `## Experiments / Case Study` → concrete scenario; tie to workflow benefits (traceability, repeatability, quality gates).
  - `## Related Work` → 3–5 compact paragraphs; only cite what’s essential; avoid inventing references.
  - `## Discussion` → limitations and future directions.
  - `## Conclusion` → single paragraph.
- Keep headlines terse and parallel. Prefer short paragraphs (3–5 sentences). Avoid first-person plural unless the PDF drafts do so consistently.
- Where you extract content from the PDFs, add a silent provenance comment to help future edits, e.g.: `<!-- source: v01.pdf p.3 para 2 -->`.
- Citations: there is no bibliography file; only cite if a clear reference is in the PDFs. Otherwise, write descriptively without formal citations.

### Patterns and examples

- Figure (place future images under `figures/`; create if needed):
  ```markdown
  ![Workflow overview](../figures/workflow-overview.png)
  _Figure 1. End-to-end AI workflow stages and artifacts._
  ```
- Table:
  ```markdown
  | Stage | Input | Output | Tooling |
  |---|---|---|---|
  | Planning | Problem statement | TODO list | Copilot |
  | Build | Draft manuscript | Lint + checks | Scripts |
  ```
- Math (use inline LaTeX if necessary; keep minimal): `Accuracy = (TP + TN) / (TP + TN + FP + FN)`.

### Conversion to DOCX (Windows PowerShell)

Preferred (confirmed): Pandoc with the conference Word template as a reference document. Using the template ensures the produced `.docx` matches page size (A4), margins, and styles (title block, headings, figure captions) defined by the conference.

Option A — Pandoc (recommended):

```powershell
# Ensure the build directory exists
mkdir -Force .\build

# Use the conference reference template (template-a4.docx) if available.
# Pandoc's --reference-doc option tells Word to apply the template styles to the output.
$template = '.\template-a4.docx'
if (-Not (Test-Path $template)) {
	Write-Host "Warning: reference template not found at $template. Producing plain docx without template." -ForegroundColor Yellow
	pandoc .\paper.md -o .\build\paper.docx --from gfm --toc --reference-location=block
} else {
	$cmd = "pandoc .\paper.md -o .\build\paper.docx --from gfm --toc --reference-location=block --reference-doc=\"$template\""
	Write-Host "Running: $cmd"
	Invoke-Expression $cmd

	# Record the exact export command and template used for reproducibility
	"$((Get-Date).ToString('u'))`nCommand: $cmd`nTemplate: $template`nOutput: .\build\paper.docx" | Out-File -FilePath .\build\export-command.txt -Encoding utf8
}
```

Option B — Python converter (if you prefer a Python-based tool):

```powershell
# Example patterns (pick the one that matches the installed tool)
python -m docx_converter .\paper.md -o .\build\paper.docx
python -m md2docx .\paper.md -o .\build\paper.docx
docx-converter .\paper.md -o .\build\paper.docx
```

Notes

- Keep Windows paths and PowerShell syntax.
- The conference template (`template-a4.docx`) enforces A4 paper size, margins, and style names (e.g., "Heading 1".."Heading 5", "Figure Caption", "Table Head"). Prefer using it via `--reference-doc` when available.
- Remove any template instructional text from the final `paper.md` before conversion (the Word template contains guidance sections that must not appear in the submitted paper).
- Ensure figures are placed under `figures/`, are high-resolution (prefer 300 dpi), and have captions following the template guidance (use "Fig. N" and 8pt Times New Roman for labels where applicable).
- Pandoc will apply paragraph/heading structure but will not embed fonts; if the conference requires specific fonts not present on your system, verify the produced `.docx` on a machine that has them installed or ask for the publisher's preferred reference-doc.
- The `build/export-command.txt` file records the exact command and template used for reproducibility.

### Quickstart tasks for agents

1) Skim `_v01.pdf` then `_v00.pdf`; list the 5–8 core ideas that must survive condensation.
2) Create section stubs in `paper.md` following the structure above and fill Abstract last.
3) Draft Introduction and Method first, using provenance comments for traced content.
4) Keep a strict eye on page budget—favor concise, high-signal sentences.
5) Export to `.docx` into `build/paper.docx` using the converter; iterate on formatting only after content stabilizes.

### Do / Don’t

- Do: maintain factual alignment with the PDFs; add provenance comments; keep within 6–7 pages; use simple Markdown.
- Don’t: invent citations, create new folders arbitrarily, or split the manuscript into multiple files without request.

### Open questions to confirm

- What is the exact Python converter/CLI name and (if any) the Docx template to use?
- Any publisher style constraints (fonts/margins) we should match during export?
