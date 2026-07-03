"""API server mode for pam-core."""

from .app import app, create_app

__all__ = ["app", "create_app"]
