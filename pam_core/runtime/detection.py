"""Environment detection for portable adapter selection."""

from __future__ import annotations

import os


def detect_environment() -> str:
    """Detect a runtime adapter using environment variables only."""

    explicit = os.getenv("PAM_CORE_ADAPTER")
    if explicit:
        return explicit.strip().lower()

    env_names = {key.lower() for key in os.environ}
    if any("claude" in key for key in env_names):
        return "claude"
    if any("codex" in key for key in env_names):
        return "codex"
    if any("cursor" in key for key in env_names):
        return "cursor"
    return "cli"
