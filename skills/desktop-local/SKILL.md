---
name: desktop-local
description: Build local desktop tools that preserve user files, work offline, and keep storage simple.
---

# desktop-local

## Purpose
Shape local desktop tools around predictable files, simple storage, and clear
failure modes.

## Auto Activation
Use when building or changing local desktop apps, offline workflows, local file
storage, SQLite-backed tools, startup scripts, or user-machine behavior.

## Do Not Activate
Do not use for hosted SaaS or backend services unless they also include a local
desktop surface.

## Detect
Look for local app entry points, Tkinter/PySide/PyQt, SQLite files, user data
folders, Windows shortcuts, offline behavior, import/export folders, and local
settings.

## Responsibilities
- Prefer native OS behavior and explicit local paths.
- Preserve user data above convenience.
- Keep storage simple, usually local files or SQLite.
- Handle offline use and clear startup errors.
- Avoid background services unless they are truly needed.

## Never Do
- Store user data in surprising or temporary locations.
- Delete or overwrite local files without confirmation or backup strategy.
- Require network access for local workflows unnecessarily.
- Add hidden background services for simple desktop tasks.

## Cooperates With
windows-desktop, sqlite, python, automation-scripts, packaging, data-privacy,
security, testing, code-review.

## Final Checklist
- User files and storage locations are explicit.
- Offline and startup failure behavior is clear.
- Data preservation is prioritized.
- Platform-specific paths are handled safely.
- Local workflow has a focused smoke check when practical.

## Examples
- Store app data under an explicit user data directory instead of the install
  folder.
- Add a clear error when a local database file cannot be opened.
