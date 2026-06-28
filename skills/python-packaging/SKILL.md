---
name: python-packaging
description: Maintain Python packaging, dependency metadata, entry points, and build configuration.
---

# python-packaging

## Purpose
Keep Python project packaging installable, minimal, and consistent with the existing toolchain.

## Auto Activation
Use when editing `pyproject.toml`, `setup.cfg`, `setup.py`, requirements files, lockfiles, package discovery, console scripts, build backends, or version metadata.

## Do Not Activate
Do not use for application code changes that do not affect installation, dependency metadata, or distribution.

## Detect
Look for `pyproject.toml`, `requirements.txt`, `uv.lock`, `poetry.lock`, `setup.cfg`, `setup.py`, `hatchling`, `setuptools`, `poetry`, `uv`, `pip`, and console entry points.

## Responsibilities
- Follow the package manager and build backend already in use.
- Keep dependency ranges intentional and as narrow as the project needs.
- Separate runtime, development, and optional dependencies when the toolchain supports it.
- Preserve entry points and importable package layout.
- Run the smallest packaging check available.

## Never Do
- Add a dependency without a clear need.
- Rewrite packaging to a different tool because of preference.
- Commit environment-specific paths or local virtualenv state.
- Loosen dependency pins without checking compatibility risk.

## Cooperates With
python, dependency-audit, packaging, deployment, testing, code-review.

## Final Checklist
- Existing packaging tool was preserved.
- Dependency changes are justified and scoped.
- Entry points still point to importable functions.
- Build or metadata validation ran when practical.
- Lockfile changes match dependency changes when lockfiles are used.

## Examples
- Add a console script in `pyproject.toml` for an existing `main()` function.
- Move a test-only dependency out of runtime requirements when the project already separates groups.
