"""CLI runtime adapter."""

from __future__ import annotations

from typing import Any

from .base_adapter import BaseAdapter


class CliAdapter(BaseAdapter):
    """Adapter for terminal and generic CLI environments."""

    name = "cli"

    def translate_input(self, payload: dict[str, Any] | None = None) -> dict[str, Any]:
        payload = payload or {}
        return {
            "adapter": self.name,
            "role": payload.get("role", "cli"),
            "action": payload.get("action", "run"),
            "input": payload.get("input", ""),
            **payload,
        }
