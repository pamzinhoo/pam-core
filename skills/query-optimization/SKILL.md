---
name: query-optimization
description: Improve database query performance with plans, indexes, batching, and N+1 fixes.
---

# query-optimization

## Purpose
Make slow database access faster by changing queries, indexes, loading strategy, or data access patterns based on evidence.

## Auto Activation
Use for slow endpoints, N+1 queries, missing indexes, expensive joins, full scans, pagination issues, database load, or query plan analysis.

## Do Not Activate
Do not use for schema design without a performance concern or for Python-only performance work.

## Detect
Look for `EXPLAIN`, query plans, slow query logs, repeated selects, ORM lazy loading, missing indexes, large offsets, `ORDER BY`, joins, and aggregate queries.

## Responsibilities
- Inspect the query shape and available indexes.
- Fix N+1 behavior with joins, eager loading, batching, or prefetching.
- Add indexes only for real query patterns and write-cost tradeoffs.
- Prefer keyset pagination for large ordered scans when appropriate.
- Verify results remain correct after optimization.

## Never Do
- Add indexes blindly to every filtered column.
- Optimize by removing authorization or tenant filters.
- Denormalize before simpler query and index fixes are considered.
- Claim performance improved without evidence or a clear rationale.

## Cooperates With
sqlalchemy, database-design, python-performance, fastapi, testing, code-review.

## Final Checklist
- Slow query pattern is identified.
- Index or query change matches that pattern.
- Authorization and tenant filters remain intact.
- Correctness checks pass.
- Measurement or query-plan rationale is reported.

## Examples
- Add a composite index matching `tenant_id`, `status`, and `created_at` for a filtered ordered list.
- Replace per-row relationship loading with `selectinload` in a SQLAlchemy list endpoint.
