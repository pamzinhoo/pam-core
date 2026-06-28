---
name: transactions
description: Protect multi-step database writes with explicit transaction boundaries, isolation, and rollback behavior.
---

# transactions

## Purpose
Keep database state consistent when a workflow has multiple reads, writes, side effects, or failure paths.

## Auto Activation
Use when editing multi-step writes, commits, rollbacks, unit-of-work patterns, isolation levels, locks, idempotency, retries, or payment/order/status workflows.

## Do Not Activate
Do not use for single independent reads or writes with no consistency concern.

## Detect
Look for `commit`, `rollback`, `begin`, `atomic`, `transaction`, unit of work, status transitions, balances, reservations, inventory, and concurrent updates.

## Responsibilities
- Define the smallest transaction boundary that protects the invariant.
- Commit only after all required database writes succeed.
- Roll back partial changes on failure.
- Use locks, constraints, or idempotency keys for concurrency-sensitive flows.
- Keep external side effects outside transactions unless the project has an outbox pattern.

## Never Do
- Commit halfway through an invariant-preserving workflow.
- Hold transactions open during slow network calls.
- Rely on read-then-write checks without constraints or locks when races matter.
- Retry non-idempotent writes unsafely.

## Cooperates With
database-design, sqlalchemy, database-migrations, python-error-handling, financial-system, testing, code-review.

## Final Checklist
- Transaction boundary protects the invariant.
- Partial failure rolls back correctly.
- Concurrency risks are handled or stated.
- External side effects are ordered safely.
- A focused transaction test or check ran when practical.

## Examples
- Wrap order creation and inventory reservation in one transaction.
- Move email sending after commit so a rollback does not still notify the user.
