"""Base adapter contract for pam-core runtimes."""

from __future__ import annotations

from typing import Any

from pam_core.engine import PamCoreEngine


class BaseAdapter:
    """Translate environment-specific input into the core engine context."""

    name = "base"

    def __init__(self, engine: PamCoreEngine | None = None) -> None:
        self.engine = engine or PamCoreEngine()

    def translate_input(self, payload: dict[str, Any] | None = None) -> dict[str, Any]:
        payload = payload or {}
        return {
            "adapter": self.name,
            **payload,
        }

    def run_once(self, payload: dict[str, Any] | None = None) -> dict[str, Any]:
        context = self.translate_input(payload)
        self.engine.update_context(context)
        return self.engine.run_once()

    def memory(self) -> dict[str, Any]:
        return self.engine.memory()

    def health(self) -> dict[str, Any]:
        health = self.engine.health()
        health["adapter"] = self.name
        return health
