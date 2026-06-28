---
name: security-review
description: Review security risk before completion. Use for Security Gate checks, auth, permissions, secrets, file operations, dependencies, external input, or agent trust boundaries.
---

# security-review

## Purpose
Decide whether a change preserves security boundaries before completion.

## Auto Activation
Use for Security Gate checks, authentication, authorization, secrets, external
input, file operations, shell commands, dependency changes, logs, exports,
uploads, webhooks, or agent/tool behavior.

## Do Not Activate
Do not use as a generic code review when no trust boundary, sensitive data, or
destructive behavior is touched.

## Detect
Look for tokens, cookies, API keys, `.env`, roles, owners, tenant IDs, uploads,
paths, SQL, shell commands, logs, web content, documents, and package metadata.

## Responsibilities
- Identify changed trust boundaries.
- Check input validation and authorization placement.
- Verify secrets and private data are not exposed.
- Check destructive actions are explicit and constrained.
- Coordinate dependency risk with `dependency-review`.
- Report a pass, fail, or explicit residual risk for the Security Gate.

## Never Do
- Print raw secrets or sensitive values.
- Treat client-side checks as authoritative authorization.
- Weaken validation to make a change smaller.
- Replace the implementation guidance owned by `security`.

## Cooperates With
security, secrets-management, permissions-authorization, data-privacy,
prompt-injection-defense, dependency-review, testing, code-review.

## Final Checklist
- Trust boundary is identified.
- Authorization and validation remain authoritative.
- Secrets and private data are protected.
- Destructive behavior is constrained.
- Security Gate result is stated.

## Examples
- Fail a route that returns records by ID without ownership checks.
- Pass a docs-only change that does not expose credentials or unsafe commands.
