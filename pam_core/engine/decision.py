"""Portable memory-aware skill decision engine."""

from __future__ import annotations

from pathlib import Path
from typing import Any


class DecisionEngine:
    """Select and rank skill references with heuristic scoring."""

    SKILL_CANDIDATES = {
        "security-review": {
            "intents": {"security_review"},
            "terms": {"security", "admin", "permission", "audit", "auth"},
            "risk": {"medium": 2.0, "high": 3.0},
        },
        "accessibility-review": {
            "intents": {"accessibility_review"},
            "terms": {"accessibility", "aluno", "student", "screen", "ui"},
            "risk": {"low": 1.0, "medium": 1.0},
        },
        "architecture-review": {
            "intents": {"architecture_review"},
            "terms": {"system", "architecture", "module", "design", "engine"},
            "risk": {"medium": 1.5, "high": 1.0},
        },
        "testing": {
            "intents": {"verification"},
            "terms": {"test", "verify", "check", "validate"},
            "risk": {"low": 0.75, "medium": 1.0, "high": 1.0},
        },
        "project-understanding": {
            "intents": {"generic_analysis", "architecture_review"},
            "terms": {"context", "repository", "project", "analyze"},
            "risk": {"low": 0.75, "medium": 0.75},
        },
        "code-review": {
            "intents": {"generic_analysis", "verification"},
            "terms": {"review", "risk", "change", "quality"},
            "risk": {"low": 0.5, "medium": 0.75, "high": 1.0},
        },
        "generic-analysis": {
            "intents": {"generic_analysis"},
            "terms": set(),
            "risk": {"low": 0.25, "medium": 0.1},
        },
    }

    def __init__(self, skills_path: Path) -> None:
        self.skills_path = skills_path

    def choose(
        self,
        context: dict[str, Any],
        analysis: dict[str, Any],
        memory: dict[str, Any],
    ) -> dict[str, Any]:
        ranked = self.rank(context, analysis, memory)
        selected = ranked[0]
        return {
            "selected_skill": selected["skill"],
            "decision": selected["reason"],
            "alternatives": ranked[1:4],
            "ranking": ranked,
        }

    def rank(
        self,
        context: dict[str, Any],
        analysis: dict[str, Any],
        memory: dict[str, Any],
    ) -> list[dict[str, Any]]:
        text = " ".join(f"{key} {value}" for key, value in context.items()).lower()
        performance = memory.get("skill_performance", {})
        ranked = []

        for skill, profile in self.SKILL_CANDIDATES.items():
            score = self._score_skill(skill, profile, text, analysis, performance)
            ranked.append(
                {
                    "skill": skill,
                    "score": round(score, 3),
                    "reason": self._reason(skill, score, analysis),
                    "skill_exists": self._skill_exists(skill),
                }
            )

        ranked.sort(key=lambda item: item["score"], reverse=True)
        return ranked

    def _score_skill(
        self,
        skill: str,
        profile: dict[str, Any],
        text: str,
        analysis: dict[str, Any],
        performance: dict[str, Any],
    ) -> float:
        score = 0.0
        if analysis["intent"] in profile.get("intents", set()):
            score += 3.0
        score += sum(0.5 for term in profile.get("terms", set()) if term in text)
        score += float(profile.get("risk", {}).get(analysis["risk_level"], 0.0))
        score += float(performance.get(skill, {}).get("score_adjustment", 0.0))
        if self._skill_exists(skill):
            score += 0.25
        return score

    @staticmethod
    def _reason(skill: str, score: float, analysis: dict[str, Any]) -> str:
        return (
            f"{skill} ranked highest for intent={analysis['intent']} "
            f"risk={analysis['risk_level']} score={round(score, 3)}"
        )

    def _skill_exists(self, skill: str) -> bool:
        return (self.skills_path / skill / "SKILL.md").exists()
