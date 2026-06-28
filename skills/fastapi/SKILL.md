---
name: fastapi
description: Build simple, safe FastAPI backends.
---

# fastapi

## Purpose
Build FastAPI endpoints with thin routes, validated contracts, and safe errors.

## Auto Activation
Use when editing FastAPI routes, dependencies, Pydantic models, middleware, auth, OpenAPI behavior, or backend tests.

## Do Not Activate
Do not use for generic Python scripts or non-HTTP code unless FastAPI integration is involved.

## Detect
Look for `FastAPI`, `APIRouter`, `Depends`, Pydantic models, `HTTPException`, route decorators, request/response schemas, and test clients.

## Responsibilities
- Keep routes thin and move business rules to services or domain functions.
- Validate request and response models.
- Use dependencies for auth, database sessions, and shared context.
- Return clear HTTP errors without leaking internals.
- Preserve API compatibility unless the task changes it.

## Never Do
- Put complex business logic directly in route handlers.
- Trust client-provided identity, role, tenant, or ownership values.
- Leak stack traces, secrets, or raw database errors to clients.
- Change public response shapes accidentally.

## Cooperates With
api-design, authentication, security, python, database-design, sqlite, testing, code-review.

## Final Checklist
- Request and response contracts are explicit.
- Authorization is enforced before sensitive data access.
- Errors are intentional and safe.
- Route logic stays small.
- Endpoint behavior has a focused test or smoke check.

## Examples
- Add a `Depends(get_current_user)` ownership check before loading account data.
- Move invoice total calculation out of a route and test it as a domain function.
