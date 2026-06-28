---
name: dependency-review
description: Review dependency risk before completion. Use for dependency gate checks, package additions, lockfile changes, upgrades, plugins, scripts, or supply-chain risk.
---

# dependency-review

## Purpose
Decide whether dependency changes are justified, safe, and maintainable.

## Auto Activation
Use for new packages, package upgrades, lockfile changes, plugin manifests,
download scripts, build tool changes, or dependency-related security findings.

## Do Not Activate
Do not use when no dependency, package metadata, lockfile, installer, or external
tooling behavior changed.

## Detect
Look for `package.json`, lockfiles, `pyproject.toml`, requirements files,
plugin manifests, installer scripts, Dockerfiles, GitHub Actions, and vendor
downloads.

## Responsibilities
- Check whether the dependency is necessary for the task.
- Verify existing platform or project tools cannot reasonably do the job.
- Identify supply-chain, license, maintenance, and transitive risk.
- Check lockfile and metadata consistency.
- Report a pass, fail, or explicit residual risk for dependency readiness.

## Never Do
- Install or upgrade packages without explicit need.
- Replace `dependency-audit` for implementation guidance.
- Approve a dependency that only saves a few lines of simple code.
- Ignore lockfile drift or unknown external downloads.

## Cooperates With
dependency-audit, security-review, ponytail, safe-command-execution, packaging,
deployment, testing, code-review.

## Final Checklist
- Dependency change is identified.
- Need is justified.
- Metadata and lockfiles are consistent.
- Supply-chain risk is acceptable or disclosed.
- Dependency result is stated.

## Examples
- Fail adding a utility package for behavior the standard library covers.
- Pass a lockfile update that matches a justified patch release.
