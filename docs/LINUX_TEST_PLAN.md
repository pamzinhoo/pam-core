# Linux Test Plan

Use this plan on a real Linux host. Do not use Git Bash results as Linux native
evidence.

## 1. Get the Repository

Clone from the project remote:

```bash
git clone <REPOSITORY_URL> pam-core
cd pam-core
```

Or copy the repository folder to the Linux host and enter it:

```bash
cd /path/to/pam-core
```

## 2. Prepare Scripts

```bash
chmod +x scripts/*.sh
```

## 3. Validate Bash Support

```bash
bash scripts/validate-unix.sh
```

Success means the source tree has the required Unix scripts, docs, runtime test
files, and LF shell scripts.

## 4. Generate Packages

```bash
bash scripts/package-release.sh
```

Expected outputs:

- `dist/pam-core-1.2.0.tar.gz`
- `dist/pam-core-1.2.0.zip` when `zip` or PowerShell is available
- `dist/CHECKSUMS.txt`

## 5. Validate Packages

```bash
bash scripts/validate-package.sh
```

Success means the generated packages contain required files, exclude forbidden
local artifacts, and keep `runtime_pending: true`.

## 6. Install to a Temporary Target

```bash
bash scripts/install-unix.sh --agent generic --target /tmp/pam-core-linux-test --force
```

## 7. Run File Smoke Test

```bash
bash scripts/runtime-smoke-test.sh --target /tmp/pam-core-linux-test
```

This confirms the target has required files. It does not prove AI behavior.

## 8. Uninstall Temporary Target

```bash
bash scripts/uninstall-unix.sh --target /tmp/pam-core-linux-test
```

## 9. Check Diff Cleanliness

```bash
git diff --check
```

## 10. Optional Codex CLI Test on Linux

Run this only if Codex CLI is installed:

```bash
codex --version
bash scripts/install-unix.sh --agent codex-cli --codex-runtime-cache --force
bash scripts/runtime-smoke-test.sh --target ~/.codex/plugins/cache/personal/pam-core/1.2.0
```

Then start a fresh Codex CLI session and run the prompts from
`docs/runtime-tests/SMOKE_TEST_PROMPTS.md`. Record the observed response in
`docs/runtime-tests/RUNTIME_RESULTS.md`.

## 11. Where to Record Results

Record the Linux host result in:

- `docs/runtime-tests/RUNTIME_RESULTS.md`
- `PROJECT_STATE.md`
- `CHANGELOG.md`
- `docs/PACKAGING.md`, if packaging behavior changes
- `docs/INSTALL_LINUX.md`, if installation notes change

Include:

- Linux distribution and version from `/etc/os-release`
- `uname -a`
- commands run
- pass/fail result
- whether Codex CLI, Claude Code, Codex App, or only generic file validation was
  tested

## 12. Success Criteria

Linux native script validation succeeds when all of these pass on a real Linux
host:

```bash
chmod +x scripts/*.sh
bash scripts/validate-unix.sh
bash scripts/package-release.sh
bash scripts/validate-package.sh
bash scripts/install-unix.sh --agent generic --target /tmp/pam-core-linux-test --force
bash scripts/runtime-smoke-test.sh --target /tmp/pam-core-linux-test
bash scripts/uninstall-unix.sh --target /tmp/pam-core-linux-test
git diff --check
```

Runtime support for an agent succeeds only when a real agent session reads the
installed files and passes the prompts in `SMOKE_TEST_PROMPTS.md`.

## 13. Failure Criteria

Treat the run as failed or partial if:

- a validation script fails;
- package validation fails;
- install or uninstall leaves an unsafe or unmanaged target;
- `runtime-smoke-test.sh` cannot find required files;
- an agent runtime is available but cannot read or follow the installed
  `pam-core` files.

## 14. What Not to Mark Supported

Do not mark these as `supported` from file smoke tests alone:

- Claude Code runtime
- Codex App runtime
- Generic agent runtime
- Codex CLI generic target `~/.codex/plugins/pam-core`

A smoke test proves file presence only. Runtime support requires evidence in
`docs/runtime-tests/RUNTIME_RESULTS.md`.
