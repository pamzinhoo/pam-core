# Runtime Results

This file records real runtime evidence for `pam-core` after installation. Do
not mark a runtime as `supported` unless a real agent session completed the
matching runbook and the evidence is recorded here or linked from here.

Allowed final statuses:

- `supported`
- `partial`
- `failed`
- `pending`
- `manual`
- `unknown`

## Results

| Agent | Operating system | Agent version | Test date | Install method | Target used | File smoke test | Prompts executed | Observed result | Final status | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Claude Code | pending | pending | pending | `bash scripts/install-unix.sh --agent claude-code --force` | `~/.claude/plugins/pam-core` or manual target | pending | pending | No real Claude Code runtime session recorded yet. | pending | Keep pending until `CLAUDE_CODE.md` and `SMOKE_TEST_PROMPTS.md` are completed in Claude Code. |
| Codex CLI | pending | pending | pending | `bash scripts/install-unix.sh --agent codex-cli --force` or Windows Codex plugin install | `${CODEX_HOME:-~/.codex}/plugins/pam-core` or Windows plugin target | pending | pending | No real Codex CLI runtime session recorded yet. | pending | Keep pending until a fresh Codex CLI session demonstrates runtime use. |
| Codex App | pending | pending | pending | `bash scripts/install-unix.sh --agent codex-app --force` | Linux: `${XDG_CONFIG_HOME:-~/.config}/codex/plugins/pam-core`; macOS: `~/Library/Application Support/Codex/plugins/pam-core` | pending | pending | No real Codex App runtime session recorded yet. | pending | Keep pending until app reload behavior is tested in the real app. |
| Generic agent | manual | unknown | pending | `bash scripts/install-unix.sh --agent generic --target PATH --force` | manual | manual | pending | No generic-agent runtime session recorded yet. | manual | Generic support depends on explicitly pointing the agent at the installed shared core. |

## Evidence Rules

- A file smoke test alone is not runtime evidence.
- A transcript without install target and agent version is incomplete evidence.
- A status of `supported` requires all required prompts to pass or a written
  reason why a prompt is not applicable.
- A status of `partial` requires clear notes describing which runtime behavior
  worked and which behavior still requires manual setup.
- A status of `failed` requires enough detail to reproduce the failure.
