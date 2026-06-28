---
name: permissions-authorization
description: Enforce user, role, ownership, tenant, and capability checks in authoritative code.
---

# permissions-authorization

## Purpose
Ensure users can only access actions and data they are allowed to use.

## Auto Activation
Use for protected routes, admin features, roles, ownership checks, tenants,
organization IDs, resource sharing, policy changes, and permission bugs.

## Do Not Activate
Do not use for purely public resources with no user, role, tenant, or ownership
boundary.

## Detect
Look for `current_user`, roles, scopes, permissions, tenant IDs, organization
IDs, ownership fields, admin checks, ACLs, policy tables, and protected queries.

## Responsibilities
- Derive identity and scope from trusted server-side context.
- Enforce authorization before sensitive reads or writes.
- Scope queries by owner, tenant, or organization.
- Keep UI checks secondary to backend checks.
- Test denied and allowed paths when practical.

## Never Do
- Trust client-provided role, owner, tenant, or organization values directly.
- Rely only on hidden buttons or frontend guards.
- Add broad admin bypasses without explicit need.
- Leak whether a forbidden resource exists unless intended.

## Cooperates With
authentication, security, api-design, database-design, saas, fastapi, testing,
code-review.

## Final Checklist
- Identity source is trusted.
- Authorization happens before data access.
- Queries are scoped correctly.
- Denied paths fail safely.
- Permission behavior has a focused check when relevant.

## Examples
- Add an ownership filter to a FastAPI query before returning account records.
- Require an admin capability before exporting organization data.
