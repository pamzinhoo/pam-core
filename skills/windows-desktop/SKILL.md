---
name: windows-desktop
description: Handle Windows paths, PowerShell commands, user folders, prerequisites, and local delivery safely.
---

# windows-desktop

## Purpose
Make Windows-specific local tools and scripts work reliably on real user
machines.

## Auto Activation
Use when editing PowerShell, batch files, Windows paths, local installers,
shortcuts, user folders, file operations, prerequisites, or desktop app startup.

## Do Not Activate
Do not use for platform-neutral backend code unless Windows behavior is directly
affected.

## Detect
Look for `.ps1`, `.bat`, `.cmd`, `%USERPROFILE%`, `$HOME`, `%APPDATA%`,
`Join-Path`, `-LiteralPath`, recursive file operations, spaces in paths,
execution policy notes, and Windows install helpers.

## Responsibilities
- Support spaces, accents, and long user paths.
- Prefer `$HOME`, `%USERPROFILE%`, `%APPDATA%`, or app-relative folders.
- Use PowerShell-native file operations with `-LiteralPath`.
- Verify resolved paths before recursive delete or move.
- Show clear prerequisite and startup errors.

## Never Do
- Hard-code machine-specific user paths.
- Compose destructive file operations across shells.
- Recursively delete or move without path-boundary checks.
- Hide execution policy or prerequisite failures.

## Cooperates With
desktop-local, automation-scripts, safe-command-execution, packaging, python,
security, testing, code-review.

## Final Checklist
- Paths handle spaces and non-ASCII user names.
- File operations use Windows-safe primitives.
- Destructive operations are bounded.
- Prerequisite errors are clear.
- Windows script behavior was validated when practical.

## Examples
- Replace string-built paths with `Join-Path` and `-LiteralPath`.
- Add a resolved-path guard before removing an installed plugin directory.
