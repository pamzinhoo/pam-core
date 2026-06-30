# Use pam-core with a Generic Agent

Generic mode is for agents that do not have native support for Codex plugins or
Claude Code plugins.

## How To Use

Point the agent at this repository and tell it to follow the shared core:

1. Read `AGENTS.md` or `CLAUDE.md` for the operating model.
2. Read `PROJECT_STATE.md` for the current phase and known constraints.
3. Use `MODULES.md` to identify skill modules.
4. Use `SKILL_DEPENDENCIES.md` and `PROJECT_PROFILES.md` for routing.
5. Read only the relevant `skills/*/SKILL.md` files.
6. Use `QUALITY_GATES.md` before declaring work complete.

## Core Files

The reusable core is:

- `skills/`
- `MODULES.md`
- `SKILL_DEPENDENCIES.md`
- `PROJECT_PROFILES.md`
- `QUALITY_GATES.md`
- `SKILL_GUIDELINES.md`
- `PROJECT_STATE.md`

## Limitations

- Generic mode is documentation-only.
- There is no automatic skill discovery.
- There is no manifest validation for arbitrary agents.
- Agent-specific instructions in `AGENTS.md` or `CLAUDE.md` must be interpreted
  according to the agent being used.

Do not copy `skills/` into another format unless a future approved adapter
requires a generated export.
