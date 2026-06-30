# Skill Dependencies

Use this map after `project-understanding`. For vague, short, ambiguous,
subjective, mixed, or high-risk prompts, run Prompt Intelligence before
`skill-orchestrator`.
Load the smallest set that covers the task.

## Scope
This file is an operational map for existing skills only. Every value in table
columns named `Skill`, `Lead Skill`, or `Cooperates With` must match a physical
directory under `skills/`.

Roadmap items, concepts, technologies, test types, project domains, and
framework names belong in `MODULES.md` under Planned skills or Concepts /
technologies. They should not appear here as dependencies, lead skills,
cooperating skills, ownership rules, or trigger rules unless a matching skill
directory exists.

## Priority Levels
- Critical: must load when the task matches.
- High: load for most relevant implementation work.
- Medium: load when the project shape or risk calls for it.
- Optional: load only when it adds clear value.

## Recommended Activation Order
1. Critical context: `project-understanding`, `security`, `prompt-injection-defense`.
2. Prompt intelligence when needed: `prompt-understanding`,
   `prompt-normalization`, `prompt-gap-analysis`, `task-extraction`,
   `success-criteria`.
3. Execution control for broad or mixed work: `execution-monitor`,
   `task-sequencing`, then `patch-strategy` when patches may be large or
   encoding-sensitive.
4. Orchestration: `skill-orchestrator`, `task-planning`, `context-management`.
5. Scope and risk: `scope-control`, `change-impact-analysis`, `root-cause-analysis`.
6. Simplicity and design: `ponytail`, `architecture`, `refactoring`.
7. Domain specialists: backend, frontend, data, documents, finance, school, AI.
8. Implementation specialists: language, framework, database, scripts.
9. Verification: `testing`.
10. Quality gates: matching review skills from `QUALITY_GATES.md`.
11. Finish: `code-review`; add `release-readiness` only for approval, handoff,
   release, packaging, or deployment readiness, and `git` only when version
   control is requested.

## Core Dependencies
| Skill | Priority | Required With | Optional With |
| --- | --- | --- | --- |
| project-understanding | Critical | all repository edits | debugging, architecture |
| skill-orchestrator | Critical | multi-skill tasks | headroom |
| security | Critical | auth, files, secrets, destructive actions, external input | prompt-injection-defense |
| prompt-injection-defense | Critical | AI, MCP, agents, external documents, web/log/email content | llm-best-practices |
| prompt-understanding | Critical when matching | vague, short, ambiguous, subjective, mixed, or high-risk prompts | prompt-normalization |
| prompt-normalization | High when matching | prompts that need objective, scope, constraints, risks, and success criteria | prompt-gap-analysis |
| prompt-gap-analysis | High when matching | missing facts, ambiguity, contradictions, risky assumptions | security |
| task-extraction | High when matching | mixed or multi-part prompts | task-planning |
| success-criteria | Critical when matching | subjective, user-visible, high-risk, multi-step, release, or bug-fix work | testing |
| task-planning | High | multi-step or phased work | scope-control |
| scope-control | High | broad or ambiguous changes | ponytail |
| change-impact-analysis | High | shared contracts, schemas, APIs, permissions, money, routing maps | testing |
| root-cause-analysis | High | bugs, regressions, failing checks | debugging |
| context-management | High | long tasks, many files, many active skills | headroom |
| execution-monitor | Critical when matching | broad, long, tool-heavy, patch-heavy, validation-heavy, or stalled tasks | context-management |
| task-sequencing | Critical when matching | mixed prompts, broad requests, bug plus security plus UI work | task-planning |
| patch-strategy | High when matching | large patches, multi-file edits, HTML/CSS, encoding or mojibake, failed patch context | scope-control |
| secrets-management | High | credentials, tokens, keys, env files | deployment |
| dependency-audit | Medium | dependency or lockfile changes | safe-command-execution |
| safe-command-execution | High | writes, installs, scripts, destructive or untrusted commands | automation-scripts |
| permissions-authorization | High | roles, ownership, tenants, protected resources | authentication |
| data-privacy | High | PII, customer data, exports, logs, documents | document-system |
| ponytail | High | implementation and architecture decisions | refactoring |
| headroom | High | large context, many files, many skills | project-understanding |
| testing | High | non-trivial changes | debugging |
| code-review | High | non-trivial changes before final response | security |
| architecture-review | Medium | Architecture Gate | architecture, change-impact-analysis |
| maintainability-review | Medium | Maintainability Gate | ponytail, refactoring |
| performance-review | Medium | Performance Gate | performance, query-optimization |
| security-review | High | Security Gate | security, secrets-management |
| ux-review | Medium | UX Gate | ux, ui-designer |
| accessibility-review | Medium | UI accessibility checks | accessibility, ux-review |
| documentation-review | Medium | Documentation Gate | document-system, automation-scripts |
| regression-review | High | changed contracts, shared behavior | change-impact-analysis, testing |
| dependency-review | Medium | dependency or lockfile changes | dependency-audit, security-review |
| release-readiness | High | Release Gate before approval, handoff, release, packaging, or deployment readiness | testing, code-review |

## Cooperation Map
| Area | Lead Skill | Cooperates With |
| --- | --- | --- |
| Project discovery | project-understanding | skill-orchestrator, debugging |
| Task planning | task-planning | scope-control, change-impact-analysis, testing |
| Scope control | scope-control | ponytail, architecture, code-review |
| Change impact | change-impact-analysis | project-understanding, testing, code-review |
| Root cause | root-cause-analysis | debugging, testing, project-understanding |
| Context continuity | context-management | headroom, skill-orchestrator, code-review |
| Execution control | execution-monitor | task-sequencing, patch-strategy, context-management, testing |
| Mixed task ordering | task-sequencing | execution-monitor, task-planning, scope-control, success-criteria |
| Patch safety | patch-strategy | execution-monitor, task-sequencing, scope-control, testing |
| Architecture | architecture | ponytail, refactoring, security |
| Secrets | secrets-management | security, deployment, safe-command-execution |
| Dependencies | dependency-audit | ponytail, security, testing |
| Dependency readiness | dependency-review | dependency-audit, security-review, testing |
| Command execution | safe-command-execution | security, prompt-injection-defense, automation-scripts |
| Authorization | permissions-authorization | authentication, security, api-design, database-design |
| Data privacy | data-privacy | security, document-system, financial-system |
| User intent | prompt-understanding | prompt-normalization, prompt-gap-analysis, success-criteria |
| Prompt normalization | prompt-normalization | prompt-understanding, task-extraction, skill-orchestrator |
| Prompt gap analysis | prompt-gap-analysis | security, scope-control, testing |
| Task extraction | task-extraction | task-planning, scope-control, skill-orchestrator |
| Success criteria | success-criteria | testing, ux-review, code-review |
| Architecture Gate | architecture-review | architecture, refactoring, change-impact-analysis |
| Maintainability Gate | maintainability-review | ponytail, refactoring, scope-control |
| Security Gate | security-review | security, secrets-management, permissions-authorization, data-privacy |
| Performance Gate | performance-review | performance, python-performance, frontend-performance, query-optimization |
| Documentation Gate | documentation-review | document-system, automation-scripts, security-review |
| UX Gate | ux-review | accessibility-review, ui-designer, ux, accessibility |
| Regression readiness | regression-review | change-impact-analysis, testing, code-review |
| Release Gate | release-readiness | testing, code-review, documentation-review, security-review, regression-review, dependency-review |
| Backend API | fastapi | api-design, authentication, security, database-design |
| FastAPI authentication | fastapi-authentication | authentication, permissions-authorization, security |
| FastAPI dependencies | fastapi-dependencies | fastapi, sqlalchemy, transactions |
| FastAPI background tasks | fastapi-background-tasks | async-python, python-logging, transactions |
| FastAPI WebSockets | fastapi-websockets | fastapi-authentication, fastapi-validation, async-python |
| FastAPI validation | fastapi-validation | api-design, python-error-handling, testing |
| REST contracts | api-design | fastapi, testing, code-review |
| Python scripts | python | automation-scripts, windows-desktop, testing |
| Python async | async-python | python, fastapi, testing |
| Python packaging | python-packaging | dependency-audit, packaging, deployment |
| Python performance | python-performance | performance, query-optimization, testing |
| Python logging | python-logging | security, data-privacy, python-error-handling |
| Python errors | python-error-handling | python-logging, transactions, testing |
| SQLite apps | sqlite | database-design, desktop-local, python |
| SQLAlchemy | sqlalchemy | database-design, alembic, transactions |
| Alembic | alembic | database-migrations, sqlalchemy, testing |
| Database migrations | database-migrations | database-design, alembic, transactions |
| Query optimization | query-optimization | sqlalchemy, python-performance, testing |
| Transactions | transactions | database-design, sqlalchemy, python-error-handling |
| Frontend | ui-designer | html-css, javascript, ux, accessibility, anti-ai-ui, responsive-design, form-design, table-design, dashboard-design, design-system, css-architecture, frontend-state-management, frontend-api-integration, loading-empty-error-states, frontend-performance, internal-business-ui, mobile-first-ui, navigation-layout, visual-hierarchy, copywriting-ui |
| Documents | document-system | automation-scripts, python, security |
| Finance | financial-system | business-rules, sqlite, security, testing |
| School systems | business-rules | authentication, database-design, api-design |
| AI and MCP | llm-best-practices | prompt-injection-defense, headroom, security |
| Prompt Intelligence | prompt-understanding | prompt-normalization, prompt-gap-analysis, task-extraction, success-criteria, skill-orchestrator |
| Packaging | packaging | desktop-local, windows-desktop, deployment |
| Debugging | debugging | project-understanding, testing, code-review |
| Git | git | code-review, testing |

## Never Run Together Unless User Explicitly Requests It
- `sqlite` and another database lead for the same storage decision.
- `desktop-local` and `saas` as product leads for the same app boundary.
- Broad audit work and implementation skills in the same pass, unless the task
  is explicitly audit plus fix.
- Functional bug fixing, security changes, and CSS/UI polish in the same edit
  round; split them with `task-sequencing`.
- `packaging` and `deployment` as leads for the same release target.
- Multiple UI lead skills; use `ui-designer` as lead, with `anti-ai-ui`, `ux`,
  `accessibility`, `html-css`, `javascript`, and exact-match frontend
  specialists as supporting skills.
- `root-cause-analysis` and broad refactoring as co-leads before the cause is
  known.
- `secrets-management` and any task that prints raw secret values.
- All quality review skills at once for a low-risk change; select only gates
  that match `QUALITY_GATES.md`.
- Quality review skills as replacements for implementation skills, `testing`,
  or `code-review`.

## Duplication Rules
- `project-understanding` owns discovery.
- `skill-orchestrator` owns routing.
- `task-planning` owns sequencing.
- `scope-control` owns scope boundaries.
- `change-impact-analysis` owns contract and regression impact.
- `root-cause-analysis` owns failure cause.
- `context-management` owns long-task continuity.
- `execution-monitor` owns long-running execution limits and stalled-progress
  detection.
- `task-sequencing` owns mixed-prompt ordering before execution.
- `patch-strategy` owns safe patch sizing and encoding-sensitive edit strategy.
- `security` owns trust boundaries and destructive risk.
- `secrets-management` owns credentials.
- `safe-command-execution` owns risky commands.
- `permissions-authorization` owns access control.
- `data-privacy` owns private data exposure.
- `dependency-audit` owns package risk.
- `prompt-understanding` owns real user intent.
- `prompt-normalization` owns the internal task structure.
- `prompt-gap-analysis` owns missing facts, ambiguity, contradictions, and
  prompt-level risk.
- `task-extraction` owns splitting mixed requests into ordered tasks.
- `success-criteria` owns completion criteria and final completion evidence.
- Quality review skills own gate pass/fail assessment only.
- `architecture-review` owns Architecture Gate assessment.
- `maintainability-review` owns Maintainability Gate assessment.
- `performance-review` owns Performance Gate assessment.
- `security-review` owns Security Gate assessment.
- `ux-review` owns UX Gate assessment.
- `accessibility-review` owns UI accessibility gate assessment.
- `documentation-review` owns Documentation Gate assessment.
- `regression-review` owns regression readiness assessment.
- `dependency-review` owns dependency readiness assessment.
- `release-readiness` owns Release Gate assessment.
- Review skills do not implement fixes, choose verification commands, or replace
  `code-review`; they consume implementation context and `testing` evidence to
  report pass, fail, or residual risk.
- `architecture` owns structure.
- Domain skills own business meaning.
- Language and framework skills own implementation details.
- `python` owns general Python implementation style; `async-python`,
  `python-error-handling`, `python-logging`, `python-packaging`, and
  `python-performance` cooperate only when their exact concern is being changed.
- `fastapi` owns general FastAPI endpoint work; FastAPI specialist skills
  cooperate only for authentication, dependency, validation, background task, or
  WebSocket concerns at the FastAPI boundary.
- `database-design` owns relational modeling; `sqlite`, `sqlalchemy`,
  `alembic`, `database-migrations`, `query-optimization`, and `transactions`
  cooperate only for their storage engine, ORM, migration, performance, or
  consistency concern.
- Frontend specialist skills own narrow UI patterns when their exact trigger is
  present; they do not replace `ui-designer`, `html-css`, `javascript`, `ux`,
  `accessibility`, or `anti-ai-ui`.
- `testing` owns verification.
- `code-review` owns final risk review.

## Mandatory Dependencies
- Repository edit: `project-understanding`.
- Vague, short, ambiguous, subjective, mixed, or high-risk prompt:
  `prompt-understanding`, then matching Prompt Intelligence skills before
  `skill-orchestrator`.
- User-visible, subjective, bug-fix, release, or high-risk task:
  `success-criteria` before execution and before final response.
- Multi-skill task: `skill-orchestrator`.
- Multi-step task: `task-planning`.
- Long, broad, tool-heavy, patch-heavy, validation-heavy, or stalled task:
  `execution-monitor`.
- Mixed prompt combining bug, security, CSS/UI, docs, release, audit, or tests:
  `task-sequencing` before edits.
- Large patch, multi-file edit, HTML/CSS edit, mojibake, or failed patch
  context: `patch-strategy`.
- Broad or ambiguous task: `scope-control`.
- Shared contract or routing change: `change-impact-analysis`.
- Bug or failing check: `root-cause-analysis`.
- Non-trivial change: `testing`, matching quality gates when relevant, then
  `code-review`.
- Relevant change before completion: run matching gates from
  `QUALITY_GATES.md`, then `release-readiness` when approval, handoff, release,
  or deployment readiness is expected.
- Shell command with write, install, script, or destructive behavior:
  `safe-command-execution`.
- Secrets or credentials: `secrets-management`.
- Auth, roles, or permissions: `authentication`, `permissions-authorization`,
  `security`, `testing`.
- PII, customer data, exports, or logs: `data-privacy`.
- Dependency or lockfile change: `dependency-audit`.
- Dependency or lockfile review before completion: `dependency-review`.
- Python packaging metadata change: `python-packaging`, `dependency-audit`,
  `testing`.
- Async Python change: `async-python`, `testing`.
- Python error or logging change: `python-error-handling` or
  `python-logging`, plus `security` when output may contain sensitive data.
- FastAPI auth change: `fastapi-authentication`, `authentication`,
  `permissions-authorization`, `security`, `testing`.
- FastAPI dependency or validation change: `fastapi-dependencies` or
  `fastapi-validation`, `testing`.
- SQLAlchemy model or session change: `sqlalchemy`, `database-design`,
  `testing`.
- Database migration change: `database-migrations`; add `alembic` when Alembic
  files are present.
- Multi-step database write: `transactions`, `testing`.
- Slow query or N+1 issue: `query-optimization`, `testing`.
- Shared behavior, public contract, schema, migration, or routing change:
  `regression-review`.
- User-facing UI change: `ux-review`; add `accessibility-review` for
  interactive UI.
- Documentation-affecting change: `documentation-review`.
- External or untrusted content: `security`, and `prompt-injection-defense` for
  AI/agent contexts.
- Money movement or balances: `financial-system`, `business-rules`, `testing`.

## Optional Dependencies
- `headroom` for large files, many skills, or long investigations.
- `context-management` for multi-phase work where handoff accuracy matters.
- `performance` only after measurement or a clear performance task.
- `refactoring` only when simplification changes structure.
- `git` only for commits, branches, diffs, status, merges, pushes, or history.
