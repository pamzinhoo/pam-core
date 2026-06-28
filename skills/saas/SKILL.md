---
name: saas
description: Build hosted multi-user products with tenant isolation, roles, billing, audit, and data lifecycle safety.
---

# saas

## Purpose
Protect multi-tenant product boundaries and hosted operational concerns.

## Auto Activation
Use when changing tenants, organizations, users, subscriptions, roles, billing,
audit logs, data exports, deletion flows, hosted settings, or SaaS onboarding.

## Do Not Activate
Do not use as the lead for local-only desktop tools or single-user offline apps.

## Detect
Look for tenant IDs, organization IDs, user roles, subscriptions, billing plans,
audit events, hosted databases, admin features, data export/delete, and
cross-customer access risks.

## Responsibilities
- Treat tenant isolation as a security boundary.
- Scope every protected query and permission check.
- Keep roles and billing behavior explicit.
- Plan audit logs for sensitive administrative actions.
- Coordinate data lifecycle with privacy and database skills.

## Never Do
- Trust tenant or organization IDs from clients without authorization.
- Mix customer data in shared queries or exports.
- Add broad admin bypasses without explicit policy.
- Implement billing or deletion flows without auditability.

## Cooperates With
security, permissions-authorization, authentication, data-privacy,
database-design, transactions, business-rules, testing, code-review.

## Final Checklist
- Tenant or organization scope is enforced server-side.
- Roles and permissions are explicit.
- Billing and audit-sensitive behavior is traceable.
- Export and deletion risks are considered.
- Isolation behavior has focused checks when practical.

## Examples
- Add tenant scoping to every query behind an organization dashboard.
- Require an audited admin permission before exporting customer data.
