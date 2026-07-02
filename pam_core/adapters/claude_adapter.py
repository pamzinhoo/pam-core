"""Claude Code runtime adapter."""

from __future__ import annotations

from typing import Any

from .base_adapter import BaseAdapter


class ClaudeAdapter(BaseAdapter):
    """Adapter for Claude Code style agent contexts."""

    name = "claude"

    def translate_input(self, payload: dict[str, Any] | None = None) -> dict[str, Any]:
        payload = payload or {}
        return {
            "adapter": self.name,
            "role": payload.get("role", "ide-agent"),
            "action": payload.get("action", "claude-code"),
            "input": payload.get("input", ""),
            **payload,
        }
