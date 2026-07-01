# Packaging

Phase 17 adds versioned distribution packages for `pam-core`. Packaging creates
clean archives in `dist/`; it does not install the pack into any runtime. The
install scripts from Phase 15 remain responsible for installation after a
package is extracted.

## Version Source

The packaging scripts read the current version from the first available source:

1. `VERSION`, when present.
2. `VERSIONING.md`, when it contains a simple `Version: x.y.z`,
   `Current version: x.y.z`, or `Manifest version: x.y.z` line.
3. `PROJECT_STATE.md`, using the `Manifest version` line.

```text
Manifest version: 1.2.0
```

Markdown extraction is intentionally simple. It only supports one plain version
line and does not infer versions from examples, changelog headings, or prose.

## Build on Windows

From the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\package-release.ps1
```

The script writes:

- `dist/pam-core-VERSION.zip`
- `dist/pam-core-VERSION.tar.gz` when `tar` is available
- `dist/CHECKSUMS.txt`

## Build on Linux/macOS

From the repository root:

```bash
bash scripts/package-release.sh
```

The script writes:

- `dist/pam-core-VERSION.tar.gz`
- `dist/pam-core-VERSION.zip` when `zip` or PowerShell is available
- `dist/CHECKSUMS.txt`

## Validate Packages

Windows:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-package.ps1
```

Linux/macOS:

```bash
bash scripts/validate-package.sh
```

Validation checks that `dist/` exists, both archive formats exist,
`CHECKSUMS.txt` exists, `PACKAGE_MANIFEST.json` is inside each archive, required
files are present, forbidden local artifacts are absent, checksums match, and
`runtime_pending` is true while runtime support is not confirmed.

## Phase 17.1 Native Validation

On 2026-07-01, the Bash packaging path was validated with Git Bash at
`C:\Program Files\Git\bin\bash.exe`:

```bash
chmod +x scripts/*.sh
bash scripts/validate-unix.sh
bash scripts/package-release.sh
bash scripts/validate-package.sh
git diff --check
```

The Bash scripts generated and validated `dist/pam-core-1.2.0.zip`,
`dist/pam-core-1.2.0.tar.gz`, and `dist/CHECKSUMS.txt`. The PowerShell and Bash
package paths matched on the package allowlist, manifest fields, required
files, exclusions, checksums, and `runtime_pending: true`.

WSL was not installed in this validation environment, and no separate native
Linux or macOS host run was recorded.

## Phase 19 Runtime and Native OS Status

On 2026-07-01, Phase 19 rechecked package-relevant runtime status after Codex
CLI cache-adapter validation:

- Codex CLI remains supported only for the explicit
  `--codex-runtime-cache` adapter.
- Claude Code remains pending because no `claude` or `claude.cmd` runtime
  command was available.
- Codex App remains pending because no real app session or app config target
  was observable.
- WSL/Linux/macOS native validation remains pending because this host only had
  Windows PowerShell and Git Bash on Windows.

Release package manifests must continue to write `runtime_pending: true` until
Claude Code, Codex App, and native OS validation have real evidence recorded in
`docs/runtime-tests/RUNTIME_RESULTS.md`.

## Phase 20 Release Readiness Docs

Phase 20 adds release-facing documentation to the package allowlist:

- `docs/USAGE.md`
- `docs/LINUX_TEST_PLAN.md`
- `docs/KNOWN_LIMITATIONS.md`
- `docs/RELEASE_READINESS.md`

These files explain how to install, validate, test tomorrow on a real Linux
host, interpret support states, and decide whether 1.2.0 is ready to hand off.
They do not change runtime status and do not make the release fully
multi-platform.

## Included Files

Packages include a `pam-core-VERSION/` root with:

- `AGENTS.md`
- `README.md`
- `MODULES.md`
- `SKILL_DEPENDENCIES.md`
- `PROJECT_STATE.md`
- `DECISIONS.md`
- `VERSIONING.md`
- `skills/`
- `scripts/install-unix.sh`
- `scripts/uninstall-unix.sh`
- `scripts/validate-unix.sh`
- `scripts/detect-agent.sh`
- `scripts/runtime-smoke-test.sh`
- `scripts/validate.ps1`
- `scripts/validate-claude.ps1`
- `docs/INSTALL_LINUX.md`
- `docs/INSTALL_MACOS.md`
- `docs/AGENT_COMPATIBILITY.md`
- `docs/USAGE.md`
- `docs/LINUX_TEST_PLAN.md`
- `docs/KNOWN_LIMITATIONS.md`
- `docs/RELEASE_READINESS.md`
- `docs/runtime-tests/`
- `PACKAGE_MANIFEST.json`

## Excluded Files

Packages must not include:

- `.git/`
- `dist/`
- `logs/`
- `tmp/`
- `cache/`
- `node_modules/`
- `__pycache__/`
- `.pytest_cache/`
- `.mypy_cache/`
- `*.bak`
- `*.tmp`
- `.DS_Store`
- `Thumbs.db`

## Checksums

`dist/CHECKSUMS.txt` contains SHA256 hashes for generated packages. Verify a
downloaded package by recomputing SHA256 and comparing it with the matching
line in `CHECKSUMS.txt`.

## Runtime Pending

`runtime_pending: true` means the package correctly records that runtime support
has not been confirmed for all main runtime agents. It is not a packaging
failure.

Do not change runtime status to confirmed in a package unless
`docs/runtime-tests/RUNTIME_RESULTS.md` records real evidence for Claude Code,
Codex CLI, and Codex App.

## Install From an Extracted Package

Extract the package, then run the existing installer from the extracted
`pam-core-VERSION/` directory:

```bash
chmod +x scripts/*.sh
bash scripts/validate-unix.sh
bash scripts/install-unix.sh --agent auto
```

For Codex CLI runtime testing in environments that use the observed personal
plugin cache, install explicitly to the cache adapter:

```bash
bash scripts/install-unix.sh --agent codex-cli --codex-runtime-cache --force
```

This is not the default Codex CLI target and should only be used when the
runtime cache adapter is the intended install path.

Use `--target PATH` when an agent expects a non-default install location. On
Windows, use the existing PowerShell install flow from `README.md`; packaging
does not replace that installer.
