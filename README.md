# pam-core

Portable AI agent runtime for skill-orchestrated development workflows.

`pam-core` is an installable Python runtime and agent coordination framework for
running portable AI agent workflows across local projects, CLIs, and compatible
agent hosts. It packages a small runtime engine, a command-line interface,
persistent memory hooks, and a reusable skill orchestration model that can be
adapted to Codex, Claude Code, and generic agent environments.

The project is designed for practical engineering work: predictable local
execution, conservative safety boundaries, reusable project understanding, and
clear quality gates before changes are handed off.

## Key Features

- Portable runtime core for AI agent workflows.
- `pam` CLI entry point for running, checking, and inspecting the runtime.
- Skill orchestration model for routing work to focused specialist instructions.
- Persistent memory hooks for runtime state and future agent context.
- Shared-core adapter layout for Codex, Claude Code, and generic agents.
- Safety-first defaults for file operations, command execution, validation, and
  trust boundaries.
- Documentation and installer scripts for Linux, Windows, and macOS users.
- Release packaging support for PyPI and source-distributed agent packs.

## Installation

`pam-core` requires Python 3.10 or newer. The package installs the `pam`
console command.

The official project version is stored in the root `VERSION` file. Python
package metadata, plugin manifests, and API Server `/version` are expected to
stay aligned with that value.

### Linux

```bash
python3 -m pip install pam-core
```

### Windows

```powershell
py -m pip install pam-core
```

### macOS

```bash
python3 -m pip install pam-core
```

For editable development from a cloned repository, install the local checkout:

```bash
python3 -m pip install -e .
```

On Windows, use `py -m pip install -e .` from the repository root.
Platform-specific agent adapter installation notes are preserved in the legacy
documentation below.

## Quickstart local

Use this flow from a cloned repository when you want to install, validate, run,
and smoke-test `pam-core` locally.

### Create a virtual environment

Windows:

```bat
py -m venv .venv
.\.venv\Scripts\python.exe -m pip install --upgrade pip
.\.venv\Scripts\python.exe -m pip install -e ".[test]"
```

Linux/macOS:

```bash
python3 -m venv .venv
./.venv/bin/python -m pip install --upgrade pip
./.venv/bin/python -m pip install -e ".[test]"
```

### Run validations

Windows:

```bat
.\.venv\Scripts\python.exe -m compileall pam_core
.\.venv\Scripts\python.exe -m pytest
powershell -ExecutionPolicy Bypass -File .\scripts\validate.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\validate-claude.ps1
git diff --check
```

Linux/macOS:

```bash
./.venv/bin/python -m compileall pam_core
./.venv/bin/python -m pytest
bash scripts/validate-unix.sh
git diff --check
```

### Run the local API Server

Windows:

```bat
.\.venv\Scripts\python.exe -m pam_core.server
```

Linux/macOS:

```bash
./.venv/bin/python -m pam_core.server
```

The default server address is:

```txt
http://127.0.0.1:8765
```

`GET /` can return `404`; that is normal. Use the API endpoints below.

### Test the main endpoints

```bash
curl http://127.0.0.1:8765/health
curl http://127.0.0.1:8765/version
curl http://127.0.0.1:8765/skills
curl http://127.0.0.1:8765/modules
curl http://127.0.0.1:8765/state
```

Test `/resolve` from Linux, macOS, or Git Bash:

```bash
curl -X POST http://127.0.0.1:8765/resolve \
  -H "Content-Type: application/json" \
  -d '{"task":"corrigir bug em FastAPI com autenticação","agent":"codex","project_type":"fastapi-app"}'
```

Test `/resolve` from Windows CMD:

```bat
curl -X POST http://127.0.0.1:8765/resolve -H "Content-Type: application/json" -d "{\"task\":\"corrigir bug em FastAPI com autenticação\",\"agent\":\"codex\",\"project_type\":\"fastapi-app\"}"
```

### Available MVP endpoints

```txt
GET  /health
GET  /version
GET  /skills
GET  /modules
GET  /state
POST /resolve
```

### MVP limitations

- The API Server is local and read-only by default.
- The resolver is heuristic and deterministic.
- It does not use external AI, embeddings, or remote calls.
- It does not execute system commands.
- The registry reads local skills into memory.
- Skill recommendations should still be reviewed for critical tasks.

## Usage

Run one runtime cycle:

```bash
pam run
```

Check runtime health and local configuration:

```bash
pam doctor
```

Inspect runtime memory state:

```bash
pam memory
```

These commands are installed through the `pam` console script declared by the
Python package.

## API Server

`pam-core` also includes an initial HTTP API Server layer for external apps that
need to inspect the runtime and skill pack without depending directly on Codex
App, Codex CLI, or Claude Code.

Start the server from a development checkout or installed package. The default
bind address is local-only:

```powershell
.\.venv\Scripts\python.exe -m pam_core.server
```

Or through the existing CLI:

```powershell
.\.venv\Scripts\pam.exe serve
```

Both commands default to `127.0.0.1:8765`. Use `--host` and `--port` only when
you intentionally need different local settings.

Read-only MVP endpoints:

- `GET /health` - server status.
- `GET /version` - current pam-core version from the official `VERSION` file.
- `GET /skills` - real skills discovered from the configured `skills/` folder.
- `GET /modules` - modules detected from `MODULES.md` and real skill
  inventory.
- `GET /state` - read-only project summary, adapters, required files, and
  server mode.
- `POST /resolve` - deterministic skill recommendations for a task.
- `POST /select-skill` - legacy read-only alias that returns one suggested
  skill.
- `POST /optimize-prompt` - legacy structural prompt cleanup without external
  AI.
- `POST /analyze-static-security` - legacy defensive static checks for text,
  code, or a safe relative project path.

PowerShell examples:

```powershell
Invoke-RestMethod -Uri "http://127.0.0.1:8765/health"
Invoke-RestMethod -Uri "http://127.0.0.1:8765/state"

$skills = Invoke-RestMethod -Uri "http://127.0.0.1:8765/skills"
$skills.count
```

```json
{
  "status": "ok",
  "project": "pam-core",
  "version": "1.2.0"
}
```

Skill resolution example:

```powershell
$body = @{
  task = "corrigir bug em FastAPI com autenticação"
  agent = "codex"
  project_type = "fastapi-app"
} | ConvertTo-Json -Compress

Invoke-RestMethod -Method Post `
  -Uri "http://127.0.0.1:8765/resolve" `
  -ContentType "application/json" `
  -Body $body
```

`/resolve` uses transparent local heuristics only: task keywords, skill names,
module names, descriptions, derived tags, `project_type`, `agent`, and declared
dependencies when available. It does not call an LLM, embeddings, network APIs,
plugins, shell commands, or skill code, and it never returns a skill that is not
present in the local registry.

External apps can consume the server by polling `GET /state` to confirm
`server_mode: read_only`, then reading `GET /skills` and calling
`POST /resolve` with the user's task. The MVP is intentionally inspection-only:
it does not execute skills, mutate memory, run commands, install plugins,
authenticate users, expose a public network listener by default, or provide a
database-backed registry.

## 🧠 PAM PROTOCOL

PAM PROTOCOL v1 is the universal interaction contract for external AI agents
and tools that need to recognize and execute `pam-core`.

Agents should detect these trigger keywords:

- `use pam-core`
- `run pam-core`
- `pam-core`
- `pam://`

When a trigger is detected, agents should execute `pam-core` through one of the
supported paths:

```bash
pam run
```

```http
POST /run-once
```

```python
import pam_core.runtime

pam_core.runtime.run()
```

Protocol responses use this envelope:

```json
{
  "tool": "pam-core",
  "intent": "<detected_intent>",
  "action": "<executed_action>",
  "result": "<execution_result>"
}
```

Supported PAM URI commands:

- `pam://run`
- `pam://doctor`
- `pam://memory`

See `docs/PAM_PROTOCOL.md` for the full protocol definition and integration
rules.

## Architecture Summary

`pam-core` is organized around a small runtime engine and a shared skill pack:

- `pam_core/` contains the Python package, CLI, adapters, runtime loop, and
  configuration.
- `skills/` contains reusable specialist instructions for implementation,
  review, testing, security, documentation, deployment, and related work.
- `AGENTS.md`, `CLAUDE.md`, and plugin manifests provide thin adapters for
  supported agent hosts.
- Governance files such as `MODULES.md`, `SKILL_DEPENDENCIES.md`,
  `PROJECT_PROFILES.md`, and `QUALITY_GATES.md` define routing, ownership, and
  validation expectations.
- `docs/` and `scripts/` contain compatibility notes, installer flows,
  validation commands, runtime smoke tests, and release packaging workflows.

The intended model is a shared core with thin host-specific adapters. Runtime
logic and skill behavior stay portable while each agent host gets only the
metadata and installation layer it needs.

## Safety Model

`pam-core` treats repository content, logs, web pages, issues, prompts, and
external files as untrusted input. The default operating model emphasizes:

- preserving user work and avoiding destructive file operations;
- validating installer, package, and runtime targets before handoff;
- keeping security, data integrity, and permissions ahead of convenience;
- separating prompt instructions from repository-controlled documentation;
- using quality gates for testing, architecture, security, maintainability, UX,
  documentation, performance, and release readiness when relevant.

The framework is intended to support local automation without silently expanding
scope or weakening validation boundaries.

## Roadmap

- Stabilize the Python runtime API and CLI behavior.
- Expand runtime memory into a durable, documented developer-facing interface.
- Complete real-host validation across Linux, Windows, macOS, WSL, Codex CLI,
  Codex App, Claude Code, and generic agent targets.
- Harden package metadata, release automation, and PyPI publishing workflows.
- Improve adapter compatibility while keeping the shared core host-neutral.
- Grow focused skill coverage without turning the framework into a broad,
  duplicated instruction bundle.

# 📜 Legacy Documentation

## pam-core

AI Agent Runtime Engine based on skill orchestration.

`pam-core` provides a safe, installable agent runtime base with a CLI command,
persistent memory hooks, and skill orchestration foundations. It also preserves
the original reusable multi-agent skill pack for practical project work across
repositories.

### PyPI Installation

```bash
pip install pam-core
```

For local development:

```bash
pip install -e .
```

### CLI Usage

```bash
pam run
pam doctor
pam memory
```

### Package Build

```bash
python -m build
twine check dist/*
twine upload dist/*
```

The pack favors small working changes, security at trust boundaries, low context
noise, and boring maintainable code. It is intentionally project-agnostic.

### Contents

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
- `docs/AGENT_COMPATIBILITY.md` - Unix agent target and compatibility notes.
- `docs/INSTALL_CODEX.md` - Codex installation notes.
- `docs/INSTALL_CLAUDE.md` - Claude Code usage notes.
- `docs/INSTALL_GENERIC.md` - documentation-only generic agent usage.
- `docs/INSTALL_LINUX.md` - Linux shell install, validate, and uninstall notes.
- `docs/INSTALL_MACOS.md` - macOS shell install, validate, and uninstall notes.
- `docs/PACKAGING.md` - versioned distribution package workflow.
- `docs/USAGE.md` - practical install, validation, package, and runtime test guide.
- `docs/LINUX_TEST_PLAN.md` - real Linux host validation plan.
- `docs/KNOWN_LIMITATIONS.md` - current support boundaries and pending targets.
- `docs/RELEASE_READINESS.md` - 1.2.0 release readiness status.
- `docs/runtime-tests/` - manual runtime compatibility runbooks, prompts, and evidence records.
- `scripts/install-windows.ps1` - Windows installer for the personal Codex marketplace.
- `scripts/uninstall-windows.ps1` - Windows uninstaller for the local plugin copy.
- `scripts/install-unix.sh` - Linux/macOS installer for shared-core targets.
- `scripts/uninstall-unix.sh` - Linux/macOS uninstaller guarded by the install manifest.
- `scripts/validate-unix.sh` - Linux/macOS validation for shell scripts and installs.
- `scripts/detect-agent.sh` - conservative Unix agent and target detection.
- `scripts/runtime-smoke-test.sh` - installed-target file check for manual runtime tests.
- `scripts/package-release.ps1` - Windows release package builder.
- `scripts/package-release.sh` - Unix release package builder.
- `scripts/validate-package.ps1` - Windows release package validator.
- `scripts/validate-package.sh` - Unix release package validator.
- `scripts/validate.ps1` - local manifest and skill sanity checks.
- `scripts/validate-claude.ps1` - local Claude adapter sanity checks.
- `CHANGELOG.md` - release notes.

### Multi-Agent Support

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
- `docs/AGENT_COMPATIBILITY.md`
- `docs/USAGE.md`
- `docs/LINUX_TEST_PLAN.md`
- `docs/INSTALL_CODEX.md`
- `docs/INSTALL_CLAUDE.md`
- `docs/INSTALL_GENERIC.md`
- `docs/INSTALL_LINUX.md`
- `docs/INSTALL_MACOS.md`
- `docs/PACKAGING.md`
- `docs/KNOWN_LIMITATIONS.md`
- `docs/RELEASE_READINESS.md`
- `docs/runtime-tests/README.md`

### Current Runtime Status

- Codex CLI is supported only through the explicit
  `--codex-runtime-cache` adapter.
- The generic Codex CLI target `~/.codex/plugins/pam-core` is not proven as a
  runtime source.
- Claude Code and Codex App remain pending until real runtime sessions are
  recorded.
- Generic agents are manual because they require explicit context or target
  setup.
- Windows PowerShell and Git Bash on Windows have been validated.
- Git Bash on Windows does not count as Linux native validation.
- Linux native, WSL, and macOS native remain pending until real host validation
  is recorded.
- Global `runtime_pending` remains true.

### Governance

Start with these files when evolving the pack:

1. `PROJECT_STATE.md`
2. `DECISIONS.md`
3. `MODULES.md`
4. `SKILL_GUIDELINES.md`
5. `SKILL_DEPENDENCIES.md`
6. `PROJECT_PROFILES.md`
7. `VERSIONING.md`
8. `CONTRIBUTING.md`

### Install on Windows

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

### Update During Local Development

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

### Install on Linux/macOS

From this directory:

```bash
chmod +x scripts/*.sh
bash scripts/validate-unix.sh
bash scripts/install-unix.sh --agent auto
```

Install for a specific agent or manual target:

```bash
bash scripts/install-unix.sh --agent claude-code --force
bash scripts/install-unix.sh --agent codex-cli --force
bash scripts/install-unix.sh --agent codex-cli --codex-runtime-cache --force
bash scripts/install-unix.sh --agent codex-app --force
bash scripts/install-unix.sh --agent generic --target /tmp/pam-core-test --force
```

The Codex CLI runtime-supported path is the explicit
`--codex-runtime-cache` adapter. The generic Codex CLI target is still not
proven as a runtime source.

Validate and uninstall a manual target:

```bash
bash scripts/validate-unix.sh --target /tmp/pam-core-test
bash scripts/runtime-smoke-test.sh --target /tmp/pam-core-test
bash scripts/uninstall-unix.sh --target /tmp/pam-core-test --dry-run
bash scripts/uninstall-unix.sh --target /tmp/pam-core-test
```

See `docs/INSTALL_LINUX.md`, `docs/INSTALL_MACOS.md`, and
`docs/AGENT_COMPATIBILITY.md` for target defaults and known limitations.

### Package a Release

Windows:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\package-release.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\validate-package.ps1
```

Linux/macOS:

```bash
bash scripts/package-release.sh
bash scripts/validate-package.sh
```

Packages are written to `dist/` as `pam-core-VERSION.zip` and
`pam-core-VERSION.tar.gz`, with SHA256 hashes in `dist/CHECKSUMS.txt`. See
`docs/PACKAGING.md` for the allowlist, exclusions, and install-from-extracted
package flow.

### Validate

```powershell
.\scripts\validate.ps1
codex.cmd --version
```

The Codex CLI version recorded in the latest runtime evidence is `0.142.5`.

Claude adapter validation is included at the end of `.\scripts\validate.ps1` and
can also be run directly without Claude Code installed:

```powershell
.\scripts\validate-claude.ps1
```

Validation checks that:

- `.codex-plugin/plugin.json` is valid JSON and UTF-8 without BOM.
- `AGENTS.md` and `README.md` exist.
- Each skill directory has `SKILL.md`.
- Each `SKILL.md` starts with frontmatter containing `name` and `description`.
- No source file is empty.
- Any local `marketplace.json` is UTF-8 without BOM.
- The Claude adapter files exist, use valid JSON, point to the shared `skills/`
  core, and do not duplicate skills under `.claude/skills`.
- Runtime compatibility documents exist. Runtime behavior still requires the
  manual prompts in `docs/runtime-tests/SMOKE_TEST_PROMPTS.md` and evidence in
  `docs/runtime-tests/RUNTIME_RESULTS.md`.

### Uninstall on Windows

The uninstaller removes the local plugin source and removes the `pam-core` entry
from the personal marketplace file. It does not run Codex commands.

```powershell
.\scripts\uninstall-windows.ps1 -Force
```

Then start a new Codex thread so loaded plugin state is refreshed.

### Manual Install

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
