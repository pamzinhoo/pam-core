"""Skill inventory helpers for the pam-core API server."""

from __future__ import annotations

import re
from dataclasses import dataclass
from pathlib import Path

from pam_core.config import RuntimeSettings, get_settings


@dataclass(frozen=True)
class SkillRecord:
    name: str
    path: str
    module: str | None
    status: str
    description: str | None


def list_skills(settings: RuntimeSettings | None = None) -> list[SkillRecord]:
    """Read the real skills directory and return available skill metadata."""

    runtime_settings = settings or get_settings()
    skills_path = _safe_skills_path(runtime_settings)
    if skills_path is None:
        return []

    module_map = _load_module_map(skills_path.parent)

    if not skills_path.exists() or not skills_path.is_dir():
        return []

    records: list[SkillRecord] = []
    for skill_dir in sorted((item for item in skills_path.iterdir() if item.is_dir()), key=lambda item: item.name):
        skill_md = skill_dir / "SKILL.md"
        if not skill_md.exists():
            continue

        frontmatter = _read_frontmatter(skill_md)
        name = frontmatter.get("name") or skill_dir.name
        records.append(
            SkillRecord(
                name=name,
                path=_relative_path(skill_md, skills_path.parent),
                module=module_map.get(name),
                status="available",
                description=frontmatter.get("description"),
            )
        )
    return records


def _safe_skills_path(settings: RuntimeSettings) -> Path | None:
    base_dir = settings.base_dir.resolve()
    skills_path = settings.skills_path.resolve()
    if base_dir != skills_path and base_dir not in skills_path.parents:
        return None
    return skills_path


def select_skill(task: str, settings: RuntimeSettings | None = None) -> tuple[SkillRecord | None, str]:
    """Select a likely skill with a deterministic local heuristic."""

    normalized_task = _normalize_words(task)
    if not normalized_task:
        return None, "No task content was provided."

    task_words = set(normalized_task)
    skills = list_skills(settings)
    best_skill: SkillRecord | None = None
    best_score = 0
    best_matches: list[str] = []

    for skill in skills:
        fields = " ".join(part for part in [skill.name, skill.module or "", skill.description or ""] if part)
        skill_words = set(_normalize_words(fields))
        matches = sorted(task_words.intersection(skill_words))
        score = len(matches)
        score += _keyword_bonus(task_words, skill)
        if score > best_score:
            best_skill = skill
            best_score = score
            best_matches = matches[:5]

    if best_skill is None or best_score <= 0:
        return None, "No strong local keyword match was found."

    match_text = ", ".join(best_matches) if best_matches else "module keywords"
    return best_skill, f"Matched local task keywords against skill metadata: {match_text}."


def _read_frontmatter(path: Path) -> dict[str, str]:
    try:
        text = path.read_text(encoding="utf-8")
    except OSError:
        return {}

    match = re.match(r"^---\r?\n(.*?)\r?\n---", text, flags=re.DOTALL)
    if not match:
        return {}

    values: dict[str, str] = {}
    for line in match.group(1).splitlines():
        if ":" not in line:
            continue
        key, value = line.split(":", 1)
        values[key.strip()] = value.strip().strip('"')
    return values


def _load_module_map(project_root: Path) -> dict[str, str]:
    modules_path = project_root / "MODULES.md"
    if not modules_path.exists():
        return {}

    try:
        text = modules_path.read_text(encoding="utf-8")
    except OSError:
        return {}

    module_map: dict[str, str] = {}
    current_module: str | None = None
    inside_skills = False
    for line in text.splitlines():
        if line.startswith("## ") and not line.startswith("### "):
            heading = line[3:].strip()
            if heading not in {"Skill Reference Classes", "Principles", "Current Architecture Review", "Priority Model", "Version 2.0 Roadmap"}:
                current_module = heading
            inside_skills = False
            continue
        if line.strip() == "### Skills":
            inside_skills = True
            continue
        if inside_skills and line.startswith("### "):
            inside_skills = False
        if inside_skills and current_module:
            for skill_name in re.findall(r"`([a-z0-9]+(?:-[a-z0-9]+)*)`", line):
                module_map[skill_name] = current_module
    return module_map


def _relative_path(path: Path, root: Path) -> str:
    try:
        return path.relative_to(root).as_posix()
    except ValueError:
        return path.as_posix()


def _normalize_words(text: str) -> list[str]:
    return re.findall(r"[a-z0-9]+", text.lower())


def _keyword_bonus(task_words: set[str], skill: SkillRecord) -> int:
    bonus = 0
    module = (skill.module or "").lower()
    skill_name = skill.name
    keyword_groups = {
        "fastapi": {"api", "http", "endpoint", "route", "server", "fastapi"},
        "api-design": {"api", "contract", "endpoint", "request", "response", "http"},
        "security": {"security", "secret", "token", "permission", "safe", "vulnerability"},
        "testing": {"test", "tests", "pytest", "validate", "coverage"},
        "python": {"python", "script", "module", "package"},
        "prompt-normalization": {"prompt", "normalize", "organize", "rewrite"},
        "skill-orchestrator": {"skill", "route", "select", "orchestrate"},
    }
    for name, keywords in keyword_groups.items():
        if skill_name == name and task_words.intersection(keywords):
            bonus += 3
    if module and module in task_words:
        bonus += 2
    return bonus
