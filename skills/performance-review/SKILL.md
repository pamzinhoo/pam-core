---
name: performance-review
description: Review performance risk before completion. Use for Performance Gate checks, hot paths, slow UI, queries, loops, payload size, or resource usage concerns.
---

# performance-review

## Purpose
Decide whether a change introduces unacceptable performance or resource risk.

## Auto Activation
Use for Performance Gate checks, hot paths, database queries, loops over large
data, startup work, UI rendering, network payloads, file processing, or explicit
performance tasks.

## Do Not Activate
Do not use to micro-optimize cold paths, guess at performance without risk, or
replace implementation specialists such as `query-optimization`.

## Detect
Look for nested loops, N+1 queries, large DOM updates, repeated parsing,
blocking I/O, expensive startup work, large assets, unbounded memory, and
missing pagination or batching.

## Responsibilities
- Identify likely hot paths and resource bounds.
- Check whether work scales with data size or user count.
- Verify obvious batching, pagination, caching, or lazy loading needs.
- Prefer measurement when the project has a relevant benchmark or profiler.
- Flag performance regressions that should block completion.
- Report a pass, fail, or explicit residual risk for the Performance Gate.

## Never Do
- Claim performance improved without evidence.
- Add caching that can return stale or unauthorized data without safeguards.
- Replace `performance`, `python-performance`, `frontend-performance`, or
  `query-optimization`.
- Sacrifice correctness, security, or data integrity for speed.

## Cooperates With
performance, python-performance, frontend-performance, query-optimization,
testing, code-review.

## Final Checklist
- Hot path or scaling concern is named.
- Data-size behavior is acceptable.
- Existing measurements were used when available.
- No unsafe optimization was introduced.
- Performance Gate result is stated.

## Examples
- Fail a table view that loads all customer records without pagination.
- Pass a small admin-only config edit with no runtime path impact.
