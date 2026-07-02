"""Portable persistent runtime memory."""

from __future__ import annotations

import json
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


class RuntimeState:
    """Persistent memory backed by a configurable JSON file."""

    def __init__(self, store_path: Path) -> None:
        self.store_path = store_path
        self.store_path.parent.mkdir(parents=True, exist_ok=True)
        self._data = self._load()

    def _load(self) -> dict[str, Any]:
        if not self.store_path.exists():
            return self._default_data()
        try:
            data = json.loads(self.store_path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError):
            data = self._default_data()
        data.setdefault("context", {})
        data.setdefault("history", [])
        data.setdefault("skill_results", [])
        data.setdefault("skill_performance", {})
        data.setdefault("last_result", None)
        return data

    @staticmethod
    def _default_data() -> dict[str, Any]:
        return {
            "context": {},
            "history": [],
            "skill_results": [],
            "skill_performance": {},
            "last_result": None,
        }

    def save(self) -> None:
        self.store_path.write_text(
            json.dumps(self._data, indent=2, sort_keys=True),
            encoding="utf-8",
        )

    def context(self) -> dict[str, Any]:
        return dict(self._data.get("context", {}))

    def update_context(self, context: dict[str, Any]) -> dict[str, Any]:
        self._data["context"] = {**self.context(), **context}
        self.save()
        return self.context()

    def record(self, result: dict[str, Any]) -> dict[str, Any]:
        entry = {
            "timestamp": datetime.now(timezone.utc).isoformat(),
            **result,
        }
        selected_skill = result.get("selected_skill")
        success = not str(result.get("result", "")).lower().startswith("blocked")
        self._data.setdefault("history", []).append(entry)
        self._data.setdefault("skill_results", []).append(
            {
                "timestamp": entry["timestamp"],
                "skill": selected_skill,
                "result": result.get("result"),
                "success": success,
            }
        )
        if selected_skill:
            self._update_skill_performance(str(selected_skill), success)
        self._data["last_result"] = entry
        self.save()
        return entry

    def _update_skill_performance(self, skill: str, success: bool) -> None:
        performance = self._data.setdefault("skill_performance", {})
        current = performance.setdefault(
            skill,
            {
                "runs": 0,
                "successes": 0,
                "failures": 0,
                "score_adjustment": 0.0,
            },
        )
        current["runs"] += 1
        if success:
            current["successes"] += 1
            current["score_adjustment"] = min(
                2.0,
                float(current.get("score_adjustment", 0.0)) + 0.1,
            )
        else:
            current["failures"] += 1
            current["score_adjustment"] = max(
                -2.0,
                float(current.get("score_adjustment", 0.0)) - 0.25,
            )

    def snapshot(self) -> dict[str, Any]:
        return json.loads(json.dumps(self._data))
