---
name: maintainability-review
description: Review maintainability before completion. Use for Maintainability Gate checks, complex diffs, duplicated logic, naming drift, or hard-to-change code.
---

# maintainability-review

## Purpose
Decide whether a change remains easy to read, change, and debug.

## Auto Activation
Use for Maintainability Gate checks, multi-file edits, duplicated logic,
complex conditionals, new helpers, config changes, or code likely to be reused.

## Do Not Activate
Do not use for trivial text edits or generated output where maintainability is
not part of the reviewed surface.

## Detect
Look for repeated blocks, vague names, long functions, mixed responsibilities,
dead options, unclear comments, brittle ordering, and unnecessary indirection.

## Responsibilities
- Check whether the diff is understandable without hidden context.
- Identify duplication that will likely cause inconsistent behavior.
- Verify names describe domain behavior, not implementation trivia.
- Confirm comments explain non-obvious intent only.
- Flag fragile structure and unused flexibility.
- Report a pass, fail, or explicit residual risk for the Maintainability Gate.

## Never Do
- Demand style-only rewrites unrelated to the change.
- Replace `ponytail`, `refactoring`, or `code-review`.
- Add abstractions just to reduce line count.
- Ignore validation, security, or tests in the name of simplicity.

## Cooperates With
project-understanding, ponytail, refactoring, scope-control, testing,
code-review.

## Final Checklist
- Diff is locally understandable.
- Responsibilities are not mixed.
- Duplication risk is acceptable.
- Names and comments are useful.
- Maintainability Gate result is stated.

## Examples
- Fail a change that duplicates the same authorization branch in three routes.
- Pass a small helper when it replaces repeated parsing with one clear function.
