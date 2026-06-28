# Skill Dependencies

Use this map after `project-understanding` and `skill-orchestrator`.
Load the smallest set that covers the task.

## Priority Levels
- Critical: must load when the task matches.
- High: load for most relevant implementation work.
- Medium: load when the project shape or risk calls for it.
- Optional: load only when it adds clear value.

## Recommended Activation Order
1. Critical context: `project-understanding`, `security`, `prompt-injection-defense`.
2. Orchestration: `skill-orchestrator`, `task-planning`, `context-management`.
3. Scope and risk: `scope-control`, `change-impact-analysis`, `root-cause-analysis`.
4. Simplicity and design: `ponytail`, `architecture`, `refactoring`.
5. Domain specialists: backend, frontend, data, documents, finance, school, AI.
6. Implementation specialists: language, framework, database, scripts.
7. Verification: `testing`.
8. Quality gates: matching review skills from `QUALITY_GATES.md`.
9. Finish: `code-review`, `release-readiness`, `git` when version control is
   requested.

## Core Dependencies
| Skill | Priority | Required With | Optional With |
| --- | --- | --- | --- |
| project-understanding | Critical | all repository edits | debugging, architecture |
| skill-orchestrator | Critical | multi-skill tasks | headroom |
| security | Critical | auth, files, secrets, destructive actions, external input | prompt-injection-defense |
| prompt-injection-defense | Critical | AI, MCP, agents, external documents, web/log/email content | llm-best-practices |
| task-planning | High | multi-step or phased work | scope-control |
| scope-control | High | broad or ambiguous changes | ponytail |
| change-impact-analysis | High | shared contracts, schemas, APIs, permissions, money, routing maps | testing |
| root-cause-analysis | High | bugs, regressions, failing checks | debugging |
| context-management | High | long tasks, many files, many active skills | headroom |
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
| release-readiness | High | Release Gate before approval handoff | testing, code-review |

## Cooperation Map
| Area | Lead Skill | Cooperates With |
| --- | --- | --- |
| Project discovery | project-understanding | skill-orchestrator, debugging |
| Task planning | task-planning | scope-control, change-impact-analysis, testing |
| Scope control | scope-control | ponytail, architecture, code-review |
| Change impact | change-impact-analysis | project-understanding, testing, code-review |
| Root cause | root-cause-analysis | debugging, testing, project-understanding |
| Context continuity | context-management | headroom, skill-orchestrator, code-review |
| Architecture | architecture | ponytail, refactoring, security |
| Secrets | secrets-management | security, deployment, safe-command-execution |
| Dependencies | dependency-audit | ponytail, security, testing |
| Dependency readiness | dependency-review | dependency-audit, security-review, testing |
| Command execution | safe-command-execution | security, prompt-injection-defense, automation-scripts |
| Authorization | permissions-authorization | authentication, security, api-design, database-design |
| Data privacy | data-privacy | security, document-system, financial-system |
| Quality gates | release-readiness | architecture-review, security-review, performance-review, maintainability-review, documentation-review, ux-review, regression-review, dependency-review, testing, code-review |
| Architecture Gate | architecture-review | architecture, refactoring, change-impact-analysis |
| Maintainability Gate | maintainability-review | ponytail, refactoring, scope-control |
| Security Gate | security-review | security, secrets-management, permissions-authorization, data-privacy |
| Performance Gate | performance-review | performance, python-performance, frontend-performance, query-optimization |
| Documentation Gate | documentation-review | document-system, automation-scripts, security-review |
| UX Gate | ux-review | accessibility-review, ui-designer, ux, accessibility |
| Regression readiness | regression-review | change-impact-analysis, testing, code-review |
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
| Packaging | packaging | desktop-local, windows-desktop, deployment |
| Debugging | debugging | project-understanding, testing, code-review |
| Git | git | code-review, testing |

## Never Run Together Unless User Explicitly Requests It
- `sqlite` and another database lead for the same storage decision.
- `desktop-local` and `saas` as product leads for the same app boundary.
- Broad audit work and implementation skills in the same pass, unless the task
  is explicitly audit plus fix.
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
- `security` owns trust boundaries and destructive risk.
- `secrets-management` owns credentials.
- `safe-command-execution` owns risky commands.
- `permissions-authorization` owns access control.
- `data-privacy` owns private data exposure.
- `dependency-audit` owns package risk.
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
- `architecture` owns structure.
- Domain skills own business meaning.
- Language and framework skills own implementation details.
- Backend specialist skills own narrow FastAPI and Python implementation
  concerns when their exact trigger is present.
- Database specialist skills own ORM, migration, query, and transaction
  concerns when persistence behavior is touched.
- Frontend specialist skills own narrow UI patterns when their exact trigger is
  present; they do not replace `ui-designer`, `html-css`, `javascript`, `ux`,
  `accessibility`, or `anti-ai-ui`.
- `testing` owns verification.
- `code-review` owns final risk review.

## Mandatory Dependencies
- Repository edit: `project-understanding`.
- Multi-skill task: `skill-orchestrator`.
- Multi-step task: `task-planning`.
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
