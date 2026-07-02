"""FastAPI app for pam-core AI tool server mode."""

from __future__ import annotations

from typing import Any

from fastapi import Body, FastAPI

from pam_core.engine import PamCoreEngine
from pam_core.protocol.parser import call, doctor, memory as protocol_memory, run

from .router import handle_tool_call


def create_app(engine: PamCoreEngine | None = None) -> FastAPI:
    """Create the AI tool server app without changing CLI runtime behavior."""

    runtime_engine = engine or PamCoreEngine()
    app = FastAPI(title="pam-core AI Tool Server", version="1.0.0")

    @app.get("/health")
    def health() -> dict[str, Any]:
        return doctor(runtime_engine)

    @app.post("/call")
    def tool_call(payload: Any = Body(default=None)) -> dict[str, Any]:
        return handle_tool_call(payload or {})

    @app.post("/protocol")
    def protocol(payload: Any = Body(default=None)) -> dict[str, Any]:
        return call(payload, runtime_engine)

    @app.post("/run-once")
    def run_once(payload: Any = Body(default=None)) -> dict[str, Any]:
        if payload is not None:
            return call(payload, runtime_engine)
        return run(runtime_engine)

    @app.post("/context")
    def update_context(context: dict[str, Any] | None = Body(default=None)) -> dict[str, Any]:
        return {
            "source": "pam-core",
            "protocol": "pam-protocol-v1",
            "intent": "POST /context",
            "action": "update_context",
            "result": runtime_engine.update_context(context or {}),
            "status": "success",
        }

    @app.get("/memory")
    def memory() -> dict[str, Any]:
        return protocol_memory(runtime_engine)

    return app


app = create_app()
