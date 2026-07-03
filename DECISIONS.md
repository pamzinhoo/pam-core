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

## DEC-012
- Date: 2026-07-01
- Context: `pam-core` needs Linux/macOS installation support for Claude Code,
  Codex CLI, Codex App, and generic compatible agents without changing the
  shared skill architecture.
- Decision: Add Unix install, validate, detect, and uninstall scripts as a thin
  copy layer over the existing shared core.
- Motive: Unix support should make local installation repeatable while avoiding
  duplicated skills or agent-specific generated exports.
- Impact: Unix targets are selected by conservative detection or explicit
  `--target`; uninstall is allowed only when `.install-manifest.json` proves the
  target was created by the Unix installer.

## DEC-013
- Date: 2026-07-01
- Context: File installation and validation can prove that a `pam-core` target
  contains the shared core, but they cannot prove that Claude Code, Codex CLI,
  Codex App, or a generic agent actually loaded and followed it in a model
  session.
- Decision: Track runtime compatibility separately from installation
  compatibility and require manual smoke-test evidence before marking runtime
  support as confirmed.
- Motive: Different agents load instructions, plugins, and local files through
  different mechanisms. A script must not pretend to validate model behavior.
- Impact: Runtime docs use explicit states such as `supported`, `partial`,
  `manual`, `pending`, and `unknown`. `scripts/runtime-smoke-test.sh` checks
  required files only; it does not test AI behavior.

## DEC-014
- Date: 2026-07-01
- Context: `pam-core` needs distributable release archives that do not require a
  full repository clone and do not leak local source-control or cache state.
- Decision: Build release packages from an explicit allowlist, include
  `PACKAGE_MANIFEST.json` in every archive, and write SHA256 checksums in
  `dist/CHECKSUMS.txt`.
- Motive: Distribution should be reproducible and clean while remaining
  separate from runtime installation and runtime confirmation.
- Impact: Packages must exclude `.git`, `dist`, caches, logs, temporary files,
  and personal local artifacts. Package manifests keep
  `runtime_pending` true until real runtime evidence is recorded.

## DEC-015
- Date: 2026-07-01
- Context: Phase 18.1 showed Codex CLI runtime loading `pam-core` from the
  personal plugin cache, not from the generic Unix target
  `~/.codex/plugins/pam-core`.
- Decision: Support Codex CLI runtime installation through an explicit
  `--codex-runtime-cache` adapter that targets the observed cache path. Never
  select this cache target silently.
- Motive: Runtime support must match the path the agent actually reads while
  keeping cache writes visible, reversible, and validated.
- Impact: The generic Unix Codex target remains available for file installation
  tests, but supported Codex CLI runtime evidence applies only to the explicit
  cache adapter until another source path is proven.

## DEC-016
- Date: 2026-07-02
- Context: The Python package metadata reported `1.0.0` while Codex and Claude
  plugin manifests, project state, release docs, and the API Server reported
  `1.2.0`.
- Decision: Use the root `VERSION` file as the official version source.
- Motive: Existing install and packaging scripts already prioritize `VERSION`
  when present, and Python packaging can read the same file through dynamic
  metadata.
- Impact: `pyproject.toml` must read its version from `VERSION`. Plugin
  manifests and project state keep explicit version fields for host
  compatibility, but tests must verify they match `VERSION`. API endpoints must
  return the `VERSION` value.
