---
name: fastapi-validation
description: Validate FastAPI request, response, path, query, and body data with Pydantic contracts.
---

# fastapi-validation

## Purpose
Keep FastAPI input and output contracts explicit, narrow, and compatible.

## Auto Activation
Use when editing Pydantic models, request bodies, response models, query parameters, path parameters, OpenAPI schemas, or validation error behavior.

## Do Not Activate
Do not use for pure database constraints or domain invariants unless they cross the FastAPI boundary.

## Detect
Look for `BaseModel`, `Field`, `Annotated`, `Path`, `Query`, `Body`, `response_model`, validators, `model_config`, and `422` behavior.

## Responsibilities
- Define request and response schemas at the API boundary.
- Reject unknown or unsafe fields when the project expects strict contracts.
- Keep response models from leaking internal ORM fields.
- Preserve OpenAPI compatibility unless the task changes it.
- Test validation success and failure paths for changed contracts.

## Never Do
- Accept raw dictionaries for structured public inputs without a reason.
- Expose password hashes, tokens, internal IDs, or private fields in responses.
- Change field names, optionality, or error behavior accidentally.
- Duplicate domain validation instead of calling the domain layer where needed.

## Cooperates With
fastapi, api-design, python-error-handling, sqlalchemy, database-design, testing, code-review.

## Final Checklist
- Inputs and outputs use explicit schemas.
- Unsafe or internal fields are excluded.
- Validation errors are intentional.
- OpenAPI impact is understood.
- Contract checks ran when practical.

## Examples
- Add a `response_model` that excludes internal audit columns from a user endpoint.
- Make a query parameter bounded with `Query(ge=1, le=100)` for pagination.
