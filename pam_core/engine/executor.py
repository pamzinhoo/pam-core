"""Safe simulated executor for pam-core runtime tasks."""

from __future__ import annotations

from pathlib import Path
from typing import Any


class SafeExecutor:
    """Execute simulated logic only."""

    UNSAFE_TERMS = {
        "sudo",
        "rm -rf",
        "format",
        "wipe",
        "delete filesystem",
        "print secret",
        "exfiltrate",
        "private key",
    }

    def __init__(self, skills_path: Path) -> None:
        self.skills_path = skills_path

    def execute(
        self,
        task: dict[str, Any],
        context: dict[str, Any],
        analysis: dict[str, Any],
    ) -> dict[str, Any]:
        selected_skill = task["selected_skill"]
        safety = self._validate(context, analysis)

        if not safety["allowed"]:
            return self._format_result(
                analysis=analysis,
                selected_skill=selected_skill,
                alternatives=task["alternatives"],
                result=safety["reason"],
            )

        if self._skill_exists(selected_skill):
            result = f"Safely simulated existing pam-core skill: {selected_skill}"
        else:
            result = f"Safely simulated generic agent task: {selected_skill}"

        return self._format_result(
            analysis=analysis,
            selected_skill=selected_skill,
            alternatives=task["alternatives"],
            result=result,
        )

    def _validate(self, context: dict[str, Any], analysis: dict[str, Any]) -> dict[str, Any]:
        text = " ".join(f"{key} {value}" for key, value in context.items()).lower()
        if any(term in text for term in self.UNSAFE_TERMS):
            return {
                "allowed": False,
                "reason": "Blocked unsafe context before simulated execution.",
            }
        if analysis["risk_level"] == "high":
            return {
                "allowed": False,
                "reason": "Blocked high-risk context; safe executor only allows low/medium risk simulation.",
            }
        return {"allowed": True, "reason": "Context accepted for safe simulation."}

    @staticmethod
    def _format_result(
        analysis: dict[str, Any],
        selected_skill: str,
        alternatives: list[dict[str, Any]],
        result: str,
    ) -> dict[str, Any]:
        return {
            "intent": analysis["intent"],
            "risk_level": analysis["risk_level"],
            "selected_skill": selected_skill,
            "alternatives": alternatives,
            "result": result,
            "learning_update": True,
        }

    def _skill_exists(self, skill: str) -> bool:
        return (self.skills_path / skill / "SKILL.md").exists()
