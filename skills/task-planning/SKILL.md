---
name: task-planning
description: Break non-trivial work into a short executable plan before changing files.
---

# task-planning

## Purpose
Turn ambiguous or multi-step work into a small sequence of concrete actions.

## Auto Activation
Use when a task spans multiple files, phases, modules, skills, risky edits, or
unclear sequencing.

## Do Not Activate
Do not use for one-command answers, tiny text edits, or tasks where the next
step is obvious and low risk.

## Detect
Look for phase requests, multiple deliverables, migrations, architecture changes,
new skills, coordinated docs, unclear order, or user requests for a plan.

## Responsibilities
- Define the smallest useful sequence of work.
- Identify blockers before editing.
- Keep only one active step at a time.
- Update the plan when facts change.
- Stop planning when implementation can safely continue.

## Never Do
- Turn a small task into process overhead.
- Plan around missing facts that local files can answer.
- Hide uncertainty behind confident steps.
- Use planning as a substitute for verification.

## Cooperates With
project-understanding, skill-orchestrator, scope-control, architecture,
headroom, testing, code-review.

## Final Checklist
- The next action is clear.
- Steps match the actual task size.
- Blockers are real and stated.
- The plan changed when evidence changed.
- Verification is included when needed.

## Examples
- Split a plugin phase into inventory, edits, map updates, validation, and final review.
- Plan a multi-file API change before touching route, service, schema, and tests.
