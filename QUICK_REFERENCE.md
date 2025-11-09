# Quick Reference Card

## Convert Paper (1 command)

```powershell
.\convert_to_docx.ps1
```

**Output:** `build/paper.docx` (IEEE two-column format)

---

## Verify Format (1 command)

```powershell
python verify_format.py .\build\paper.docx
```

**Checks:** Two-column layout, abstract, references, content length

---

## Complete Workflow (3 steps)

```powershell
# 1. Edit the paper
notepad paper.md

# 2. Convert to DOCX
.\convert_to_docx.ps1

# 3. Verify format
python verify_format.py .\build\paper.docx
```

---

## Paper Format Requirements

### Title & Author (Plain Text)
```
Paper Title

Author Name
*Department*
*Institution*
City, Country
email@example.com
```

### Abstract & Keywords
```
*Abstract*—Your abstract text (150-200 words).

*Keywords*—keyword1, keyword2, keyword3
```

### Sections
```
# Main Section      (Heading 1)
## Subsection       (Heading 2)
### Sub-subsection  (Heading 3)
```

### References
```
##### References

1. First reference...
2. Second reference...
```

---

## Common Issues

| Problem | Solution |
|---------|----------|
| YAML parsing error | Remove `---` front matter, use plain text title |
| Single column output | Post-processing should fix automatically |
| Pandoc not found | Install from https://pandoc.org/installing.html |
| Template not found | Ensure `template-a4.docx` exists in repo root |

---

## File Locations

- **Input:** `paper.md` (edit this)
- **Output:** `build/paper.docx` (submit this)
- **Metadata:** `build/export-command.txt` (reproducibility)
- **Template:** `template-a4.docx` (reference doc)

---

## Verification Checklist

- [ ] Two-column layout
- [ ] Abstract present
- [ ] References present
- [ ] Proper content length (>5000 characters)
- [ ] IEEE format compliance

---

## Quick Test

```powershell
# Full end-to-end test
.\convert_to_docx.ps1
python verify_format.py .\build\paper.docx
```

Expected output: `All critical checks PASSED ✓`

---

## Status Indicators

- ✓ Green check — Success
- ⚠ Yellow warning — Non-critical issue
- ✗ Red X — Failure, action required

---

## Support

- **Documentation:** `README.md`
- **Detailed guide:** `.github/copilot-instructions.md`
- **Completion summary:** `COMPLETION_SUMMARY.md`

---

**Last Updated:** November 9, 2025  
**System Status:** ✓ OPERATIONAL
