---
name: skill-orchestrator
description: Select the right pam-core skills and activation order for each task.
---

# skill-orchestrator

## Purpose
Route each task to the smallest useful set of pam-core specialists.

## Auto Activation
Use after `project-understanding` and before loading domain skills for any task
that touches an existing project, multiple files, architecture, data, UI,
security, AI behavior, or plugin behavior.

## Do Not Activate
Do not use for one-off answers with no project context, trivial command output,
or tasks where the user explicitly names a single skill and no cooperation is
needed.

## Detect
Look for project files, frameworks, routes, scripts, package manifests, database
files, UI assets, plugin manifests, MCP references, money rules, document
workflows, tests, and deployment files.

## Responsibilities
- Identify the project profile from `PROJECT_PROFILES.md`.
- Select only the skills needed for the current task.
- Order selected skills by priority: Critical, High, Medium, Optional.
- Apply dependency rules from `SKILL_DEPENDENCIES.md`.
- Avoid conflicting skills and duplicated responsibilities.
- Prefer shared base skills before narrow domain skills.
- Keep routing decisions short enough to preserve context.

## Never Do
- Load every plausible skill just in case.
- Skip `project-understanding` before editing an existing project.
- Let two skills own the same decision when one should lead.
- Use optional skills when Critical and High skills already cover the task.
- Override user, system, developer, or repository safety rules.

## Cooperates With
project-understanding, ponytail, architecture, security, headroom, testing,
code-review.

## Final Checklist
- Project profile is identified or explicitly unknown.
- Critical skills are loaded first.
- Domain skills match detected files and task risk.
- Conflicts and duplication were avoided.
- Testing and code-review are included for relevant changes.

## Examples
- A FastAPI route change activates `project-understanding`, then
  `skill-orchestrator`, then `security`, `fastapi`, `api-design`, `testing`,
  and `code-review`.
- A PDF folder automation task activates `project-understanding`, then
  `skill-orchestrator`, then `document-system`, `automation-scripts`, `python`,
  `security`, `testing`, and `code-review`.
