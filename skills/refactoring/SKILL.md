---
name: refactoring
description: Refactor only when it removes duplication, clarifies ownership, or makes required change safer.
---

# refactoring

## Purpose
Improve structure without changing behavior unless the task explicitly requires
behavior change.

## Auto Activation
Use when simplifying duplicated logic, renaming unclear concepts, extracting
helpers, moving code across boundaries, or making a necessary change safer.

## Do Not Activate
Do not use for speculative cleanup, style-only rewrites, or broad redesigns not
needed for the current task.

## Detect
Look for duplicated branches, mixed responsibilities, unclear names, repeated
validation, hard-to-test code, circular dependencies, and behavior-preserving
structure changes.

## Responsibilities
- Keep behavior stable unless a behavior change is requested.
- Refactor only where it pays for the current work.
- Preserve public contracts and compatibility.
- Prefer small moves and clear names.
- Run checks that prove behavior stayed intact.

## Never Do
- Rewrite working modules just to match a preferred style.
- Add abstractions that have only one speculative caller.
- Hide behavior changes inside cleanup.
- Refactor before understanding the current flow.

## Cooperates With
project-understanding, ponytail, architecture, scope-control,
maintainability-review, regression-review, testing, code-review.

## Final Checklist
- The refactor has a concrete reason.
- Behavior changes are absent or explicit.
- Public contracts are preserved.
- The diff is smaller or clearer after the change.
- Regression checks ran or are disclosed.

## Examples
- Extract a repeated permission predicate used by three routes.
- Rename an internal helper for clarity while keeping its callers unchanged.
