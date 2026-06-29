# Project State

Long-term state for `pam-core`.

## Current Version
- Manifest version: `1.2.0`
- Governance state: Phase 12 complete
- Last updated: 2026-06-29
- Release status: `1.2.0` prepared; plugin reinstall not run.

## Current Phase
Phase 12 complete: Prompt Intelligence Foundation and Execution Control for
version 1.2.

This phase added the first Prompt Intelligence layer so `pam-core` can
understand vague prompts, normalize execution context, detect gaps, split mixed
requests, and define success criteria before routing and execution. It does not
implement Meta Orchestrator, UI Visual Review, or the broader version 2.0 skill
roadmap.

Execution Control was completed after a real long-running Working incident. It
prevents silent stalled tools, broad patch loops, and mixed bug/security/CSS
work from continuing without progress limits.

Post-action verification was registered as a mandatory future improvement after
an observed file-edit failure where an agent claimed a change was applied, but a
final reread showed the target line was still unchanged. The corrective rule is:
after any file change, command, installation, migration, or configuration
change, the agent must verify the real result before saying the work is done.

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

## Pending Work
- Reinstall the plugin only after explicit approval.
- Do not reinstall the plugin until explicitly approved.
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

## Known Problems
- The installed plugin cache may lag behind the workspace until reinstall.
- `MODULES.md` intentionally lists future roadmap skills that do not exist yet.
- This workspace may not be a Git repository after invalid source metadata is
  cleaned; release tracking should use the user's chosen version-control source.

## Next Phase
- Decide the next approved roadmap item after release `1.2.0`; keep plugin
  reinstall separate and explicit.
