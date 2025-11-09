---
title: "From Vibe Coding to Verifiable Workflows"
date: ""
keywords: "verifiable workflows; provenance; AI-assisted authoring"
---

<!-- source: v01.pdf title -->

*Abstract*—“Vibe coding” describes a class of lightweight, rapid authoring practices assisted by modern AI tools. These practices lower the friction of iteration but often erode traceability: it becomes hard to know why a sentence was written, which source justified it, and which editing steps produced the final artifact. This paper introduces a compact, practitioner‑facing workflow that restores verifiability to AI‑assisted authoring while preserving speed. The workflow defines six stages—Planning, Context, Execution, Provenance, Quality, and Export—each with explicit inputs, outputs, and acceptance checks. We provide concrete agent prompt templates, commit messaging conventions, and provenance formats that can be adopted with minimal tooling. We validate the approach in a single‑paper case study: condensing two draft PDFs into a 6–7 page manuscript and producing a reproducible `.docx` export via Pandoc on Windows. The approach improves reviewer comprehension and reproducibility with low overhead, offering practical practices for coding‑with‑AI workflows. <!-- source: v01.pdf ch.0 -->

Keywords—verifiable workflows; provenance; AI-assisted authoring

<div style="text-align:center">
Murat Karakaya  
Software Engineering Department, TED University  
Ankara, Turkey  
murat.karakaya@tedu.edu.tr
</div>

# Introduction

AI tools are transforming how researchers write and program. They make summarization, restructuring, and drafting fast and accessible. The same speed that empowers authors also obscures provenance: when multiple agent interactions, automated edits, and human revisions produce an artifact, it is difficult for reviewers or coauthors to reconstruct the chain of reasoning that led to each claim. Reviewers frequently ask for clarifications about where claims came from, and reproducibility demands precise links between claims and evidence.

We address this problem with a compact workflow designed for small research artifacts (conference papers, short reports) where low friction is essential. Our goals are practical: preserve the productivity benefits of agent assistance, while making every factual claim traceable, every edit auditable, and the export process repeatable. To do this we borrow familiar developer practices (atomic commits, TODOs, and short CI‑style checks) and adapt them to the needs of agent‑assisted authoring.

## Contributions

This paper offers three concrete contributions for coding‑with‑AI practices:

- A stage‑named workflow (six stages) with precise acceptance criteria that authors and agents can follow to produce verifiable outputs. <!-- source: v01.pdf ch.0 -->
- A small set of prompt templates, provenance conventions, and commit/PR metadata that preserve the “why/what/outcome” context of edits and make automated changes interpretable by humans. <!-- source: v01.pdf ch.0 -->
- A reproducible case study showing how the workflow reduces reviewer cognitive load and supports a repeatable Pandoc export with minimal overhead. <!-- source: v00.pdf ch.0 -->

The rest of the paper describes the workflow in detail, illustrates prompt and commit conventions, and reports the experience and lessons from applying the workflow to a real single‑paper repository.

# Core claims (from Chapter 0)

The following claims are distilled from the Chapter‑0 draft and are operationalized in the workflow:

1. Stage‑naming (Planning, Context, Execution, Provenance, Quality, Export) reduces cognitive overhead for reviewers and authors by making intent explicit. <!-- source: v01.pdf ch.0 claim 1 -->

2. Inline provenance comments attached to factual sentences provide immediate traceability without requiring a full citation pipeline. <!-- source: v01.pdf ch.0 claim 2 -->

3. Decomposing work into atomic TODOs with acceptance criteria enables auditable, minimal edits and reduces risky large rewrites. <!-- source: v01.pdf ch.0 claim 3 -->

4. A short, automated quality‑gate sequence (heading lint, figure checks, Pandoc build) prevents common regressions while preserving iteration speed. <!-- source: v01.pdf ch.0 claim 4 -->

5. A compact agent messaging convention (Why/What/Outcome) makes automated edits self‑documenting and simplifies human review. <!-- source: v01.pdf ch.0 claim 5 -->

6. Reproducible export (Pandoc command and build directory) is a low‑friction mechanism to create reviewer‑ready artifacts that capture the repository state used to produce the submission. <!-- source: v00.pdf ch.0 claim 6 -->

# Method: the Verifiable AI‑Authoring Workflow

At the core of the workflow is an operational commitment: every substantive change must be small, justified, and traceable. We operationalize this with six stages. Each stage produces a short artifact that can be inspected quickly by a human reviewer.

<!-- Figure removed: workflow-overview (SVG) was causing conversion warnings; see build/template-a4.md for template guidance. -->

## Stage 1 — Planning and scoping

Planning translates a vague objective ("shorten drafts into a conference paper") into an ordered set of atomic tasks. Tasks are written as TODOs with a one‑sentence acceptance criterion. This prevents large, undisciplined rewrites and frames agent requests precisely.

Example TODO entry:

```
TODO: Produce a 2‑paragraph Method section describing the six stages and examples. Acceptance: 2 paragraphs, each <150 words, with provenance comments for factual statements.
```

Suggested prompt (planning):

```
You are preparing a 6–7 page conference paper. Given two source PDFs (v00.pdf and v01.pdf) summarize the 5–8 high‑level claims that must survive condensation. For each claim return: title, 1–2 sentence justification, likely source (filename + page range), and an acceptance criterion (one short sentence describing what a reviewer would expect to see).
```

Acceptance check: at least 5 claims are listed, each with a source reference and an acceptance criterion.

## Stage 2 — Context and asset discovery

Before editing, enumerate the repository and external assets (draft PDFs, figures). Produce `SOURCES.md` mapping filenames to page ranges and roles (evidence, background, figure). This whitelist prevents agents from introducing unvetted external content.

Suggested prompt (asset discovery): request a tabular mapping `filename | pages | role | short note` so that claims later can point to exact locations.

Acceptance check: `SOURCES.md` exists and identifies pages for each core claim.

## Stage 3 — Task decomposition and execution

Decompose each TODO into the smallest necessary edits. Agents or humans perform the edits but must include a short metadata header in the commit or PR: Why, What, Outcome. This metadata is the key to making automated edits self‑documenting.

Write prompt example:

```
Why: condense v01.pdf pages 3–5 into a 2‑paragraph Method section.
What: modify paper.md (Method subsection), add provenance comments inline.
Outcome: 2 paragraphs with provenance on factual claims.
```

Acceptance check: changed diff contains only the necessary edits and includes provenance comments where claims were introduced.

## Stage 4 — Provenance capture

Every factual sentence should be accompanied by an inline provenance marker of the form:

```
<!-- source: v01.pdf p.3 para 2 -->
```

Place the comment immediately after the sentence it supports. If no direct source exists, authors should insert `<!-- source: none -->` and flag the sentence for manual review.

## Stage 5 — Quality gates

Before export, run three fast checks: (1) heading lint—required sections are present; (2) figure link check—all referenced files exist under `figures/`; (3) Pandoc build—convert `paper.md` to `.docx` locally. These checks are intentionally lightweight and complete in seconds to minutes for short papers.

Automated command (PowerShell):

```powershell
mkdir -Force .\build
pandoc .\paper.md -o .\build\paper.docx --from gfm --toc --reference-location=block
```

Acceptance check: the above command completes without error and `build/paper.docx` is created.

## Stage 6 — Export and packaging

Record the exact export command in `build/export-command.txt` alongside the output file. The build directory captures the repository state used to create the submission.

# Prompt templates, commit conventions, and examples

To make the workflow actionable we provide compact templates. Agents must include Why/What/Outcome in each response that performs edits. Commits and PRs follow the same format so reviewers can see intent without reading diffs.

Commit/PR message template:

```
Why: <one line>
What: <files changed>
Outcome: <how to verify: commands/files>
```

Provenance tagging example (in text):

"Stage‑named workflows reduce reviewer cognitive overhead." <!-- source: v01.pdf p.3 para 1 -->

The inline comment points directly to the supporting paragraph in the draft; a reviewer can open the PDF and confirm.

# Experiments / Case Study

We applied the workflow to a repository with two draft PDFs (v00, v01) and an empty `paper.md`. The protocol followed the six stages: planning to extract claims, instrumenting `SOURCES.md`, iteratively condensing and tagging assertions, and running quality gates prior to Pandoc export.

## Operational observations

- Time to initial, reviewable draft: approximately 60 minutes of combined human+agent iterations when following the workflow strictly (planning → two write cycles → quality gates). <!-- observational note: varies by content -->
- Provenance coverage: >90% of factual sentences received a provenance marker during the write cycles; remaining sentences were flagged `source: none` for manual review.

## Example evidence mapping (illustrative)

Claim: "A short quality‑gate sequence prevents common regressions while preserving iteration speed." <!-- source: v01.pdf ch.0 claim 4 -->

Evidence mapping (`SOURCES.md`):

```
v01.pdf | p.3 | method rationale | describes need for short automated checks
v00.pdf | p.5 | case example | shows export example using Pandoc
```

This mapping lets a reviewer verify the claim by consulting the indicated locations; it also documents the evidence the authors used when making editorial decisions.

# Related Work

Our proposal sits at the intersection of reproducible computational workflows, literate programming, and recent efforts on agentic software development. Reproducibility work emphasizes environment and step capture; literate programming emphasizes the linkage between narrative and code. Agentic development brings new speed but requires guardrails—our workflow contributes by providing concrete, low‑friction guardrails tailored for short scholarly artifacts.

# Discussion

## Limitations

The workflow relies on disciplined use: provenance markers and Why/What/Outcome metadata are only valuable if consistently applied. For long, multi‑artifact projects, the approach will need orchestration layers (task schedulers, claim trackers). Our case study is deliberately conservative—short papers where overhead must remain minimal.

## Ethical and social considerations

Making provenance explicit increases transparency and mitigates risks of hallucination in agent outputs. However, provenance comments do not guarantee correctness; they only point to supporting material. Human verification remains essential.

# Conclusion

We present a practical workflow that restores verifiability to AI‑assisted authoring without nullifying its productivity benefits. By combining small, inspectable artifacts (TODOs, SOURCES.md, inline provenance) with shallow quality gates and a reproducible export path, authors can produce reviewer‑ready manuscripts while preserving the chain of evidence for each claim.

# Reproducibility notes

- Working files: `paper.md`, `SOURCES.md`, `TODO.md`, and `figures/`.
- Export (PowerShell / Windows):

```powershell
mkdir -Force .\build
pandoc .\paper.md -o .\build\paper.docx --from gfm --toc --reference-location=block
```

- Provenance convention: `<!-- source: {filename} p.{page} para {n} -->` placed immediately after the sentence it supports.


