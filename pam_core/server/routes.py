"""Read-only HTTP routes for the pam-core local API server."""

from __future__ import annotations

from collections import Counter

from fastapi import APIRouter, HTTPException

from pam_core.registry import SkillRegistry
from pam_core.resolver import ResolveRequest as ResolverRequest
from pam_core.resolver import SkillResolver
from pam_core.server.prompt_optimizer import optimize_prompt
from pam_core.server.schemas import (
    HealthResponse,
    OptimizePromptRequest,
    OptimizePromptResponse,
    ResolveRequest,
    ResolveResponse,
    SelectSkillRequest,
    SelectSkillResponse,
    SkillResponse,
    StaticSecurityRequest,
    StaticSecurityResponse,
    VersionResponse,
)
from pam_core.server.security_static import analyze_static_security
from pam_core.version import get_version, get_version_with_source


def create_router(registry: SkillRegistry | None = None) -> APIRouter:
    skill_registry = registry or SkillRegistry()
    resolver = SkillResolver(skill_registry)
    router = APIRouter()

    @router.get("/health", response_model=HealthResponse)
    def health() -> HealthResponse:
        return HealthResponse(status="ok", project="pam-core", version=get_version())

    @router.get("/version", response_model=VersionResponse)
    def version() -> VersionResponse:
        version_value, source = get_version_with_source()
        return VersionResponse(service="pam-core", version=version_value, source=source)

    @router.get("/skills", response_model=list[SkillResponse])
    def skills() -> list[SkillResponse]:
        return [_skill_response(skill) for skill in skill_registry.list_skills()]

    @router.get("/modules")
    def modules() -> list[dict[str, object]]:
        return [module.__dict__ for module in skill_registry.list_modules()]

    @router.get("/state")
    def state() -> dict[str, object]:
        project_state = skill_registry.state()
        return {
            "version": project_state.version,
            "skill_count": project_state.skill_count,
            "module_count": project_state.module_count,
            "adapters": [adapter.__dict__ for adapter in project_state.adapters],
            "core_files": project_state.core_files,
            "server_mode": project_state.server_mode,
            "warnings": project_state.warnings,
        }

    @router.post("/resolve", response_model=ResolveResponse)
    def resolve(request: ResolveRequest) -> ResolveResponse:
        result = resolver.resolve(
            ResolverRequest(
                task=request.task,
                agent=request.agent,
                project_type=request.project_type,
                limit=request.limit,
            )
        )
        return ResolveResponse(
            task=result.task,
            agent=result.agent,
            project_type=result.project_type,
            recommended_skills=[_skill_response(skill) for skill in result.recommended_skills],
            reasoning_summary=result.reasoning_summary,
            warnings=result.warnings,
            missing_information=result.missing_information,
            confidence=result.confidence,
        )

    @router.post("/select-skill", response_model=SelectSkillResponse)
    def select_skill_route(request: SelectSkillRequest) -> SelectSkillResponse:
        result = resolver.resolve(ResolverRequest(task=request.task, limit=1))
        if not result.recommended_skills:
            return SelectSkillResponse(
                selected_skill=None,
                module=None,
                status="no_match",
                explanation=result.reasoning_summary,
            )
        selected = result.recommended_skills[0]
        return SelectSkillResponse(
            selected_skill=selected.id,
            module=selected.module,
            status="matched",
            explanation=result.reasoning_summary,
        )

    @router.post("/optimize-prompt", response_model=OptimizePromptResponse)
    def optimize_prompt_route(request: OptimizePromptRequest) -> OptimizePromptResponse:
        optimized, sections = optimize_prompt(request.prompt)
        return OptimizePromptResponse(
            original_prompt=request.prompt,
            optimized_prompt=optimized,
            sections=sections,
        )

    @router.post("/analyze-static-security", response_model=StaticSecurityResponse)
    def analyze_static_security_route(request: StaticSecurityRequest) -> StaticSecurityResponse:
        try:
            analyzed_source, findings = analyze_static_security(
                text=request.text,
                code=request.code,
                relative_path=request.path,
                project_root=skill_registry.project_root,
            )
        except ValueError as exc:
            raise HTTPException(status_code=400, detail=str(exc)) from exc

        counts = Counter(finding.severity for finding in findings)
        return StaticSecurityResponse(
            status="completed",
            analyzed_source=analyzed_source,
            findings=findings,
            summary={"total": len(findings), "by_severity": dict(counts)},
        )

    return router


def _skill_response(skill: object) -> SkillResponse:
    return SkillResponse(
        id=getattr(skill, "id"),
        path=getattr(skill, "path"),
        module=getattr(skill, "module"),
        title=getattr(skill, "title"),
        description=getattr(skill, "description"),
        tags=getattr(skill, "tags"),
        dependencies=getattr(skill, "dependencies"),
        warnings=getattr(skill, "warnings"),
    )
