---
name: task-extraction
description: Split mixed, multi-part, or tangled user requests into smaller ordered tasks with dependencies and execution boundaries.
---

# task-extraction

## Purpose
Break mixed prompts into executable tasks that can be routed, sequenced, and
verified independently.

## Auto Activation
Use when a prompt contains multiple asks, combines investigation with
implementation, mixes unrelated domains, or includes release, testing, and
documentation work in one request.

## Do Not Activate
Do not use when the request is a single clear task and splitting it would add
unnecessary process.

## Detect
Look for "and", "also", numbered lists, bug plus feature requests, UI plus
backend changes, implementation plus deployment, or broad phase requests.

## Responsibilities
- Extract discrete tasks from the prompt.
- Preserve dependencies and required order.
- Identify tasks that should be deferred or require approval.
- Keep the task list small enough to execute.
- Feed ordered tasks to `task-planning` or `skill-orchestrator`.

## Never Do
- Create speculative tasks that the user did not ask for.
- Split a cohesive change into artificial busywork.
- Reorder tasks in a way that violates data, safety, or release dependencies.
- Treat deferred roadmap work as approved implementation.

## Cooperates With
prompt-understanding, prompt-normalization, prompt-gap-analysis,
success-criteria, task-planning, scope-control, skill-orchestrator.

## Final Checklist
- Each task has one clear outcome.
- Ordering and dependencies are clear.
- Deferred or approval-only tasks are separated.
- The list stays within the user's requested scope.
- Routing can happen per task when needed.

## Examples
- Split "fix login, improve the dashboard, and deploy" into auth bug
  investigation, UI work, verification, and release handoff tasks.
- Split a phase request into create skills, update architecture docs, validate,
  and report files changed.
