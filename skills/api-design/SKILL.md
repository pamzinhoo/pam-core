---
name: api-design
description: Design clear APIs with validation, authorization boundaries, stable errors, and compatible contracts.
---

# api-design

## Purpose
Design API boundaries that are predictable, validated, and compatible.

## Auto Activation
Use when changing routes, request or response shapes, status codes, validation,
pagination, error responses, versioning, or backend integration contracts.

## Do Not Activate
Do not use for internal implementation changes that do not affect an API
boundary or contract.

## Detect
Look for HTTP handlers, routers, controllers, schemas, OpenAPI, JSON response
models, status codes, client calls, and public service interfaces.

## Responsibilities
- Name resources and actions clearly.
- Validate inputs at the boundary.
- Return predictable status codes and error shapes.
- Preserve compatibility or state the migration path.
- Avoid exposing internal models accidentally.

## Never Do
- Treat UI validation as the only API validation.
- Leak private implementation fields in responses.
- Change response shape without considering callers.
- Mix authentication, authorization, and business validation without clear
  errors.

## Cooperates With
fastapi, security, permissions-authorization, database-design, testing,
regression-review, code-review.

## Final Checklist
- Request and response contracts are explicit.
- Inputs are validated at the API boundary.
- Errors are stable and safe.
- Authorization is handled by authoritative code.
- Compatibility risk is tested or disclosed.

## Examples
- Add a `400` validation error shape for invalid query filters.
- Keep an old response field during a transition while adding the new one.
