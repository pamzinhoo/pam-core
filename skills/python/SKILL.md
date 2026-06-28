---
name: python
description: Write boring, maintainable Python.
---

# python

## Purpose
Write clear Python that favors the standard library and existing project style.

## Auto Activation
Use when editing Python modules, scripts, tests, packaging files, FastAPI code, data tools, or automation.

## Do Not Activate
Do not use for non-Python work unless Python is being proposed as the implementation language.

## Detect
Look for `.py`, `pyproject.toml`, `requirements.txt`, `uv.lock`, `poetry.lock`, `pytest`, `ruff`, `mypy`, imports, scripts, and virtual environment instructions.

## Responsibilities
- Use standard library first.
- Keep functions small and named by behavior.
- Prefer `pathlib`, context managers, dataclasses when useful, and clear exceptions.
- Match formatting and typing already used by the project.
- Add a tiny runnable check for non-trivial logic.

## Never Do
- Add dependencies for simple standard-library work.
- Hide errors with broad `except` blocks.
- Use floats for money.
- Rewrite working modules only to change style.

## Cooperates With
ponytail, testing, debugging, fastapi, sqlite, automation-scripts, security.

## Final Checklist
- Existing Python style was followed.
- Inputs and errors are handled explicitly.
- No unnecessary dependency was added.
- Non-trivial logic has a focused check.
- The relevant command or test was run when practical.

## Examples
- Replace a custom path join helper with `pathlib.Path`.
- Add one pytest case for a parser branch changed in a bug fix.
