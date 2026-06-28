---
name: database-migrations
description: Plan and review database migrations across tools with data integrity, rollout, and rollback safety.
---

# database-migrations

## Purpose
Change database schemas without losing data or breaking running application code.

## Auto Activation
Use when adding, removing, renaming, or altering tables, columns, indexes, constraints, enums, seed data, or migration workflows.

## Do Not Activate
Do not use for query-only changes or model-only edits where no schema change is involved.

## Detect
Look for migration folders, schema diffs, `CREATE TABLE`, `ALTER TABLE`, `DROP`, constraints, indexes, Alembic, Django migrations, Prisma migrations, and rollback notes.

## Responsibilities
- Separate schema change, data backfill, and application rollout when needed.
- Prefer additive migrations for live systems.
- Protect existing data with backups, checks, or staged changes.
- Keep migration order and dependencies clear.
- Test migrations on representative empty and populated states when practical.

## Never Do
- Drop data-bearing structures casually.
- Rename columns without considering old application versions.
- Assume local empty-database migration proves production safety.
- Replace database constraints with application-only checks when constraints fit.

## Cooperates With
database-design, alembic, sqlalchemy, transactions, security, testing, code-review.

## Final Checklist
- Existing data impact is understood.
- Rollout order is safe for the project type.
- Constraints and indexes match domain needs.
- Rollback or recovery path is clear.
- Migration checks ran when practical.

## Examples
- Add a nullable column, backfill it, then enforce `NOT NULL` in a later migration.
- Add a unique index only after checking and cleaning duplicate rows.
