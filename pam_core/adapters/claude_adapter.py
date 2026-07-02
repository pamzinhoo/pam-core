"""Claude Code runtime adapter."""

from __future__ import annotations

from typing import Any

from .base_adapter import BaseAdapter


class ClaudeAdapter(BaseAdapter):
    """Adapter for Claude Code style agent contexts."""

    name = "claude"

    def translate_input(self, payload: dict[str, Any] | None = None) -> dict[str, Any]:
        payload = payload or {}
        return super().translate_input({
            "adapter": self.name,
            "role": payload.get("role", "ide-agent"),
            "action": payload.get("action", "run"),
            "input": payload.get("input", ""),
            **payload,
        })
