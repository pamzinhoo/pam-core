# Project State

Long-term state for `pam-core`.

## Current Version
- Manifest version: `1.2.0`
- Governance state: Phase 17 implemented
- Last updated: 2026-07-01
- Release status: Versioned distribution packaging is implemented in checkout;
  runtime status remains pending without real evidence.

## Current Phase
Phase 17 implemented: Versioned Distribution Packages.

This phase adds versioned zip and tar.gz package generation in `dist/`, package
manifests, SHA256 checksums, package validation scripts, and packaging
documentation. Packaging is separate from runtime installation; the Phase 15
install scripts remain responsible for installing an extracted package into a
target agent location.

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
- Manually run the Phase 16 runtime test runbooks for Claude Code, Codex CLI,
  Codex App, and generic agents, record evidence in
  `docs/runtime-tests/RUNTIME_RESULTS.md`, then update
  `docs/AGENT_COMPATIBILITY.md` with confirmed runtime results.

## Known Problems
- Claude Code plugin loading has not been manually verified in this phase.
- The Claude plugin manifest is intentionally minimal and may need schema
  expansion after practical testing.
- `MODULES.md` intentionally lists future roadmap skills that do not exist yet.
- Unix scripts validate file layout and install manifests, but they do not
  guarantee that each agent runtime reloads the installed pack automatically.
- `scripts/runtime-smoke-test.sh` checks installed file presence only; it does
  not validate AI behavior.
- `docs/runtime-tests/RUNTIME_RESULTS.md` currently records no confirmed
  runtime support for Claude Code, Codex CLI, or Codex App.

## Next Phase
- Execute the Phase 16 runtime runbooks in real agent sessions, record evidence
  with the Phase 16.1 template, and document any runtime-specific registration
  or reload steps that are proven necessary.
