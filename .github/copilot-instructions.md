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

**Confirmed working approach:** Pandoc with the IEEE conference Word template as a reference document, followed by post-processing to enforce two-column layout.

**To convert paper.md to paper.docx:**

```powershell
# Run the conversion script
.\convert_to_docx.ps1
```

This script performs the following steps:

1. **Creates the build directory** if it doesn't exist
2. **Runs Pandoc** with the correct options:
   - `--from markdown` (not gfm - YAML front matter not needed/supported)
   - `--reference-doc="template-a4.docx"` (applies IEEE conference template)
   - `--reference-location=block` (places references at end)
3. **Post-processes the .docx** to enforce two-column layout by:
   - Extracting the .docx (which is a ZIP archive)
   - Modifying `word/document.xml` to set `<w:cols w:num="2" w:space="708" w:sep="0" />`
   - Re-packaging the modified document
4. **Records metadata** in `build/export-command.txt` for reproducibility

**Verification:**

After conversion, verify format compliance:

```powershell
python verify_format.py .\build\paper.docx
```

The verification script checks:
- Two-column layout specification
- Presence of Abstract and References
- Document structure and content length

**Format Requirements (from template-a4.docx):**

- **Paper size:** A4 (210mm × 297mm)
- **Layout:** Two-column with 708 twips spacing
- **Margins:** As specified in template
- **Title block:** Plain text (no YAML front matter)
  - Title on first line
  - Author name, affiliation, location, email on following lines
- **Abstract:** Italic prefix "*Abstract*—" followed by 150-200 words
- **Keywords:** Italic prefix "*Keywords*—" followed by comma-separated terms
- **Sections:** Use `#` for top-level headings (Introduction, Method, etc.)
- **Subsections:** Use `##`, `###` etc. for nested headings
- **References:** Use `#####` heading level with "(Heading 5)" style
- **Figures:** Place in `figures/` directory, reference with standard Markdown syntax
- **Tables:** Use standard Markdown table syntax

**Important Notes:**

- Do NOT use YAML front matter (causes Pandoc parsing errors with `--from markdown`)
- Title and author information should be plain text at the start of the document
- The template (`template-a4.docx`) provides IEEE-style formatting
- Post-processing automatically adds two-column layout if not present in template
- All conversions are logged in `build/export-command.txt` for reproducibility

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
