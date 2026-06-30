# pam-core Audit Report

- Generated at: 2026-06-30 19:55:50 -03:00
- Validation status: passed
- Claude validation status: passed

## Skill Inventory

- Physical skill directories: 93
- Skill directories with SKILL.md: 93
- Skills represented in SKILL_DEPENDENCIES.md: 93

## Skills Missing SKILL.md

- None

## Missing References

- None

## Accepted Planned Skills

- agent-memory
- ambiguity-resolution
- audit-log
- backup-restore
- billing
- charts
- ci-diagnostics
- ci-quality-gates
- crm-system
- data-import
- documentation
- file-safety
- file-watchers
- intent-classifier
- inventory-system
- local-config
- mcp-server
- meta-orchestrator
- module-planner
- openapi-contracts
- prompt-enhancement
- quality-reporting
- reporting
- rest-api
- risk-classifier
- risk-scoring
- school-system
- skill-authoring
- structured-outputs
- tool-design
- webhooks
- webhook-security
- windows-installer

## Accepted Concepts / Technologies

- api-docs
- changelog
- contract-tests
- docker
- env-config
- evals
- forms
- github-actions
- oauth
- observability
- playwright
- postgres
- pydantic
- pyside
- pytest
- rag
- rbac
- react
- release-notes
- rollback
- runbooks
- smoke-tests
- tables
- tenant-isolation
- tkinter
- user-guides

## Central Files Inspected

- .codex-plugin\plugin.json
- AGENTS.md
- CHANGELOG.md
- CLAUDE.md
- CONTRIBUTING.md
- DECISIONS.md
- docs\INSTALL_CLAUDE.md
- docs\MULTI_AGENT_COMPATIBILITY.md
- MODULES.md
- PROJECT_PROFILES.md
- PROJECT_STATE.md
- QUALITY_GATES.md
- README.md
- scripts\install-windows.ps1
- scripts\uninstall-windows.ps1
- scripts\validate.ps1
- scripts\validate-claude.ps1
- SKILL_DEPENDENCIES.md
- SKILL_GUIDELINES.md
- skills\*\SKILL.md
- VERSIONING.md

## Install-Excluded Directory Warnings

- Install-excluded directory is empty: .agents. It will not be copied by install-windows.ps1; remove it manually if it is leftover local state.
- Install-excluded directory is present: .git (464 item(s)). It will not be copied by install-windows.ps1; keep it only if it is intentional local state.

## Automatically Validated

- Required root files exist.
- Critical text files are UTF-8 without BOM.
- Codex plugin manifest is valid and points to ./skills/.
- Every physical skill directory has valid SKILL.md frontmatter.
- Every SKILL.md contains required headings in the expected order.
- Cooperates With references point to physical skills.
- MODULES.md current Skills sections match physical skills.
- Central backticked references are existing skills, planned skills, concepts / technologies, or known non-skill references.
- SKILL_DEPENDENCIES.md operational table columns reference physical skills only.
- Every physical skill is represented in SKILL_DEPENDENCIES.md.
- Empty files are rejected.
- Marketplace files are UTF-8 without BOM when present.
- Claude integration validation passed.
