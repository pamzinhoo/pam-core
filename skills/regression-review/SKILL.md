---
name: regression-review
description: Review regression risk before completion. Use for regression gate checks, shared behavior, public contracts, migrations, UI flows, bug fixes, and compatibility-sensitive changes.
---

# regression-review

## Purpose
Decide whether a change is likely to break existing behavior or contracts.

## Auto Activation
Use for regression checks on shared modules, public APIs, schemas, migrations,
UI flows, bug fixes, routing maps, configuration, or behavior used by multiple
callers.

## Do Not Activate
Do not use for isolated docs edits or brand-new unused files with no integration
path.

## Detect
Look for changed function signatures, response shapes, schemas, defaults,
routes, component props, file formats, validation rules, permissions, and
backward compatibility assumptions.

## Responsibilities
- Identify existing behavior that must keep working.
- Check callers, contracts, and default behavior affected by the change.
- Verify the selected tests or smoke checks cover likely regressions.
- Flag compatibility breaks that need migration or explicit approval.
- Coordinate test selection with `testing` without owning it.
- Report a pass, fail, or explicit residual risk for regression readiness.

## Never Do
- Replace `testing` or claim tests passed without running them.
- Ignore changed public contracts because the diff is small.
- Treat snapshot churn as proof of correctness.
- Hide compatibility breaks in the final summary.

## Cooperates With
change-impact-analysis, testing, code-review, api-design, database-migrations,
ux-review.

## Final Checklist
- Existing behavior at risk is named.
- Callers or contracts were considered.
- Relevant checks are run or disclosed as missing.
- Compatibility breaks are explicit.
- Regression result is stated.

## Examples
- Fail an API response rename that has no compatibility plan or test update.
- Pass a bug fix when the old broken path and nearby success path are checked.
