# Decisions

Permanent decision log for `pam-core`.

## DEC-001
- Date: 2026-06-28
- Context: The pack needs predictable behavior across many projects.
- Decision: Keep `AGENTS.md` as the routing brain.
- Motive: Codex needs one small entry point before loading specialists.
- Impact: Routing must stay concise and delegate details to dedicated docs.

## DEC-002
- Date: 2026-06-28
- Context: Skills were inconsistent and hard to compare.
- Decision: Require the same nine-section structure for future skills.
- Motive: Consistency improves activation, review, and maintenance.
- Impact: New and updated skills must follow `SKILL_GUIDELINES.md`.

## DEC-003
- Date: 2026-06-28
- Context: The pack must scale beyond a small list of skills.
- Decision: Organize skills by modules, not by project types.
- Motive: Modules make ownership stable while project profiles can change.
- Impact: `MODULES.md` is the source for domain ownership.

## DEC-004
- Date: 2026-06-28
- Context: Loading too many skills wastes context and creates conflicts.
- Decision: Use `skill-orchestrator`, priority levels, and dependency maps.
- Motive: The agent should load only the specialists required by the task.
- Impact: `SKILL_DEPENDENCIES.md` and `PROJECT_PROFILES.md` must stay aligned.

## DEC-005
- Date: 2026-06-28
- Context: Core and Security affect every project.
- Decision: Expand Core and Security before domain-specific modules.
- Motive: Planning, scope, impact, commands, secrets, permissions, and privacy
  reduce risk across all later skills.
- Impact: Later module expansions should depend on these shared skills instead
  of duplicating their rules.

## DEC-006
- Date: 2026-06-28
- Context: The workspace and installed plugin cache can diverge.
- Decision: Do not reinstall the plugin unless explicitly approved.
- Motive: Reinstall changes active tool state and should be user-controlled.
- Impact: Local docs and skills may be newer than the loaded plugin cache.

## DEC-007
- Date: 2026-06-28
- Context: The project needs durable memory across phases.
- Decision: Add project state, decision, versioning, and contribution docs.
- Motive: Future phases need a reliable source of truth.
- Impact: Governance docs must be updated when architecture or process changes.

## DEC-008
- Date: 2026-06-28
- Context: `project-understanding` reads project context and
  `skill-orchestrator` chooses skills, but some decisions should happen before
  technology, stack, module, or skill selection.
- Decision: Record a future Meta Orchestrator layer above
  `project-understanding` and `skill-orchestrator`; do not implement it yet.
- Motive: The pack needs a place to challenge architecture choices early, such
  as whether SQLite is enough, whether SaaS is warranted, whether a technology
  is needed, and whether the proposed path is overengineered.
- Impact: Future design should define this layer before adding a skill. Current
  routing remains unchanged.

## DEC-009
- Date: 2026-06-29
- Context: During a correction to `execution-monitor`, the agent repeatedly
  claimed a file change was applied, but rereading the file showed the target
  line was still unchanged. The issue was resolved only through manual
  CMD/PowerShell correction.
- Decision: Register post-action verification as a mandatory future
  improvement, without creating the skill yet.
- Motive: Agent completion claims must be based on evidence from the final
  state, not on trust that a tool action succeeded.
- Impact: A future `result-verification` or `post-action-verification` skill
  must require verification of the real result after any file change, command,
  installation, migration, or configuration change before the agent says the
  work is complete.

## DEC-010
- Date: 2026-06-29
- Context: `pam-core` needs to be reusable by multiple agents, starting with
  Codex and Claude Code, without breaking the current Codex installation.
- Decision: Keep one shared core and expose it through thin agent adapters.
- Motive: A single `skills/` directory and shared governance docs avoid drift
  between agents while allowing each agent to keep its own manifest and
  entrypoint.
- Impact: Do not duplicate `skills/` for agent-specific formats. Codex remains
  on `AGENTS.md` and `.codex-plugin/plugin.json`; Claude Code starts with
  `CLAUDE.md` and `.claude-plugin/plugin.json`.

## DEC-011
- Date: 2026-06-30
- Context: Governance docs need to mention physical skills, future skill ideas,
  and technologies without making validation ambiguous.
- Decision: Keep `SKILL_DEPENDENCIES.md` as an operational map of existing
  physical skills only. Keep roadmap skills, technologies, and conceptual
  references classified in `MODULES.md`.
- Motive: Validation should be able to distinguish real skill dependencies from
  future work and non-skill concepts.
- Impact: References to missing skill-like names are accepted only when they are
  explicitly classified as Planned skills or Concepts / technologies.
