# Changelog

## Unreleased

- No unreleased changes.

## 1.2.0 - 2026-06-29 (prepared)

- Phase 12: add the Prompt Intelligence foundation module.
- Add `prompt-understanding`, `prompt-normalization`, `prompt-gap-analysis`,
  `task-extraction`, and `success-criteria` skills.
- Update routing docs so vague, short, ambiguous, subjective, mixed, or
  high-risk prompts can be clarified before `skill-orchestrator`.
- Update quality gates to require explicit success criteria for relevant
  tasks.
- Add Execution Control skills: `execution-monitor`, `patch-strategy`, and
  `task-sequencing`.
- Require stopping after 23 minutes without tool or command return, summarizing
  progress, and asking before continuing.
- Require mixed prompts to be split into independent passes, with bug fixes
  before security, UI/CSS, and documentation.
- Forbid large multi-file patches on encoding-sensitive HTML; require smaller
  patches and ASCII anchors after context failures.
- Register post-action verification as a mandatory future improvement; a future
  `result-verification` or `post-action-verification` skill should require
  verifying the real result after any file change, command, installation,
  migration, or configuration change before claiming completion.
- Leave Meta Orchestrator, UI Visual Review, and later prompt roadmap skills
  unimplemented.
- Improve validation warnings for install-excluded directories.

## 1.1.0 - 2026-06-28

- Phase 8: normalize remaining existing skills to the standard
  `SKILL_GUIDELINES.md` structure.
- Phase 9: strengthen routing docs, dependency cooperation, project profiles,
  and quality gate readiness.
- Phase 10: expand specialist coverage for Backend, Frontend, Database,
  Security, Quality, and supporting implementation concerns.
- Phase 11: audit the full pack for release preparation, fix missing skill
  references, strengthen validation, refresh project state, and clean invalid
  source-tree metadata.
- Harden Windows installer path handling and install exclusions.
- Add Windows uninstaller for the local plugin copy and personal marketplace entry.
- Expand validation for required files, skill frontmatter, empty files, JSON parsing, and UTF-8 BOM checks.
- Document install, update, validate, and uninstall workflows.
