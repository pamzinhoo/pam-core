# Contributing

`pam-core` is a personal project, but changes still need a stable process.

## Creating New Skills
- Create new skills only after checking `MODULES.md` and
  `SKILL_DEPENDENCIES.md`.
- Follow `SKILL_GUIDELINES.md`.
- Use lowercase hyphenated names.
- Give each skill one clear lead responsibility.
- Do not duplicate rules owned by another skill.
- Add the skill to the correct module, dependency map, and project profiles when
  relevant.

## Required Review
Before accepting a change:

- Confirm the request is in scope.
- Check that no unrelated project was touched.
- Confirm skill responsibilities do not overlap unnecessarily.
- Check security, privacy, permissions, and destructive command risks.
- Run the smallest useful validation.
- Use `code-review` for non-trivial changes.

## Validations
Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate.ps1
```

For skill changes, also check:

- `SKILL.md` has `name` and `description` frontmatter.
- Required headings match `SKILL_GUIDELINES.md`.
- Descriptions are short and activation-focused.
- Cooperation and conflicts are reflected in `SKILL_DEPENDENCIES.md`.

## Naming Conventions
- Skill folders: lowercase letters, numbers, and hyphens.
- Documents: uppercase descriptive names ending in `.md`.
- Scripts: descriptive PowerShell names ending in `.ps1`.
- Decision IDs: `DEC-001`, `DEC-002`, and so on.

## Acceptance Checklist
- Scope is limited to `pam-core`.
- No plugin reinstall unless explicitly approved.
- No new dependency unless clearly justified.
- New or changed skills follow the standard structure.
- Routing docs are updated when behavior changes.
- Validation passed or the failure is documented.
