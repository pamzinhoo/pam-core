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
| Codex CLI | supported | partial | supported | pending | pending | `docs/runtime-tests/RUNTIME_RESULTS.md` | Unix target and Codex plugin metadata are present. Windows Codex installation remains supported separately. Fresh-session Unix runtime confirmation is still required. |
| Codex App | supported | partial | supported | pending | pending | `docs/runtime-tests/RUNTIME_RESULTS.md` | Default target differs between Linux and macOS. App reload and plugin registration behavior must be confirmed manually. |
| Generic agent | manual | manual | supported | manual | pending | `docs/runtime-tests/RUNTIME_RESULTS.md` | Generic mode depends on the agent being explicitly pointed at `AGENTS.md`, governance docs, and `skills/`. |

No Phase 16 runtime row should be changed from `pending` or `manual` to
`supported` until the matching document in `docs/runtime-tests/` has been run in
the real agent and the result is recorded.

## Supported Agent Values

| Agent | Default Unix target |
| --- | --- |
| `claude-code` | `~/.claude/plugins/pam-core` |
| `codex-cli` | `${CODEX_HOME:-~/.codex}/plugins/pam-core` |
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

## Known Limits

- Unix installation does not replace the Windows PowerShell installer.
- Runtime registration is still agent-specific.
- Generic mode depends on the agent reading `AGENTS.md`, shared governance
  files, and relevant `skills/*/SKILL.md` files.
- File validation does not prove that an agent has reloaded or used the pack in
  a live model session.
