# Packaging

Phase 17 adds versioned distribution packages for `pam-core`. Packaging creates
clean archives in `dist/`; it does not install the pack into any runtime. The
install scripts from Phase 15 remain responsible for installation after a
package is extracted.

## Version Source

The packaging scripts read the current version from `PROJECT_STATE.md`:

```text
Manifest version: 1.2.0
```

There is no separate plain version file yet. If a future phase adds one, the
packaging scripts should switch to that source and keep `PROJECT_STATE.md`
aligned.

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
files are present, forbidden local artifacts are absent, and
`runtime_status.runtime_pending` is true while runtime support is not confirmed.

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
- `docs/PACKAGING.md`
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
- `*.bak`
- `*.tmp`
- `.DS_Store`
- `Thumbs.db`

## Checksums

`dist/CHECKSUMS.txt` contains SHA256 hashes for generated packages. Verify a
downloaded package by recomputing SHA256 and comparing it with the matching
line in `CHECKSUMS.txt`.

## Runtime Pending

`runtime_status.runtime_pending: true` means the package correctly records that
runtime support has not been confirmed by real agent evidence. It is not a
packaging failure.

Do not change runtime status to confirmed in a package unless
`docs/runtime-tests/RUNTIME_RESULTS.md` records real evidence for the agent.

## Install From an Extracted Package

Extract the package, then run the existing installer from the extracted
`pam-core-VERSION/` directory:

```bash
bash scripts/validate-unix.sh
bash scripts/install-unix.sh --agent auto
```

Use `--target PATH` when an agent expects a non-default install location. On
Windows, use the existing PowerShell install flow from `README.md`; packaging
does not replace that installer.
