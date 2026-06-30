# Multi-Agent Compatibility

`pam-core` is moving toward a shared-core, thin-adapter architecture.

## Shared Core

The core is reusable across agents:

- `skills/`
- `MODULES.md`
- `SKILL_DEPENDENCIES.md`
- `PROJECT_PROFILES.md`
- `QUALITY_GATES.md`
- `SKILL_GUIDELINES.md`
- `PROJECT_STATE.md`

The core owns skill content, module ownership, routing dependencies, project
profiles, quality gates, and project state.

## Thin Adapters

Adapters expose the same core to a specific agent without copying skills.

Current adapters:

- Codex: `AGENTS.md`, `.codex-plugin/plugin.json`, and Windows install scripts.
- Claude Code: `CLAUDE.md` and `.claude-plugin/plugin.json`.
- Generic: documentation-only usage through the shared core files.

## Codex

Codex remains the primary supported adapter for version `1.2.0`. The existing
Codex behavior is unchanged:

- `AGENTS.md` remains the Codex routing entrypoint.
- `.codex-plugin/plugin.json` remains the Codex plugin manifest.
- `scripts/install-windows.ps1` and `scripts/uninstall-windows.ps1` remain the
  Codex personal marketplace workflow.

## Claude Code

Claude Code support starts with a minimal adapter:

- `CLAUDE.md` is the Claude Code entrypoint.
- `.claude-plugin/plugin.json` declares the plugin and points to the existing
  root `skills/` directory.

The Claude adapter does not install itself automatically and does not copy
skills.

Validate the Claude adapter with:

```powershell
.\scripts\validate-claude.ps1
```

The main `.\scripts\validate.ps1` command keeps the Codex package checks and
runs the Claude adapter validation at the end.

## Generic Mode

Agents without native plugin or skill support can still use `pam-core` by
reading:

1. `AGENTS.md` or `CLAUDE.md` for operating guidance.
2. `MODULES.md`, `SKILL_DEPENDENCIES.md`, and `PROJECT_PROFILES.md` for routing.
3. `QUALITY_GATES.md` for completion checks.
4. The relevant `skills/*/SKILL.md` files for specialist behavior.

Generic mode is documentation-only. It relies on the agent following the files
manually.

## Current Limitations

- Claude Code installation is documented but not automated.
- `scripts/validate.ps1` validates the current Codex package contract first,
  then runs the Claude adapter validation.
- The Claude plugin manifest is minimal and may need expansion after practical
  Claude Code testing.
- `README.md` still keeps the Codex workflow as the main installation path.
- No adapter exports, packaging scripts, or generated manifests exist yet.

## Future Work

- Decide whether generic adapters need generated bundles or only docs.
- Add adapter install scripts only after manual usage is proven.
- Keep any future adapter metadata thin and pointed at the shared core.
