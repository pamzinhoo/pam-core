"""Defensive static security checks for submitted text or safe project files."""

from __future__ import annotations

import re
from pathlib import Path

from pam_core.server.schemas import SecurityFinding


MAX_FILE_BYTES = 512_000


def analyze_static_security(
    *,
    text: str | None = None,
    code: str | None = None,
    relative_path: str | None = None,
    project_root: Path | None = None,
) -> tuple[str, list[SecurityFinding]]:
    """Analyze text or a safe relative project file without executing anything."""

    source_text = code if code is not None else text
    analyzed_source = "inline"

    if relative_path:
        root = (project_root or Path.cwd()).resolve()
        target = _resolve_safe_path(root, relative_path)
        if target.stat().st_size > MAX_FILE_BYTES:
            raise ValueError("File is too large for static API analysis.")
        source_text = target.read_text(encoding="utf-8", errors="replace")
        analyzed_source = target.relative_to(root).as_posix()

    if source_text is None:
        raise ValueError("Provide text, code, or a safe relative path.")

    return analyzed_source, _scan_text(source_text)


def _resolve_safe_path(root: Path, relative_path: str) -> Path:
    candidate = Path(relative_path)
    if candidate.is_absolute():
        raise ValueError("Path must be relative to the project root.")

    resolved = (root / candidate).resolve()
    if root != resolved and root not in resolved.parents:
        raise ValueError("Path must stay inside the project root.")
    if not resolved.exists() or not resolved.is_file():
        raise ValueError("Path does not point to an existing project file.")
    return resolved


def _scan_text(text: str) -> list[SecurityFinding]:
    findings: list[SecurityFinding] = []
    for line_number, line in enumerate(text.splitlines(), start=1):
        checks = [
            (r"\beval\s*\(", "high", "python-eval", "Avoid eval; use explicit parsing or a narrow command map."),
            (r"\bexec\s*\(", "high", "python-exec", "Avoid exec; use explicit functions or data-driven dispatch."),
            (r"\bos\.system\s*\(", "high", "os-system", "Use subprocess with argument lists and no shell when command execution is required."),
            (r"\bsubprocess\.(Popen|run|call|check_call|check_output)\s*\(.*shell\s*=\s*True", "high", "subprocess-shell", "Avoid shell=True; pass arguments as a list and validate inputs."),
            (r"\bsubprocess\.(Popen|run|call|check_call|check_output)\s*\(", "medium", "subprocess-use", "Review subprocess calls for input validation and shell avoidance."),
            (r"(open|read_text)\s*\([^)]*\.env", "medium", "env-file-read", "Avoid reading .env values through API-facing code paths."),
            (r"(?i)(api[_-]?key|secret|token|password)\s*[:=]\s*['\"][^'\"]{8,}", "high", "hardcoded-secret", "Move hardcoded credentials to a secret store or environment variable."),
            (r"(?i)(bearer\s+[a-z0-9._\-]{20,}|sk-[a-z0-9]{20,})", "high", "apparent-token", "Remove apparent tokens from source and rotate them if real."),
        ]
        for pattern, severity, rule, suggestion in checks:
            if re.search(pattern, line):
                findings.append(
                    SecurityFinding(
                        severity=severity,
                        rule=rule,
                        evidence=_evidence(line),
                        suggestion=suggestion,
                        line=line_number,
                    )
                )
    return findings


def _evidence(line: str) -> str:
    compact = re.sub(r"\s+", " ", line).strip()
    if len(compact) <= 160:
        return compact
    return compact[:157] + "..."
