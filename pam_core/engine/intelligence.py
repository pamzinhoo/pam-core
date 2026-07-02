"""Context intelligence for pam-core agent orchestration."""

from __future__ import annotations

from typing import Any


class ContextIntelligence:
    """Analyze context into intent and risk signals."""

    HIGH_RISK_TERMS = {
        "delete",
        "remove",
        "drop",
        "wipe",
        "format",
        "sudo",
        "token",
        "secret",
        "password",
        "private key",
        "chmod",
        "rm ",
        "destructive",
    }
    MEDIUM_RISK_TERMS = {
        "admin",
        "permission",
        "auth",
        "security",
        "deploy",
        "database",
        "migration",
        "file",
        "config",
    }

    def analyze(self, context: dict[str, Any]) -> dict[str, Any]:
        text = self._context_text(context)
        return {
            "intent": self._intent(text),
            "risk_level": self._risk_level(text),
            "signals": {
                "role": str(context.get("role", "")),
                "action": str(context.get("action", "")),
                "input": str(context.get("input", "")),
            },
        }

    def _intent(self, text: str) -> str:
        if any(term in text for term in ("audit", "security", "admin", "permission")):
            return "security_review"
        if any(term in text for term in ("accessibility", "aluno", "student", "screen")):
            return "accessibility_review"
        if any(term in text for term in ("system", "architecture", "module", "design")):
            return "architecture_review"
        if any(term in text for term in ("test", "verify", "check")):
            return "verification"
        return "generic_analysis"

    def _risk_level(self, text: str) -> str:
        if any(term in text for term in self.HIGH_RISK_TERMS):
            return "high"
        if any(term in text for term in self.MEDIUM_RISK_TERMS):
            return "medium"
        return "low"

    @staticmethod
    def _context_text(context: dict[str, Any]) -> str:
        return " ".join(f"{key} {value}" for key, value in context.items()).lower()
