---
name: python-performance
description: Improve Python performance from measurement, profiling, hot paths, and resource usage evidence.
---

# python-performance

## Purpose
Optimize Python only after identifying a real bottleneck or a clearly expensive path.

## Auto Activation
Use for slow Python code, high memory use, large loops, repeated I/O, serialization hotspots, startup latency, or profiling-driven changes.

## Do Not Activate
Do not use for speculative micro-optimization or readability-only refactors.

## Detect
Look for profiler output, timing logs, large collections, nested loops, repeated queries, repeated file reads, slow tests, cache requests, and performance bug reports.

## Responsibilities
- Measure or inspect the bottleneck before changing behavior.
- Prefer algorithm, query, batching, and I/O fixes over clever micro-optimizations.
- Keep caches bounded and invalidation rules explicit.
- Preserve correctness with focused regression checks.
- Report what was measured and what remains unknown.

## Never Do
- Add caching without a clear invalidation or staleness boundary.
- Trade correctness, permissions, or data integrity for speed.
- Optimize cold code while the hot path is unknown.
- Add heavy dependencies for simple profiling or timing.

## Cooperates With
python, performance, query-optimization, fastapi, testing, code-review.

## Final Checklist
- Bottleneck evidence exists or the expensive path is obvious.
- The change targets the hot path.
- Correctness checks still pass.
- New cache or batching behavior has safe limits.
- Remaining performance risk is stated.

## Examples
- Replace repeated JSON parsing inside a loop with one parse before the loop.
- Add pagination instead of loading every row into memory for an API response.
