"""Tool-call router for external AI systems."""

from __future__ import annotations

from typing import Any

from pam_core.protocol.parser import normalize_input
from pam_core.runtime.bridge import handle_external_prompt


SUPPORTED_AGENTS = {"claude", "codex", "cursor", "generic"}


def handle_tool_call(payload: dict[str, Any]) -> dict[str, Any]:
    """Normalize an external AI tool call and return a compact tool response."""

    if not isinstance(payload, dict):
        return _error("invalid_payload", "Tool call payload must be a JSON object.")

    tool_payload = _tool_payload(payload)
    protocol_request = normalize_input(tool_payload)
    protocol_result = handle_external_prompt(protocol_request)

    if protocol_result is None:
        return _error(
            str(protocol_request.get("intent", "unknown")),
            "No supported pam-core tool call detected.",
        )

    return _tool_response(protocol_result)


def _tool_payload(payload: dict[str, Any]) -> dict[str, Any]:
    agent = str(payload.get("agent") or "generic").lower()
    if agent not in SUPPORTED_AGENTS:
        agent = "generic"

    return {
        **payload,
        "agent": agent,
        "input": str(payload.get("input") or ""),
    }


def _tool_response(protocol_result: dict[str, Any]) -> dict[str, Any]:
    result = protocol_result.get("result")
    result_data = result if isinstance(result, dict) else {}

    return {
        "source": "pam-core",
        "intent": protocol_result.get("intent", ""),
        "selected_skill": result_data.get("selected_skill"),
        "result": result_data.get("result", result),
        "status": protocol_result.get("status", "success"),
    }


def _error(intent: str, message: str) -> dict[str, Any]:
    return {
        "source": "pam-core",
        "intent": intent,
        "selected_skill": None,
        "result": message,
        "status": "error",
    }
