# pam-core Audit Report

- Generated at: 2026-07-01 20:31:13 -03:00
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
- docs\AGENT_COMPATIBILITY.md
- docs\INSTALL_CLAUDE.md
- docs\INSTALL_LINUX.md
- docs\INSTALL_MACOS.md
- docs\KNOWN_LIMITATIONS.md
- docs\LINUX_TEST_PLAN.md
- docs\MULTI_AGENT_COMPATIBILITY.md
- docs\PACKAGING.md
- docs\RELEASE_READINESS.md
- docs\runtime-tests\CLAUDE_CODE.md
- docs\runtime-tests\CODEX_APP.md
- docs\runtime-tests\CODEX_CLI.md
- docs\runtime-tests\EVIDENCE_TEMPLATE.md
- docs\runtime-tests\GENERIC_AGENT.md
- docs\runtime-tests\README.md
- docs\runtime-tests\RUNTIME_RESULTS.md
- docs\runtime-tests\SMOKE_TEST_PROMPTS.md
- docs\USAGE.md
- MODULES.md
- PROJECT_PROFILES.md
- PROJECT_STATE.md
- QUALITY_GATES.md
- README.md
- scripts\detect-agent.sh
- scripts\install-unix.sh
- scripts\install-windows.ps1
- scripts\package-release.ps1
- scripts\package-release.sh
- scripts\runtime-smoke-test.sh
- scripts\uninstall-unix.sh
- scripts\uninstall-windows.ps1
- scripts\validate.ps1
- scripts\validate-claude.ps1
- scripts\validate-package.ps1
- scripts\validate-package.sh
- scripts\validate-unix.sh
- SKILL_DEPENDENCIES.md
- SKILL_GUIDELINES.md
- skills\*\SKILL.md
- VERSIONING.md

## Install-Excluded Directory Warnings

- Install-excluded directory is empty: .agents. It will not be copied by install-windows.ps1; remove it manually if it is leftover local state.
- Install-excluded directory is present: .git (520 item(s)). It will not be copied by install-windows.ps1; keep it only if it is intentional local state.

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
- Unix shell scripts exist, use bash shebangs, use set -euo pipefail, and use LF line endings.
- Runtime compatibility test documents exist.
- Claude integration validation passed.
