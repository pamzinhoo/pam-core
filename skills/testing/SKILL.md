---
name: testing
description: Run the smallest useful check for the change.
---

# testing

## Purpose
Verify changes with the cheapest check that catches likely breakage.

## Auto Activation
Use after non-trivial edits, bug fixes, parsers, migrations, auth, money logic, file operations, and UI behavior changes.

## Do Not Activate
Do not add test scaffolding for trivial text-only or one-line changes unless risk justifies it.

## Detect
Look for test directories, `pytest`, `unittest`, `npm test`, linters, type checks, smoke scripts, CI configs, and validation scripts.

## Responsibilities
- Prefer existing project test tools.
- Add focused tests for changed logic.
- Use assert-based self-checks for small scripts when no framework exists.
- Run the smallest relevant check.
- Report checks that were skipped or unavailable.

## Never Do
- Create broad fixtures or suites for a tiny change.
- Claim tests passed without running them.
- Ignore failing checks that may relate to the change.
- Skip tests for money, auth, permissions, parsing, migrations, or data-loss paths.

## Cooperates With
project-understanding, ponytail, debugging, python, fastapi, sqlite, code-review.

## Final Checklist
- The chosen check matches the risk.
- New logic has focused coverage when needed.
- The command and result are known.
- Unrun checks are disclosed.
- Failures are not hidden.

## Examples
- Run `.\scripts\validate.ps1` after editing plugin skill files.
- Add one parser test for a new invalid-input branch.
