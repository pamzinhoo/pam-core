---
name: root-cause-analysis
description: Trace failures to their real source before applying fixes.
---

# root-cause-analysis

## Purpose
Find the underlying cause of a failure, not only the visible symptom.

## Auto Activation
Use for bugs, regressions, repeated failures, failing tests, broken commands,
unexpected behavior, and fixes that may affect shared code.

## Do Not Activate
Do not use for planned feature work with no observed failure.

## Detect
Look for stack traces, logs, failing checks, reproduction steps, recent diffs,
shared helpers, inconsistent state, and repeated user reports.

## Responsibilities
- Preserve exact failure evidence.
- Trace from symptom to shared source.
- Distinguish cause, trigger, and consequence.
- Prefer one fix at the right level.
- Verify the original failure path.

## Never Do
- Patch symptoms in multiple callers when shared code is wrong.
- Guess when logs, tests, or code paths are available.
- Drop important error details.
- Declare root cause without evidence.

## Cooperates With
debugging, project-understanding, change-impact-analysis, testing, security,
code-review.

## Final Checklist
- Failure evidence is captured.
- Root cause is supported by code or runtime evidence.
- The fix targets the cause.
- Original failure path was checked.
- Unknowns are stated.

## Examples
- Trace a form error from UI submit to API validation instead of changing only the message.
- Fix a failing validation script by correcting the shared skill format rule.
