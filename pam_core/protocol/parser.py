"""PAM PROTOCOL v1 normalization and execution helpers."""

from __future__ import annotations

from typing import Any

from pam_core.engine import PamCoreEngine

ProtocolResult = dict[str, Any]

PAM_SOURCE = "pam-core"
PAM_PROTOCOL = "pam-protocol-v1"


def _envelope(
    intent: str,
    action: str,
    result: Any,
    status: str = "success",
) -> ProtocolResult:
    return {
        "source": PAM_SOURCE,
        "protocol": PAM_PROTOCOL,
        "intent": intent,
        "action": action,
        "result": result,
        "status": status,
    }


def run(engine: PamCoreEngine | None = None) -> ProtocolResult:
    """Execute one runtime cycle and return a protocol envelope."""

    runtime_engine = engine or PamCoreEngine()
    return _envelope("pam://run", "run", runtime_engine.run_once())


def doctor(engine: PamCoreEngine | None = None) -> ProtocolResult:
    """Return runtime health information in a protocol envelope."""

    runtime_engine = engine or PamCoreEngine()
    return _envelope("pam://doctor", "doctor", runtime_engine.health())


def memory(engine: PamCoreEngine | None = None) -> ProtocolResult:
    """Return runtime memory information in a protocol envelope."""

    runtime_engine = engine or PamCoreEngine()
    return _envelope("pam://memory", "memory", runtime_engine.memory())


def parse_pam_call(text: str, engine: PamCoreEngine | None = None) -> ProtocolResult:
    """Parse a PAM URI command from text and execute the mapped action."""

    return execute_protocol(normalize_input(text), engine)


def normalize_input(payload: Any) -> dict[str, Any]:
    """Normalize natural language, PAM URIs, and tool-call JSON into PAM v1."""

    if payload is None:
        return _protocol_request("pam://run", "run", "")

    if isinstance(payload, str):
        return _normalize_text(payload)

    if isinstance(payload, dict):
        return _normalize_dict(payload)

    return _protocol_request(
        "unsupported_input",
        "error",
        payload,
        error="Input must be a string or JSON object.",
    )


def execute_protocol(
    protocol_request: dict[str, Any],
    engine: PamCoreEngine | None = None,
) -> ProtocolResult:
    """Execute a normalized PAM PROTOCOL request and return a v1 envelope."""

    runtime_engine = engine or PamCoreEngine()
    action = str(protocol_request.get("action", "run")).lower()
    intent = str(protocol_request.get("intent", action))

    if action == "run":
        context = protocol_request.get("context")
        if isinstance(context, dict) and context:
            runtime_engine.update_context(context)
        return _envelope(intent, "run", runtime_engine.run_once())

    if action == "doctor":
        return _envelope(intent, "doctor", runtime_engine.health())

    if action == "memory":
        return _envelope(intent, "memory", runtime_engine.memory())

    return _envelope(
        intent,
        action,
        {
            "reason": protocol_request.get(
                "error",
                "No supported PAM protocol command detected.",
            ),
        },
        status="error",
    )


def call(payload: Any, engine: PamCoreEngine | None = None) -> ProtocolResult:
    """Normalize any supported input shape and execute it."""

    return execute_protocol(normalize_input(payload), engine)


def _normalize_text(text: str) -> dict[str, Any]:
    normalized = text.strip()
    lowered = normalized.lower()

    commands: dict[str, str] = {
        "pam://run": "run",
        "pam://doctor": "doctor",
        "pam://memory": "memory",
    }
    for command, action in commands.items():
        if command in lowered:
            return _protocol_request(command, action, normalized)

    if "pam://" in lowered:
        return _protocol_request(
            "pam://unknown",
            "error",
            normalized,
            error="No supported PAM protocol command detected.",
        )

    if "doctor" in lowered or "health" in lowered:
        return _protocol_request(_detected_text_intent(lowered), "doctor", normalized)

    if "memory" in lowered:
        return _protocol_request(_detected_text_intent(lowered), "memory", normalized)

    return _protocol_request(_detected_text_intent(lowered), "run", normalized)


def _normalize_dict(payload: dict[str, Any]) -> dict[str, Any]:
    text = _first_text(payload, ("input", "prompt", "query", "command", "content"))
    tool = payload.get("tool")
    action = payload.get("action") or payload.get("name")
    if action is None and tool != PAM_SOURCE:
        action = tool
    intent = payload.get("intent")

    if text:
        text_request = _normalize_text(text)
    else:
        text_request = _protocol_request("structured_tool_request", "run", "")

    normalized_action = _normalize_action(action) or text_request["action"]
    normalized_intent = str(intent or text_request["intent"])

    context = {key: value for key, value in payload.items() if key not in {"source", "protocol"}}
    return {
        "source": PAM_SOURCE,
        "protocol": PAM_PROTOCOL,
        "intent": normalized_intent,
        "action": normalized_action,
        "input": text or payload,
        "context": context,
    }


def _protocol_request(
    intent: str,
    action: str,
    original_input: Any,
    error: str | None = None,
) -> dict[str, Any]:
    request = {
        "source": PAM_SOURCE,
        "protocol": PAM_PROTOCOL,
        "intent": intent,
        "action": action,
        "input": original_input,
        "context": {"input": original_input} if original_input else {},
    }
    if error:
        request["error"] = error
    return request


def _first_text(payload: dict[str, Any], keys: tuple[str, ...]) -> str:
    for key in keys:
        value = payload.get(key)
        if isinstance(value, str) and value.strip():
            return value.strip()
    return ""


def _normalize_action(action: Any) -> str | None:
    if not isinstance(action, str):
        return None

    normalized = action.strip().lower()
    if normalized.startswith("pam://"):
        return {
            "pam://run": "run",
            "pam://doctor": "doctor",
            "pam://memory": "memory",
        }.get(normalized, "error")
    if normalized in {"run", "call", "execute", "run-once"}:
        return "run"
    if normalized in {"doctor", "health"}:
        return "doctor"
    if normalized == "memory":
        return "memory"
    return "error"


def _detected_text_intent(normalized_prompt: str) -> str:
    if "use pam-core" in normalized_prompt:
        return "use pam-core"
    if "run pam-core" in normalized_prompt:
        return "run pam-core"
    if "pam-core" in normalized_prompt:
        return "pam-core"
    return "natural_language"
