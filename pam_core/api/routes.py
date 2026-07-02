"""FastAPI routes for pam-core."""

from __future__ import annotations

from typing import Any

from fastapi import APIRouter

from pam_core.engine import PamCoreEngine


def create_router(engine: PamCoreEngine | None = None) -> APIRouter:
    runtime_engine = engine or PamCoreEngine()
    router = APIRouter()

    @router.get("/health")
    def health() -> dict[str, Any]:
        return runtime_engine.health()

    @router.get("/run-once")
    def run_once() -> dict[str, Any]:
        return runtime_engine.run_once()

    @router.get("/loop")
    def loop_once() -> dict[str, Any]:
        return runtime_engine.run_once()

    @router.post("/context")
    def update_context(context: dict[str, Any]) -> dict[str, Any]:
        return {
            "status": "ok",
            "context": runtime_engine.update_context(context),
        }

    @router.get("/memory")
    def memory() -> dict[str, Any]:
        return runtime_engine.memory()

    return router
