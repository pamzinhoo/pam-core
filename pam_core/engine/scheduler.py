"""Runtime scheduler for one pam-core execution cycle."""

from __future__ import annotations

from typing import Any

from .decision import DecisionEngine
from .executor import SafeExecutor
from .intelligence import ContextIntelligence
from .state import RuntimeState


class SkillScheduler:
    """Coordinate intelligence, decision ranking, execution, and memory."""

    def __init__(
        self,
        intelligence: ContextIntelligence | None = None,
        decision_engine: DecisionEngine | None = None,
        executor: SafeExecutor | None = None,
    ) -> None:
        self.intelligence = intelligence or ContextIntelligence()
        if decision_engine is None or executor is None:
            raise ValueError("decision_engine and executor are required")
        self.decision_engine = decision_engine
        self.executor = executor

    def run_cycle(self, state: RuntimeState) -> dict[str, Any]:
        context = state.context()
        analysis = self.intelligence.analyze(context)
        task = self.decision_engine.choose(context, analysis, state.snapshot())
        result = self.executor.execute(task, context, analysis)
        state.record(result)
        return result
