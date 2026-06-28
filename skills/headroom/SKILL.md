---
name: headroom
description: Preserve critical context while reducing noise.
---

# headroom

## Purpose
Keep context useful by preserving facts that affect correctness and dropping noise.

## Auto Activation
Use during long tasks, large code reads, summaries, handoffs, multi-file changes, and agent memory compression.

## Do Not Activate
Do not use to skip required reading or replace source files as the source of truth.

## Detect
Look for long logs, many files, repeated outputs, compaction summaries, test runs, stack traces, schemas, permissions, migrations, and task constraints.

## Responsibilities
- Preserve paths, commands, errors, versions, schemas, contracts, permissions, money rules, and destructive-operation decisions.
- Summarize decisions and open risks.
- Remove repetitive or low-signal text.
- Re-read source when precision matters.

## Never Do
- Treat a summary as more authoritative than the code.
- Drop constraints, failures, or security-relevant details.
- Compress away exact commands needed for verification.
- Include secrets in summaries.

## Cooperates With
project-understanding, prompt-injection-defense, security, debugging, testing, code-review.

## Final Checklist
- Critical facts remain available.
- Noise was reduced without hiding failures.
- Source files can be found again by path.
- Secrets are excluded.
- Assumptions are labeled.

## Examples
- Summarize a long test run by preserving failing test names, commands, and error messages.
- Keep the list of edited files and skipped checks after a multi-file documentation change.
