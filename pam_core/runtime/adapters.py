"""Adapter factory for pam-core runtime environments."""

from __future__ import annotations

from pam_core.adapters import ClaudeAdapter, CliAdapter, CodexAdapter, CursorAdapter
from pam_core.adapters.base_adapter import BaseAdapter
from pam_core.engine import PamCoreEngine


def create_adapter(name: str, engine: PamCoreEngine | None = None) -> BaseAdapter:
    normalized = name.strip().lower()
    if normalized == "claude":
        return ClaudeAdapter(engine)
    if normalized == "codex":
        return CodexAdapter(engine)
    if normalized == "cursor":
        return CursorAdapter(engine)
    return CliAdapter(engine)
