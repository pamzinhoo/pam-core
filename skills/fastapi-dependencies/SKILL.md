---
name: fastapi-dependencies
description: Design FastAPI dependency injection for request context, resources, auth, and database sessions.
---

# fastapi-dependencies

## Purpose
Use FastAPI dependencies to share request-scoped resources without hiding business logic.

## Auto Activation
Use when editing `Depends`, dependency overrides, database session providers, current-user providers, settings injection, request context, or FastAPI tests with overrides.

## Do Not Activate
Do not use for generic Python dependency injection outside FastAPI.

## Detect
Look for `Depends`, `Annotated[..., Depends(...)]`, `dependency_overrides`, `yield` dependencies, `Request`, settings providers, and session dependencies.

## Responsibilities
- Keep dependencies small and request-scoped.
- Use `yield` dependencies for resources that need cleanup.
- Make test overrides explicit and local.
- Avoid hidden database writes or business decisions in dependencies.
- Preserve dependency order where auth or transactions depend on it.

## Never Do
- Put complex domain workflows inside a dependency.
- Share mutable request state globally.
- Leave sessions, clients, or files open after requests.
- Make dependencies perform surprising side effects.

## Cooperates With
fastapi, fastapi-authentication, sqlalchemy, transactions, python-error-handling, testing, code-review.

## Final Checklist
- Dependencies have one clear job.
- Request resources are cleaned up.
- Tests can override external resources safely.
- Auth and database dependencies run in the intended order.
- Route handlers remain readable.

## Examples
- Use a `yield` dependency to open and close a SQLAlchemy session per request.
- Override `get_current_user` in one test module without changing global app state.
