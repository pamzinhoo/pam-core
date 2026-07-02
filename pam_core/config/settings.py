"""Cross-platform runtime settings."""

from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class RuntimeSettings:
    """Runtime paths and server defaults without OS-specific assumptions."""

    base_dir: Path
    memory_path: Path
    skills_path: Path
    host: str
    port: int
    loop_interval: float


def get_settings() -> RuntimeSettings:
    """Resolve settings from environment variables and portable defaults."""

    package_root = Path(__file__).resolve().parents[1]
    project_root = package_root.parent

    base_dir = _path_from_env("PAM_CORE_HOME") or _default_base_dir(project_root)
    memory_path = (
        _path_from_env("PAM_CORE_MEMORY_PATH")
        or _repo_memory_path(project_root)
        or base_dir / "memory" / "store.json"
    )
    skills_path = (
        _path_from_env("PAM_CORE_SKILLS_PATH")
        or _repo_skills_path(project_root)
        or package_root / "skills"
    )

    return RuntimeSettings(
        base_dir=base_dir,
        memory_path=memory_path,
        skills_path=skills_path,
        host=os.getenv("PAM_CORE_HOST", "0.0.0.0"),
        port=_int_env("PAM_CORE_PORT", 8000),
        loop_interval=_float_env("PAM_CORE_LOOP_INTERVAL", 5.0),
    )


def _path_from_env(name: str) -> Path | None:
    value = os.getenv(name)
    return Path(value).expanduser() if value else None


def _default_base_dir(project_root: Path) -> Path:
    if (project_root / "pyproject.toml").exists():
        return project_root
    return Path.cwd() / ".pam-core"


def _repo_memory_path(project_root: Path) -> Path | None:
    path = project_root / "memory" / "store.json"
    return path if path.exists() else None


def _repo_skills_path(project_root: Path) -> Path | None:
    path = project_root / "skills"
    return path if path.exists() else None


def _int_env(name: str, default: int) -> int:
    try:
        return int(os.getenv(name, str(default)))
    except ValueError:
        return default


def _float_env(name: str, default: float) -> float:
    try:
        return float(os.getenv(name, str(default)))
    except ValueError:
        return default
