"""FastAPI app for pam-core API server mode."""

from __future__ import annotations

from fastapi import FastAPI

from pam_core.config import RuntimeSettings
from pam_core.registry import SkillRegistry
from pam_core.server.routes import create_router
from pam_core.version import get_version


def create_app(settings: RuntimeSettings | None = None) -> FastAPI:
    """Create the HTTP API server without changing CLI runtime behavior."""

    app = FastAPI(title="pam-core API Server", version=get_version())
    app.include_router(create_router(SkillRegistry(settings)))

    return app


app = create_app()
