"""External prompt bridge for PAM PROTOCOL v1."""

from __future__ import annotations

from typing import Any

from pam_core.engine import PamCoreEngine
from pam_core.protocol.parser import execute_protocol, normalize_input


def handle_external_prompt(prompt: str | dict[str, Any]) -> dict[str, Any] | None:
    """
    Detects if external AI is trying to use pam-core.
    If trigger keywords are found, route to runtime engine.
    """

    protocol_request = normalize_input(prompt)
    normalized = str(protocol_request.get("input", "")).lower()
    engine = PamCoreEngine()

    if (
        "pam://" in normalized
        or "use pam-core" in normalized
        or "run pam-core" in normalized
        or "pam-core" in normalized
        or isinstance(prompt, dict)
    ):
        return execute_protocol(protocol_request, engine)

    return None
