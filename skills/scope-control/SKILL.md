---
name: scope-control
description: Keep implementation focused on the requested outcome and prevent scope creep.
---

# scope-control

## Purpose
Prevent unnecessary features, rewrites, dependencies, and broad cleanup.

## Auto Activation
Use when a task invites expansion, has many possible improvements, touches
architecture, or includes phrases like future-proof, platform, full system, or
while you are there.

## Do Not Activate
Do not use to reject explicit user requirements, safety fixes, tests, or data
integrity work.

## Detect
Look for broad refactors, new abstractions, optional features, dependency
additions, speculative config, unrelated cleanup, and extra docs.

## Responsibilities
- Identify the requested outcome.
- Separate required work from optional improvements.
- Keep edits limited to files that serve the outcome.
- Defer useful but unrelated work explicitly.
- Preserve safety, validation, and tests.

## Never Do
- Remove required security, accessibility, or data integrity checks.
- Ignore user-approved scope.
- Add future hooks without current callers.
- Mix unrelated improvements into a focused change.

## Cooperates With
ponytail, task-planning, architecture, refactoring, project-understanding,
testing, code-review.

## Final Checklist
- The change matches the request.
- No unrelated cleanup was included.
- No speculative abstraction was added.
- Required safety work stayed in scope.
- Deferred work is named only when useful.

## Examples
- Add one requested skill without creating an entire module tree.
- Fix a validation bug without rewriting the surrounding service layer.
