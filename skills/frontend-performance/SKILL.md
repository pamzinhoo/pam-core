---
name: frontend-performance
description: Improve frontend speed from user-visible evidence.
---

# frontend-performance

## Purpose
Improve frontend performance where UI responsiveness, loading time, rendering,
or bundle size affects real use.

## Auto Activation
Use when the task mentions slow UI, large bundles, layout shift, expensive
rendering, image weight, table performance, hydration issues, or measured web
vitals.

## Do Not Activate
Do not use for speculative optimization or backend-only performance work.

## Detect
Look for large assets, repeated renders, heavy effects, long lists, expensive
DOM updates, bundle reports, Lighthouse output, web vitals, memoization, and
lazy loading.

## Responsibilities
- Start from a visible symptom or measurement.
- Reduce unnecessary rendering, work, and asset weight.
- Prefer pagination, virtualization, or progressive loading for large data.
- Preserve accessibility and perceived responsiveness.
- Verify improvement with the smallest practical check.

## Never Do
- Add memoization everywhere without measuring or isolating a cause.
- Trade correctness or accessibility for speed.
- Lazy-load critical controls needed for first action.
- Optimize micro-costs while ignoring large assets or network waits.

## Cooperates With
performance, javascript, html-css, frontend-api-integration, table-design,
css-architecture, testing.

## Final Checklist
- A performance symptom or measurement guided the work.
- The fix targets the likely bottleneck.
- Initial interaction remains usable.
- Layout shift and loading feedback are handled.
- A relevant check or measurement is reported.

## Examples
- Paginate a large audit table instead of rendering thousands of rows at once.
- Replace oversized images with responsive sources on a product page.
