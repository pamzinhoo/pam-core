---
name: success-criteria
description: Define concrete completion criteria for tasks so technical checks, user-visible outcomes, and manual verification align before execution.
---

# success-criteria

## Purpose
Define how to know whether the user's real task is actually complete.

## Auto Activation
Use for subjective, user-visible, high-risk, multi-step, release, bug-fix, UI,
business-rule, data, security, or prompt-normalized tasks before execution and
again before final response.

## Do Not Activate
Do not use for trivial informational answers or simple commands whose output is
the complete result.

## Detect
Look for prompts where tests can pass without satisfying the user, such as UI
polish, performance, business correctness, workflow completion, migration
safety, or "make it better" requests.

## Responsibilities
- Define observable success criteria before implementation.
- Include technical checks and user-visible outcome checks when both matter.
- Identify manual verification needs when automation is insufficient.
- Use criteria to judge completion before final response.
- Report any criteria that remain unverified.

## Never Do
- Equate changed files with completed work.
- Equate passing checks with user satisfaction when the task is visual,
  subjective, or workflow-based.
- Create impossible or unverifiable criteria.
- Hide manual verification gaps.

## Cooperates With
prompt-understanding, prompt-normalization, prompt-gap-analysis,
task-extraction, testing, ux-review, accessibility-review, code-review.

## Final Checklist
- Success criteria are explicit.
- Criteria match the user's real outcome.
- Automated checks are named where available.
- Manual checks are named where needed.
- Final status reports passed, failed, and unverified criteria.

## Examples
- For a CSS task, require the relevant screen to look coherent at target
  viewports, not only that CSS files changed and tests passed.
- For a data export task, require correct fields, authorization, file format,
  error handling, and a focused verification command.
