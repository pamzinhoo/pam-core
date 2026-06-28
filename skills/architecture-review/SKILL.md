---
name: architecture-review
description: Review architecture quality before completion. Use for Architecture Gate checks, boundary changes, module changes, routing changes, or broad structural edits.
---

# architecture-review

## Purpose
Decide whether a change preserves clear architecture and module boundaries.

## Auto Activation
Use for Architecture Gate checks, new modules, changed ownership boundaries,
shared abstractions, public contracts, routing maps, or broad file movement.

## Do Not Activate
Do not use for tiny local edits that do not affect structure, ownership, public
contracts, or dependency direction.

## Detect
Look for new services, modules, layers, folders, interfaces, registries, plugin
metadata, routing tables, dependency direction changes, and cross-cutting
helpers.

## Responsibilities
- Identify the affected architectural boundary.
- Check that one component owns each responsibility.
- Confirm new abstractions remove real complexity.
- Verify dependency direction stays understandable.
- Flag hidden coupling, duplicate ownership, and speculative layers.
- Report a pass, fail, or explicit residual risk for the Architecture Gate.

## Never Do
- Replace implementation design skills such as `architecture` or `refactoring`.
- Approve broad rewrites without clear need.
- Treat naming cleanup as architecture improvement by itself.
- Duplicate `code-review` final review responsibilities.

## Cooperates With
project-understanding, skill-orchestrator, architecture, refactoring, ponytail,
change-impact-analysis, code-review.

## Final Checklist
- Boundary affected by the change is named.
- Ownership remains clear.
- Dependency direction remains simple.
- No speculative layer was added.
- Architecture Gate result is stated.

## Examples
- Review whether a new plugin module belongs in Core, Testing, or DevOps.
- Fail a change that adds a generic service layer with only one caller.
