---
name: python-error-handling
description: Handle Python errors with clear exceptions, cleanup, retries, and user-safe failure paths.
---

# python-error-handling

## Purpose
Make Python failure paths explicit, recoverable where appropriate, and visible without hiding bugs.

## Auto Activation
Use when editing exceptions, retries, cleanup, context managers, result validation, CLI error output, service error boundaries, or backend error translation.

## Do Not Activate
Do not use for code that does not change failure behavior.

## Detect
Look for `try`, `except`, `finally`, `raise`, custom exceptions, retries, context managers, `HTTPException`, rollback paths, and error response handling.

## Responsibilities
- Catch only exceptions the code can handle or translate.
- Preserve original error context with `raise ... from ...` when wrapping.
- Keep cleanup and rollback paths reliable.
- Use retries only for transient failures with bounded attempts.
- Convert internal errors to safe user-facing messages at the boundary.

## Never Do
- Use broad `except Exception` to continue silently.
- Swallow data-loss, permission, or integrity errors.
- Retry non-idempotent operations without safeguards.
- Leak stack traces or internal details to untrusted users.

## Cooperates With
python, python-logging, fastapi-validation, transactions, security, testing, code-review.

## Final Checklist
- Each catch block has a clear reason.
- Cleanup or rollback happens on partial failure.
- Error messages are safe for their audience.
- Original context is preserved for diagnostics.
- Failure behavior has a focused check when practical.

## Examples
- Wrap a file parse error with the filename but not the full private path contents.
- Roll back a multi-step import when one row fails validation.
