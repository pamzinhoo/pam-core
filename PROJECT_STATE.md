# Project State

Long-term state for `pam-core`.

## Current Version
- Manifest version: `1.2.0`
- Governance state: Phase 20 completed
- Last updated: 2026-07-01
- Release status: Versioned distribution packaging is implemented in checkout;
  Bash packaging validation passed under Git Bash. Phase 20 consolidated usage,
  release readiness, known limitations, and the Linux test plan. Codex CLI is
  supported through the explicit runtime cache adapter, and global runtime
  status remains pending for Claude Code, Codex App, and native OS validation
  not available in this environment.

## Current Phase
Phase 20 completed: Release Readiness, Usage Guide, and Final Git Sync.

Phase 20 added release-facing documentation without changing skills or module
architecture:

- `docs/USAGE.md`
- `docs/LINUX_TEST_PLAN.md`
- `docs/KNOWN_LIMITATIONS.md`
- `docs/RELEASE_READINESS.md`

These docs consolidate install, validation, package, uninstall, Linux test, and
runtime evidence rules for the current 1.2.0 release candidate. They explicitly
keep Codex CLI `supported` only through `--codex-runtime-cache`; Claude Code,
Codex App, WSL, Linux native, and macOS native remain `pending`; generic agents
remain `manual`; and global `runtime_pending` remains true.

Phase 19 completed: Native OS and Remaining Agent Verification.

On 2026-07-01, Phase 19 rechecked the Phase 18.2 Codex CLI runtime cache
adapter and confirmed that `scripts/install-unix.sh`,
`scripts/uninstall-unix.sh`, and `scripts/validate-unix.sh` still protect the
explicit `--codex-runtime-cache` mode. Codex CLI remains `supported` only for
the explicit runtime cache adapter. The generic Unix target
`~/.codex/plugins/pam-core` remains unproven as a runtime source.

Claude Code discovery found `C:\Users\joaov\.claude` and
`C:\Users\joaov\.claude\plugins`, but no `claude` or `claude.cmd` command in
PowerShell or Git Bash. No real Claude Code runtime session could be run, so
Claude Code remains `pending`.

Codex App discovery found existing Codex CLI/cache directories under
`C:\Users\joaov\.codex`, but no `%APPDATA%\Codex`, `%LOCALAPPDATA%\Codex`,
Linux-style app config directory, or observable Codex App session. Codex App
remains `pending`.

The available Unix-like shell was Git Bash on Windows, reporting
`MINGW64_NT-10.0-26200`. WSL was not installed, `sw_vers` was unavailable, and
no Linux native or macOS native environment was present. Native Linux, WSL, and
macOS validation remain `pending` with environment limitation recorded in
`docs/runtime-tests/RUNTIME_RESULTS.md`. Git Bash validation is recorded
separately and must not be treated as Linux native evidence.

Global `runtime_pending` remains true because Claude Code, Codex App, and
native OS validation are still pending.

Phase 18.2 completed: Codex CLI Install Adapter.

Phase 18.2 added an explicit `--codex-runtime-cache` mode to the Unix installer
and uninstaller. This mode installs only when requested, only for Codex CLI, and
resolves to the observed runtime cache target:

`C:\Users\joaov\.codex\plugins\cache\personal\pam-core\1.2.0`

The installer writes `.install-manifest.json` with
`"runtime_cache_target": true`, and `runtime-smoke-test.sh` reports that marker.
Runtime cache backups are placed outside the active `personal/pam-core/`
directory under `personal/pam-core-backups/` because Codex CLI inspected an
adjacent backup directory during testing.

On 2026-07-01, Codex CLI `0.142.5` read the Phase 18.2 sentinel from the
explicit cache target:

`C:\Users\joaov\.codex\plugins\cache\personal\pam-core\1.2.0\RUNTIME_SENTINEL.md`

with content `CODEX_RUNTIME_SENTINEL_PHASE_18_2_CACHE_TARGET`. The main runtime
prompts passed, with one focused FastAPI routing retest. Codex CLI is now
`supported` for the explicit runtime cache adapter only. The generic Unix
target `~/.codex/plugins/pam-core` is still not proven as a runtime source.

The sentinel was removed after testing. The previous cache backup was preserved
at:

`C:\Users\joaov\.codex\plugins\cache\personal\pam-core-backups\1.2.0.backup.20260701224602`

Global `runtime_pending` remains true because Claude Code and Codex App are
still pending.

Phase 18.1 completed: Codex CLI Source-of-Truth Verification.

On 2026-07-01, Codex CLI source-of-truth probes showed that the observed runtime
loads `pam-core` from the Codex personal plugin cache
`C:\Users\joaov\.codex\plugins\cache\personal\pam-core\1.2.0`, not from the
Phase 15 Unix target `C:\Users\joaov\.codex\plugins\pam-core`.

A target-only `RUNTIME_SENTINEL.md` was not found by Codex CLI, did not appear
in the cache before or after a runtime session, and the cache was not recreated
from the target when renamed. With the target renamed away and cache restored,
Codex CLI still recognized `pam-core` and read entrypoints from the cache. The
target and cache were restored, the sentinel was removed, and no Phase 18.1
backup directories were left behind.

Codex CLI remains `partial`: real runtime behavior is confirmed through the
personal plugin cache, but the Unix target path is not proven as a runtime
source.

Phase 18 started: Real Agent Runtime Verification.

On 2026-07-01, Codex CLI `0.142.5` was tested in a fresh non-interactive
runtime session on Windows with Git Bash available. The Unix-style Codex CLI
target `/c/Users/joaov/.codex/plugins/pam-core` was installed, validated, and
passed the file smoke test. The real runtime session recognized `pam-core`,
used `AGENTS.md`, `MODULES.md`, and `SKILL_DEPENDENCIES.md`, avoided creating
new skills, and did not hallucinate the planned `result-verification` skill.

The Codex CLI result is recorded as `partial` because the observed runtime
loaded `pam-core` from the Codex personal plugin cache
`C:\Users\joaov\.codex\plugins\cache\personal\pam-core\1.2.0`, not from the
newly installed Unix target. Claude Code was not available on PATH in this
environment, and no Codex App runtime session was observed.

Phase 17.1 validated: Native Package Validation.

Phase 17 added versioned zip and tar.gz package generation in `dist/`, package
manifests, SHA256 checksums, package validation scripts, and packaging
documentation. Packaging is separate from runtime installation; the Phase 15
install scripts remain responsible for installing an extracted package into a
target agent location.

Phase 17.1 validated the Bash packaging path under Git Bash on 2026-07-01:
`validate-unix.sh`, `package-release.sh`, `validate-package.sh`, and
`git diff --check` passed. The generated Bash packages matched the PowerShell
package path on allowlist, manifest fields, required files, exclusions,
checksums, and `runtime_pending: true`. WSL was not installed in this
environment, and no separate native Linux or macOS host run was recorded.

The shared core remains `skills/`, `MODULES.md`, `SKILL_DEPENDENCIES.md`,
`PROJECT_PROFILES.md`, `QUALITY_GATES.md`, `SKILL_GUIDELINES.md`, and
`PROJECT_STATE.md`. The physical skill inventory remains 93 skills.

This phase did not create or remove skills and did not change existing skill
behavior.

## Completed Functionality
- Personal Codex plugin manifest in `.codex-plugin/plugin.json`.
- Windows install, uninstall, and validation scripts.
- Core `AGENTS.md` routing behavior.
- Standard skill format in `SKILL_GUIDELINES.md`.
- Skill cooperation map in `SKILL_DEPENDENCIES.md`.
- Project profile routing in `PROJECT_PROFILES.md`.
- Modular architecture in `MODULES.md`.
- Explicit quality gates in `QUALITY_GATES.md`.
- Core and Security expansion from earlier phases.
- Prompt Intelligence foundation for version 1.2.
- Execution Control foundation for version 1.2.
- Project governance documents from Phase 7.
- Phase 8 normalization for remaining short skills.
- Phase 9 stronger routing and cooperation documentation.
- Phase 10 Backend, Frontend, Database, Security, Quality, and supporting skill
  expansion.
- Phase 11 audit cleanup for release preparation.
- Claude adapter structural validation through `scripts/validate-claude.ps1`,
  called by `scripts/validate.ps1`.
- Phase 14 consistency validation across checkout, local package, and Codex
  cache with 93 physical skills and 117 compared files after install
  exclusions.
- Automatic audit report generation in `docs/audit-report.md`.
- Phase 15 Unix install layer: `scripts/install-unix.sh`,
  `scripts/uninstall-unix.sh`, `scripts/validate-unix.sh`, and
  `scripts/detect-agent.sh`.
- Linux/macOS installation documentation in `docs/INSTALL_LINUX.md`,
  `docs/INSTALL_MACOS.md`, and `docs/AGENT_COMPATIBILITY.md`.
- Phase 16 runtime test documentation in `docs/runtime-tests/`.
- Runtime compatibility matrix in `docs/AGENT_COMPATIBILITY.md` that separates
  installation, automatic detection, file validation, and runtime confirmation.
- Installed-target file smoke checker in `scripts/runtime-smoke-test.sh`.
- Phase 16.1 runtime evidence tracking in
  `docs/runtime-tests/RUNTIME_RESULTS.md` and
  `docs/runtime-tests/EVIDENCE_TEMPLATE.md`.
- Phase 17 versioned distribution packaging through
  `scripts/package-release.ps1`, `scripts/package-release.sh`,
  `scripts/validate-package.ps1`, `scripts/validate-package.sh`, and
  `docs/PACKAGING.md`.
- Phase 17.1 Bash package validation under Git Bash, including Unix validation,
  package generation, package validation, checksum verification, and
  PowerShell/Bash content equivalence for required package criteria.
- Phase 18 started real runtime verification and recorded partial Codex CLI
  evidence in `docs/runtime-tests/RUNTIME_RESULTS.md`.
- Phase 18.1 verified the Codex CLI runtime source of truth: the observed
  source is the personal plugin cache, not the Phase 15 Unix target.
- Phase 18.2 added and validated an explicit Codex CLI runtime cache adapter,
  promoting Codex CLI to supported for that adapter only.
- Phase 19 verified remaining runtime status honestly: Claude Code command not
  available, Codex App session not observable, WSL/Linux/macOS native
  validation not available, and Git Bash kept separate from Linux native.
- Phase 20 added usage, Linux test plan, known limitations, and release
  readiness docs for the 1.2.0 release candidate without changing skills or
  architecture.

## Existing Modules
- Core
- Backend
- Frontend
- Database
- Desktop
- Business
- Prompt Intelligence
- AI
- Security
- Testing
- Quality
- DevOps
- Documentation

## Skills By Module

### Core
- `project-understanding`
- `skill-orchestrator`
- `task-planning`
- `scope-control`
- `change-impact-analysis`
- `root-cause-analysis`
- `context-management`
- `ponytail`
- `architecture`
- `refactoring`
- `headroom`
- `debugging`
- `performance`
- `execution-monitor`
- `patch-strategy`
- `task-sequencing`

### Backend
- `fastapi`
- `api-design`
- `python`
- `async-python`
- `python-packaging`
- `python-performance`
- `python-logging`
- `python-error-handling`
- `fastapi-authentication`
- `fastapi-dependencies`
- `fastapi-background-tasks`
- `fastapi-websockets`
- `fastapi-validation`

### Frontend
- `ui-designer`
- `anti-ai-ui`
- `html-css`
- `javascript`
- `ux`
- `accessibility`
- `responsive-design`
- `form-design`
- `table-design`
- `dashboard-design`
- `design-system`
- `css-architecture`
- `frontend-state-management`
- `frontend-api-integration`
- `loading-empty-error-states`
- `frontend-performance`
- `internal-business-ui`
- `mobile-first-ui`
- `navigation-layout`
- `visual-hierarchy`
- `copywriting-ui`

### Database
- `database-design`
- `sqlite`
- `sqlalchemy`
- `alembic`
- `database-migrations`
- `query-optimization`
- `transactions`

### Desktop
- `desktop-local`
- `windows-desktop`
- `packaging`
- `automation-scripts`
- `python`
- `sqlite`

### Business
- `business-rules`
- `financial-system`
- `saas`

### Prompt Intelligence
- `prompt-understanding`
- `prompt-normalization`
- `prompt-gap-analysis`
- `task-extraction`
- `success-criteria`

### AI
- `llm-best-practices`
- `prompt-injection-defense`
- `headroom`
- `skill-orchestrator`

### Security
- `security`
- `authentication`
- `prompt-injection-defense`
- `secrets-management`
- `dependency-audit`
- `safe-command-execution`
- `permissions-authorization`
- `data-privacy`

### Testing
- `testing`
- `code-review`
- `debugging`

### Quality
- `architecture-review`
- `maintainability-review`
- `performance-review`
- `security-review`
- `ux-review`
- `accessibility-review`
- `documentation-review`
- `regression-review`
- `dependency-review`
- `release-readiness`

### DevOps
- `git`
- `deployment`
- `packaging`
- `performance`

### Documentation
- `document-system`
- `automation-scripts`

## Phase History
- Phase 7: Added durable project state, decisions, versioning, contribution
  rules, and governance memory.
- Phase 8: Normalized existing skills toward the standard structure.
- Phase 9: Strengthened routing, dependencies, project profiles, and quality
  gate documentation.
- Phase 10: Expanded specialist coverage across backend, frontend, database,
  security, quality, and supporting implementation concerns.
- Phase 11: Audited the full pack, completed remaining skill normalization,
  fixed missing-skill references, strengthened validation, updated release
  docs, and cleaned invalid source-tree metadata.
- Phase 12: Added Prompt Intelligence foundation skills, Execution Control
  skills, and routing documentation for version 1.2.
- Phase 13: Added the initial multi-agent compatibility base with a Claude Code
  adapter, documentation, and Claude-specific structural validation while
  keeping the existing Codex adapter intact.
- Phase 14: Normalized skill references into Existing, Planned, and Concepts /
  technologies; hardened validation; generated an audit report; and confirmed
  checkout, local package, and Codex cache consistency after installation.
- Phase 15: Added Linux/macOS installation support for Claude Code, Codex CLI,
  Codex App, and generic compatible agents through shell scripts, target
  detection, install manifests, validation, and uninstall safeguards.
- Phase 16: Added manual runtime compatibility test runbooks, shared smoke-test
  prompts, a runtime compatibility matrix, and a file-presence smoke checker for
  installed targets.
- Phase 16.1: Added formal runtime evidence records and templates, and required
  evidence before marking agent runtime support as `supported`.
- Phase 17: Added versioned zip and tar.gz release packages, package manifests,
  checksums, validation scripts, and packaging documentation.
- Phase 17.1: Validated the Bash packaging path under Git Bash and confirmed
  generated packages keep runtime support pending. WSL was not installed, and
  no separate native Linux or macOS host run was recorded.
- Phase 19: Rechecked Codex CLI cache-adapter support, discovered Claude Code
  and Codex App availability in the current Windows environment, recorded
  native OS validation as pending because WSL/Linux/macOS were unavailable, and
  kept global `runtime_pending` true.
- Phase 20: Consolidated release readiness, usage, known limitations, and the
  Linux native test plan. Release remains evidence-scoped with
  `runtime_pending` true.

## Roadmap
- Keep `SKILL_DEPENDENCIES.md`, `PROJECT_PROFILES.md`, and `MODULES.md`
  synchronized with physical skills.
- Evaluate a future Meta Orchestrator layer above `project-understanding` and
  `skill-orchestrator` before choosing technology, stack, module, or skill.
- Add missing roadmap skills only after explicit approval.
- Expand Prompt Intelligence only in future approved phases; do not add
  `prompt-enhancement`, `intent-classifier`, or `ambiguity-resolution` as part
  of Phase 12.
- Create a future `result-verification` or `post-action-verification` skill to
  enforce post-action verification after file edits, commands, installations,
  migrations, and configuration changes.
- Consider module and priority frontmatter in a future major version if the
  plugin format needs it.
- Prepare a 2.0 architecture release only when routing and module metadata
  require an incompatible change.
- Expand multi-agent adapters only through thin manifests, entrypoints, and
  install docs unless a future phase explicitly approves generated exports.

## Important Architectural Decisions
- Skills are grouped by module, not by project type.
- A future Meta Orchestrator is planned as a pre-routing decision layer; it is
  not implemented as a skill yet.
- Prompt Intelligence runs before `skill-orchestrator` only when prompts are
  vague, short, ambiguous, subjective, mixed, or high-risk.
- Execution Control runs before broad, mixed, long-running, patch-heavy, or
  validation-heavy work.
- Tool or command silence past 23 minutes requires stopping, summarizing
  progress, and asking for confirmation.
- Mixed prompts must be split before execution. Functional bug fixes, security
  changes, and CSS/UI polish must not be edited in the same round.
- Large multi-file patches on HTML with encoding or mojibake are forbidden;
  patch one file at a time and reduce failed contexts to ASCII anchors.
- Post-action verification is mandatory future behavior: after any file change,
  command, installation, migration, or configuration change, the agent must
  verify the real result before claiming completion.
- `project-understanding` runs before repository edits.
- `skill-orchestrator` owns routing.
- `testing` and `code-review` close non-trivial changes.
- Quality review skills judge gates; they do not replace implementation skills.
- Security owns trust boundaries; domain skills do not duplicate full security
  policy.
- New or changed skills must follow `SKILL_GUIDELINES.md`.
- Plugin reinstall happens only after explicit approval.
- `pam-core` uses one shared core with thin agent adapters. Do not duplicate
  `skills/` for Codex, Claude Code, or generic agents.
- `SKILL_DEPENDENCIES.md` is an operational map for existing physical skills
  only. Roadmap items, technologies, and concepts must be classified in
  `MODULES.md`.
- Unix install support must remain a thin copy/install layer over the shared
  core and must not generate agent-specific skill exports.
- Runtime compatibility must be tracked separately from installation
  compatibility. File validation cannot prove model behavior, and runtime
  support should remain `pending` or `manual` until tested in the real agent.
- Runtime evidence must be recorded in `docs/runtime-tests/RUNTIME_RESULTS.md`
  before any compatibility matrix runtime status is changed to `supported`.
- Release packages use an explicit allowlist and must not include `.git`,
  `dist`, caches, logs, temporary files, or personal local artifacts.
- Packaging creates clean archives only. It must not perform runtime
  installation or mark runtime support as confirmed.

## Pending Work
- Specify the future Meta Orchestrator before implementation. It should answer
  whether a project needs a proposed technology, whether SQLite is enough or
  PostgreSQL is needed, whether local desktop is enough or SaaS is warranted,
  whether the solution is too simple, too complex, or appropriate, whether
  overengineering risk exists, and which path delivers the most value with the
  least complexity.
- Decide later whether module and priority frontmatter are worth a 2.0
  migration.
- Add roadmap skills only in future phases; do not add them as part of Phase 12.
- Create the future `result-verification` or `post-action-verification` skill;
  do not create it until explicitly approved.
- Continue real runtime verification for Claude Code and Codex App, and run
  Linux/WSL/macOS native validation on matching hosts. Update
  `docs/AGENT_COMPATIBILITY.md` only with confirmed evidence.
- Use `docs/LINUX_TEST_PLAN.md` for the next real Linux validation run.

## Known Problems
- Claude Code plugin loading has not been manually verified in this phase;
  `claude` was not available on PATH in the 2026-07-01 test environment.
- The Claude plugin manifest is intentionally minimal and may need schema
  expansion after practical testing.
- `MODULES.md` intentionally lists future roadmap skills that do not exist yet.
- Unix scripts validate file layout and install manifests, but they do not
  guarantee that each agent runtime reloads the installed pack automatically.
- Phase 17.1 Bash package validation was run under Git Bash on Windows; a
  separate WSL, Linux, or macOS host validation has not been recorded.
- `scripts/runtime-smoke-test.sh` checks installed file presence only; it does
  not validate AI behavior.
- `docs/runtime-tests/RUNTIME_RESULTS.md` records supported Codex CLI runtime
  evidence for the explicit cache adapter only. Claude Code and Codex App still
  have no confirmed runtime support.
- Phase 19 found Git Bash on Windows but no WSL, Linux native, or macOS native
  environment. Native OS validation remains pending.

## Next Phase
- Run the Claude Code and Codex App runtime runbooks in real agent sessions.
- Run the native validation sequence on WSL, Linux native, or macOS native hosts
  and record the evidence before changing those statuses.
