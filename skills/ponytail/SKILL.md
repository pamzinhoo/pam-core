---
name: ponytail
description: Prefer the smallest safe change that actually works.
---

# ponytail

## Purpose
Solve the task with the smallest safe change that works.

## Auto Activation
Use for every implementation or review task, especially when scope, abstractions, dependencies, or rewrites are being considered.

## Do Not Activate
Do not use to remove validation, authorization, accessibility, data integrity, error handling, or checks that prevent data loss.

## Detect
Look for new dependencies, new abstractions, factories, configuration, scaffolding, rewrites, duplicated logic, optional features, and "for later" code.

## Responsibilities
- Try existing code first.
- Prefer standard library, native platform features, and installed dependencies before new code.
- Delete or reuse before adding.
- Keep files and explanations short.
- Leave the smallest useful verification for non-trivial logic.

## Never Do
- Add speculative abstractions or broad rewrites.
- Add dependencies for simple local problems.
- Build future-proofing that the current task does not need.
- Choose a small patch in the wrong place instead of the root cause.

## Cooperates With
project-understanding, architecture, testing, security, refactoring, code-review.

## Final Checklist
- The change is the smallest safe solution.
- No speculative layer or dependency was added.
- Existing helpers and platform features were considered.
- Safety and data integrity remain intact.
- Verification matches the risk.

## Examples
- Use `pathlib` instead of adding a path utility package.
- Add one guard in a shared function instead of duplicating checks at every caller.
