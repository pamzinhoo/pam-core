---
name: fastapi-authentication
description: Implement FastAPI authentication boundaries, current-user dependencies, sessions, JWTs, and auth errors.
---

# fastapi-authentication

## Purpose
Enforce identity at FastAPI boundaries with explicit dependencies and safe auth failures.

## Auto Activation
Use when editing login, logout, current-user dependencies, token parsing, session cookies, OAuth callbacks, auth middleware, or authenticated routes.

## Do Not Activate
Do not use for generic authorization policy design unless FastAPI request handling is involved.

## Detect
Look for `Depends(get_current_user)`, `OAuth2PasswordBearer`, `Security`, `Authorization`, cookies, JWT claims, session IDs, `401`, and auth middleware.

## Responsibilities
- Centralize identity extraction in dependencies or middleware.
- Validate tokens, sessions, expiration, issuer, audience, and revocation where applicable.
- Return correct `401` errors without leaking credential details.
- Keep authentication separate from resource authorization decisions.
- Test protected and anonymous request paths.

## Never Do
- Trust user IDs, roles, tenants, or scopes from request bodies.
- Store or log plaintext credentials or tokens.
- Treat authentication as authorization.
- Disable auth checks to make tests pass.

## Cooperates With
fastapi, authentication, permissions-authorization, security, data-privacy, testing, code-review.

## Final Checklist
- Current user comes from a trusted dependency.
- Invalid and expired credentials fail safely.
- Protected routes cannot be reached anonymously.
- Authorization is handled by the proper policy layer.
- Auth tests or smoke checks ran when practical.

## Examples
- Add `get_current_user` to a router and reject missing bearer tokens with `401`.
- Move role checks out of token parsing and into a permission dependency.
