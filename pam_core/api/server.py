"""FastAPI application factory for pam-core."""

from __future__ import annotations

from fastapi import FastAPI

from pam_core.engine import PamCoreEngine

from .routes import create_router


def create_app(engine: PamCoreEngine | None = None) -> FastAPI:
    app = FastAPI(title="pam-core Runtime Engine", version="1.2.0")
    app.include_router(create_router(engine))
    return app


app = create_app()
