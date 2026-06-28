---
name: async-python
description: Write correct Python async code for asyncio, async clients, workers, and FastAPI integrations.
---

# async-python

## Purpose
Use Python async features only where concurrency is real and the project already supports it.

## Auto Activation
Use when editing `async def`, `await`, `asyncio`, async database sessions, async HTTP clients, task groups, async tests, or FastAPI async routes.

## Do Not Activate
Do not use for synchronous scripts, CPU-bound performance work, or code where async would only add complexity.

## Detect
Look for `async def`, `await`, `asyncio`, `anyio`, `httpx.AsyncClient`, `AsyncSession`, `pytest.mark.anyio`, `pytest.mark.asyncio`, `BackgroundTasks`, and async FastAPI dependencies.

## Responsibilities
- Preserve async boundaries instead of mixing blocking calls into event-loop code.
- Use timeouts and cancellation-aware cleanup for network and worker code.
- Keep shared mutable state protected or avoided.
- Prefer project-standard async libraries over adding new clients.
- Test async behavior with the existing async test setup.

## Never Do
- Call blocking file, network, sleep, or database operations from hot async paths without an explicit reason.
- Use `asyncio.run()` inside an already running event loop.
- Hide concurrent failures with fire-and-forget tasks.
- Convert a synchronous module to async without a clear integration need.

## Cooperates With
python, fastapi, fastapi-background-tasks, sqlalchemy, transactions, testing, code-review.

## Final Checklist
- Blocking calls were removed or isolated.
- Awaited operations have clear ownership and error paths.
- Cancellation and timeout behavior is acceptable.
- Async tests or smoke checks ran when practical.
- No unnecessary async rewrite was introduced.

## Examples
- Replace `requests.get()` in an async route with the project's existing async HTTP client and a timeout.
- Keep a CLI importer synchronous because it has no concurrent I/O and async would not improve it.
