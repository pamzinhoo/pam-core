---
name: patch-strategy
description: Split risky or large file edits into small safe patches. Use for multi-file changes, generated HTML, large CSS, encoding or mojibake issues, failed apply_patch attempts, or any broad edit where patch context may be fragile.
---

# patch-strategy

## Purpose
Make file edits small, reviewable, and resilient to encoding or context problems.

## Auto Activation
Use before applying large patches, multi-file patches, broad HTML/CSS edits, or any patch after a context or encoding failure.

## Do Not Activate
Do not use for a simple one-line edit with stable ASCII context.

## Detect
Look for HTML with inline scripts, CSS rewrites, mojibake, emoji-heavy text, generated files, long diffs, multiple unrelated files, and apply_patch context failures.

## Responsibilities
- Prefer one file per patch.
- Prefer one behavior per patch.
- Use stable ASCII anchors when files contain encoding or mojibake.
- After a patch fails for context or encoding, reduce to the smallest ASCII anchor.
- Read the changed hunk after patching.
- Stop large patch attempts and report when a safer split is needed.

## Never Do
- Apply a large multi-file patch to HTML with encoding or mojibake.
- Rewrite a full file when a narrow hunk works.
- Keep retrying the same failed patch context.
- Mix functional bug fixes, security changes, and CSS polish in one patch.
- Patch generated or unrelated files unless explicitly requested.

## Cooperates With
execution-monitor, task-sequencing, project-understanding, scope-control, testing, code-review.

## Final Checklist
- Patch size matches the risk.
- HTML/CSS with encoding risk was edited one file at a time.
- Failed patch context was reduced to ASCII anchors.
- Each patch had one purpose.
- Changed hunks were reviewed.

## Examples
- For four HTML files using `event.target`, patch one file, verify the hunk, then move to the next.
- For mojibake HTML, anchor on `id="admin_pass"` instead of nearby emoji text.
