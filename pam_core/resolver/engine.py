"""Heuristic, deterministic skill selection for pam-core."""

from __future__ import annotations

import re
import unicodedata
from dataclasses import dataclass, field

from pam_core.registry import SkillInfo, SkillRegistry


VAGUE_TERMS = {"help", "fix", "improve", "update", "change", "thing", "stuff", "ajuda", "arrumar", "melhorar"}
AGENT_HINTS = {
    "codex": {"project-understanding", "skill-orchestrator", "testing", "code-review"},
    "claude": {"project-understanding", "skill-orchestrator", "testing", "code-review"},
}
PROJECT_TYPE_HINTS = {
    "fastapi": {"fastapi", "api-design", "fastapi-validation", "python"},
    "fastapi-app": {"fastapi", "api-design", "fastapi-validation", "python"},
    "api": {"api-design", "fastapi", "python"},
    "python": {"python", "testing", "debugging"},
    "desktop": {"desktop-local", "windows-desktop", "automation-scripts"},
    "sqlite": {"sqlite", "database-design", "python"},
    "frontend": {"ui-designer", "html-css", "javascript", "ux", "accessibility"},
    "saas": {"saas", "security", "database-design", "api-design"},
}
TASK_HINTS = {
    "auth": {"authentication", "permissions-authorization", "security"},
    "autenticacao": {"authentication", "permissions-authorization", "security"},
    "login": {"authentication", "permissions-authorization", "security"},
    "bug": {"debugging", "root-cause-analysis", "testing"},
    "endpoint": {"fastapi", "api-design", "fastapi-validation"},
    "route": {"fastapi", "api-design"},
    "rota": {"fastapi", "api-design"},
    "security": {"security", "security-review"},
    "seguranca": {"security", "security-review"},
    "test": {"testing"},
    "teste": {"testing"},
    "ui": {"ui-designer", "anti-ai-ui", "ux"},
    "database": {"database-design", "sqlalchemy", "sqlite"},
    "sqlite": {"sqlite", "database-design"},
}


@dataclass(frozen=True)
class ResolveRequest:
    task: str
    agent: str | None = None
    project_type: str | None = None
    limit: int = 5


@dataclass(frozen=True)
class ResolveResult:
    task: str
    agent: str | None
    project_type: str | None
    recommended_skills: list[SkillInfo]
    reasoning_summary: str
    warnings: list[str] = field(default_factory=list)
    missing_information: list[str] = field(default_factory=list)
    confidence: float = 0.0


class SkillResolver:
    """Rank real registry skills with transparent local heuristics."""

    def __init__(self, registry: SkillRegistry | None = None) -> None:
        self.registry = registry or SkillRegistry()

    def resolve(self, request: ResolveRequest) -> ResolveResult:
        snapshot = self.registry.snapshot()
        skills = snapshot.skills
        warnings = list(snapshot.warnings)
        missing_information = _missing_information(request)
        task_tokens = set(_tokenize(request.task))
        project_tokens = set(_tokenize(request.project_type or ""))
        agent = (request.agent or "").lower().strip()

        scored: list[tuple[float, str, SkillInfo]] = []
        for skill in skills:
            score = self._score_skill(skill, task_tokens, project_tokens, agent)
            if score > 0:
                scored.append((score, skill.id, skill))

        scored.sort(key=lambda item: (-item[0], item[1]))
        limit = min(max(request.limit, 1), 7)
        selected = [skill for _score, _skill_id, skill in scored[:limit]]

        if not selected:
            warnings.append("No relevant skill was found in the local registry.")
            summary = "No local skill matched the provided task strongly enough."
            confidence = 0.0
        else:
            top_score = scored[0][0]
            confidence = min(0.95, round(top_score / 12, 2))
            names = ", ".join(skill.id for skill in selected)
            summary = f"Selected real skills from local metadata and keyword matches: {names}."

        return ResolveResult(
            task=request.task,
            agent=request.agent,
            project_type=request.project_type,
            recommended_skills=selected,
            reasoning_summary=summary,
            warnings=warnings,
            missing_information=missing_information,
            confidence=confidence,
        )

    def _score_skill(
        self,
        skill: SkillInfo,
        task_tokens: set[str],
        project_tokens: set[str],
        agent: str,
    ) -> float:
        skill_tokens = set(
            _tokenize(
                " ".join(
                    [
                        skill.id,
                        skill.module or "",
                        skill.description or "",
                        " ".join(skill.tags),
                        " ".join(skill.dependencies),
                    ]
                )
            )
        )
        matches = task_tokens.intersection(skill_tokens)
        score = float(len(matches))

        for token in task_tokens:
            if skill.id in TASK_HINTS.get(token, set()):
                score += 4
        for token in project_tokens:
            if skill.id in PROJECT_TYPE_HINTS.get(token, set()):
                score += 3
        project_type = "-".join(sorted(project_tokens))
        if skill.id in PROJECT_TYPE_HINTS.get(project_type, set()):
            score += 3
        if skill.id in AGENT_HINTS.get(agent, set()) and score > 0:
            score += 0.5
        if skill.id in {"project-understanding", "skill-orchestrator"} and score > 0:
            score += 0.25
        return score


def _missing_information(request: ResolveRequest) -> list[str]:
    missing: list[str] = []
    tokens = _tokenize(request.task)
    if len(tokens) < 3 or set(tokens).issubset(VAGUE_TERMS):
        missing.append("Task is too short or vague for confident routing.")
    if not request.project_type:
        missing.append("project_type was not provided.")
    if not request.agent:
        missing.append("agent was not provided.")
    return missing


def _tokenize(text: str) -> list[str]:
    normalized = unicodedata.normalize("NFKD", text.lower()).encode("ascii", "ignore").decode("ascii")
    return re.findall(r"[a-z0-9]+", normalized)
