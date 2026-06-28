---
name: code-review
description: Review changes for bugs, regressions, and missing checks.
---

# code-review

## Purpose
Catch correctness, security, data integrity, and testing issues before finishing.

## Auto Activation
Use before final response for non-trivial code, config, documentation standards, workflows, or behavior changes.

## Do Not Activate
Do not perform a full review for tiny answers with no file changes, unless the user asks.

## Detect
Look for diffs, changed contracts, validation, permissions, migrations, money logic, date logic, async behavior, file operations, and missing tests.

## Responsibilities
- Lead with findings when reviewing.
- Check for regressions, edge cases, and missing checks.
- Verify the request was actually satisfied.
- Confirm the diff stayed focused.
- Name residual risk when no issues are found.

## Never Do
- Bury serious findings under a summary.
- Approve changes that skip obvious validation or authorization.
- Ignore unrelated user changes by overwriting them.
- Pretend unrun tests were run.

## Cooperates With
testing, security, project-understanding, debugging, ponytail, financial-system, architecture.

## Final Checklist
- Request is satisfied.
- Diff is focused.
- Trust boundaries are protected.
- Data and status transitions are safe.
- Tests or skipped checks are reported.

## Examples
- Review a FastAPI change for missing ownership checks and response-shape regressions.
- Review a documentation standards change for consistency across all required skill files.
