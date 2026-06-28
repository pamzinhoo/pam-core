---
name: business-rules
description: Keep domain policies explicit, source-backed, and protected by focused checks.
---

# business-rules

## Purpose
Protect domain decisions from being invented, scattered, or hidden in UI code.

## Auto Activation
Use when changing domain policies, status transitions, eligibility rules,
approval flows, money-adjacent behavior, school or SaaS rules, audit behavior,
or validations that represent business meaning.

## Do Not Activate
Do not use for purely technical validation with no domain policy.

## Detect
Look for status fields, policy checks, approval states, invoices, balances,
enrollments, subscriptions, roles, audit trails, and domain-specific validators.

## Responsibilities
- Confirm the rule source before encoding behavior.
- Put authoritative rules close to domain logic.
- Name rules by business meaning.
- Keep UI convenience separate from authoritative decisions.
- Add small checks for important cases.

## Never Do
- Invent policy because it seems reasonable.
- Let frontend-only checks enforce important decisions.
- Hide rule changes inside refactors.
- Change money, eligibility, or status behavior without verification.

## Cooperates With
financial-system, database-design, security, permissions-authorization, testing,
regression-review, code-review.

## Final Checklist
- The rule source is known or uncertainty is stated.
- Authoritative code owns the decision.
- Edge cases are explicit.
- Important transitions are tested.
- UI behavior does not replace domain enforcement.

## Examples
- Add a named status-transition guard for invoice cancellation.
- Refuse to guess enrollment eligibility without a source rule.
