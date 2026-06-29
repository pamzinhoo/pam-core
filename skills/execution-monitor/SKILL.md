---
name: execution-monitor
description: Detect long-running work, missing progress, repeated review loops, stalled tools, and commands that run too long. Use for broad tasks, multi-step implementation, tool-heavy work, patch attempts, validation runs, or any task at risk of staying in Working without clear progress.
---

# execution-monitor

## Purpose
Keep execution bounded and visible during long or tool-heavy tasks.

## Auto Activation
Use when a task may take multiple steps, touches several files, runs tools, applies patches, validates a project, or combines bug fixing, security, UI, documentation, or release work.

## Do Not Activate
Do not use for direct answers, tiny one-file edits, or commands expected to return immediately unless they already stalled.

## Detect
Look for long-running tool calls, repeated failed patches, repeated validation without new evidence, broad scope, many files, mixed tasks, large diffs, and no user-visible progress update.

## Responsibilities
- Track the current step, expected output, and elapsed time.
- Stop and report when a tool or command has no return for more than 2-3 minutes.
- Detect repeated review loops where the same checks run without new changes.
- Detect patch loops after context, encoding, or matcher failures.
- Summarize completed work, current blocker, and next proposed action before continuing.
- End work when main items are complete and list remaining risks.

## Never Do
- Let a tool run silently past 23 minutes.
- Keep retrying the same patch or validation pattern without changing strategy.
- Mix new scope into an already long task.
- Hide that a command, validation, or patch is stalled.
- Continue after 23 minutes without user confirmation.

## Cooperates With
task-sequencing, patch-strategy, task-planning, context-management, headroom, testing, code-review.

## Final Checklist
- No command or tool exceeded 23 minutes without stopping and asking.
- Repeated checks produced new evidence or were stopped.
- Long work has a clear progress summary.
- Main items are complete or the blocker is explicit.
- Residual risks are listed instead of extending scope.

## Examples
- A validation script hangs: stop after 23 minutes, summarize changed files, state that validation stalled, and ask before retrying.
- A multi-file patch keeps failing on HTML encoding: stop patch retries and hand off to `patch-strategy`.
