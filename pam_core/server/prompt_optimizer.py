"""Small deterministic prompt cleanup for the API server."""

from __future__ import annotations

import re
import unicodedata


SECTION_ALIASES = {
    "objective": {"objective", "goal", "objetivo"},
    "context": {"context", "background", "contexto"},
    "constraints": {"constraints", "rules", "restrictions", "regras", "restricoes"},
    "tasks": {"tasks", "steps", "tarefas", "escopo"},
}


def optimize_prompt(prompt: str) -> tuple[str, dict[str, list[str]]]:
    """Clean spacing and group existing content without inventing requirements."""

    lines = _clean_lines(prompt)
    sections: dict[str, list[str]] = {
        "objective": [],
        "context": [],
        "constraints": [],
        "tasks": [],
    }
    current_section = "objective"

    for line in lines:
        detected = _detect_section(line)
        if detected:
            current_section = detected
            remainder = _strip_section_label(line)
            if remainder:
                sections[current_section].append(remainder)
            continue
        sections[current_section].append(line)

    sections = {key: value for key, value in sections.items() if value}
    optimized = _format_sections(sections)
    return optimized, sections


def _clean_lines(prompt: str) -> list[str]:
    normalized = prompt.replace("\r\n", "\n").replace("\r", "\n")
    lines = []
    for raw_line in normalized.split("\n"):
        line = re.sub(r"[ \t]+", " ", raw_line).strip()
        if line:
            lines.append(line)
    return lines


def _detect_section(line: str) -> str | None:
    label = _ascii_lower(line.split(":", 1)[0].strip())
    label = re.sub(r"^[#*\-\d.\s]+", "", label)
    for section, aliases in SECTION_ALIASES.items():
        if label in aliases:
            return section
    return None


def _ascii_lower(value: str) -> str:
    normalized = unicodedata.normalize("NFKD", value)
    return normalized.encode("ascii", "ignore").decode("ascii").lower()


def _strip_section_label(line: str) -> str:
    if ":" not in line:
        return ""
    return line.split(":", 1)[1].strip()


def _format_sections(sections: dict[str, list[str]]) -> str:
    labels = {
        "objective": "Objective",
        "context": "Context",
        "constraints": "Constraints",
        "tasks": "Tasks",
    }
    blocks: list[str] = []
    for section in ("objective", "context", "constraints", "tasks"):
        items = sections.get(section)
        if not items:
            continue
        body = "\n".join(f"- {item}" for item in items)
        blocks.append(f"{labels[section]}:\n{body}")
    return "\n\n".join(blocks)
