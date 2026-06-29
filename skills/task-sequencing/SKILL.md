---
name: task-sequencing
description: Order mixed prompts into independent execution passes. Use when a request combines bug fixes, security review, CSS/UI polish, documentation, tests, release work, or any broad set of tasks that should not be edited together.
---

# task-sequencing

## Purpose
Separate mixed work into safe, ordered passes before editing.

## Auto Activation
Use when a prompt includes multiple task types, such as bug plus security plus CSS, or when completion could expand into unrelated work.

## Do Not Activate
Do not use for a single clear task with one obvious edit path.

## Detect
Look for words like fix, improve, review, security, CSS, UI, tests, docs, release, cleanup, audit, and deploy in the same request.

## Responsibilities
- Split mixed prompts into independent tasks before execution.
- Run bug fixes first, security second, UI/CSS third, documentation last.
- Keep each pass to one primary outcome and one patch stream.
- Stop after main requested items are complete.
- List remaining risks instead of continuing into optional work.
- Ask for confirmation before expanding scope after the main pass.

## Never Do
- Mix functional bug fixes, security changes, and CSS changes in the same edit round.
- Treat a broad prompt as permission for an open-ended audit.
- Start polish before the functional bug is understood.
- Hide unfinished optional work inside the final answer.

## Cooperates With
execution-monitor, patch-strategy, task-planning, scope-control, success-criteria, testing, code-review.

## Final Checklist
- Mixed prompt was split before editing.
- Bug, security, UI, and docs were ordered separately.
- Each edit round had one lead objective.
- Work stopped after main items were done.
- Remaining risks are explicit.

## Examples
- "Fix the bug, improve CSS, check security" becomes: functional bug pass, security pass, CSS pass, then summary.
- "Audit and fix everything" becomes a scoped audit first, then user-approved fixes.
