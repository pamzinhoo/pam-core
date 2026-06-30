# pam-core

Reusable multi-agent skill pack for practical project work across repositories.

The pack favors small working changes, security at trust boundaries, low context
noise, and boring maintainable code. It is intentionally project-agnostic.

## Contents

- `.codex-plugin/plugin.json` - Codex plugin manifest.
- `.claude-plugin/plugin.json` - Claude Code plugin manifest.
- `AGENTS.md` - default behavior for agents using this pack.
- `CLAUDE.md` - Claude Code entrypoint for this pack.
- `PROJECT_STATE.md` - current phase, modules, roadmap, and known issues.
- `DECISIONS.md` - permanent architecture and governance decision log.
- `VERSIONING.md` - release and compatibility policy.
- `CONTRIBUTING.md` - change process for skills and docs.
- `MODULES.md` - official module architecture.
- `SKILL_GUIDELINES.md` - required format for skills.
- `SKILL_DEPENDENCIES.md` - skill cooperation, priority, and conflict map.
- `PROJECT_PROFILES.md` - project-type routing defaults.
- `skills/` - reusable skills for coding, review, UI, security, data, docs, and deployment.
- `docs/MULTI_AGENT_COMPATIBILITY.md` - shared-core and adapter model.
- `docs/INSTALL_CODEX.md` - Codex installation notes.
- `docs/INSTALL_CLAUDE.md` - Claude Code usage notes.
- `docs/INSTALL_GENERIC.md` - documentation-only generic agent usage.
- `scripts/install-windows.ps1` - Windows installer for the personal Codex marketplace.
- `scripts/uninstall-windows.ps1` - Windows uninstaller for the local plugin copy.
- `scripts/validate.ps1` - local manifest and skill sanity checks.
- `CHANGELOG.md` - release notes.

## Multi-Agent Support

`pam-core` now uses a shared-core, thin-adapter model.

The shared core is:

- `skills/`
- `MODULES.md`
- `SKILL_DEPENDENCIES.md`
- `PROJECT_PROFILES.md`
- `QUALITY_GATES.md`
- `SKILL_GUIDELINES.md`
- `PROJECT_STATE.md`

Codex continues to be supported through the existing `AGENTS.md`,
`.codex-plugin/plugin.json`, and Windows marketplace scripts. Claude Code has
an initial adapter through `CLAUDE.md` and `.claude-plugin/plugin.json`.
Generic mode is documentation-only for agents that can read the shared core but
do not have a native adapter.

See:

- `docs/MULTI_AGENT_COMPATIBILITY.md`
- `docs/INSTALL_CODEX.md`
- `docs/INSTALL_CLAUDE.md`
- `docs/INSTALL_GENERIC.md`

## Governance

Start with these files when evolving the pack:

1. `PROJECT_STATE.md`
2. `DECISIONS.md`
3. `MODULES.md`
4. `SKILL_GUIDELINES.md`
5. `SKILL_DEPENDENCIES.md`
6. `PROJECT_PROFILES.md`
7. `VERSIONING.md`
8. `CONTRIBUTING.md`

## Install on Windows

From this directory:

```powershell
.\scripts\validate.ps1
.\scripts\install-windows.ps1
codex.cmd plugin add pam-core@personal
```

To replace an existing local copy:

```powershell
.\scripts\validate.ps1
.\scripts\install-windows.ps1 -Force
codex.cmd plugin add pam-core@personal
```

Start a new Codex thread after installing so the CLI reloads plugin skills.

If PowerShell blocks local scripts, run them for this process only:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\install-windows.ps1
```

The installer copies this repository to `%USERPROFILE%\plugins\pam-core`, updates
`%USERPROFILE%\.agents\plugins\marketplace.json`, and refuses to overwrite the
source when source and target resolve to the same path.

## Update During Local Development

1. Edit files in this repository.
2. Run validation:

```powershell
.\scripts\validate.ps1
```

3. Replace the local plugin copy and reinstall from the personal marketplace:

```powershell
.\scripts\install-windows.ps1 -Force
codex.cmd plugin add pam-core@personal
```

4. Start a new Codex thread so updated skills are loaded.

The installer refuses to overwrite itself when the source and target paths are
the same. It also excludes `.git`, `.agents`, `.codex`, `.cache`, `.tmp`,
`node_modules`, common language caches, and temporary files from the installed
plugin copy.

## Validate

```powershell
.\scripts\validate.ps1
codex.cmd --version
```

The expected Codex CLI version for this release is `0.142.3`.

Validation checks that:

- `.codex-plugin/plugin.json` is valid JSON and UTF-8 without BOM.
- `AGENTS.md` and `README.md` exist.
- Each skill directory has `SKILL.md`.
- Each `SKILL.md` starts with frontmatter containing `name` and `description`.
- No source file is empty.
- Any local `marketplace.json` is UTF-8 without BOM.

## Uninstall on Windows

The uninstaller removes the local plugin source and removes the `pam-core` entry
from the personal marketplace file. It does not run Codex commands.

```powershell
.\scripts\uninstall-windows.ps1 -Force
```

Then start a new Codex thread so loaded plugin state is refreshed.

## Manual Install

Copy this folder to:

```text
%USERPROFILE%\plugins\pam-core
```

Ensure `%USERPROFILE%\.agents\plugins\marketplace.json` contains:

```json
{
  "name": "personal",
  "interface": {
    "displayName": "Personal"
  },
  "plugins": [
    {
      "name": "pam-core",
      "source": {
        "source": "local",
        "path": "./plugins/pam-core"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Productivity"
    }
  ]
}
```

Then install:

```powershell
codex.cmd plugin add pam-core@personal
```
