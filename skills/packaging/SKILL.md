---
name: packaging
description: Package local apps or plugins with reproducible inputs, included files, and install/remove steps.
---

# packaging

## Purpose
Prepare local deliverables that can be built, installed, updated, and removed
without hidden assumptions.

## Auto Activation
Use when changing package metadata, install scripts, plugin bundles, included
files, release artifacts, local app delivery, or customer installation steps.

## Do Not Activate
Do not use as the lead for hosted deployment; use `deployment` for server or
cloud release targets.

## Detect
Look for manifests, build scripts, installers, included file lists, plugin
metadata, archives, executable entry points, versioned artifacts, and uninstall
steps.

## Responsibilities
- Keep build inputs explicit and repeatable.
- Include only required files.
- Document build, install, update, and removal.
- Avoid installer behavior that hides errors.
- Coordinate versioning and release checks with release readiness.

## Never Do
- Package caches, temporary files, secrets, or source-only metadata.
- Rely on machine-specific absolute paths.
- Hide install failures behind generic success output.
- Change versioned artifacts without release notes.

## Cooperates With
desktop-local, windows-desktop, deployment, python-packaging,
automation-scripts, testing, release-readiness, code-review.

## Final Checklist
- Required files are included and unwanted files are excluded.
- Build and install steps are reproducible.
- Removal or rollback is documented where relevant.
- Version and release notes are aligned when changed.
- Package validation ran or is disclosed.

## Examples
- Exclude `.git`, caches, and logs from a local plugin copy.
- Add an uninstall command to the README for a packaged Windows tool.
