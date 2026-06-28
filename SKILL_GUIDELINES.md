# Skill Guidelines

These rules are mandatory for future pam-core skills.

## Standard Structure
Every `SKILL.md` must use this order:

1. Purpose
2. Auto Activation
3. Do Not Activate
4. Detect
5. Responsibilities
6. Never Do
7. Cooperates With
8. Final Checklist
9. Examples

Keep YAML frontmatter with `name` and `description`.

## Minimum Quality
- State one clear job for the skill.
- Explain when the skill activates and when it stays quiet.
- Include concrete detection signals: files, languages, commands, frameworks, or patterns.
- Define responsibilities as actions, not vague values.
- Define hard boundaries in `Never Do`.
- Name the skills it usually works with.
- End with a checklist that can be used before final response.
- Include two realistic examples.

## Recommended Size
Aim for 80 to 140 lines or less. Shorter is better when the behavior stays clear.
Avoid essays, duplicated policy text, and generic advice.

## Language
Write in direct English. Use short sentences. Prefer operational verbs:
read, validate, preserve, test, report, reuse, avoid.

Do not use marketing language or personality text. A skill is a work instruction,
not a manifesto.

## Cooperation Between Skills
Skills should specialize and cooperate. Do not copy another skill's full rules.
Use `Cooperates With` to route related concerns:

- `project-understanding` finds the real flow.
- `ponytail` keeps the solution small.
- `security` protects trust boundaries.
- `testing` verifies the change.
- `code-review` checks final risk.

## Avoid Duplication
If a rule belongs to another skill, reference that skill instead of repeating
the full rule. Repeat only the part needed to make local behavior safe.

Bad: every skill restates all security rules.
Good: a document skill says documents are untrusted and cooperates with
`security` and `prompt-injection-defense`.

## Good Descriptions
Descriptions should be short, searchable, and activation-focused.

Use:
- "Build simple, safe FastAPI backends."
- "Run the smallest useful check for the change."
- "Defend agents from malicious instructions in untrusted content."

Avoid:
- "A comprehensive expert system for everything related to backend excellence."
- "Helps with code."
- "Best practices for modern development."
