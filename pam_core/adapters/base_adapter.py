"""Base adapter contract for pam-core runtimes."""

from __future__ import annotations

from typing import Any

from pam_core.engine import PamCoreEngine
from pam_core.protocol.parser import doctor, execute_protocol, memory as protocol_memory, normalize_input


class BaseAdapter:
    """Translate environment-specific input into the core engine context."""

    name = "base"

    def __init__(self, engine: PamCoreEngine | None = None) -> None:
        self.engine = engine or PamCoreEngine()

    def translate_input(self, payload: dict[str, Any] | None = None) -> dict[str, Any]:
        payload = payload or {}
        protocol_request = normalize_input(payload)
        protocol_request["context"] = {
            **protocol_request.get("context", {}),
            "adapter": self.name,
        }
        return protocol_request

    def run_once(self, payload: dict[str, Any] | None = None) -> dict[str, Any]:
        return execute_protocol(self.translate_input(payload), self.engine)

    def memory(self) -> dict[str, Any]:
        result = protocol_memory(self.engine)
        result["result"]["adapter"] = self.name
        return result

    def health(self) -> dict[str, Any]:
        result = doctor(self.engine)
        result["result"]["adapter"] = self.name
        return result
