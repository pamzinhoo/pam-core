---
name: debugging
description: Debug from evidence, not guesses.
---

# debugging

## Purpose
Find and fix root causes using observed evidence.

## Auto Activation
Use for errors, failed tests, broken behavior, CI failures, crashes, regressions, and unclear symptoms.

## Do Not Activate
Do not use when the task is a straightforward planned change with no failure to investigate.

## Detect
Look for stack traces, logs, failing commands, reproduction steps, screenshots, status codes, version differences, recent diffs, and flaky behavior.

## Responsibilities
- Reproduce or inspect the failing path first.
- Preserve exact errors, commands, versions, files, and traces.
- Change one thing at a time.
- Fix shared root causes instead of individual symptoms.
- Verify the failure path after the fix.

## Never Do
- Guess when a command, log, or code path can provide evidence.
- Hide or paraphrase away important error details.
- Patch every caller when one shared function is wrong.
- Ignore new failures introduced during investigation.

## Cooperates With
project-understanding, testing, python, fastapi, javascript, security, code-review.

## Final Checklist
- Failure evidence is known.
- Root cause is identified or uncertainty is stated.
- Fix is at the right level.
- Relevant check was rerun.
- Remaining failures are reported separately.

## Examples
- Trace a failed pytest assertion to a shared parser instead of changing one test fixture.
- Use browser console and network errors to fix a failed form submission.
