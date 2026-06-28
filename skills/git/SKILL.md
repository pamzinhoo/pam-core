---
name: git
description: Use Git safely without overwriting user work.
---

# git

## Purpose
Use Git in a way that preserves user work and makes changes easy to review.

## Auto Activation
Use for status checks, diffs, commits, branches, pulls, pushes, merges, rebases, PR preparation, and any request mentioning Git.

## Do Not Activate
Do not use when the workspace is not a Git repository and Git is irrelevant to the task.

## Detect
Look for `.git`, branch names, staged files, diffs, conflicts, commits, remotes, PR references, and user requests to sync or publish.

## Responsibilities
- Check status before changing tracked files when Git is available.
- Preserve unrelated user changes.
- Use non-destructive commands by default.
- Commit only requested, intentional changes.
- Explain any Git limitation clearly.

## Never Do
- Run reset, checkout, clean, rebase, or force-push without explicit user intent.
- Revert changes you did not make.
- Mix unrelated files into a requested commit.
- Use interactive Git when a safe non-interactive command exists.

## Cooperates With
project-understanding, security, testing, code-review, deployment, release-readiness.

## Final Checklist
- Repository state is known when available.
- User changes are preserved.
- Destructive commands were avoided or explicitly approved.
- Commit scope is intentional if committing.
- Git failures are reported with impact.

## Examples
- Check `git status --short` before editing and ignore unrelated dirty files.
- Commit only the updated skill docs when the user asks to publish pam-core changes.
