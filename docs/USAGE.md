# Usage

This guide shows how to install, validate, package, and test `pam-core` without
overstating runtime support.

## 1. What pam-core Is

`pam-core` is a reusable multi-agent skill pack. It provides shared project
instructions, governance docs, validation scripts, runtime test runbooks, and a
single `skills/` core for practical software work.

## 2. What It Installs

Install scripts copy the shared core and thin adapter metadata:

- `AGENTS.md`
- `CLAUDE.md` when installing for Claude Code
- `.codex-plugin/` for Codex targets
- `.claude-plugin/` for Claude Code targets
- `MODULES.md`, `SKILL_DEPENDENCIES.md`, `PROJECT_STATE.md`, and related docs
- `skills/`
- `.install-manifest.json` in Unix install targets

## 3. What It Does Not Install

`pam-core` does not install agent runtimes, register every app automatically, or
prove AI behavior. A file smoke test confirms files only. Runtime support is
confirmed only when evidence is recorded in
`docs/runtime-tests/RUNTIME_RESULTS.md`.

## 4. Prerequisites

Windows:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate.ps1
codex.cmd --version
```

Linux, macOS, WSL, or Git Bash:

```bash
chmod +x scripts/*.sh
bash scripts/validate-unix.sh
```

Git Bash on Windows is validated separately and is not Linux native evidence.

## 5. Install on Codex CLI

The generic Codex CLI target can be installed and file-validated, but it is not
proven as the runtime source:

```bash
bash scripts/install-unix.sh --agent codex-cli --force
bash scripts/validate-unix.sh --target ~/.codex/plugins/pam-core
bash scripts/runtime-smoke-test.sh --target ~/.codex/plugins/pam-core
```

Treat this target as unconfirmed for runtime behavior until a real Codex CLI
session reads it and evidence is recorded.

## 6. Install on Codex CLI With Runtime Cache Adapter

Codex CLI is supported only through the explicit runtime cache adapter:

```bash
bash scripts/install-unix.sh --agent codex-cli --codex-runtime-cache --force
bash scripts/runtime-smoke-test.sh --target ~/.codex/plugins/cache/personal/pam-core/1.2.0
```

This mode is explicit by design. It installs to the observed Codex CLI personal
plugin cache path for version `1.2.0` and writes
`"runtime_cache_target": true` in `.install-manifest.json`.

## 7. Install in a Manual Target

Use a manual target for generic testing or an agent-specific path that is not
known by the installer:

```bash
bash scripts/install-unix.sh --agent generic --target /tmp/pam-core-test --force
```

## 8. Validate Installation

Validate the source tree:

```bash
bash scripts/validate-unix.sh
```

Validate a specific install target:

```bash
bash scripts/validate-unix.sh --target /tmp/pam-core-test
bash scripts/runtime-smoke-test.sh --target /tmp/pam-core-test
```

`runtime-smoke-test.sh` checks required files only. It does not test AI
behavior.

## 9. Uninstall

Unix uninstall removes only targets with a manifest created by
`scripts/install-unix.sh`:

```bash
bash scripts/uninstall-unix.sh --target /tmp/pam-core-test
```

Preview first:

```bash
bash scripts/uninstall-unix.sh --target /tmp/pam-core-test --dry-run
```

For the Codex CLI runtime cache adapter:

```bash
bash scripts/uninstall-unix.sh --agent codex-cli --codex-runtime-cache --dry-run
```

## 10. Use a .zip or .tar.gz Package

Linux, macOS, WSL, or Git Bash:

```bash
mkdir -p /tmp/pam-core-release
tar -xzf dist/pam-core-1.2.0.tar.gz -C /tmp/pam-core-release
cd /tmp/pam-core-release/pam-core-1.2.0
bash scripts/validate-unix.sh
```

Windows:

```powershell
Expand-Archive .\dist\pam-core-1.2.0.zip -DestinationPath .\release-test
Set-Location .\release-test\pam-core-1.2.0
powershell -ExecutionPolicy Bypass -File .\scripts\validate.ps1
```

## 11. Test on Linux Tomorrow

On a real Linux host:

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

Record the result in `docs/runtime-tests/RUNTIME_RESULTS.md`. This proves script
and file behavior on Linux, but it does not prove any AI runtime unless a real
agent session also runs the smoke prompts.

If Codex CLI is installed on Linux:

```bash
codex --version
bash scripts/install-unix.sh --agent codex-cli --codex-runtime-cache --force
bash scripts/runtime-smoke-test.sh --target ~/.codex/plugins/cache/personal/pam-core/1.2.0
```

Then run the Codex CLI runtime prompts from
`docs/runtime-tests/SMOKE_TEST_PROMPTS.md` before changing runtime status.

## 12. Test on macOS

On a real macOS host:

```bash
chmod +x scripts/*.sh
bash scripts/validate-unix.sh
bash scripts/package-release.sh
bash scripts/validate-package.sh
bash scripts/install-unix.sh --agent generic --target /tmp/pam-core-macos-test --force
bash scripts/runtime-smoke-test.sh --target /tmp/pam-core-macos-test
bash scripts/uninstall-unix.sh --target /tmp/pam-core-macos-test
git diff --check
```

For Codex App on macOS, use the documented app target only when a real app
session is available:

```bash
bash scripts/install-unix.sh --agent codex-app --force
bash scripts/validate-unix.sh --target "$HOME/Library/Application Support/Codex/plugins/pam-core"
```

Do not mark Codex App supported without a real app session.

## 13. Test Claude Code When claude Is Available

When `claude` or `claude.cmd` exists:

```bash
claude --version
bash scripts/install-unix.sh --agent claude-code --force
bash scripts/validate-unix.sh --target ~/.claude/plugins/pam-core
bash scripts/runtime-smoke-test.sh --target ~/.claude/plugins/pam-core
```

Open a fresh Claude Code session and run the prompts in
`docs/runtime-tests/SMOKE_TEST_PROMPTS.md`. Record evidence in
`docs/runtime-tests/RUNTIME_RESULTS.md` before changing the status.

## 14. Test Codex App When a Real Session Exists

Linux:

```bash
bash scripts/install-unix.sh --agent codex-app --force
bash scripts/validate-unix.sh --target "${XDG_CONFIG_HOME:-$HOME/.config}/codex/plugins/pam-core"
```

macOS:

```bash
bash scripts/install-unix.sh --agent codex-app --force
bash scripts/validate-unix.sh --target "$HOME/Library/Application Support/Codex/plugins/pam-core"
```

Restart Codex App, open a fresh session, run
`docs/runtime-tests/SMOKE_TEST_PROMPTS.md`, and record evidence before changing
status.

## 15. Interpret Status Values

- `supported`: implemented and backed by script validation or real runtime
  evidence.
- `partial`: partly implemented or validated, with known gaps.
- `pending`: expected or planned, but not yet confirmed.
- `manual`: requires an explicit target, manual setup, or agent-specific
  context wiring.
- `unknown`: no reliable evidence.

## 16. Known Limitations

- Codex CLI is supported only via `--codex-runtime-cache`.
- The generic Codex CLI target `~/.codex/plugins/pam-core` is not proven as a
  runtime source.
- Claude Code is pending until `claude` or `claude.cmd` is available and tested.
- Codex App is pending until a real app session is tested.
- Git Bash on Windows is validated separately and is not Linux native.
- Linux native, WSL, and macOS native still need real host validation.
- Global `runtime_pending` remains true.
- A file smoke test is not AI runtime evidence.
