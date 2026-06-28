---
name: python-logging
description: Add safe, useful Python logging for diagnostics, operations, and backend services.
---

# python-logging

## Purpose
Make Python logs useful for diagnosis without leaking secrets or private data.

## Auto Activation
Use when adding or changing loggers, log levels, structured logging, request IDs, error logs, audit-relevant diagnostics, or logging configuration.

## Do Not Activate
Do not use when print output is only a simple CLI result and no operational logging is needed.

## Detect
Look for `logging`, `logger`, `dictConfig`, `structlog`, `loguru`, request IDs, trace IDs, exception handlers, and production diagnostics.

## Responsibilities
- Use the project's logging library and configuration style.
- Choose levels that match operational severity.
- Include stable context such as IDs, names of operations, and safe counts.
- Exclude secrets, tokens, passwords, cookies, and unnecessary PII.
- Preserve exceptions with stack traces only in trusted logs.

## Never Do
- Log raw credentials, session values, auth headers, private keys, or `.env` contents.
- Replace useful exceptions with vague log-only failures.
- Spam logs inside hot loops without sampling or aggregation.
- Configure global logging in reusable library modules unless the project already does that.

## Cooperates With
python, security, data-privacy, fastapi, python-error-handling, testing, code-review.

## Final Checklist
- Log messages identify the operation and safe context.
- Sensitive values are not logged.
- Levels are intentional.
- Errors still propagate or return correctly.
- Logging was checked in the relevant path.

## Examples
- Add `logger.exception("failed to sync invoice", extra={"invoice_id": invoice_id})` without logging customer payment data.
- Downgrade expected validation failures from error logs to debug or info.
