---
name: sqlalchemy
description: Use SQLAlchemy ORM and Core safely for models, sessions, queries, and FastAPI integration.
---

# sqlalchemy

## Purpose
Implement SQLAlchemy models, sessions, and queries with clear persistence boundaries.

## Auto Activation
Use when editing SQLAlchemy models, mappings, sessions, engines, query construction, relationships, eager loading, or ORM integration in services and APIs.

## Do Not Activate
Do not use for raw SQL-only projects unless SQLAlchemy is already part of the stack or being explicitly introduced.

## Detect
Look for `sqlalchemy`, `Session`, `AsyncSession`, `select`, `relationship`, `Mapped`, `mapped_column`, `declarative_base`, engines, and ORM models.

## Responsibilities
- Follow the project's SQLAlchemy major-version style.
- Keep session ownership clear and request-scoped in web apps.
- Use parameterized SQLAlchemy expressions or bound parameters.
- Model relationships and constraints consistently with migrations.
- Avoid accidental lazy-loading problems in response serialization.

## Never Do
- Create sessions deep inside domain logic when the project passes sessions explicitly.
- Build SQL with untrusted string interpolation.
- Mix sync and async SQLAlchemy APIs in one flow.
- Change models without considering migrations.

## Cooperates With
database-design, alembic, transactions, query-optimization, fastapi-dependencies, testing, code-review.

## Final Checklist
- SQLAlchemy style matches the project.
- Session lifecycle is explicit.
- Queries are parameterized.
- Model changes are paired with migration consideration.
- Relevant database checks ran when practical.

## Examples
- Add a `selectinload` option before serializing a list endpoint that needs related rows.
- Pass an `AsyncSession` from a FastAPI dependency instead of opening one in the route.
