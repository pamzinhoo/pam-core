# Use pam-core with Claude Code

Claude Code support starts with a minimal adapter.

## Files

- `CLAUDE.md` is the Claude Code entrypoint.
- `.claude-plugin/plugin.json` is the Claude plugin manifest.
- `skills/` remains the shared skill directory.

The Claude adapter does not duplicate skills and does not replace the Codex
adapter.

## Use

Use this repository as the plugin or project context for Claude Code. Claude
Code should read `CLAUDE.md` first, then use the shared core files:

- `skills/`
- `MODULES.md`
- `SKILL_DEPENDENCIES.md`
- `PROJECT_PROFILES.md`
- `QUALITY_GATES.md`
- `SKILL_GUIDELINES.md`
- `PROJECT_STATE.md`

`CLAUDE.md` imports `AGENTS.md` for shared routing guidance. Codex-specific
installation and marketplace references in `AGENTS.md` apply only to Codex.

## Limitations

- There is no Claude install script yet.
- The Claude manifest is intentionally minimal.
- Claude validation checks the adapter files and shared-core references, but it
  does not verify Claude Code runtime loading.
- Practical Claude Code plugin loading still needs manual verification.

## Validate

Claude adapter validation is local and does not require Claude Code to be
installed. It does not install, copy, or delete anything.

```powershell
.\scripts\validate-claude.ps1
```

The main validation script also runs the Claude adapter check after completing
the existing Codex package checks:

```powershell
.\scripts\validate.ps1
```

## Updating

Update shared behavior by editing the core files, not by copying skills into a
Claude-specific directory. After updating:

```powershell
.\scripts\validate.ps1
```

Then reopen or reload the Claude Code session so it rereads `CLAUDE.md` and the
shared core files.
