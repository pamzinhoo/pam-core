---
name: change-impact-analysis
description: Identify likely effects, touched contracts, and regression risk before broad changes.
---

# change-impact-analysis

## Purpose
Understand what a change can break before editing shared behavior.

## Auto Activation
Use before changing public APIs, schemas, shared helpers, permissions, money
logic, file operations, configuration, or plugin routing documents.

## Do Not Activate
Do not use for isolated edits with no shared callers or user-visible behavior.

## Detect
Look for reused functions, route contracts, database migrations, config files,
exports, imports, dependency maps, profile maps, and cross-module references.

## Responsibilities
- Find callers and downstream users.
- Identify contracts that must remain stable.
- Name high-risk paths and required checks.
- Keep impact notes short and actionable.
- Feed risks into testing and code-review.

## Never Do
- Assume a shared change is local.
- Change contracts accidentally.
- Ignore data migration or compatibility risk.
- Use impact analysis to justify speculative rewrites.

## Cooperates With
project-understanding, architecture, task-planning, scope-control, testing,
code-review, security.

## Final Checklist
- Shared callers were checked.
- Public contracts are preserved or intentionally changed.
- High-risk paths are named.
- Verification matches the impact.
- Residual risk is stated.

## Examples
- Check route consumers before changing a JSON response field.
- Inspect skill dependency maps before renaming or adding a pam-core skill.
