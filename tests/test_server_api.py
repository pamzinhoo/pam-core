from __future__ import annotations

import json
import re
from pathlib import Path

from fastapi.testclient import TestClient

from pam_core.config import RuntimeSettings
from pam_core.registry import SkillRegistry
from pam_core.resolver import ResolveRequest, SkillResolver
from pam_core.server.app import create_app
from pam_core.version import get_version, get_version_with_source


PROJECT_ROOT = Path(__file__).resolve().parents[1]
client = TestClient(create_app())


def test_health() -> None:
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json() == {
        "status": "ok",
        "project": "pam-core",
        "version": "1.2.0",
    }


def test_version() -> None:
    response = client.get("/version")

    assert response.status_code == 200
    body = response.json()
    assert body["service"] == "pam-core"
    assert body["version"] == get_version() == "1.2.0"
    assert body["source"] == "VERSION"


def test_version_sources_are_aligned() -> None:
    official_version = (PROJECT_ROOT / "VERSION").read_text(encoding="utf-8").strip()
    pyproject = (PROJECT_ROOT / "pyproject.toml").read_text(encoding="utf-8")
    codex_manifest = json.loads((PROJECT_ROOT / ".codex-plugin" / "plugin.json").read_text(encoding="utf-8"))
    claude_manifest = json.loads((PROJECT_ROOT / ".claude-plugin" / "plugin.json").read_text(encoding="utf-8"))
    project_state = (PROJECT_ROOT / "PROJECT_STATE.md").read_text(encoding="utf-8")
    official_state_match = re.search(r"(?m)^- Official version:\s*`?([^`\s]+)`?", project_state)
    manifest_state_match = re.search(r"(?m)^- Manifest version:\s*`?([^`\s]+)`?", project_state)
    helper_version, helper_source = get_version_with_source()

    assert re.fullmatch(r"[0-9]+(?:\.[0-9]+){2}(?:[-+][0-9A-Za-z.-]+)?", official_version)
    assert 'dynamic = ["version"]' in pyproject
    assert 'version = {file = ["VERSION"]}' in pyproject
    assert 'version = "' not in pyproject
    assert codex_manifest["version"] == official_version
    assert claude_manifest["version"] == official_version
    assert helper_version == official_version
    assert helper_source == "VERSION"
    assert official_state_match is not None
    assert official_state_match.group(1) == official_version
    assert manifest_state_match is not None
    assert manifest_state_match.group(1) == official_version


def test_registry_detects_real_skills() -> None:
    skills = SkillRegistry().list_skills()
    skill_ids = {skill.id for skill in skills}

    assert "fastapi" in skill_ids
    assert "security" in skill_ids
    assert all(skill.path.startswith("skills/") for skill in skills)


def test_registry_tolerates_missing_skill_files(tmp_path: Path) -> None:
    project_root = tmp_path
    skills_path = project_root / "skills"
    (skills_path / "broken-skill").mkdir(parents=True)
    settings = RuntimeSettings(
        base_dir=project_root,
        memory_path=project_root / "memory.json",
        skills_path=skills_path,
        host="127.0.0.1",
        port=8765,
        loop_interval=5.0,
    )

    snapshot = SkillRegistry(settings).snapshot()

    assert snapshot.skills[0].id == "broken-skill"
    assert "Missing SKILL.md." in snapshot.skills[0].warnings


def test_skills_endpoint_lists_real_project_skills() -> None:
    response = client.get("/skills")

    assert response.status_code == 200
    body = response.json()
    skill_ids = {skill["id"] for skill in body}
    assert "fastapi" in skill_ids
    assert "security" in skill_ids
    assert all("name" not in skill for skill in body)


def test_modules_endpoint_responds() -> None:
    response = client.get("/modules")

    assert response.status_code == 200
    body = response.json()
    module_titles = {module["title"] for module in body}
    assert "Core" in module_titles
    assert "Backend" in module_titles


def test_state_endpoint_responds_read_only_summary() -> None:
    response = client.get("/state")

    assert response.status_code == 200
    body = response.json()
    assert body["version"] == "1.2.0"
    assert body["skill_count"] >= 90
    assert body["module_count"] >= 10
    assert body["server_mode"] == "read_only"
    assert {adapter["id"] for adapter in body["adapters"]} == {"codex", "claude"}
    assert body["core_files"]["README.md"] is True


def test_resolve_returns_valid_structure_with_real_skills() -> None:
    response = client.post(
        "/resolve",
        json={
            "task": "corrigir bug em FastAPI com autenticação",
            "agent": "codex",
            "project_type": "fastapi-app",
        },
    )

    assert response.status_code == 200
    body = response.json()
    registry_ids = {skill.id for skill in SkillRegistry().list_skills()}
    recommended_ids = {skill["id"] for skill in body["recommended_skills"]}
    assert body["task"] == "corrigir bug em FastAPI com autenticação"
    assert recommended_ids
    assert recommended_ids.issubset(registry_ids)
    assert body["reasoning_summary"]
    assert 0.0 <= body["confidence"] <= 1.0


def test_resolve_does_not_invent_skills_for_no_match() -> None:
    response = client.post(
        "/resolve",
        json={"task": "zzzz qqqq impossibleword", "agent": "codex", "project_type": "unknown"},
    )

    assert response.status_code == 200
    body = response.json()
    assert body["recommended_skills"] == []
    assert "No relevant skill" in " ".join(body["warnings"])


def test_resolver_is_deterministic_for_same_input() -> None:
    resolver = SkillResolver()
    request = ResolveRequest(task="Create a FastAPI endpoint with validation", agent="codex", project_type="fastapi-app")

    first = resolver.resolve(request)
    second = resolver.resolve(request)

    assert [skill.id for skill in first.recommended_skills] == [skill.id for skill in second.recommended_skills]
    assert first.confidence == second.confidence


def test_select_skill_alias_uses_resolver() -> None:
    response = client.post(
        "/select-skill",
        json={"task": "Create a FastAPI HTTP endpoint with request and response validation."},
    )

    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "matched"
    assert body["selected_skill"] in {"fastapi", "api-design", "fastapi-validation"}


def test_optimize_prompt_preserves_original_and_structures_content() -> None:
    raw_prompt = "Objetivo: build API\n\nContexto: pam-core   server\nRegras: no external AI\nTarefas: add tests"
    response = client.post("/optimize-prompt", json={"prompt": raw_prompt})

    assert response.status_code == 200
    body = response.json()
    assert body["original_prompt"] == raw_prompt
    assert "build API" in body["optimized_prompt"]
    assert "no external AI" in body["optimized_prompt"]
    assert body["sections"]["objective"] == ["build API"]
    assert body["sections"]["constraints"] == ["no external AI"]


def test_analyze_static_security_detects_obvious_patterns() -> None:
    response = client.post(
        "/analyze-static-security",
        json={"code": "import os\nos.system(user_input)\nsecret = 'abcd1234abcd1234'\neval(user_input)\n"},
    )

    assert response.status_code == 200
    body = response.json()
    rules = {finding["rule"] for finding in body["findings"]}
    assert body["status"] == "completed"
    assert "os-system" in rules
    assert "python-eval" in rules
    assert "hardcoded-secret" in rules
