---
name: authentication
description: Handle identity, sessions, credentials, roles, and auth event safety.
---

# authentication

## Purpose
Manage user identity and session mechanics without confusing them with
authorization policy.

## Auto Activation
Use when editing login, logout, signup, password handling, sessions, tokens,
cookies, current-user lookup, roles, credential rotation, or auth audit events.

## Do Not Activate
Do not use as the lead for resource-level access decisions; use
`permissions-authorization` for ownership, tenant, and capability checks.

## Detect
Look for password hashes, session IDs, JWTs, cookies, auth middleware,
`current_user`, roles, scopes, reset links, login events, and logout flows.

## Responsibilities
- Derive the current user from trusted server-side context.
- Hash passwords with proven algorithms.
- Expire and rotate sessions or tokens when risk changes.
- Keep identity extraction separate from authorization decisions.
- Audit important auth events without logging credentials.

## Never Do
- Trust user IDs, roles, or tenant IDs from request bodies.
- Log passwords, tokens, cookies, reset links, or private keys.
- Disable auth checks to simplify tests.
- Treat successful authentication as permission to access every resource.

## Cooperates With
security, permissions-authorization, fastapi-authentication, data-privacy,
testing, code-review.

## Final Checklist
- Identity source is trusted.
- Credentials and tokens are protected.
- Session expiration and rotation risks are considered.
- Authorization remains separate and authoritative.
- Auth paths have focused checks when practical.

## Examples
- Move current-user lookup into a trusted backend dependency.
- Add safe audit logging for failed login attempts without recording passwords.
