"""Read-only skill and module inventory for pam-core."""

from __future__ import annotations

import json
import re
import unicodedata
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

from pam_core.config import RuntimeSettings, get_settings
from pam_core.version import get_version


IGNORED_MODULE_HEADINGS = {
    "Skill Reference Classes",
    "Principles",
    "Current Architecture Review",
    "Priority Model",
    "Version 2.0 Roadmap",
}

KEYWORDS_BY_SKILL = {
    "api-design": {"api", "contract", "request", "response", "http"},
    "authentication": {"auth", "login", "session", "identity"},
    "fastapi": {"fastapi", "endpoint", "route", "http", "api"},
    "python": {"python", "script", "package", "module"},
    "security": {"security", "secret", "token", "permission", "safe"},
    "skill-orchestrator": {"skill", "route", "orchestrate", "selection"},
    "testing": {"test", "pytest", "validate", "check"},
}


@dataclass(frozen=True)
class SkillInfo:
    id: str
    path: str
    module: str | None
    title: str | None
    description: str | None
    tags: list[str] = field(default_factory=list)
    dependencies: list[str] = field(default_factory=list)
    warnings: list[str] = field(default_factory=list)


@dataclass(frozen=True)
class ModuleInfo:
    id: str
    title: str
    skills: list[str] = field(default_factory=list)


@dataclass(frozen=True)
class AdapterInfo:
    id: str
    path: str
    status: str
    version: str | None = None


@dataclass(frozen=True)
class ProjectState:
    version: str
    skill_count: int
    module_count: int
    adapters: list[AdapterInfo]
    core_files: dict[str, bool]
    server_mode: str
    warnings: list[str] = field(default_factory=list)


@dataclass(frozen=True)
class RegistrySnapshot:
    skills: list[SkillInfo]
    modules: list[ModuleInfo]
    state: ProjectState
    warnings: list[str] = field(default_factory=list)


class SkillRegistry:
    """Build a tolerant, read-only inventory from the local pam-core checkout."""

    def __init__(self, settings: RuntimeSettings | None = None) -> None:
        self.settings = settings or get_settings()
        self.project_root = self.settings.base_dir.resolve()
        self.skills_path = self.settings.skills_path.resolve()

    def snapshot(self) -> RegistrySnapshot:
        warnings: list[str] = []
        module_map, modules = self._load_modules(warnings)
        dependency_map = self._load_dependencies(warnings)
        skills = self._load_skills(module_map, dependency_map, warnings)
        modules = self._merge_real_skill_modules(modules, skills)
        state = self._build_state(skills, modules, warnings)
        return RegistrySnapshot(skills=skills, modules=modules, state=state, warnings=warnings)

    def list_skills(self) -> list[SkillInfo]:
        return self.snapshot().skills

    def list_modules(self) -> list[ModuleInfo]:
        return self.snapshot().modules

    def state(self) -> ProjectState:
        return self.snapshot().state

    def _load_skills(
        self,
        module_map: dict[str, str],
        dependency_map: dict[str, list[str]],
        warnings: list[str],
    ) -> list[SkillInfo]:
        if not self._is_inside_project(self.skills_path):
            warnings.append("Configured skills path is outside the project root.")
            return []
        if not self.skills_path.exists() or not self.skills_path.is_dir():
            warnings.append(f"Skills directory not found: {self._display_path(self.skills_path)}")
            return []

        skills: list[SkillInfo] = []
        skill_dirs = sorted((item for item in self.skills_path.iterdir() if item.is_dir()), key=lambda item: item.name)
        physical_skill_ids = {item.name for item in skill_dirs}
        for skill_dir in skill_dirs:
            skill_md = skill_dir / "SKILL.md"
            skill_warnings: list[str] = []
            frontmatter: dict[str, Any] = {}
            body = ""
            if skill_md.exists():
                frontmatter, body = _read_frontmatter(skill_md, skill_warnings)
            else:
                skill_warnings.append("Missing SKILL.md.")

            skill_id = str(frontmatter.get("name") or skill_dir.name).strip() or skill_dir.name
            description = _clean_optional_text(frontmatter.get("description"))
            if not description and skill_md.exists():
                skill_warnings.append("Missing frontmatter description.")
            title = _first_heading(body) or _title_from_id(skill_id)
            module = module_map.get(skill_id)
            tags = _derive_tags(skill_id, module, description, frontmatter.get("tags"))
            dependencies = [dep for dep in dependency_map.get(skill_id, []) if dep != skill_id and dep in physical_skill_ids]
            skills.append(
                SkillInfo(
                    id=skill_id,
                    path=self._display_path(skill_md if skill_md.exists() else skill_dir),
                    module=module,
                    title=title,
                    description=description,
                    tags=tags,
                    dependencies=dependencies,
                    warnings=skill_warnings,
                )
            )
            for warning in skill_warnings:
                warnings.append(f"{skill_dir.name}: {warning}")
        return skills

    def _load_modules(self, warnings: list[str]) -> tuple[dict[str, str], list[ModuleInfo]]:
        path = self.project_root / "MODULES.md"
        if not path.exists():
            warnings.append("MODULES.md not found.")
            return {}, []
        try:
            text = path.read_text(encoding="utf-8")
        except OSError as exc:
            warnings.append(f"Could not read MODULES.md: {exc}")
            return {}, []

        module_map: dict[str, str] = {}
        module_skills: dict[str, list[str]] = {}
        current_module: str | None = None
        inside_skills = False
        for line in text.splitlines():
            if line.startswith("## ") and not line.startswith("### "):
                heading = line[3:].strip()
                current_module = None if heading in IGNORED_MODULE_HEADINGS else heading
                inside_skills = False
                if current_module:
                    module_skills.setdefault(current_module, [])
                continue
            if line.strip() == "### Skills":
                inside_skills = current_module is not None
                continue
            if inside_skills and line.startswith("### "):
                inside_skills = False
            if inside_skills and current_module:
                for skill_id in _skill_refs(line):
                    module_map[skill_id] = current_module
                    if skill_id not in module_skills[current_module]:
                        module_skills[current_module].append(skill_id)

        modules = [
            ModuleInfo(id=_slug(module), title=module, skills=sorted(skills))
            for module, skills in sorted(module_skills.items())
        ]
        return module_map, modules

    def _load_dependencies(self, warnings: list[str]) -> dict[str, list[str]]:
        path = self.project_root / "SKILL_DEPENDENCIES.md"
        if not path.exists():
            warnings.append("SKILL_DEPENDENCIES.md not found.")
            return {}
        try:
            text = path.read_text(encoding="utf-8")
        except OSError as exc:
            warnings.append(f"Could not read SKILL_DEPENDENCIES.md: {exc}")
            return {}

        dependencies: dict[str, set[str]] = {}
        for line in text.splitlines():
            refs = _skill_refs(line)
            if len(refs) < 2:
                continue
            owner = refs[0]
            dependencies.setdefault(owner, set()).update(refs[1:])
        return {skill_id: sorted(values) for skill_id, values in dependencies.items()}

    def _merge_real_skill_modules(self, modules: list[ModuleInfo], skills: list[SkillInfo]) -> list[ModuleInfo]:
        known_modules = {module.title: set(module.skills) for module in modules}
        for skill in skills:
            if skill.module:
                known_modules.setdefault(skill.module, set()).add(skill.id)
        return [
            ModuleInfo(id=_slug(module), title=module, skills=sorted(skill_ids))
            for module, skill_ids in sorted(known_modules.items())
        ]

    def _build_state(self, skills: list[SkillInfo], modules: list[ModuleInfo], warnings: list[str]) -> ProjectState:
        core_files = {
            "README.md": (self.project_root / "README.md").exists(),
            "PROJECT_STATE.md": (self.project_root / "PROJECT_STATE.md").exists(),
            "CHANGELOG.md": (self.project_root / "CHANGELOG.md").exists(),
            "VERSIONING.md": (self.project_root / "VERSIONING.md").exists(),
            "AGENTS.md": (self.project_root / "AGENTS.md").exists(),
            "MODULES.md": (self.project_root / "MODULES.md").exists(),
            "SKILL_DEPENDENCIES.md": (self.project_root / "SKILL_DEPENDENCIES.md").exists(),
            "skills/": self.skills_path.exists(),
        }
        return ProjectState(
            version=get_version(),
            skill_count=len(skills),
            module_count=len(modules),
            adapters=self._detect_adapters(),
            core_files=core_files,
            server_mode="read_only",
            warnings=warnings,
        )

    def _detect_adapters(self) -> list[AdapterInfo]:
        adapters = []
        for adapter_id, relative_path in {
            "codex": ".codex-plugin/plugin.json",
            "claude": ".claude-plugin/plugin.json",
        }.items():
            path = self.project_root / relative_path
            status = "found" if path.exists() else "missing"
            version = None
            if path.exists():
                try:
                    version = json.loads(path.read_text(encoding="utf-8")).get("version")
                except (OSError, json.JSONDecodeError):
                    status = "malformed"
            adapters.append(AdapterInfo(id=adapter_id, path=relative_path, status=status, version=version))
        return adapters

    def _is_inside_project(self, path: Path) -> bool:
        try:
            path.relative_to(self.project_root)
        except ValueError:
            return False
        return True

    def _display_path(self, path: Path) -> str:
        try:
            return path.relative_to(self.project_root).as_posix()
        except ValueError:
            return path.as_posix()


def _read_frontmatter(path: Path, warnings: list[str]) -> tuple[dict[str, Any], str]:
    try:
        text = path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        warnings.append("SKILL.md is not valid UTF-8.")
        return {}, ""
    except OSError as exc:
        warnings.append(f"Could not read SKILL.md: {exc}")
        return {}, ""

    match = re.match(r"^---\r?\n(.*?)\r?\n---\r?\n?(.*)$", text, flags=re.DOTALL)
    if not match:
        warnings.append("Missing frontmatter block.")
        return {}, text

    values: dict[str, Any] = {}
    for line in match.group(1).splitlines():
        if ":" not in line:
            continue
        key, value = line.split(":", 1)
        key = key.strip()
        value = value.strip().strip('"').strip("'")
        if key:
            values[key] = value
    if not values.get("name"):
        warnings.append("Missing frontmatter name.")
    return values, match.group(2)


def _first_heading(text: str) -> str | None:
    for line in text.splitlines():
        if line.startswith("# "):
            return line[2:].strip() or None
    return None


def _title_from_id(skill_id: str) -> str:
    return " ".join(part.capitalize() for part in skill_id.split("-"))


def _clean_optional_text(value: Any) -> str | None:
    if value is None:
        return None
    text = str(value).strip()
    return text or None


def _derive_tags(skill_id: str, module: str | None, description: str | None, raw_tags: Any) -> list[str]:
    tags: set[str] = set()
    if raw_tags:
        raw = str(raw_tags).strip("[]")
        tags.update(tag.strip().strip('"').strip("'").lower() for tag in raw.split(",") if tag.strip())
    tags.update(skill_id.split("-"))
    if module:
        tags.update(_tokenize(module))
    if description:
        tags.update(word for word in _tokenize(description) if len(word) >= 4)
    tags.update(KEYWORDS_BY_SKILL.get(skill_id, set()))
    return sorted(tag for tag in tags if tag)


def _tokenize(text: str) -> list[str]:
    normalized = unicodedata.normalize("NFKD", text.lower()).encode("ascii", "ignore").decode("ascii")
    return re.findall(r"[a-z0-9]+", normalized)


def _skill_refs(text: str) -> list[str]:
    return re.findall(r"`([a-z0-9]+(?:-[a-z0-9]+)*)`", text)


def _slug(text: str) -> str:
    return "-".join(_tokenize(text))
