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
| Claude Code | Windows 11 host; Git Bash available but not native Linux | not found | 2026-07-01 | not installed for runtime; discovery only | Plausible directory found: `C:\Users\joaov\.claude\plugins`; default documented target remains `~/.claude/plugins/pam-core` | not run | not run | `where.exe claude`, `where.exe claude.cmd`, `Get-Command claude`, `Get-Command claude.cmd`, Git Bash `command -v claude`, and Git Bash `command -v claude.cmd` found no runtime command. `~/.claude` and `~/.claude/plugins` exist; `~/.claude/skills`, `~/.config/claude`, `%APPDATA%\Claude`, `%LOCALAPPDATA%\Claude`, and `~/Library/Application Support/Claude` were not found. | pending | Runtime command was not available, so no real Claude Code session or AI runtime prompt could be executed. |
| Codex CLI | Windows 11 / Git Bash `MINGW64_NT-10.0-26200` | `codex-cli 0.142.5` | 2026-07-01 | `bash scripts/install-unix.sh --agent codex-cli --codex-runtime-cache --force` through Git Bash | `/c/Users/joaov/.codex/plugins/cache/personal/pam-core/1.2.0` | passed | all shared prompts, focused retests, Phase 18.1 probes, and Phase 18.2 cache-adapter sentinel test | Codex CLI recognized `pam-core` from the explicitly installed personal plugin cache, read the Phase 18.2 sentinel from that cache path, and passed the main runtime prompts with one focused FastAPI routing retest. | supported | Supported for the explicit Codex CLI runtime cache adapter only. Global runtime remains pending for Claude Code and Codex App. |
| Codex App | Windows 11 host; Git Bash available but not native Linux | no app runtime observed | 2026-07-01 | discovery only | No Codex App target found. Existing Codex paths were CLI/cache paths: `C:\Users\joaov\.codex`, `C:\Users\joaov\.codex\plugins`, and `C:\Users\joaov\.codex\plugins\cache`. `%APPDATA%\Codex`, `%LOCALAPPDATA%\Codex`, `~/.config/codex`, and `~/.local/share/codex` were not found. | not run | not run | Running processes showed Codex CLI / command runner processes only, not a separate Codex App session. No real app session was observable. | pending | Do not mark supported until a real Codex App session reads the installed pack and passes the smoke prompts. |
| Generic agent | manual | unknown | pending | `bash scripts/install-unix.sh --agent generic --target PATH --force` | manual | manual | pending | No generic-agent runtime session recorded yet. | manual | Generic support depends on explicitly pointing the agent at the installed shared core. |

## Evidence Rules

- A file smoke test alone is not runtime evidence.
- A transcript without install target and agent version is incomplete evidence.
- A status of `supported` requires all required prompts to pass or a written
  reason why a prompt is not applicable.
- A status of `partial` requires clear notes describing which runtime behavior
  worked and which behavior still requires manual setup.
- A status of `failed` requires enough detail to reproduce the failure.

## Evidence Details

### Codex CLI - 2026-07-01

#### Test Metadata

- Agent tested: Codex CLI
- Agent version: `codex-cli 0.142.5`
- Operating system: Windows 11 host with Git Bash reporting
  `MINGW64_NT-10.0-26200`
- Test date: 2026-07-01
- Tester: Codex in this repository session

#### Install and Validation

- Install command used:
  `bash scripts/install-unix.sh --agent codex-cli --force`
- Validation command used:
  `bash scripts/validate-unix.sh --target /c/Users/joaov/.codex/plugins/pam-core`
- Target used: `/c/Users/joaov/.codex/plugins/pam-core`
- Package used: source checkout install, not a release archive
- File smoke command used:
  `bash scripts/runtime-smoke-test.sh --target /c/Users/joaov/.codex/plugins/pam-core`
- File smoke result: passed

#### Runtime Session

- Reload or restart step used: fresh non-interactive `codex exec --ephemeral`
  sessions
- Workspace or project opened:
  `C:\Users\joaov\CodexWorkspace\pam-core\.runtime-codex-cli`
- Prompt source: `docs/runtime-tests/SMOKE_TEST_PROMPTS.md`
- Runtime command shape:
  `codex.cmd -a never exec --ephemeral --sandbox read-only -C .runtime-codex-cli`

#### Prompts Sent

```text
Do you recognize pam-core in this session? Name the pam-core entrypoint files
you can actually use. If you cannot inspect them, say so.

Read pam-core AGENTS.md and summarize the default routing order in five bullets
or fewer. Do not load every skill.

Using pam-core MODULES.md, identify the module that owns frontend UI decisions
and the module that owns verification. Answer only with module names and one
short reason each.

Using pam-core SKILL_DEPENDENCIES.md, choose the minimum skills for a
documentation-only update that also edits a validation shell script. Do not add
new skills.

Does pam-core contain a result-verification skill today? Answer from the project
state only. If it is only roadmap work, say that.

A user asks for a small FastAPI request validation fix. Which pam-core module
and lead skills apply first? Keep the answer minimal.

For a task that only adds runtime compatibility documentation, should pam-core
create new skills or refactor the skill architecture? Answer yes or no and cite
the controlling project rule.
```

Focused retest prompt:

```text
Do not edit files. Using pam-core SKILL_DEPENDENCIES.md, choose the minimum
skills for a documentation-only update that also edits a validation shell
script. Do not add new skills. Answer with the skills and one short reason per
skill.
```

#### Observed Response

Codex CLI reported that it recognized `pam-core` as installed plugin
`pam-core` version `1.2.0`. It inspected these files from the Codex plugin
cache:

- `.codex-plugin/plugin.json`
- `AGENTS.md`
- `MODULES.md`
- `SKILL_DEPENDENCIES.md`
- `PROJECT_PROFILES.md`
- `QUALITY_GATES.md`
- `SKILL_GUIDELINES.md`

It summarized `AGENTS.md` routing as project understanding first, Prompt
Intelligence when needed, `skill-orchestrator`, minimal specialists, and
`testing`/quality gates/`code-review` before finishing. It selected Frontend
for UI decisions and Testing for verification. It said there is no physical
`result-verification` skill and that the item is roadmap/future work. It chose
Backend with `fastapi` and `fastapi-validation` for a small FastAPI validation
fix. It answered that runtime documentation alone should not create new skills
or refactor architecture.

The first grouped response to the `SKILL_DEPENDENCIES.md` prompt selected a
small set but omitted `skill-orchestrator`. A focused retest inspected
`SKILL_DEPENDENCIES.md` and selected `project-understanding`,
`skill-orchestrator`, `task-sequencing`, `automation-scripts`,
`safe-command-execution`, `documentation-review`, `testing`, and `code-review`.

#### Criteria Passed

- Recognized main `pam-core` files: passed.
- Answered based on `AGENTS.md`: passed.
- Used `MODULES.md` to choose a module: passed.
- Consulted or cited `SKILL_DEPENDENCIES.md` when relevant: passed after
  focused retest.
- Did not create a new skill impulsively: passed.
- Respected minimal scope: passed.
- Did not hallucinate `result-verification` support: passed.
- Passed `SMOKE_TEST_PROMPTS.md` prompts: mostly passed; dependency selection
  needed one focused retest.

#### Criteria Failed

- Failed criteria: Unix target loading was not proven as the Codex CLI runtime
  source. The observed runtime session used
  `C:\Users\joaov\.codex\plugins\cache\personal\pam-core\1.2.0`.
- Reproduction notes: run a fresh Codex CLI session after installing from
  `/c/Users/joaov/.codex/plugins/pam-core` and confirm the active plugin source
  if Codex CLI exposes that metadata.

#### Conclusion

- Conclusion: Codex CLI can use `pam-core` behavior in a real runtime session
  through the installed Codex personal plugin cache. The Unix target was
  installed and file-validated, but the runtime did not prove that this target
  is the source loaded by Codex CLI.
- Recommended final status: `partial`
- Follow-up needed: confirm Codex CLI loading from the Unix target or document
  the Windows personal plugin cache as the supported Codex CLI runtime path.

### Codex CLI Source-of-Truth - 2026-07-01

#### Test Metadata

- Agent tested: Codex CLI
- Agent version: `codex-cli 0.142.5`
- Operating system: Windows host with Git Bash reporting
  `MINGW64_NT-10.0-26200`
- Test date: 2026-07-01
- Installed target:
  `C:\Users\joaov\.codex\plugins\pam-core`
  (`/c/Users/joaov/.codex/plugins/pam-core`)
- Observed cache:
  `C:\Users\joaov\.codex\plugins\cache\personal\pam-core\1.2.0`

#### Sentinel Test

Created target-only file:

```text
C:\Users\joaov\.codex\plugins\pam-core\RUNTIME_SENTINEL.md
```

Sentinel content:

```text
CODEX_RUNTIME_SENTINEL_PHASE_18_1_TARGET_ONLY
```

Before running Codex CLI, the sentinel existed in the target and did not exist
in the cache:

- Target sentinel: present.
- Cache sentinel: absent.

Prompt executed:

```text
Procure no pam-core por um arquivo chamado RUNTIME_SENTINEL.md e informe o
conteúdo exato dele. Também diga o caminho de onde ele foi lido. Se você não
conseguir encontrar ou ler esse arquivo, diga isso explicitamente e liste quais
caminhos do pam-core você conseguiu inspecionar.
```

Observed result: Codex CLI did not find `RUNTIME_SENTINEL.md`. In that first
sentinel run, the session only inspected the empty runtime workspace
`.runtime-codex-source-test`, not the target or cache. After the run, the
sentinel still had not appeared in the cache.

#### Cache Propagation Test

- Target sentinel before Codex run: present.
- Cache sentinel before Codex run: absent.
- Cache sentinel after Codex run: absent.

Conclusion: no immediate or post-run target-to-cache propagation was observed.

#### Cache Rename Test

The cache directory was renamed before running Codex CLI:

```text
C:\Users\joaov\.codex\plugins\cache\personal\pam-core\1.2.0
-> C:\Users\joaov\.codex\plugins\cache\personal\pam-core\1.2.0.backup-phase-18-1
```

The target remained present and still contained the sentinel. Codex CLI was then
run with a prompt asking whether it recognized `pam-core` and where it read the
entrypoint files from.

Observed result: Codex CLI still recognized `pam-core`, but read it from the
renamed cache directory:

```text
C:\Users\joaov\.codex\plugins\cache\personal\pam-core\1.2.0.backup-phase-18-1
```

It did not find `RUNTIME_SENTINEL.md`. After the run:

- Original cache path `1.2.0`: not recreated.
- Backup cache path `1.2.0.backup-phase-18-1`: present.
- Sentinel in backup cache: absent.

Conclusion: Codex CLI did not recreate the cache from the target. It could still
use the renamed cache directory.

#### Target Rename Test

The cache was restored to the original `1.2.0` path. The installed target was
then renamed before running Codex CLI:

```text
C:\Users\joaov\.codex\plugins\pam-core
-> C:\Users\joaov\.codex\plugins\pam-core.backup-phase-18-1
```

Observed result: Codex CLI recognized `pam-core` and read usable entrypoints
from:

```text
C:\Users\joaov\.codex\plugins\cache\personal\pam-core\1.2.0
```

The Codex CLI session also checked
`C:\Users\joaov\.codex\plugins\pam-core` and observed that it did not exist.
It concluded, based on inspected paths, that the target was not required for the
runtime behavior observed in that session.

#### Cleanup

- Restored target:
  `C:\Users\joaov\.codex\plugins\pam-core`
- Restored cache:
  `C:\Users\joaov\.codex\plugins\cache\personal\pam-core\1.2.0`
- Removed target sentinel:
  `C:\Users\joaov\.codex\plugins\pam-core\RUNTIME_SENTINEL.md`
- Verified no remaining Phase 18.1 backup directories:
  `pam-core.backup-phase-18-1` and `1.2.0.backup-phase-18-1` were absent.
- Verified no sentinel remained in target or cache.
- Removed local temporary runtime workspace and response capture files from the
  repository checkout.

#### Conclusion

- Codex CLI runtime source observed: Codex personal plugin cache.
- Target source observed: not observed.
- Cache recreation from target: not observed.
- Cache-only runtime behavior: observed.
- Target-only sentinel read by Codex CLI: not observed.
- Recommended final status: `partial`.

Codex CLI must not be marked `supported` for the Unix target path based on this
evidence. The observed runtime depends on Codex's personal plugin cache, and no
relationship from the Phase 15 Unix target to that cache was proven.

### Codex CLI Runtime Cache Adapter - 2026-07-01

#### Test Metadata

- Agent tested: Codex CLI
- Agent version: `codex-cli 0.142.5`
- Operating system: Windows host with Git Bash reporting
  `MINGW64_NT-10.0-26200`
- Test date: 2026-07-01
- Explicit install target:
  `C:\Users\joaov\.codex\plugins\cache\personal\pam-core\1.2.0`
- Backup created by install:
  `C:\Users\joaov\.codex\plugins\cache\personal\pam-core-backups\1.2.0.backup.20260701224602`

#### Install and Validation

Install command:

```bash
bash scripts/install-unix.sh --agent codex-cli --codex-runtime-cache --force
```

Resolved target:

```text
/c/Users/joaov/.codex/plugins/cache/personal/pam-core/1.2.0
```

The installer printed `Runtime cache target: true` and wrote
`.install-manifest.json` with:

```json
"runtime_cache_target": true
```

File smoke command:

```bash
bash scripts/runtime-smoke-test.sh --target /c/Users/joaov/.codex/plugins/cache/personal/pam-core/1.2.0
```

File smoke result: passed and reported `Runtime cache target: true`.

#### Sentinel Test

Created cache-only sentinel:

```text
C:\Users\joaov\.codex\plugins\cache\personal\pam-core\1.2.0\RUNTIME_SENTINEL.md
```

Sentinel content:

```text
CODEX_RUNTIME_SENTINEL_PHASE_18_2_CACHE_TARGET
```

Prompt executed:

```text
Procure no pam-core por RUNTIME_SENTINEL.md e informe o conteúdo exato. Também
diga o caminho de onde ele foi lido.
```

Observed result: Codex CLI read:

```text
C:\Users\joaov\.codex\plugins\cache\personal\pam-core\1.2.0\RUNTIME_SENTINEL.md
```

with exact content:

```text
CODEX_RUNTIME_SENTINEL_PHASE_18_2_CACHE_TARGET
```

#### Main Prompt Result

In the same runtime test, Codex CLI recognized `pam-core`, identified usable
entrypoints including `AGENTS.md`, `MODULES.md`, `SKILL_DEPENDENCIES.md`,
`PROJECT_PROFILES.md`, `QUALITY_GATES.md`, `SKILL_GUIDELINES.md`,
`PROJECT_STATE.md`, and `DECISIONS.md`, summarized the `AGENTS.md` routing
order, selected Frontend and Testing from `MODULES.md`, used
`SKILL_DEPENDENCIES.md` for a documentation plus shell-validation task, did not
invent `result-verification`, and answered that runtime compatibility docs
should not create new skills or refactor architecture.

The first FastAPI validation answer was too minimal. A focused retest read the
active cache path and selected `project-understanding`, `skill-orchestrator`,
`ponytail`, `security`, `fastapi-validation`, optional `fastapi`/`api-design`,
then `testing` and `code-review`.

#### Cleanup

- Removed
  `C:\Users\joaov\.codex\plugins\cache\personal\pam-core\1.2.0\RUNTIME_SENTINEL.md`
  after the runtime test.
- Preserved the previous cache backup outside the active `pam-core` directory:
  `C:\Users\joaov\.codex\plugins\cache\personal\pam-core-backups\1.2.0.backup.20260701224602`.
- Moved backups out of `personal/pam-core/` because Codex CLI inspected an
  adjacent `1.2.0.backup...` directory during a focused retest.

#### Conclusion

- Explicit cache adapter installed: yes.
- Runtime cache target validated: yes.
- Sentinel found by Codex CLI: yes.
- Main runtime prompts passed: yes, with one focused FastAPI routing retest.
- Recommended final status: `supported` for the explicit Codex CLI runtime cache
  adapter.

This does not prove the generic Unix target
`~/.codex/plugins/pam-core` as a runtime source. It supports the explicit cache
adapter path only, and global runtime remains pending until Claude Code and
Codex App have sufficient evidence.

### Phase 19 Native OS and Remaining Agent Discovery - 2026-07-01

#### Environment Classification

- Host shell: Windows PowerShell.
- Git Bash: available at `C:\Program Files\Git\bin\bash.exe`.
- Git Bash `uname -a`: `MINGW64_NT-10.0-26200 ... x86_64 Msys`.
- Git Bash classification: Git Bash on Windows, not Linux native.
- WSL: `wsl.exe -l -v` reported that Windows Subsystem for Linux is not
  installed.
- Linux native: not available in this environment.
- macOS native: not available; `sw_vers` was not found.
- `/etc/os-release`: not present in Git Bash.

#### Codex CLI Protection Check

- `scripts/install-unix.sh` still documents and handles
  `--codex-runtime-cache`.
- `scripts/uninstall-unix.sh` still documents and handles
  `--codex-runtime-cache`.
- `scripts/validate-unix.sh` requires both Unix scripts to document
  `--codex-runtime-cache`.
- Codex CLI remains `supported` only for the explicit runtime cache adapter.
- The generic Unix target `~/.codex/plugins/pam-core` remains unproven as a
  runtime source.

#### Claude Code Discovery

- PowerShell `where.exe claude`: not found.
- PowerShell `where.exe claude.cmd`: not found.
- PowerShell `Get-Command claude`: not found.
- PowerShell `Get-Command claude.cmd`: not found.
- Git Bash `command -v claude`: not found.
- Git Bash `command -v claude.cmd`: not found.
- Git Bash `claude --version`: not available.
- Git Bash `claude.cmd --version`: not available.
- Directories found: `C:\Users\joaov\.claude`,
  `C:\Users\joaov\.claude\plugins`.
- Directory contents checked at `~/.claude/plugins`: `blocklist.json` only.
- Directories not found: `C:\Users\joaov\.claude\skills`,
  `C:\Users\joaov\.config\claude`, `%APPDATA%\Claude`,
  `%LOCALAPPDATA%\Claude`, `~/Library/Application Support/Claude`.
- Plausible target: `~/.claude/plugins/pam-core`, but no runtime command was
  available to test.
- Initial status: `pending`.

#### Codex App Discovery

- Codex CLI command found: `codex.cmd`, version `codex-cli 0.142.5`.
- Codex directories found: `C:\Users\joaov\.codex`,
  `C:\Users\joaov\.codex\plugins`,
  `C:\Users\joaov\.codex\plugins\cache`.
- Codex cache personal entries found: `pam-core` and `pam-core-backups`.
- Codex App directories not found: `%APPDATA%\Codex`,
  `%LOCALAPPDATA%\Codex`, `C:\Users\joaov\.config\codex`,
  `C:\Users\joaov\.local\share\codex`.
- Running processes showed Codex CLI and Codex command runner processes, but no
  separate Codex App session.
- Initial status: `pending`.

#### Native OS Validation

- WSL/Linux/macOS native validation was not run because no WSL, Linux native,
  or macOS native environment was available.
- Git Bash validation is separate from native validation. It can execute the
  Bash scripts, but it is not evidence of Linux native support.
- Git Bash validation command run after adding `/usr/bin` and `/bin` to PATH:
  `bash scripts/validate-unix.sh`.
- Git Bash validation result: passed.
