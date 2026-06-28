---
name: documentation-review
description: Review documentation readiness before completion. Use for Documentation Gate checks, changed public behavior, setup, commands, APIs, skills, release notes, or operational docs.
---

# documentation-review

## Purpose
Decide whether documentation affected by a change is accurate and sufficient.

## Auto Activation
Use for Documentation Gate checks, new skills, APIs, commands, setup steps,
configuration, release behavior, operational procedures, or changed user-facing
behavior.

## Do Not Activate
Do not use for tiny internal changes that do not affect usage, operation,
contracts, or standards.

## Detect
Look for README files, module maps, skill files, API docs, config examples,
runbooks, changelogs, commands, validation scripts, and user-facing instructions.

## Responsibilities
- Check that required docs exist and match current behavior.
- Verify commands, file names, and examples are concrete.
- Identify stale, duplicated, or misleading documentation.
- Confirm documentation does not expose secrets or unsafe instructions.
- Keep docs concise and linked to owning skills or modules.
- Report a pass, fail, or explicit residual risk for the Documentation Gate.

## Never Do
- Create long docs for behavior users cannot act on.
- Duplicate full rules from specialist skills.
- Replace `document-system` for file workflow work.
- Claim documentation is current without checking changed behavior.

## Cooperates With
document-system, automation-scripts, skill-orchestrator, security-review,
testing, code-review.

## Final Checklist
- Affected docs are identified.
- Docs match changed behavior.
- Commands and examples are accurate.
- No sensitive data is disclosed.
- Documentation Gate result is stated.

## Examples
- Fail a new CLI option that has no README or help text update.
- Pass a skill update when module maps and dependency docs were updated.
