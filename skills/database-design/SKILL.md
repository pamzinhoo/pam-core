---
name: database-design
description: Design relational data with constraints, transactions, migrations, and integrity first.
---

# database-design

## Purpose
Model persistent data so integrity is protected by the database and application
together.

## Auto Activation
Use when changing schemas, constraints, indexes, relationships, migrations,
data access patterns, persistence boundaries, or stored domain invariants.

## Do Not Activate
Do not use for transient in-memory structures or UI-only state.

## Detect
Look for tables, models, foreign keys, unique constraints, indexes, migrations,
transactions, ORM mappings, query filters, and data import/export behavior.

## Responsibilities
- Model facts once with clear relationships.
- Use constraints, foreign keys, unique indexes, and transactions where they fit.
- Preserve data integrity during migrations.
- Keep destructive migrations reversible or explicitly documented.
- Coordinate access control and business invariants with owning skills.

## Never Do
- Rely only on app code when a database constraint is needed.
- Duplicate the same fact across tables without a clear reason.
- Add nullable or optional data paths that weaken required invariants.
- Make destructive schema changes without migration and rollback awareness.

## Cooperates With
sqlite, sqlalchemy, database-migrations, transactions, query-optimization,
business-rules, security, testing, code-review.

## Final Checklist
- Relationships and constraints match the domain.
- Integrity is protected at the right layer.
- Migration risk is identified.
- Queries can enforce authorization or ownership when needed.
- Data behavior has focused checks when practical.

## Examples
- Add a unique constraint for a natural duplicate that app code cannot reliably
  prevent.
- Split a repeated text field into a related table only when real reuse exists.
