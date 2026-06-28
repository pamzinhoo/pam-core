---
name: frontend-api-integration
description: Connect frontend UI to APIs with clear states and contracts.
---

# frontend-api-integration

## Purpose
Integrate frontend screens with API data while preserving contract clarity,
error handling, and user recovery.

## Auto Activation
Use when editing fetch calls, API clients, mutations, query parameters,
pagination, authentication headers, retries, response mapping, or UI data
loading.

## Do Not Activate
Do not use for backend-only API design or static frontend changes with no remote
data.

## Detect
Look for `fetch`, `axios`, API clients, generated clients, query hooks, request
bodies, response mappers, pagination cursors, auth headers, and network error
states.

## Responsibilities
- Match frontend expectations to documented or discovered API contracts.
- Validate and normalize API responses at the integration boundary when needed.
- Represent loading, empty, error, partial, and success states.
- Prevent duplicate submissions and unsafe retries.
- Avoid leaking tokens, PII, or internal errors into UI or logs.

## Never Do
- Assume response shapes without checking nearby contracts or existing clients.
- Swallow network or validation errors silently.
- Retry non-idempotent writes without a clear rule.
- Put API secrets in browser code.

## Cooperates With
javascript, api-design, loading-empty-error-states, frontend-state-management,
security, data-privacy, testing.

## Final Checklist
- Request and response shapes are understood.
- Error paths are visible and recoverable.
- Mutations handle pending and duplicate-submit behavior.
- Sensitive data is not exposed.
- The smallest useful integration check ran.

## Examples
- Add a typed mapper around a users endpoint before rendering a table.
- Show a retryable error state when an activity feed request fails.
