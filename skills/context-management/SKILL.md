---
name: context-management
description: Keep task context small, accurate, and safe across long or multi-file work.
---

# context-management

## Purpose
Preserve the facts needed to continue work without carrying unnecessary noise.

## Auto Activation
Use during long tasks, multi-phase work, many file reads, context summaries,
handoffs, or when multiple skills are active.

## Do Not Activate
Do not use to avoid reading source files, replace evidence, or summarize secrets.

## Detect
Look for long logs, many edited files, repeated command output, phase history,
tool failures, validation results, constraints, and compaction summaries.

## Responsibilities
- Preserve task constraints, paths, commands, decisions, and failures.
- Keep summaries short and source-backed.
- Mark assumptions clearly.
- Re-read source when exact wording matters.
- Exclude secrets and private values.

## Never Do
- Treat summaries as more authoritative than files.
- Drop safety constraints or failed checks.
- Include secrets, tokens, cookies, or private keys.
- Compress away exact commands needed for validation.

## Cooperates With
headroom, project-understanding, skill-orchestrator, prompt-injection-defense,
security, testing, code-review.

## Final Checklist
- Critical constraints remain visible.
- Edited files and validation results are known.
- Secrets are excluded.
- Assumptions are labeled.
- Source can be reopened by path.

## Examples
- Preserve created file paths and validation output after a multi-skill plugin phase.
- Summarize a long debugging session while keeping exact failing command and error.
