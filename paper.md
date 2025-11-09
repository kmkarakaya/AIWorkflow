V-Flow: From Vibe Coding to Verifiable Workflows: An AI Workflow for Traceable, Repeatable Research

Murat Karakaya
*Department of Software Engineering*
*TED University*
Ankara, Türkiye
murat.karakaya@tedu.edu.tr

*Abstract*—AI-driven software development often relies on informal, human-guided experimentation—what some call "vibe coding"—which makes results hard to reproduce, audit, and build upon. This paper presents V-Flow, a compact, verifiable AI workflow that transforms exploratory development into a repeatable pipeline by combining explicit staging (planning, build, evaluate, verify, release), automated quality gates, and artifact-level provenance. The workflow emphasizes: (1) lightweight, machine-readable checkpoints that capture intent and environment; (2) modular verification steps that separate heuristic exploration from documented, auditable outcomes; and (3) tooling patterns that integrate authorship metadata, tests, and exportable artifacts to simplify review and reuse. Together, these elements reduce the effort needed to trace how a model, dataset, or result was produced while preserving the creative iteration essential to early-stage research. The approach is validated through a case study demonstrating improved traceability and reduced ambiguity in result provenance compared to typical exploratory practices.

*Keywords*—AI workflow, reproducibility, verifiability, traceability, quality gates, software engineering

<!-- source: Workflows_v01.pdf p.1-3; Workflows_v00.pdf p.2-4 -->

<!-- short-name: V-Flow; chosen 2025-11-09 -->

# Introduction

AI-assisted coding tools such as GitHub Copilot, ChatGPT, and other large language model (LLM) systems have accelerated prototyping and lowered the barrier to producing working software. That rapid creativity often takes the form of informal, iterative exploration—commonly called "vibe coding"—but these exploratory practices frequently leave gaps in provenance, rationale, and verifiability. As a result, artifacts created during AI-assisted development can be hard to reproduce, audit, or maintain.

To address these gaps we propose V-Flow, a compact, five-stage workflow that turns exploratory AI-assisted development into a verifiable, repeatable process. V-Flow explicitly separates exploratory activities (planning, build, evaluate) from formal verification and release (verify, release), and it requires lightweight, machine-readable checkpoints at each stage. By combining staged quality gates, provenance capture, and integration patterns for version control and CI, V-Flow preserves creative iteration while making it possible to trace how a model, dataset, or result was produced.

In contrast to traditional software engineering workflows—where version control, tests, and reviews are woven into the development lifecycle—AI-assisted development often skips explicit documentation of prompts, model versions, and environment details. V-Flow addresses these specific provenance gaps by (a) requiring task-level planning records that link to commits and artifacts, (b) capturing generation metadata (prompt summaries, model version, timestamps) during build, and (c) enforcing deterministic verification gates before release. This structure reduces technical debt and improves the reproducibility and auditability of AI-produced artifacts.

The remainder of the paper describes V-Flow in detail. Section II explains the workflow stages and quality gates; Section III presents a case study applying V-Flow to a manuscript conversion pipeline; Section IV situates the approach with related work; Section V discusses limitations and future directions; and Section VI concludes.

<!-- source: Workflows_v01.pdf p.1-2 -->

**Contributions.** This paper makes the following contributions:

- A five-stage AI workflow (planning, build, evaluate, verify, release) that systematizes AI-assisted development while preserving creative iteration.
- Explicit quality gates and checkpoint mechanisms that capture intent, context, and environment metadata at each stage.
- Tooling patterns and integration strategies that enable provenance tracking, automated testing, and artifact export for review and reuse.
- A case study demonstrating practical application of the workflow, showing improvements in traceability, reproducibility, and result quality compared to unstructured AI-assisted coding.

<!-- source: Workflows_v01.pdf p.2 -->

The remainder of this paper is organized as follows. Section II describes the proposed AI workflow and its stages in detail. Section III presents a case study applying the workflow to a concrete development scenario. Section IV reviews related work on reproducibility, software engineering workflows, and AI-assisted development. Section V discusses limitations and future directions, and Section VI concludes.

# Method

The proposed AI workflow consists of five stages: Planning, Build, Evaluate, Verify, and Release. Each stage has defined inputs, outputs, quality gates, and tooling support. The workflow is designed to be lightweight and adaptable, allowing developers to maintain the rapid iteration and creative exploration characteristic of AI-assisted coding while establishing checkpoints that ensure traceability and reproducibility.

<!-- source: Workflows_v01.pdf p.3-4 -->

## Planning Stage

The planning stage transforms a problem statement or feature request into a structured task list. The developer (or AI agent) uses natural language to articulate the goal, then breaks it down into concrete, actionable steps. Each task is documented with sufficient context to enable independent execution or review.

**Input:** Problem statement, feature request, or research question.

**Output:** Machine-readable task list (e.g., Markdown checklist, JSON task array) with context annotations.

**Quality gate:** Each task must be independently verifiable; ambiguous or compound tasks are flagged for decomposition.

**Tooling:** AI assistants (e.g., GitHub Copilot Chat) can generate initial task breakdowns; task management tools (e.g., GitHub Issues, Notion) can track progress.

<!-- source: Workflows_v01.pdf p.4 -->

The planning stage establishes intent and scope, creating a traceable record of what was attempted and why. This record becomes critical for later review, replication, or debugging.

## Build Stage

The build stage generates code, documentation, or other artifacts based on the task list. Developers interact with AI tools to produce drafts, which are then saved with metadata capturing the prompts, model version, and timestamp.

**Input:** Task list from planning stage.

**Output:** Draft code, scripts, documentation, or data artifacts; metadata files capturing generation context.

**Quality gate:** Generated artifacts must compile/run without critical errors; metadata files must include model version, prompt summary, and generation timestamp.

**Tooling:** IDE integrations (e.g., Copilot, Cursor), version control (e.g., Git with commit messages linking to task IDs), metadata templates.

<!-- source: Workflows_v01.pdf p.4-5 -->

By requiring metadata capture, the build stage ensures that every artifact has a traceable origin. This provenance information is essential for understanding how code was produced and for replicating results.

## Evaluate Stage

The evaluate stage applies heuristic checks and exploratory testing to assess whether the generated artifacts meet basic functional requirements. This stage is informal and iterative, allowing developers to refine prompts and regenerate code as needed.

**Input:** Draft artifacts from build stage.

**Output:** Evaluation notes, test logs, and revised artifacts.

**Quality gate:** Artifacts must pass smoke tests (e.g., basic functionality, no syntax errors); evaluation notes must document observed behavior and any issues.

**Tooling:** Unit test frameworks (e.g., pytest, Jest), linters (e.g., flake8, ESLint), manual inspection logs.

<!-- source: Workflows_v01.pdf p.5 -->

The evaluate stage distinguishes between exploratory testing and formal verification. It acknowledges that early-stage AI-generated code may require multiple iterations before reaching a verifiable state.

## Verify Stage

The verify stage applies rigorous, automated checks to confirm that artifacts meet defined quality standards. This stage is deterministic and repeatable, producing a pass/fail result for each verification criterion.

**Input:** Evaluated artifacts from evaluate stage.

**Output:** Verification report with pass/fail status for each criterion (e.g., test coverage, performance benchmarks, style compliance).

**Quality gate:** All defined verification criteria must pass; any failures block progression to release stage.

**Tooling:** Continuous integration (CI) systems (e.g., GitHub Actions, Jenkins), test coverage tools (e.g., coverage.py, Istanbul), static analysis tools (e.g., mypy, Clippy).

<!-- source: Workflows_v01.pdf p.5-6 -->

The verify stage provides the formal checkpoint that distinguishes validated artifacts from exploratory drafts. This separation is critical for reproducibility and quality assurance.

## Release Stage

The release stage packages verified artifacts for distribution, archival, or publication. Artifacts are tagged with version identifiers and accompanied by comprehensive documentation, including provenance metadata, verification results, and usage instructions.

**Input:** Verified artifacts from verify stage.

**Output:** Released package (e.g., versioned library, research dataset, paper submission) with full documentation and metadata.

**Quality gate:** Release package must include all provenance metadata, verification reports, and usage documentation; package must be accessible via stable identifier (e.g., DOI, Git tag).

**Tooling:** Package managers (e.g., PyPI, npm), archival repositories (e.g., Zenodo, OSF), documentation generators (e.g., Sphinx, MkDocs).

<!-- source: Workflows_v01.pdf p.6 -->

The release stage ensures that artifacts are not only correct but also reusable and auditable. By bundling metadata and verification results, the release package becomes a self-contained, reproducible unit.

## Workflow Integration and Automation

The five stages are designed to integrate with existing development tools and practices. Developers can adopt the workflow incrementally, starting with manual checklists and metadata files, then gradually introducing automation as familiarity and tooling mature.

Key integration points include:

- **Version control commits** linked to task IDs from the planning stage.
- **CI pipelines** that execute evaluate and verify stages automatically on each commit.
- **Metadata templates** embedded in project repositories to standardize provenance capture.
- **Documentation generators** that compile metadata, task lists, and verification reports into human-readable summaries.

<!-- source: Workflows_v01.pdf p.6-7 -->

This integration strategy minimizes friction while maximizing traceability. Developers retain the flexibility to iterate rapidly during early stages, with the assurance that verified artifacts meet defined quality standards.

# Experiments and Case Study

To validate the proposed workflow, we applied it to a real-world development scenario: creating a conference paper processing pipeline that converts Markdown manuscripts to Word documents conforming to a specific conference template. This task involves multiple stages (planning, build, evaluate, verify, release) and requires careful attention to formatting rules, metadata preservation, and tooling integration.

<!-- source: Workflows_v00.pdf p.5-7 -->

## Scenario Description

The goal was to develop a pipeline that:

1. Accepts a Markdown manuscript with structured sections (Abstract, Introduction, Method, etc.).
2. Converts the manuscript to a Word document (.docx) using Pandoc.
3. Applies a conference-specific template (two-column IEEE format, A4 paper) to ensure compliance with submission guidelines.
4. Preserves metadata (title, author, keywords) and formatting (headings, citations, figures).

The development was performed using AI-assisted coding tools (GitHub Copilot, ChatGPT) under typical working conditions, with initial attempts following an unstructured "vibe coding" approach, followed by a structured application of the proposed workflow.

<!-- source: Workflows_v00.pdf p.6 -->

## Application of the Workflow

### Planning Stage

We began by decomposing the task into discrete steps:

1. Read the conference template file to understand formatting requirements (margins, fonts, column layout).
2. Prepare a Markdown manuscript with IEEE-compliant structure (no YAML front matter, author block following template format).
3. Write a PowerShell script to invoke Pandoc with the correct options (reference document, output format).
4. Test the conversion and verify that the output matches template specifications.
5. Implement post-processing (if needed) to enforce two-column layout and other formatting rules.

Each step was documented in a task checklist with success criteria. This planning phase took approximately 15 minutes and produced a clear roadmap for implementation.

<!-- source: Workflows_v00.pdf p.6-7 -->

### Build Stage

Using the task list, we generated initial code artifacts:

- A PowerShell script (`convert_to_docx.ps1`) implementing the Pandoc conversion with error handling and metadata capture.
- A Markdown manuscript (`paper.md`) structured according to IEEE conference format.
- A metadata template capturing generation context (timestamp, Pandoc version, template path).

AI tools (GitHub Copilot) assisted with script generation, suggesting command-line options and error handling patterns. Each code block was saved with a comment noting the generating prompt and model version.

### Evaluate Stage

We tested the conversion script incrementally:

1. **Smoke test:** Run Pandoc on a minimal Markdown file to verify installation and basic functionality.
2. **Template test:** Convert the manuscript with the conference template and inspect the output for column layout, margins, and font.
3. **Metadata test:** Verify that author names, title, and keywords appear correctly in the Word document.

Several issues emerged during evaluation:

- **YAML front matter incompatibility:** The initial manuscript used YAML front matter, which caused Pandoc parsing errors with the `--from gfm` option.
- **Single-column output:** The default Pandoc conversion did not apply the two-column layout specified in the template.
- **Missing provenance metadata:** The conversion script did not record the exact command and template used.

These issues were documented in evaluation notes and guided iterative refinement.

### Verify Stage

We defined verification criteria based on the conference template requirements:

1. **Format compliance:** Output must be two-column, A4 paper, with IEEE-style headings.
2. **Content preservation:** All sections, figures, and tables from Markdown must appear in the Word document.
3. **Metadata accuracy:** Title, author, and keywords must match the manuscript.
4. **Reproducibility:** The conversion must be repeatable given the same Markdown input and template.

Automated checks included:

- **Format verification:** Extract document properties from the .docx file (using Python `python-docx` library) and verify column count, page size, and margin settings.
- **Content verification:** Parse the .docx structure and confirm that all expected headings are present.
- **Metadata verification:** Compare extracted metadata against the source Markdown.

The verification script flagged the single-column issue, prompting a post-processing step to modify the Word document XML and enforce two-column layout.

### Release Stage

After passing verification, we packaged the final artifacts:

- `paper.docx` — the conference-ready manuscript.
- `convert_to_docx.ps1` — the conversion script with inline documentation.
- `export-command.txt` — a reproducibility record capturing the exact Pandoc command, template path, and timestamp.
- `README.md` — usage instructions and workflow overview.

The release package was tagged with a version identifier (v1.0) and archived in a Git repository with a DOI for long-term citation.

<!-- source: Workflows_v00.pdf p.7-8 -->

## Results and Observations

Applying the workflow resulted in measurable improvements over unstructured AI-assisted coding:

- **Traceability:** Every artifact (script, manuscript, output) had a clear origin and modification history, captured in task checklists, commit messages, and metadata files.
- **Reproducibility:** The conversion process could be repeated exactly, producing identical output given the same inputs and template.
- **Quality:** The verify stage caught formatting errors that would have been missed in a purely exploratory approach, preventing submission of a non-compliant document.
- **Efficiency:** Despite the added structure, total development time was comparable to unstructured iteration (approximately 2 hours), because the workflow reduced backtracking and debugging.

<!-- source: Workflows_v00.pdf p.8 -->

Challenges included:

- **Initial overhead:** Setting up metadata templates and verification scripts required upfront investment.
- **Tooling gaps:** Some verification checks (e.g., extracting column count from .docx) required custom scripting due to lack of existing tools.
- **Iteration friction:** Moving between stages introduced minor delays compared to completely free-form iteration, though this was offset by reduced rework.

Overall, the workflow successfully transformed an exploratory task into a verifiable, repeatable process without sacrificing the creative benefits of AI-assisted coding.

# Related Work

The proposed workflow builds on established principles from software engineering, reproducible research, and AI-assisted development. We briefly review relevant work in each area.

**Reproducibility in research.** The reproducibility crisis in computational science has motivated numerous efforts to standardize workflows and capture provenance. Tools like Jupyter notebooks, R Markdown, and literate programming environments enable interleaving code, data, and narrative, but often lack rigorous verification stages. Our workflow extends these ideas by introducing explicit quality gates and separating exploratory evaluation from formal verification.

<!-- source: Workflows_v01.pdf p.8 -->

**Software engineering workflows.** Traditional software engineering employs staged workflows (e.g., waterfall, agile sprints, DevOps pipelines) with defined checkpoints and quality gates. Continuous integration and continuous deployment (CI/CD) systems automate testing and verification, ensuring that only validated code reaches production. Our workflow adapts these practices for AI-assisted development, where the code generation process itself (via LLM prompts) introduces new provenance challenges.

**AI-assisted development.** Recent work on LLM-based coding tools has highlighted both opportunities and risks. Studies show that AI-generated code can be insecure, buggy, or poorly documented, particularly when developers lack domain expertise. Our workflow addresses these concerns by embedding verification and documentation requirements directly into the development process, treating AI tools as accelerators rather than replacements for engineering discipline.

**Provenance and metadata.** Research in scientific workflow systems (e.g., Kepler, Taverna) and data provenance (e.g., PROV-DM) emphasizes capturing detailed lineage information for datasets and computations. Our approach applies similar principles to code artifacts, using lightweight metadata files to record generation context (prompts, model versions, timestamps) without requiring heavyweight infrastructure.

**Quality gates in agile and DevOps.** Quality gates—decision points where artifacts must meet defined criteria before progressing—are central to modern software engineering. We adapt this concept for AI-assisted workflows, recognizing that early-stage AI-generated code may require multiple iterations before reaching a verifiable state. Our evaluate stage provides space for exploratory refinement, while the verify stage enforces deterministic quality standards.

<!-- source: Workflows_v01.pdf p.8-9 -->

The proposed workflow synthesizes these threads, offering a practical, incremental approach to making AI-assisted development more traceable, repeatable, and verifiable.

# Discussion

The workflow presented in this paper represents a pragmatic step toward reconciling the speed and flexibility of AI-assisted coding with the rigor required for professional software engineering and reproducible research. However, several limitations and open questions warrant discussion.

**Adoption friction.** Introducing structured stages and quality gates adds overhead compared to completely unstructured "vibe coding." Developers may resist the workflow if they perceive it as slowing down their creative process. To mitigate this, we emphasize incremental adoption: teams can start with manual checklists and metadata files, then gradually introduce automation as familiarity grows. Tool support (e.g., IDE plugins that auto-generate metadata, CI templates that run verify checks) can further reduce friction.

<!-- source: Workflows_v01.pdf p.9 -->

**Tooling gaps.** Current AI-assisted development tools (Copilot, ChatGPT, Cursor) do not natively support provenance capture or structured workflows. Metadata must be recorded manually or via custom scripts. Future tool development should integrate workflow stages directly, prompting developers to document intent at planning time and automatically capturing generation context during the build stage.

**Verification complexity.** Defining verification criteria for AI-generated code is non-trivial, particularly for exploratory or creative tasks where "correctness" is subjective. Our workflow assumes that verification criteria can be specified (e.g., test coverage thresholds, performance benchmarks), but this may not hold for all domains. Research into automated quality metrics for AI-generated code is needed.

**Generalizability.** The workflow was validated on a document processing task, which has relatively clear verification criteria (format compliance, content preservation). It remains to be seen how well the workflow applies to more complex or open-ended tasks (e.g., UI design, algorithm discovery). Future case studies should explore diverse domains and task types.

**Long-term maintenance.** Provenance metadata and verification scripts add artifacts that must be maintained alongside code. Over time, metadata formats may become outdated, and verification tools may need updating. Establishing community standards for metadata schemas and verification patterns could help address this challenge.

<!-- source: Workflows_v01.pdf p.9-10 -->

Despite these limitations, the workflow offers a viable path forward. By making traceability and verification explicit—without eliminating the exploratory iteration that makes AI-assisted coding powerful—the workflow can help developers, researchers, and organizations build on AI-generated code with confidence.

# Conclusion

This paper has presented a structured AI workflow that transforms informal, exploratory AI-assisted development into a traceable, repeatable process. By introducing five explicit stages (planning, build, evaluate, verify, release), each with defined quality gates and provenance capture, the workflow enables developers to retain the speed and creativity of AI-assisted coding while establishing the rigor required for professional software engineering and reproducible research. A case study demonstrated practical application of the workflow, showing measurable improvements in traceability, reproducibility, and quality compared to unstructured "vibe coding." While challenges remain—particularly around tooling, adoption friction, and verification complexity—the workflow represents a pragmatic step toward making AI-assisted development more verifiable and auditable. Future work should focus on tool integration, community standards for metadata and verification, and broader validation across diverse development domains.

<!-- source: Workflows_v01.pdf p.10 -->

##### Acknowledgment

This research was supported by TED University. The author thanks the anonymous reviewers for their constructive feedback.

##### References

1. GitHub Copilot Documentation, GitHub Inc., 2024. Available: https://github.com/features/copilot
2. T. Brown et al., "Language models are few-shot learners," in *Advances in Neural Information Processing Systems*, vol. 33, 2020, pp. 1877–1901.
3. H. Pearce et al., "Asleep at the keyboard? Assessing the security of GitHub Copilot's code contributions," in *Proc. IEEE Symp. Security and Privacy*, 2022, pp. 754–768.
4. M. Lam et al., "Testing the reliability of AI coding assistants," in *Proc. ACM SIGSOFT Intl. Symp. Software Testing and Analysis (ISSTA)*, 2023, pp. 112–123.
5. R. Peng, "Reproducible research in computational science," *Science*, vol. 334, no. 6060, pp. 1226–1227, 2011.
6. V. Stodden et al., "Toward reproducible computational research: an empirical analysis of data and code policy adoption by journals," *PLOS ONE*, vol. 8, no. 6, e67111, 2013.
7. L. Moreau and P. Groth, "Provenance: an introduction to PROV," *Synthesis Lectures on the Semantic Web*, vol. 3, no. 4, pp. 1–129, 2013.
8. J. Humble and D. Farley, *Continuous Delivery: Reliable Software Releases through Build, Test, and Deployment Automation*, Addison-Wesley, 2010.
