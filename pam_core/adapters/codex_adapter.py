"""Codex runtime adapter."""

from __future__ import annotations

from typing import Any

from .base_adapter import BaseAdapter


class CodexAdapter(BaseAdapter):
    """Adapter for Codex CLI and Codex IDE-style contexts."""

    name = "codex"

    def translate_input(self, payload: dict[str, Any] | None = None) -> dict[str, Any]:
        payload = payload or {}
        return super().translate_input({
            "adapter": self.name,
            "role": payload.get("role", "ide-agent"),
            "action": payload.get("action", "run"),
            "input": payload.get("input", ""),
            **payload,
        })
