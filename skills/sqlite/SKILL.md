---
name: sqlite
description: Use SQLite safely for local and small apps.
---

# sqlite

## Purpose
Use SQLite reliably for local, embedded, and small internal systems.

## Auto Activation
Use when editing SQLite schemas, migrations, queries, transactions, local storage, or Python database code.

## Do Not Activate
Do not use for hosted multi-user systems that clearly require PostgreSQL or another server database.

## Detect
Look for `.sqlite`, `.db`, `sqlite3`, `aiosqlite`, `SQLModel`, `CREATE TABLE`, migrations, PRAGMA settings, and local app storage paths.

## Responsibilities
- Enable foreign keys.
- Use transactions for multi-step writes.
- Keep schema setup explicit and repeatable.
- Use parameters instead of string-built SQL.
- Choose integer minor units or decimal text for money.

## Never Do
- Build SQL with untrusted string interpolation.
- Pretend SQLite solves high-concurrency hosted workloads.
- Skip backups or migrations for data-bearing changes.
- Leave partial writes possible in normal error paths.

## Cooperates With
python, database-design, financial-system, desktop-local, security, testing, code-review.

## Final Checklist
- Foreign keys and constraints protect integrity.
- Queries are parameterized.
- Multi-step writes are transactional.
- Migration or schema setup is clear.
- A focused database check was run when practical.

## Examples
- Wrap account and transaction inserts in one transaction.
- Add a foreign key constraint instead of only checking parent existence in Python.
