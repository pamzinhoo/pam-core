"""Version helpers for pam-core."""

from __future__ import annotations

import re
from importlib import metadata
from pathlib import Path


PACKAGE_NAME = "pam-core"
FALLBACK_VERSION = "0.0.0"


def get_version() -> str:
    """Return the official pam-core version."""

    version, _source = get_version_with_source()
    return version


def get_version_with_source() -> tuple[str, str]:
    """Return the official version and the source used to resolve it."""

    version = _version_from_file(_project_root() / "VERSION")
    if version:
        return version, "VERSION"

    try:
        return metadata.version(PACKAGE_NAME), "importlib.metadata"
    except metadata.PackageNotFoundError:
        return FALLBACK_VERSION, "fallback"


def _project_root() -> Path:
    return Path(__file__).resolve().parents[1]


def _version_from_file(path: Path) -> str | None:
    if not path.exists():
        return None
    try:
        value = path.read_text(encoding="utf-8").strip()
    except OSError:
        return None
    if re.fullmatch(r"[0-9]+(?:\.[0-9]+){2}(?:[-+][0-9A-Za-z.-]+)?", value):
        return value
    return None
