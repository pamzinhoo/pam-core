---
name: release-readiness
description: Review release readiness before completion. Use for Release Gate checks, deployable changes, packaging, plugin release, migrations, user-visible behavior, or handoff readiness.
---

# release-readiness

## Purpose
Decide whether a relevant change is ready to ship or hand off.

## Auto Activation
Use for Release Gate checks, deployment, packaging, plugin changes, migrations,
public behavior, operational changes, or any change the user expects to approve
as complete.

## Do Not Activate
Do not use for local exploration, drafts, or changes the user explicitly says
are not ready for completion.

## Detect
Look for versioned artifacts, manifests, migrations, setup instructions, release
notes, validation scripts, deployment configs, user-facing workflows, and
rollback-sensitive changes.

## Responsibilities
- Confirm required quality gates have known pass/fail status.
- Check validation, documentation, and residual risks are reported.
- Verify release blockers are separated from follow-up work.
- Confirm rollback, migration, or handoff notes exist when needed.
- Report a pass, fail, or explicit residual risk for the Release Gate.

## Never Do
- Mark a release ready when required gates are unknown.
- Replace `testing`, `deployment`, `packaging`, or `code-review`.
- Hide failed validation behind a summary.
- Treat approval as deployment unless the user requested deployment.

## Cooperates With
testing, code-review, documentation-review, security-review,
regression-review, deployment, packaging, git.

## Final Checklist
- Required gates have results.
- Validation result is known.
- Blockers and follow-ups are separated.
- Release or handoff risk is explicit.
- Release Gate result is stated.

## Examples
- Fail a plugin update when validation was not run or gate results are missing.
- Pass a docs-only release when validation passes and no behavior risk remains.
