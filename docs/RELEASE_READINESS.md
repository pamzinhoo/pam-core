# Release Readiness

This file records the current 1.2.0 release readiness state.

## Overall Status

`pam-core` 1.2.0 is ready as a documented Windows/Git Bash validated release
candidate with known runtime limitations. It is not yet a fully confirmed
multi-platform or multi-agent runtime release.

Global `runtime_pending` remains true.

## Packages Available

Generated artifacts:

- `dist/pam-core-1.2.0.zip`
- `dist/pam-core-1.2.0.tar.gz`
- `dist/CHECKSUMS.txt`

Validate packages with:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-package.ps1
```

```bash
bash scripts/validate-package.sh
```

## Checksums

Checksums are stored in `dist/CHECKSUMS.txt`. Recompute SHA256 for downloaded
artifacts and compare each file with the matching line.

## Validated Environments

- Windows PowerShell: validated.
- Git Bash on Windows: validated.

Git Bash is not Linux native.

## Pending Environments

- WSL: pending.
- Linux native: pending.
- macOS native: pending.

## Validated Agents

- Codex CLI: `supported` only through
  `bash scripts/install-unix.sh --agent codex-cli --codex-runtime-cache --force`.

## Pending or Manual Agents

- Claude Code: `pending`.
- Codex App: `pending`.
- Generic agent: `manual`.
- Codex CLI generic target `~/.codex/plugins/pam-core`: not proven as runtime
  source.

## Remaining Risks

- Claude Code command availability and plugin loading are untested.
- Codex App reload and plugin registration behavior are untested.
- Linux native, WSL, and macOS native script validation are untested.
- File smoke tests can pass while an AI runtime still ignores the installed
  files.
- Codex CLI runtime cache behavior may change in future Codex versions.

## Criteria for 1.2.0 Ready

1. PowerShell validation passes.
2. Git Bash validation passes.
3. PowerShell and Bash package validators pass.
4. `dist/` contains the 1.2.0 zip, tar.gz, and checksums.
5. Runtime matrix clearly marks Codex CLI support as cache-adapter only.
6. Claude Code, Codex App, WSL, Linux native, and macOS native remain pending
   unless evidence is recorded.
7. `runtime_pending` remains true.
8. Known limitations are documented.

Under these criteria, 1.2.0 is ready to release as a limited, evidence-scoped
release candidate, not as a fully native multi-platform runtime release.

## Criteria for a Future 1.3.0

Consider 1.3.0 when one or more of these are true:

- Linux native validation passes on a real Linux host.
- WSL validation passes.
- macOS native validation passes.
- Claude Code runtime evidence is recorded.
- Codex App runtime evidence is recorded.
- Codex CLI generic target behavior is proven or explicitly rejected with
  updated documentation.

Do not promote any runtime or OS target without evidence in
`docs/runtime-tests/RUNTIME_RESULTS.md`.
