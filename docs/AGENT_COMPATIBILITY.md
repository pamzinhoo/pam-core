# Agent Compatibility

`pam-core` uses one shared core with thin adapters. The Unix installer copies
the shared core plus small adapter metadata when relevant; it does not duplicate
or transform skills.

## Runtime Compatibility Matrix

States:

- `supported` - implemented and validated by script or confirmed manual
  evidence.
- `partial` - partly implemented, with known gaps or extra manual steps.
- `manual` - requires an explicit target, reload step, or manual context setup.
- `pending` - expected path exists, but runtime behavior still needs manual
  confirmation.
- `unknown` - no reliable evidence is available.

| Agent | Installation supported | Automatic detection supported | File validation supported | Runtime confirmed | Runtime pending | Evidence file | Observations |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Claude Code | supported | partial | supported | pending | pending | `docs/runtime-tests/RUNTIME_RESULTS.md` | Unix target and Claude adapter files are present. Runtime loading still needs a fresh Claude Code session smoke test. |
| Codex CLI | supported | partial | supported | supported | pending | `docs/runtime-tests/RUNTIME_RESULTS.md` | Supported through the explicit `--codex-runtime-cache` adapter. Phase 18.2 installed to the observed personal plugin cache, Codex CLI read the cache sentinel, and main prompts passed. The generic Unix target `~/.codex/plugins/pam-core` is not proven as a runtime source. |
| Codex App | supported | partial | supported | pending | pending | `docs/runtime-tests/RUNTIME_RESULTS.md` | Default target differs between Linux and macOS. App reload and plugin registration behavior must be confirmed manually. |
| Generic agent | manual | manual | supported | manual | pending | `docs/runtime-tests/RUNTIME_RESULTS.md` | Generic mode depends on the agent being explicitly pointed at `AGENTS.md`, governance docs, and `skills/`. |

No Phase 16 runtime row should be changed from `pending` or `manual` to
`supported` until the matching document in `docs/runtime-tests/` has been run in
the real agent and the result is recorded.

Phase 18 started runtime verification on 2026-07-01. Codex CLI first had
partial cache-source evidence; Claude Code and Codex App remain pending because
no real runtime session was observed for them.
Phase 18.1 confirmed that the observed Codex CLI source of truth is the personal
plugin cache, not the Phase 15 Unix target.
Phase 18.2 added and validated the explicit Codex CLI runtime cache adapter with
`--codex-runtime-cache`. Global runtime remains pending for Claude Code and
Codex App.
Phase 19 discovery on 2026-07-01 found no `claude` or `claude.cmd` command in
PowerShell or Git Bash, found only plausible Claude directories under
`~/.claude`, and found no observable Codex App session or app config directory.
Claude Code and Codex App therefore remain `pending`. The host had Windows
PowerShell and Git Bash only; WSL was not installed, and no Linux native or
macOS native validation was possible.

## Supported Agent Values

| Agent | Default Unix target |
| --- | --- |
| `claude-code` | `~/.claude/plugins/pam-core` |
| `codex-cli` | `${CODEX_HOME:-~/.codex}/plugins/pam-core` |
| `codex-cli --codex-runtime-cache` | `${CODEX_HOME:-~/.codex}/plugins/cache/personal/pam-core/VERSION` |
| `codex-app` on Linux | `${XDG_CONFIG_HOME:-~/.config}/codex/plugins/pam-core` |
| `codex-app` on macOS | `~/Library/Application Support/Codex/plugins/pam-core` |
| `generic` | `~/pam-core` |
| `auto` | Uses `scripts/detect-agent.sh`, then falls back to `generic` |

## Detect

```bash
bash scripts/detect-agent.sh
```

The output is:

```text
agent<TAB>suggested-target
```

Detection checks only known environment variables and common directories:

- Claude Code: `CLAUDE_CONFIG_DIR`, `CLAUDE_CODE_ENTRYPOINT`, or `~/.claude`.
- Codex CLI: `CODEX_HOME` or `~/.codex`.
- Codex App: common Codex app config directories.
- Generic fallback when none are found.

## Install With a Manual Target

Use `--target` when the agent expects files somewhere else:

```bash
bash scripts/install-unix.sh --agent generic --target /opt/pam-core --dry-run
bash scripts/install-unix.sh --agent generic --target /opt/pam-core --force
```

The installer creates `.install-manifest.json` in the target. The uninstaller
requires that manifest before deleting anything.

## Validate and Remove

```bash
bash scripts/validate-unix.sh
bash scripts/validate-unix.sh --target /opt/pam-core
bash scripts/runtime-smoke-test.sh --target /opt/pam-core
bash scripts/uninstall-unix.sh --target /opt/pam-core --dry-run
bash scripts/uninstall-unix.sh --target /opt/pam-core
```

`scripts/runtime-smoke-test.sh` only verifies that the target has the files
needed for a manual runtime test. It does not test model behavior.

## Manual Runtime Tests

Use the per-agent runbooks in `docs/runtime-tests/`:

- `docs/runtime-tests/CLAUDE_CODE.md`
- `docs/runtime-tests/CODEX_CLI.md`
- `docs/runtime-tests/CODEX_APP.md`
- `docs/runtime-tests/GENERIC_AGENT.md`
- `docs/runtime-tests/SMOKE_TEST_PROMPTS.md`
- `docs/runtime-tests/EVIDENCE_TEMPLATE.md`
- `docs/runtime-tests/RUNTIME_RESULTS.md`

For practical usage and release status, also see:

- `docs/USAGE.md`
- `docs/LINUX_TEST_PLAN.md`
- `docs/KNOWN_LIMITATIONS.md`
- `docs/RELEASE_READINESS.md`

## Known Limits

- Unix installation does not replace the Windows PowerShell installer.
- Git Bash on Windows is tracked separately from Linux native validation.
- Runtime registration is still agent-specific.
- Generic mode depends on the agent reading `AGENTS.md`, shared governance
  files, and relevant `skills/*/SKILL.md` files.
- File validation does not prove that an agent has reloaded or used the pack in
  a live model session.
