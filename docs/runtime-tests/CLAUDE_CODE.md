# Claude Code Runtime Test

## Objective

Confirm that Claude Code can load the installed `pam-core` shared core and use
its routing documents during a real session.

## Prerequisites

- Claude Code is installed and can open a local workspace.
- `pam-core` has been installed to the Claude Code target or a manual target.
- The target contains `CLAUDE.md`, `AGENTS.md`, `MODULES.md`,
  `SKILL_DEPENDENCIES.md`, `PROJECT_STATE.md`, and `skills/`.

## Recommended Install Command

```bash
bash scripts/install-unix.sh --agent claude-code --force
bash scripts/validate-unix.sh --target "$HOME/.claude/plugins/pam-core"
```

Use `--target PATH` if Claude Code expects plugins in another location.

## Open or Reload the Agent

Close all Claude Code sessions that might have loaded the old pack. Open a new
Claude Code session in a test repository after installation. If Claude Code
offers a plugin reload command in your version, use it before starting the
prompts.

## Test Prompts

Use the prompts in `SMOKE_TEST_PROMPTS.md`, especially:

- "Do you recognize `pam-core` in this session?"
- "Which `pam-core` module should handle a small FastAPI validation bug?"
- "Read the relevant `pam-core` routing files and tell me only the minimum
  skills you would use for a documentation-only change."

## Expected Result

Claude Code should mention the shared `pam-core` files, avoid claiming a new
skill exists, and choose a small set of relevant modules or skills. It should
not say that runtime behavior was validated unless the prompts were actually
run in Claude Code.

## Evidence Required Before Marking Supported

Do not mark Claude Code runtime as `supported` until a real Claude Code session
is recorded in `RUNTIME_RESULTS.md` or a linked evidence note. The evidence must
show that Claude Code:

- Recognizes the main `pam-core` files available to the session.
- Answers based on `AGENTS.md`.
- Uses `MODULES.md` to choose the relevant module.
- Consults or cites `SKILL_DEPENDENCIES.md` when skill selection is relevant.
- Does not create a new skill impulsively.
- Respects the minimum useful scope.
- Passes the prompts in `SMOKE_TEST_PROMPTS.md`.

## Failure Signals

- Claude Code cannot find `CLAUDE.md` or `AGENTS.md`.
- It invents `pam-core` skills that do not exist under `skills/`.
- It ignores the shared-core model and expects duplicated Claude-only skills.
- It claims installation success without checking files or session state.

## Known Limitations

- Installation and file validation are supported.
- Runtime loading is pending manual confirmation.
- Claude Code plugin schema behavior may vary by version.

## Phase 19 Discovery - 2026-07-01

In the current Windows environment, Claude Code was not testable as a real
runtime:

- `where.exe claude` and `where.exe claude.cmd` did not find a command.
- `Get-Command claude` and `Get-Command claude.cmd` did not find a command.
- Git Bash `command -v claude` and `command -v claude.cmd` did not find a
  command.
- `~/.claude` and `~/.claude/plugins` exist.
- `~/.claude/skills`, `~/.config/claude`, `%APPDATA%\Claude`,
  `%LOCALAPPDATA%\Claude`, and `~/Library/Application Support/Claude` were not
  found.

Status remains `pending` until a real Claude Code command or app session can
open the installed target and pass `SMOKE_TEST_PROMPTS.md`.
