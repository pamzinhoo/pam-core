"""FastAPI routes for pam-core."""

from __future__ import annotations

from typing import Any

from fastapi import APIRouter, Body

from pam_core.engine import PamCoreEngine
from pam_core.protocol.parser import call, doctor, memory as protocol_memory, run


def create_router(engine: PamCoreEngine | None = None) -> APIRouter:
    runtime_engine = engine or PamCoreEngine()
    router = APIRouter()

    @router.get("/health")
    def health() -> dict[str, Any]:
        return doctor(runtime_engine)

    @router.get("/run-once")
    def run_once() -> dict[str, Any]:
        return run(runtime_engine)

    @router.post("/run-once")
    def run_once_protocol(payload: Any = Body(default=None)) -> dict[str, Any]:
        return call(payload or {"intent": "POST /run-once", "action": "run"}, runtime_engine)

    @router.post("/protocol")
    def protocol(payload: Any = Body(default=None)) -> dict[str, Any]:
        return call(payload, runtime_engine)

    @router.post("/call")
    def universal_call(payload: Any = Body(default=None)) -> dict[str, Any]:
        return call(payload, runtime_engine)

    @router.get("/loop")
    def loop_once() -> dict[str, Any]:
        return run(runtime_engine)

    @router.post("/context")
    def update_context(context: dict[str, Any]) -> dict[str, Any]:
        return {
            "source": "pam-core",
            "protocol": "pam-protocol-v1",
            "intent": "POST /context",
            "action": "update_context",
            "result": runtime_engine.update_context(context),
            "status": "success",
        }

    @router.get("/memory")
    def memory() -> dict[str, Any]:
        return protocol_memory(runtime_engine)

    return router
