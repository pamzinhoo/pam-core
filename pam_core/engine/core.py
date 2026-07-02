"""Portable public engine facade."""

from __future__ import annotations

from typing import Any

from pam_core.config import RuntimeSettings, get_settings

from .decision import DecisionEngine
from .executor import SafeExecutor
from .scheduler import SkillScheduler
from .state import RuntimeState


class PamCoreEngine:
    """Public engine facade used by CLI, API, and IDE adapters."""

    def __init__(self, settings: RuntimeSettings | None = None) -> None:
        self.settings = settings or get_settings()
        self.state = RuntimeState(self.settings.memory_path)
        self.scheduler = SkillScheduler(
            decision_engine=DecisionEngine(self.settings.skills_path),
            executor=SafeExecutor(self.settings.skills_path),
        )

    def run_once(self) -> dict[str, Any]:
        return self.scheduler.run_cycle(self.state)

    def update_context(self, context: dict[str, Any]) -> dict[str, Any]:
        return self.state.update_context(context)

    def memory(self) -> dict[str, Any]:
        return self.state.snapshot()

    def health(self) -> dict[str, Any]:
        return {
            "status": "ok",
            "engine": "pam-core",
            "memory_path": str(self.settings.memory_path),
            "history_count": len(self.state.snapshot().get("history", [])),
        }
