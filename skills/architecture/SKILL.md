---
name: architecture
description: Choose simple architecture that fits the current system.
---

# architecture

## Purpose
Keep system structure simple, explicit, and aligned with the current codebase.

## Auto Activation
Use when a change affects module boundaries, shared services, data flow, deployment shape, or long-lived interfaces.

## Do Not Activate
Do not use for tiny local edits where existing structure is obvious and unchanged.

## Detect
Look for new modules, services, queues, plugins, dependency injection layers, package boundaries, cross-cutting helpers, and duplicated flow.

## Responsibilities
- Start from the existing shape.
- Add boundaries only when they protect real complexity.
- Keep ownership, inputs, outputs, and dependencies clear.
- Prefer boring modules and explicit data flow.

## Never Do
- Introduce frameworks, queues, plugins, distributed systems, or abstractions without current need.
- Split code only to look organized.
- Hide business rules behind vague layers.

## Cooperates With
project-understanding, ponytail, api-design, database-design, refactoring, security, testing.

## Final Checklist
- The design fits the existing project.
- The simplest boundary that works was chosen.
- Dependencies point in a clear direction.
- No speculative infrastructure was added.
- Tests or checks cover the affected contract.

## Examples
- Move duplicated permission checks into one service function instead of creating a full policy engine.
- Keep a local script as one file instead of adding a package layout for one command.
