---
name: fastapi-background-tasks
description: Use FastAPI background tasks and worker handoff safely for post-response work.
---

# fastapi-background-tasks

## Purpose
Run post-response work safely when it is small, non-critical, and compatible with FastAPI's background task model.

## Auto Activation
Use when editing `BackgroundTasks`, post-response email or notification work, webhook dispatch, worker handoff, async jobs, or task failure handling in FastAPI apps.

## Do Not Activate
Do not use for durable queues, scheduled jobs, or long-running workers unless FastAPI is the entry boundary.

## Detect
Look for `BackgroundTasks`, `add_task`, queue clients, Celery/RQ/Arq handoff, email after response, file cleanup, and audit side effects.

## Responsibilities
- Use FastAPI background tasks only for short best-effort work.
- Hand durable or critical work to a real queue when the project has one.
- Pass stable IDs to tasks instead of live request/session objects.
- Log task failures without exposing sensitive data.
- Keep task idempotency in mind for retries or duplicate dispatch.

## Never Do
- Put critical data writes only in in-process background tasks.
- Pass request-scoped database sessions into background execution.
- Hide user-visible failure behind a background task.
- Run unbounded CPU or I/O work in the app process.

## Cooperates With
fastapi, async-python, python-logging, python-error-handling, transactions, testing, code-review.

## Final Checklist
- Background work is safe to run after the response.
- Critical work is durable or remains in the request transaction.
- Task inputs are stable IDs or immutable values.
- Failure logging is safe and useful.
- Behavior has a focused test or smoke check when practical.

## Examples
- Queue an email notification with an order ID after the order commit succeeds.
- Move a long PDF generation task from `BackgroundTasks` to the project's worker queue.
