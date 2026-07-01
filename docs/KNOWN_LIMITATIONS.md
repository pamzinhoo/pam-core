# Known Limitations

This file summarizes current support boundaries for `pam-core` 1.2.0.

## Runtime Support

- Codex CLI is `supported` only through the explicit
  `--codex-runtime-cache` adapter.
- The generic Codex CLI target `~/.codex/plugins/pam-core` has not been proven
  as a runtime source.
- Claude Code is `pending` because `claude` and `claude.cmd` were not found in
  the tested environment.
- Codex App is `pending` because no real app session was observable.
- Generic agents are `manual` because they require explicit context or target
  wiring.

## Operating System Support

- Windows PowerShell validation has passed.
- Git Bash on Windows validation has passed.
- Git Bash on Windows is not Linux native evidence.
- WSL, Linux native, and macOS native still need real host validation.

## Packaging

- Packages are generated and validated in PowerShell and Git Bash.
- Packages intentionally keep `runtime_pending: true`.
- Packaging does not install `pam-core` into a runtime.
- Packaging does not prove AI behavior.

## Evidence Rules

- A file smoke test does not prove AI runtime behavior.
- Runtime support can be promoted only with real evidence in
  `docs/runtime-tests/RUNTIME_RESULTS.md`.
- Do not mark Claude Code, Codex App, Linux native, WSL, or macOS native as
  `supported` until their real validation is recorded.

## Current Global Status

Global `runtime_pending` remains true because Claude Code, Codex App, and
native OS validation are still pending.
