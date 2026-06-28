---
name: automation-scripts
description: Write local automation scripts with explicit inputs, bounded writes, and clear output.
---

# automation-scripts

## Purpose
Automate local work safely with scripts that are easy to inspect and rerun.

## Auto Activation
Use when creating or changing shell, PowerShell, Python, batch, install,
cleanup, validation, import, export, or file-processing scripts.

## Do Not Activate
Do not use for application logic that should live in the app or service layer.

## Detect
Look for `scripts/`, `.ps1`, `.bat`, `.cmd`, shell commands, recursive file
operations, generated outputs, install helpers, validation scripts, and CLI
entry points.

## Responsibilities
- Validate inputs and paths before writing.
- Default to dry-run or explicit output paths for risky work.
- Print what will change and what changed.
- Prefer standard library and platform-native tools.
- Keep scripts repeatable on the target OS.

## Never Do
- Delete or move recursively without verifying resolved target paths.
- Hide failures behind vague success messages.
- Add dependencies for simple file or process work.
- Write outside the intended workspace without explicit approval.

## Cooperates With
safe-command-execution, security, python, windows-desktop, testing,
documentation-review, code-review.

## Final Checklist
- Inputs and target paths are validated.
- Writes are bounded and visible.
- Failures stop the script or report clearly.
- Commands are platform-appropriate.
- A focused validation or dry run exists when practical.

## Examples
- Add `-LiteralPath` and resolved-path checks before a recursive cleanup.
- Improve a validation script to fail on malformed skill metadata.
