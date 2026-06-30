# pam-core for Claude Code

This is the Claude Code entrypoint for `pam-core`.

`pam-core` is a multi-agent skill framework. The shared core is the `skills/`
directory plus the governance files at the repository root. Claude Code should
use this file as the local project instruction entrypoint and use the shared
core instead of agent-specific copies.

## Operating Model

Use the pam-core workflow for coding tasks:

1. Project Understanding: read enough local context before editing.
2. Prompt Intelligence: clarify vague, mixed, subjective, or high-risk requests.
3. Execution Control: keep long, broad, tool-heavy, and patch-heavy work bounded.
4. Skill Orchestrator: select the smallest useful set of specialist skills.
5. Quality Gates: run relevant checks before treating work as complete.

## Shared Core

The real reusable core lives in:

- `skills/`
- `MODULES.md`
- `SKILL_DEPENDENCIES.md`
- `PROJECT_PROFILES.md`
- `QUALITY_GATES.md`
- `SKILL_GUIDELINES.md`
- `PROJECT_STATE.md`

Do not duplicate the `skills/` directory for Claude Code. Use the same files
that Codex uses.

## Adapter Notes

`AGENTS.md` remains the Codex adapter and routing brain. Claude Code can read it
as shared routing guidance, but references to Codex-specific installation,
plugin state, or marketplace behavior apply only to Codex.

@AGENTS.md
