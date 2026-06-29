---
name: prompt-normalization
description: Convert vague or mixed user prompts into a clear internal task structure with objective, scope, constraints, risks, and success criteria.
---

# prompt-normalization

## Purpose
Turn an unclear request into a compact working structure that downstream skills
can execute safely.

## Auto Activation
Use after `prompt-understanding` when a prompt needs a clearer objective, scope,
constraints, risks, ordering, or completion definition before execution.

## Do Not Activate
Do not use for already structured requests that include objective, files or
surface, constraints, and success criteria.

## Detect
Look for missing targets, subjective quality words, multiple requests in one
message, conflicting constraints, or prompts where technical checks may pass
without satisfying the user.

## Responsibilities
- Normalize the request into objective, scope, constraints, assumptions, risks,
  tasks, and success criteria.
- Keep the structure internal unless sharing it helps the user.
- Preserve user wording for hard requirements.
- Mark uncertainty explicitly.
- Hand normalized tasks to `skill-orchestrator` for specialist selection.

## Never Do
- Expand scope beyond the user's request.
- Convert assumptions into requirements.
- Remove safety, validation, or data-integrity constraints to simplify the task.
- Produce long templates when a short normalized structure is enough.

## Cooperates With
prompt-understanding, prompt-gap-analysis, task-extraction, success-criteria,
scope-control, skill-orchestrator, llm-best-practices, security.

## Final Checklist
- Objective is clear.
- Scope and non-scope are clear.
- Constraints and assumptions are separated.
- Risks are named.
- Success criteria can be checked.

## Examples
- Convert "make the dashboard better" into objective, affected screen, visual
  quality targets, constraints, UI risks, and review criteria.
- Convert "add export and fix the bug" into two ordered tasks with shared
  constraints and verification notes.
