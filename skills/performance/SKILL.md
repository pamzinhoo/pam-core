---
name: performance
description: Improve performance from measurements, traces, profiles, query plans, or visible bottlenecks.
---

# performance

## Purpose
Improve speed or resource use from evidence, not guesswork.

## Auto Activation
Use for explicit performance work, slow commands, hot paths, large data loops,
startup costs, query plans, rendering delays, payload size, caching, batching, or
profiling.

## Do Not Activate
Do not use to add speculative optimization when there is no performance problem
or risk.

## Detect
Look for timings, profiles, traces, query plans, N+1 queries, large loops, file
processing, memory growth, render jank, network waterfalls, and cache behavior.

## Responsibilities
- Measure before optimizing when practical.
- Keep the evidence that identifies the bottleneck.
- Fix the largest real bottleneck first.
- Prefer simpler access patterns before complex caching.
- Verify improvement or state residual uncertainty.

## Never Do
- Claim performance gains without evidence.
- Add unsafe caching that bypasses authorization or freshness.
- Optimize cold code while ignoring measured hot paths.
- Make code harder to maintain for negligible benefit.

## Cooperates With
python-performance, frontend-performance, query-optimization, testing,
performance-review, code-review.

## Final Checklist
- Bottleneck evidence is identified.
- The fix targets the measured or obvious hot path.
- Data size and resource behavior are considered.
- Caching or batching is safe when used.
- Performance check ran or uncertainty is stated.

## Examples
- Use a query plan to add the smallest useful index.
- Batch repeated API calls only after confirming the repeated call is the slow
  path.
