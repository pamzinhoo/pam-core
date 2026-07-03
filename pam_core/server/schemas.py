"""Request and response models for the pam-core API server."""

from __future__ import annotations

from typing import Any

from pydantic import BaseModel, Field


class HealthResponse(BaseModel):
    status: str
    project: str
    version: str


class VersionResponse(BaseModel):
    service: str
    version: str
    source: str


class SkillResponse(BaseModel):
    id: str
    path: str
    module: str | None = None
    title: str | None = None
    description: str | None = None
    tags: list[str] = []
    dependencies: list[str] = []
    warnings: list[str] = []


class ModuleResponse(BaseModel):
    id: str
    title: str
    skills: list[str] = []


class AdapterResponse(BaseModel):
    id: str
    path: str
    status: str
    version: str | None = None


class StateResponse(BaseModel):
    version: str
    skill_count: int
    module_count: int
    adapters: list[AdapterResponse]
    core_files: dict[str, bool]
    server_mode: str
    warnings: list[str] = []


class SelectSkillRequest(BaseModel):
    task: str = Field(..., min_length=1, description="Task description to route.")


class SelectSkillResponse(BaseModel):
    selected_skill: str | None
    module: str | None = None
    status: str
    explanation: str


class ResolveRequest(BaseModel):
    task: str = Field(..., min_length=1, description="Task description to resolve.")
    agent: str | None = None
    project_type: str | None = None
    limit: int = Field(default=5, ge=1, le=7)


class ResolveResponse(BaseModel):
    task: str
    agent: str | None = None
    project_type: str | None = None
    recommended_skills: list[SkillResponse]
    reasoning_summary: str
    warnings: list[str] = []
    missing_information: list[str] = []
    confidence: float


class OptimizePromptRequest(BaseModel):
    prompt: str = Field(..., min_length=1, description="Raw prompt to organize.")


class OptimizePromptResponse(BaseModel):
    original_prompt: str
    optimized_prompt: str
    sections: dict[str, list[str]]


class StaticSecurityRequest(BaseModel):
    text: str | None = None
    code: str | None = None
    path: str | None = None


class SecurityFinding(BaseModel):
    severity: str
    rule: str
    evidence: str
    suggestion: str
    line: int | None = None


class StaticSecurityResponse(BaseModel):
    status: str
    analyzed_source: str
    findings: list[SecurityFinding]
    summary: dict[str, Any]
