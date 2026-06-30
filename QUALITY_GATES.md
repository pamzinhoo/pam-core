# Quality Gates

Quality gates are the checks a relevant change passes before it is treated as
complete. They do not replace implementation skills, `testing`, or
`code-review`. They make the pass/fail criteria explicit.

Use only the gates that match the change. A small documentation edit may need
Documentation and Release gates only. A security-sensitive API change may need
all gates.

## Operating Boundaries

- Implementation skills make or guide changes; review skills only assess gate
  pass/fail status, risk, or readiness.
- `testing` owns verification command selection, execution evidence, and skipped
  check disclosure.
- `code-review` owns the final general risk review after implementation,
  verification, and relevant gates.
- `release-readiness` owns only approval, handoff, release, packaging, or
  deployment readiness. Do not use it as a replacement for `testing`,
  `code-review`, or individual gate review skills.

## Architecture Gate

### Objective
Confirm the change preserves clear ownership, boundaries, and dependency
direction.

### When To Run
Run for module changes, shared abstractions, routing maps, public contracts,
folder movement, or broad refactors.

### Approval Criteria
- The affected boundary is named.
- One component owns each responsibility.
- New abstractions remove real complexity.
- Dependency direction remains understandable.

### Rejection Criteria
- The change creates duplicate ownership.
- A speculative layer or broad rewrite is introduced without need.
- Public contracts or routing become ambiguous.

### Participating Skills
`architecture-review`, `architecture`, `refactoring`, `ponytail`,
`change-impact-analysis`, `code-review`.

## Security Gate

### Objective
Confirm trust boundaries, secrets, permissions, and destructive actions remain
safe.

### When To Run
Run for auth, authorization, secrets, external input, files, shell commands,
dependencies, uploads, exports, logs, webhooks, or agent/tool behavior.

### Approval Criteria
- Changed trust boundaries are identified.
- Validation and authorization remain authoritative.
- Secrets and private data are not exposed.
- Destructive operations are explicit and constrained.

### Rejection Criteria
- Secrets, tokens, or private data may be printed or logged.
- Authorization depends only on client-side checks.
- Input validation is weakened.
- Destructive behavior is implicit or too broad.

### Participating Skills
`security-review`, `security`, `secrets-management`,
`permissions-authorization`, `data-privacy`, `prompt-injection-defense`,
`dependency-review`, `testing`, `code-review`.

## Performance Gate

### Objective
Confirm the change does not introduce unacceptable latency, memory, query, UI,
or resource usage risk.

### When To Run
Run for hot paths, database queries, large data loops, startup work, network
payloads, file processing, rendering changes, or explicit performance work.

### Approval Criteria
- Likely hot paths and data-size behavior are considered.
- Pagination, batching, lazy loading, or caching needs are addressed where
  relevant.
- Existing measurements or focused checks are used when available.

### Rejection Criteria
- The change adds unbounded work to likely hot paths.
- It creates obvious N+1 queries or full-data loads.
- It adds unsafe caching or stale authorization behavior.
- Performance claims are made without evidence.

### Participating Skills
`performance-review`, `performance`, `python-performance`,
`frontend-performance`, `query-optimization`, `testing`, `code-review`.

## Maintainability Gate

### Objective
Confirm the change remains readable, focused, and easy to modify.

### When To Run
Run for multi-file edits, duplicated logic, new helpers, config changes,
complex conditionals, or code likely to be reused.

### Approval Criteria
- The diff is locally understandable.
- Names describe behavior and domain meaning.
- Comments explain only non-obvious intent.
- Duplication and complexity are acceptable for the risk.

### Rejection Criteria
- Responsibilities are mixed without reason.
- The same logic is duplicated in risky places.
- New flexibility is unused or speculative.
- The change is hard to debug or extend safely.
- Functional bug fixes, security work, and CSS/UI polish were mixed in one edit
  round without sequencing.
- A large multi-file patch was applied where small patches were practical.

### Participating Skills
`maintainability-review`, `ponytail`, `refactoring`, `scope-control`,
`task-sequencing`, `patch-strategy`, `execution-monitor`, `testing`,
`code-review`.

## Testing Gate

### Objective
Confirm the change was verified with checks that match its risk.

### When To Run
Run after non-trivial code, config, behavior, workflow, migration, security,
money, parsing, file, or UI changes.

### Approval Criteria
- The smallest useful check is selected and run.
- Relevant success criteria are defined before execution.
- New risky logic has focused coverage when practical.
- Relevant failures are investigated or reported.
- Skipped checks are disclosed.

### Rejection Criteria
- Required checks were skipped without explanation.
- Test results are claimed without execution.
- Related failures are ignored.
- High-risk behavior has no verification path.
- A command, tool, or validation had no return for more than 23 minutes and the
  task continued without stopping, summarizing, and asking for confirmation.
- The same validation or review loop repeated without new evidence.

### Participating Skills
`testing`, `success-criteria`, `execution-monitor`, `regression-review`,
`security-review`, `performance-review`, `code-review`.

## Documentation Gate

### Objective
Confirm documentation affected by the change is accurate and actionable.

### When To Run
Run for new skills, changed commands, APIs, setup, configuration, public
behavior, operational procedures, releases, or standards.

### Approval Criteria
- Affected docs are identified.
- New or changed skills include explicit success criteria where task completion
  could otherwise be ambiguous.
- Commands, file names, examples, and behavior match the change.
- Documentation stays concise and points to owning skills or modules.
- No sensitive data or unsafe instructions are exposed.

### Rejection Criteria
- Required docs are missing or stale.
- Examples or commands are inaccurate.
- Docs duplicate full specialist rules.
- Documentation exposes secrets or dangerous actions.

### Participating Skills
`documentation-review`, `document-system`, `automation-scripts`,
`security-review`, `testing`, `code-review`.

## UX Gate

### Objective
Confirm user-facing changes support clear, accessible, recoverable workflows.

### When To Run
Run for screens, forms, tables, dashboards, navigation, copy, states, modals,
destructive UI actions, and any user-visible workflow.

### Approval Criteria
- The primary workflow is visible and efficient.
- Success criteria include user-visible outcome checks, not only technical file
  changes.
- Empty, loading, error, and success states are usable where relevant.
- Labels and actions match user intent.
- Interactive controls meet practical accessibility requirements.

### Rejection Criteria
- Users cannot recover from common errors.
- Destructive actions are unclear.
- Required states are missing.
- Keyboard, focus, label, contrast, or semantic blockers remain.

### Participating Skills
`ux-review`, `accessibility-review`, `success-criteria`, `ux`, `ui-designer`,
`accessibility`, `anti-ai-ui`, frontend specialists, `testing`, `code-review`.

## Release Gate

### Objective
Confirm the change is ready for user approval, handoff, release, or deployment.

### When To Run
Run when the task is being handed off for approval or treated as release-ready,
especially for deployable changes, packaging, plugin updates, migrations,
user-visible behavior, or operational changes.

### Approval Criteria
- Required gates have known pass/fail status.
- Success criteria are passed, failed, or explicitly unverified.
- Validation results are known.
- Blockers and follow-up work are separated.
- Rollback, migration, or handoff notes exist when needed.

### Rejection Criteria
- Required gates are unknown.
- Validation was not run or failed without resolution.
- Release blockers are hidden as follow-ups.
- Deployment or approval is implied without user request.
- The task stayed long-running without visible progress control.
- Main requested items were complete but optional scope continued instead of
  listing residual risks.

### Participating Skills
`release-readiness`, `testing`, `code-review`, `documentation-review`,
`security-review`, `regression-review`, `deployment`, `packaging`, `git`.
