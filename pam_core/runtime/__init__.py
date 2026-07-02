"""Portable runtime orchestration layer."""

from pam_core.protocol import call, doctor, memory, normalize_input, run

from .bridge import handle_external_prompt
from .detection import detect_environment
from .loop import RuntimeLoop, run_loop

__all__ = [
    "RuntimeLoop",
    "call",
    "doctor",
    "handle_external_prompt",
    "memory",
    "normalize_input",
    "run",
    "run_loop",
    "detect_environment",
]
