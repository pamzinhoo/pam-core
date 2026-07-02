"""Portable runtime loop."""

from __future__ import annotations

import json
import time
from typing import Any

from pam_core.config import get_settings
from pam_core.engine import PamCoreEngine

from .adapters import create_adapter
from .detection import detect_environment


class RuntimeLoop:
    """Continuous runtime loop using the detected portable adapter."""

    def __init__(
        self,
        engine: PamCoreEngine | None = None,
        interval: float | None = None,
        adapter_name: str | None = None,
    ) -> None:
        self.settings = get_settings()
        self.engine = engine or PamCoreEngine(self.settings)
        self.interval = self.settings.loop_interval if interval is None else interval
        self.adapter = create_adapter(adapter_name or detect_environment(), self.engine)
        self.running = False

    def run_forever(self, payload: dict[str, Any] | None = None) -> None:
        self.running = True
        while self.running:
            result = self.adapter.run_once(payload)
            print(json.dumps(result, indent=2, sort_keys=True))
            time.sleep(self.interval)

    def stop(self) -> None:
        self.running = False


def run_loop(interval: float | None = None, adapter_name: str | None = None) -> None:
    RuntimeLoop(interval=interval, adapter_name=adapter_name).run_forever()
