# Modules

`pam-core` is organized as a modular skill platform. Modules group skills by
responsibility so the orchestrator can scale to many specialists without loading
everything.

Use this file with `AGENTS.md`, `SKILL_DEPENDENCIES.md`,
`PROJECT_PROFILES.md`, and `SKILL_GUIDELINES.md`.

## Skill Reference Classes
Use these labels consistently in governance docs:

- Existing skills: physical skill directories that exist under `skills/` and
  contain `SKILL.md`.
- Planned skills: future skill candidates that do not exist yet.
- Concepts / technologies: frameworks, tools, project artifacts, architecture
  ideas, test types, or domain concepts. These are not skills unless a future
  phase creates a matching directory in `skills/`.

## Principles
- A module owns a domain, not a project type.
- A skill has one lead responsibility.
- Cross-cutting skills stay in Core, Security, Testing, Quality, or DevOps.
- Domain modules depend on shared modules instead of duplicating rules.
- New skills must follow `SKILL_GUIDELINES.md`.
- `skill-orchestrator` selects modules first, then skills.

## Current Architecture Review

### Duplications
- Security guidance appears in `security`, `authentication`, `saas`, `fastapi`,
  `javascript`, `document-system`, and `prompt-injection-defense`.
- Testing guidance appears in `testing`, `python`, `fastapi`, `sqlite`,
  `financial-system`, and `code-review`.
- Simplicity and anti-abstraction guidance appears in `ponytail`,
  `architecture`, `refactoring`, `python`, and `automation-scripts`.
- UI quality guidance appears across `ui-designer`, `anti-ai-ui`, `html-css`,
  `ux`, and `accessibility`.

### Responsibilities To Clarify
- `security` should own general trust boundaries.
- `prompt-injection-defense` should own malicious instructions in untrusted
  content.
- `authentication` should own identity, sessions, roles, and permissions.
- `testing` should own verification strategy; other skills should only name
  domain-specific checks.
- `ui-designer` should lead UI decisions; `anti-ai-ui`, `ux`, `html-css`, and
  `accessibility` should support it.
- Skills ending in `-review` should evaluate gates, risk, or readiness after
  implementation; they should not lead implementation or replace
  `code-review`.
- `skill-orchestrator` should own routing; no domain skill should decide the
  whole skill stack.

### Module Split
The official modules are:

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

## Priority Model
- Critical: required for safety, routing, or project comprehension.
- High: primary implementation or domain skill for the task.
- Medium: supporting skill that reduces risk for this project type.
- Optional: use only when the task explicitly benefits from it.

## Core

### Objective
Coordinate work, preserve context, and keep changes simple.

### Responsibilities
- Future pre-routing architecture assessment.
- Project discovery.
- Skill routing.
- Task planning.
- Execution progress limits.
- Mixed task sequencing.
- Patch sizing and encoding-sensitive edit strategy.
- Scope control.
- Change impact analysis.
- Root cause analysis.
- Architecture boundaries.
- Simplicity and refactoring discipline.
- Context continuity.

### Skills
- `project-understanding`
- `skill-orchestrator`
- `task-planning`
- `execution-monitor`
- `task-sequencing`
- `patch-strategy`
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

### Dependencies
- Depends on Security for trust boundaries.
- Depends on Testing for verification.
- Supports every other module.

### Priorities
- Critical: `project-understanding`, `skill-orchestrator`
- Critical when matching: `execution-monitor`, `task-sequencing`
- High: `task-planning`, `patch-strategy`, `scope-control`,
  `change-impact-analysis`, `root-cause-analysis`, `context-management`,
  `ponytail`, `headroom`
- Medium: `architecture`, `debugging`, `refactoring`
- Optional: `performance`

### Cooperation Rules
- A future Meta Orchestrator may run before Core discovery and routing to
  evaluate whether the proposed project direction is appropriate.
- Core loads first.
- `project-understanding` owns discovery.
- `skill-orchestrator` owns routing.
- `task-planning` owns sequencing.
- `execution-monitor` owns long-running execution limits and stalled-progress
  detection.
- `task-sequencing` owns ordering mixed prompts before execution.
- `patch-strategy` owns safe patch sizing and encoding-sensitive edits.
- `scope-control` owns scope boundaries.
- `change-impact-analysis` owns regression and contract impact.
- `root-cause-analysis` owns failure cause.
- `context-management` owns long-task continuity.
- `architecture` owns structure only when boundaries change.

### Roadmap
- Existing skills: all listed above.
- Concepts / technologies: Meta Orchestrator above `project-understanding` and
  `skill-orchestrator`, not implemented yet.
- Planned skills: `module-planner`, `risk-classifier`, `meta-orchestrator`.
- Priority: Alta.
- Complexity: Media.

### Meta Orchestrator Proposal
The Meta Orchestrator is a future layer for architectural judgment before
technology, stack, module, or skill selection. It should help decide:

- Whether the project needs the proposed technology.
- Whether SQLite is enough or PostgreSQL is needed.
- Whether a local desktop app is enough or SaaS is warranted.
- Whether the solution is too simple, too complex, or appropriate.
- Whether overengineering risk exists.
- Which path delivers the most value with the least complexity.

This is roadmap documentation only. Do not create or activate a
`meta-orchestrator` skill until a future phase explicitly approves it.

## Backend

### Objective
Build safe backend APIs and services with stable contracts.

### Responsibilities
- HTTP contracts.
- Framework behavior.
- Request validation.
- Error shapes.
- Backend integration boundaries.
- Python runtime behavior.
- Authentication dependencies.
- Background and real-time FastAPI workflows.

### Skills
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

### Dependencies
- Depends on Security for auth and trust boundaries.
- Depends on Database for persistence.
- Depends on Testing for endpoint checks.

### Priorities
- High: `api-design`, `fastapi`, `python`
- High when matching: `fastapi-authentication`, `fastapi-dependencies`,
  `fastapi-validation`, `python-error-handling`
- Medium: `async-python`, `python-packaging`, `python-performance`,
  `python-logging`, `fastapi-background-tasks`, `fastapi-websockets`,
  `authentication`, `database-design`, `sqlite`
- Optional: `deployment`, `performance`

### Cooperation Rules
- `api-design` leads generic REST work.
- `fastapi` leads FastAPI-specific work.
- `python` owns implementation style.
- Python and FastAPI specialists activate only for the exact concern being
  changed; they cooperate with the general lead instead of becoming parallel
  leads.
- `fastapi-authentication` owns FastAPI identity extraction; use
  `permissions-authorization` for access decisions.
- `fastapi-dependencies` owns request-scoped dependency wiring.
- `fastapi-validation` owns request and response schema boundaries.
- `async-python` owns async runtime correctness.
- Python specialist skills handle packaging, performance, logging, and error
  handling only when those concerns are directly touched.
- Do not duplicate auth rules from Security.

### Roadmap
- Existing skills: `fastapi`, `api-design`, `python`, `async-python`,
  `python-packaging`, `python-performance`, `python-logging`,
  `python-error-handling`, `fastapi-authentication`, `fastapi-dependencies`,
  `fastapi-background-tasks`, `fastapi-websockets`, `fastapi-validation`.
- Planned skills: `rest-api`, `webhooks`, `openapi-contracts`.
- Concepts / technologies: `pydantic`.
- Priority: Alta.
- Complexity: Media.

## Frontend

### Objective
Create practical, accessible, non-generic product interfaces.

### Responsibilities
- UI structure.
- Visual hierarchy.
- HTML/CSS layout.
- Browser behavior.
- Accessibility and UX states.
- Responsive product layouts.
- Forms, tables, dashboards, and business UI patterns.
- Design systems and CSS architecture.
- Frontend state, API integration, and performance.
- UI copy and navigation structure.

### Skills
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

### Dependencies
- Depends on Security for client-side data risks.
- Depends on Testing for UI behavior checks.
- May depend on Backend for API contracts.

### Priorities
- High: `ui-designer`, `html-css`, `javascript`, `anti-ai-ui`
- High when matching: `responsive-design`, `form-design`, `table-design`,
  `dashboard-design`, `design-system`, `frontend-state-management`,
  `frontend-api-integration`, `loading-empty-error-states`,
  `internal-business-ui`, `navigation-layout`
- Medium: `ux`, `accessibility`, `css-architecture`, `mobile-first-ui`,
  `visual-hierarchy`, `copywriting-ui`, `frontend-performance`
- Optional: `performance`

### Cooperation Rules
- `ui-designer` leads product UI.
- `anti-ai-ui` removes generic visual patterns.
- `html-css` owns markup and layout.
- `javascript` owns browser behavior.
- `accessibility` is not optional for interactive controls.
- Use specialist skills only when their exact pattern is present.
- UI specialists refine their surface; they should not become co-leads unless
  the user request is specifically about that surface.
- `responsive-design` owns viewport behavior; `mobile-first-ui` owns
  phone-first product flows.
- `form-design`, `table-design`, and `dashboard-design` own their specific UI
  surfaces.
- `design-system` owns shared tokens and components; `css-architecture` owns
  cascade and style organization.
- `frontend-state-management` owns client state; `frontend-api-integration`
  owns browser-to-API boundaries.
- `loading-empty-error-states` owns async and missing-data states.
- `internal-business-ui`, `navigation-layout`, `visual-hierarchy`, and
  `copywriting-ui` refine product workflow, structure, priority, and text.

### Roadmap
- Existing skills: all listed above.
- Planned skills: `charts`.
- Concepts / technologies: `react`.
- Priority: Alta.
- Complexity: Alta.

## Database

### Objective
Protect data integrity through clear models, constraints, and transactions.

### Responsibilities
- Schema design.
- Query safety.
- Migrations.
- Local storage.
- Data consistency.
- SQLAlchemy persistence boundaries.
- Migration rollout safety.
- Query performance.
- Transaction integrity.

### Skills
- `database-design`
- `sqlite`
- `sqlalchemy`
- `alembic`
- `database-migrations`
- `query-optimization`
- `transactions`

### Dependencies
- Depends on Security for injection and access control.
- Depends on Business for domain invariants.
- Depends on Testing for migration and query checks.

### Priorities
- High: `database-design`
- High when matching: `sqlalchemy`, `database-migrations`, `transactions`
- High for local apps: `sqlite`
- Medium: `alembic`, `query-optimization`, `financial-system`,
  `business-rules`
- Optional: `performance`

### Cooperation Rules
- `database-design` leads relational modeling.
- `sqlite` leads SQLite implementation.
- `sqlalchemy` owns ORM and Core implementation details.
- `alembic` owns Alembic revision mechanics.
- `database-migrations` owns rollout and data-safety planning.
- `query-optimization` owns query-plan and index performance work.
- `transactions` owns multi-step write consistency.
- Database specialists cooperate with `database-design` when their exact concern
  is touched; do not call them for unrelated persistence-adjacent work.
- Do not let app code replace database constraints when constraints fit.

### Roadmap
- Existing skills: `database-design`, `sqlite`, `sqlalchemy`, `alembic`,
  `database-migrations`, `query-optimization`, `transactions`.
- Planned skills: `data-import`, `backup-restore`.
- Concepts / technologies: `postgres`.
- Priority: Alta.
- Complexity: Alta.

## Desktop

### Objective
Build local tools that respect user files, OS paths, and simple delivery.

### Responsibilities
- Local app behavior.
- Windows path safety.
- Packaging.
- Offline workflows.
- User data preservation.

### Skills
- `desktop-local`
- `windows-desktop`
- `packaging`
- `automation-scripts`
- `python`
- `sqlite`

### Dependencies
- Depends on Security for file operations.
- Depends on Database for local persistence.
- Depends on Frontend for desktop UI when present.

### Priorities
- High: `desktop-local`, `windows-desktop`, `automation-scripts`
- Medium: `packaging`, `python`, `sqlite`
- Optional: `ui-designer`

### Cooperation Rules
- `desktop-local` leads product shape.
- `windows-desktop` owns Windows-specific file and path rules.
- `automation-scripts` owns scripted operations.
- `packaging` activates only for delivery.

### Roadmap
- Existing skills: all listed above.
- Planned skills: `file-watchers`, `local-config`, `windows-installer`.
- Concepts / technologies: `tkinter`, `pyside`.
- Priority: Media.
- Complexity: Media.

## Business

### Objective
Keep domain rules explicit, auditable, and protected by tests.

### Responsibilities
- Money logic.
- Domain policies.
- Status transitions.
- Auditable corrections.
- Domain-specific data validation.

### Skills
- `business-rules`
- `financial-system`
- `saas`

### Dependencies
- Depends on Security for permissions.
- Depends on Database for integrity.
- Depends on Testing for rule coverage.
- May depend on Backend or Frontend by product type.

### Priorities
- High: `business-rules`, `financial-system`
- Medium: `saas`
- Optional: `api-design`, `ui-designer`

### Cooperation Rules
- `business-rules` owns generic domain policy.
- `financial-system` leads money, ledgers, invoices, and reconciliation.
- `saas` leads tenancy and hosted product concerns.
- Do not invent business rules without source context.

### Roadmap
- Existing skills: `business-rules`, `financial-system`, `saas`.
- Planned skills: `school-system`, `inventory-system`, `crm-system`,
  `billing`, `audit-log`, `reporting`.
- Priority: Alta.
- Complexity: Alta.

## Prompt Intelligence

### Objective
Understand, normalize, and validate user intent before execution so the agent
does not treat technical activity as task completion.

### Responsibilities
- User intent understanding.
- Prompt normalization.
- Gap and ambiguity detection.
- Mixed-task extraction.
- Success criteria definition.

### Skills
- `prompt-understanding`
- `prompt-normalization`
- `prompt-gap-analysis`
- `task-extraction`
- `success-criteria`

### Dependencies
- Depends on Security for unsafe or untrusted prompt content.
- Depends on AI for prompt and agent workflow discipline.
- Supports Core before routing when prompts are vague, ambiguous, subjective,
  mixed, or high-risk.

### Priorities
- Critical when matching: `prompt-understanding`, `success-criteria`
- High when matching: `prompt-normalization`, `prompt-gap-analysis`,
  `task-extraction`

### Cooperation Rules
- Prompt Intelligence runs after initial project context when needed and before
  `skill-orchestrator`.
- `prompt-understanding` owns the user's real intent.
- `prompt-normalization` owns the internal task structure.
- `prompt-gap-analysis` owns missing facts, contradictions, and risk signals.
- `task-extraction` owns splitting mixed requests into ordered tasks.
- `success-criteria` owns completion criteria before execution and final status.
- These skills do not choose the full skill stack; `skill-orchestrator` still
  owns routing.

### Roadmap
- Existing skills: all listed above.
- Planned skills: `prompt-enhancement`, `intent-classifier`,
  `ambiguity-resolution`.
- Concepts / technologies: Meta Orchestrator, UI Visual Review.
- Priority: Alta.
- Complexity: Media.

## AI

### Objective
Build AI, agent, MCP, and context workflows with clear guardrails.

### Responsibilities
- Prompt-intelligence cooperation.
- Prompt structure.
- Tool and MCP behavior.
- Context management.
- Model output validation.
- Agent safety with untrusted content.

### Skills
- `llm-best-practices`
- `prompt-injection-defense`
- `headroom`
- `skill-orchestrator`

### Dependencies
- Depends on Prompt Intelligence for vague, ambiguous, subjective, mixed, or
  high-risk user prompts.
- Depends on Security for trust boundaries.
- Depends on Testing for evals and structured output checks.
- Depends on Documentation for skill and prompt standards.

### Priorities
- Critical: `prompt-injection-defense` for untrusted content.
- High: `llm-best-practices`, `headroom`
- Medium: `skill-orchestrator`
- Optional: `document-system`

### Cooperation Rules
- Prompt Intelligence clarifies the user request before AI workflow design when
  the prompt itself is the risk.
- `prompt-injection-defense` owns untrusted instructions.
- `llm-best-practices` owns prompt and output design.
- `headroom` owns context discipline.
- AI skills must not override trusted instructions.

### Roadmap
- Existing skills: all listed above.
- Planned skills: `mcp-server`, `tool-design`, `structured-outputs`,
  `agent-memory`, `prompt-enhancement`, `intent-classifier`,
  `ambiguity-resolution`.
- Concepts / technologies: `rag`, `evals`.
- Priority: Alta.
- Complexity: Alta.

## Security

### Objective
Protect data, permissions, secrets, file operations, dependencies, and agent behavior.

### Responsibilities
- Trust boundaries.
- Auth and authorization.
- Secret handling.
- Destructive action control.
- Dependency risk.
- Data privacy.
- Prompt-injection defense.

### Skills
- `security`
- `authentication`
- `prompt-injection-defense`
- `secrets-management`
- `dependency-audit`
- `safe-command-execution`
- `permissions-authorization`
- `data-privacy`

### Dependencies
- Supports every module.
- Depends on Testing for security checks.
- Depends on Backend, Database, Desktop, DevOps, or AI for implementation context.

### Priorities
- Critical: `security`
- Critical for AI/content: `prompt-injection-defense`
- High: `secrets-management`, `safe-command-execution`,
  `permissions-authorization`, `data-privacy`, `authentication`
- Medium: `dependency-audit`

### Cooperation Rules
- `security` leads general safety.
- `authentication` owns identity and session mechanics.
- `permissions-authorization` owns access control decisions.
- `prompt-injection-defense` owns malicious instructions in content.
- `secrets-management` owns credential handling.
- `safe-command-execution` owns risky command execution.
- `data-privacy` owns private data minimization and disclosure.
- `dependency-audit` owns package and lockfile risk.
- Other modules reference Security instead of copying full rules.

### Roadmap
- Existing skills: all listed above.
- Planned skills: `file-safety`, `webhook-security`.
- Concepts / technologies: `oauth`, `rbac`, `tenant-isolation`.
- Priority: Alta.
- Complexity: Alta.

## Testing

### Objective
Verify changes with focused checks. Quality gates consume these results before
completion.

### Responsibilities
- Test selection.
- Smoke checks.
- Debug verification.
- Verification evidence.
- Skipped-check disclosure.

### Skills
- `testing`
- `code-review`
- `debugging`

### Dependencies
- Depends on project context from Core.
- Supports every implementation module.
- Cooperates with Security and Business for high-risk checks.

### Priorities
- High: `testing`, `code-review`
- Medium: `debugging`

### Cooperation Rules
- `testing` owns what to run.
- `code-review` owns final risk review.
- `debugging` owns failure investigation.
- `regression-review` is a Quality skill; it assesses regression readiness
  after `testing` evidence exists instead of choosing the test command.
- Do not claim checks passed unless they ran.
- Quality review skills may request evidence from `testing`, but do not decide
  the test command.

### Roadmap
- Existing skills: all listed above.
- Planned skills: `ci-diagnostics`.
- Concepts / technologies: `pytest`, `playwright`, `contract-tests`,
  `smoke-tests`.
- Priority: Alta.
- Complexity: Media.

## Quality

### Objective
Evaluate whether relevant changes pass explicit quality gates before they are
considered complete.

### Responsibilities
- Architecture gate decisions.
- Security gate decisions.
- Performance gate decisions.
- Maintainability gate decisions.
- Documentation gate decisions.
- UX and accessibility gate decisions.
- Regression risk review.
- Dependency risk review.
- Release readiness review.

### Skills
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

### Dependencies
- Depends on Core for project context and impact analysis.
- Depends on Security for trust-boundary implementation guidance.
- Depends on Testing for executed checks.
- Depends on Documentation for docs workflows.
- Depends on Frontend, Backend, Database, DevOps, or Business by changed surface.

### Priorities
- High when matching: `security-review`, `regression-review`,
  `release-readiness`
- Medium: `architecture-review`, `maintainability-review`,
  `performance-review`, `documentation-review`, `dependency-review`
- Medium for UI changes: `ux-review`, `accessibility-review`

### Cooperation Rules
- Quality skills judge gate pass/fail status; they do not implement the fix.
- `testing` owns verification commands and results.
- `code-review` owns final general risk review.
- `security-review` checks the Security Gate; `security` owns security
  implementation guidance.
- `dependency-review` checks dependency readiness; `dependency-audit` owns
  dependency investigation and implementation guidance.
- `release-readiness` runs only for approval, handoff, release, packaging, or
  deployment readiness and summarizes required gate status.
- Use only gates relevant to the change. Do not load every quality skill by
  default.

### Roadmap
- Existing skills: all listed above.
- Existing governance docs: `QUALITY_GATES.md`.
- Planned skills: `ci-quality-gates`, `risk-scoring`, `quality-reporting`.
- Priority: Alta.
- Complexity: Media.

## DevOps

### Objective
Keep delivery, deployment, Git, and packaging repeatable and low risk.

### Responsibilities
- Version control safety.
- Deployment planning.
- Local packaging.
- Release checks.
- Rollback awareness.

### Skills
- `git`
- `deployment`
- `packaging`
- `performance`

### Dependencies
- Depends on Security for secrets and destructive operations.
- Depends on Testing before release.
- Depends on Backend, Frontend, or Desktop by target.

### Priorities
- High when requested: `git`
- Medium: `deployment`, `packaging`
- Optional: `performance`

### Cooperation Rules
- `git` activates only for Git work.
- `deployment` leads hosted release work.
- `packaging` leads local app delivery.
- Avoid making packaging and deployment co-leads for one target.

### Roadmap
- Existing skills: all listed above.
- Concepts / technologies: `github-actions`, `docker`, `release-notes`,
  `env-config`, `rollback`, `observability`.
- Priority: Media.
- Complexity: Media.

## Documentation

### Objective
Keep project, skill, and operational documentation concise and useful.

### Responsibilities
- Skill standards.
- Module standards.
- Project docs.
- Project state.
- Decision records.
- Versioning policy.
- Contribution rules.
- Changelogs and release notes.
- User-facing instructions.

### Skills
- `document-system`
- `automation-scripts`

### Dependencies
- Depends on Core for project understanding.
- Depends on AI for skill and prompt documentation.
- Depends on Testing for validation scripts.

### Priorities
- Medium: `document-system`
- Medium: `automation-scripts`
- Optional: `headroom`

### Cooperation Rules
- `document-system` leads file/document workflows.
- General documentation should be handled by future documentation skills.
- Do not let docs duplicate full rules owned by specialist skills.

### Roadmap
- Existing skills: `document-system`, `automation-scripts`.
- Existing governance docs: `PROJECT_STATE.md`, `DECISIONS.md`,
  `VERSIONING.md`, `CONTRIBUTING.md`.
- Planned skills: `documentation`, `skill-authoring`.
- Concepts / technologies: `changelog`, `runbooks`, `user-guides`,
  `api-docs`.
- Priority: Media.
- Complexity: Baixa.

## Version 2.0 Roadmap

### Phase 5.1: Normalize Existing Skills
- Convert remaining short skills to the full `SKILL_GUIDELINES.md` structure.
- Remove repeated security, testing, and simplicity text from domain skills.
- Ensure every skill declares module ownership.

### Phase 5.2: Add Module Metadata
- Add module, priority, and dependency fields to each skill frontmatter.
- Update `skill-orchestrator` to route by module first.
- Keep `PROJECT_PROFILES.md` as profile-level defaults.

### Phase 5.3: Fill High-Priority Gaps
- Planned skill candidates: `rest-api`, `webhooks`, `charts`,
  `data-import`, `backup-restore`, `school-system`, `billing`, `audit-log`,
  `mcp-server`, `structured-outputs`, `webhook-security`,
  `ci-diagnostics`.
- Concepts / technologies to evaluate before turning into skills: `pydantic`,
  `react`, `forms`, `tables`, `postgres`, `evals`, `rbac`,
  `tenant-isolation`, `pytest`, `playwright`, `contract-tests`.

### Phase 5.4: Scale To 100+ Skills
- Keep modules as stable top-level groups.
- Add subdomains only inside modules.
- Require each new skill to name its lead responsibility and conflicts.
- Review `SKILL_DEPENDENCIES.md` whenever a new skill overlaps another.

### Phase 5.5: Release 2.0
- Validate all skills against the standard structure.
- Update docs and examples.
- Run plugin validation.
- Reinstall only after explicit approval.
