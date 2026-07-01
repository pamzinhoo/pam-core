# Changelog

## Unreleased

- Phase 20: add release-facing documentation for usage, Linux host testing,
  known limitations, and 1.2.0 release readiness.
- Add `docs/USAGE.md`, `docs/LINUX_TEST_PLAN.md`,
  `docs/KNOWN_LIMITATIONS.md`, and `docs/RELEASE_READINESS.md`.
- Link release readiness docs from `README.md`, include them in package
  allowlists, and require them in validation.
- Keep Codex CLI supported only through `--codex-runtime-cache`, keep Claude
  Code and Codex App pending, keep generic agents manual, and keep native
  Linux/WSL/macOS pending without new evidence.
- Phase 19: verify remaining runtime and native OS status after Phase 18.2
  without changing architecture or creating skills.
- Preserve Codex CLI runtime support only for the explicit
  `--codex-runtime-cache` adapter; keep the generic Codex CLI Unix target
  unconfirmed as a runtime source.
- Record Claude Code discovery: `claude` and `claude.cmd` were not available in
  PowerShell or Git Bash, while `~/.claude` and `~/.claude/plugins` existed;
  Claude Code remains pending because no real runtime session could be run.
- Record Codex App discovery: only Codex CLI/cache paths were found and no
  separate app session was observable; Codex App remains pending.
- Record environment limits: Git Bash on Windows was available, WSL was not
  installed, and no Linux native or macOS native host validation was possible.
- Phase 18.2: add an explicit Codex CLI runtime cache adapter with
  `--codex-runtime-cache` for install and uninstall.
- Validate the adapter by installing to the observed Codex CLI personal plugin
  cache, reading a cache sentinel from a real `codex exec` session, and running
  the main smoke prompts with a focused FastAPI routing retest.
- Mark Codex CLI runtime as `supported` for the explicit cache adapter only;
  keep global runtime pending for Claude Code and Codex App.
- Phase 18.1: verify Codex CLI runtime source of truth with target/cache
  sentinel probes.
- Record that Codex CLI read `pam-core` from the personal plugin cache, did not
  read a target-only sentinel, did not propagate the sentinel from target to
  cache, did not recreate cache from target, and still worked with the target
  renamed away.
- Keep Codex CLI runtime status `partial`; the Phase 15 Unix target is file
  validated but not proven as the runtime source.
- Phase 18: start real agent runtime verification and record partial Codex CLI
  evidence from a fresh `codex exec` session on Windows/Git Bash.
- Install, validate, and smoke-test the Codex CLI Unix target
  `~/.codex/plugins/pam-core`; keep Codex CLI runtime as `partial` because the
  observed session loaded `pam-core` from the Codex personal plugin cache
  rather than proving the Unix target as the active source.
- Keep Claude Code and Codex App runtime statuses pending; Claude Code was not
  available on PATH in this environment and no Codex App runtime session was
  observed.
- Phase 17.1: validate the Bash packaging path under Git Bash, including Unix
  script validation, package generation, package validation, checksum
  verification, and PowerShell/Bash package-content comparison for required
  release criteria.
- Record that WSL was not installed in the validation environment and no
  separate native Linux or macOS host run was recorded.
- Phase 17: add versioned distribution packaging for zip and tar.gz artifacts in
  `dist/`, with package manifests, SHA256 checksums, and package validators.
- Add `docs/PACKAGING.md` with Windows, Linux, and macOS packaging and
  validation instructions.
- Keep package runtime status honest with `runtime_pending: true` until real
  runtime evidence is recorded.
- Phase 16.1: add formal runtime evidence records with
  `docs/runtime-tests/RUNTIME_RESULTS.md` and
  `docs/runtime-tests/EVIDENCE_TEMPLATE.md`.
- Require per-agent evidence before marking runtime support as `supported`, and
  keep Claude Code, Codex CLI, Codex App, and generic runtime statuses pending
  or manual until real sessions are recorded.
- Extend runtime docs, Unix validation, and PowerShell validation to require the
  runtime evidence files.
- Phase 16: add runtime compatibility test runbooks for Claude Code, Codex CLI,
  Codex App, and generic agents, plus shared smoke-test prompts.
- Add a runtime compatibility matrix that separates installation, detection,
  file validation, and real runtime confirmation states.
- Add `scripts/runtime-smoke-test.sh` to verify that an installed target has the
  files needed for a manual runtime smoke test without pretending to test AI
  behavior.
- Extend Unix and PowerShell validation to require the runtime test
  documentation and smoke checker.
- Phase 15: add Linux/macOS installation, validation, detection, and
  manifest-guarded uninstall scripts for Claude Code, Codex CLI, Codex App, and
  generic compatible agents.
- Add Unix installation docs for Linux, macOS, and agent compatibility without
  changing the shared `skills/` architecture or removing Windows scripts.
- Extend Windows validation to check Unix script presence, LF line endings, and
  documentation files without executing bash on Windows.
- Phase 14: normalize skill references across governance docs so physical
  skills, planned skills, and concepts / technologies are classified
  explicitly.
- Keep `SKILL_DEPENDENCIES.md` as an operational map for existing physical
  skills only, with roadmap and technology references classified in
  `MODULES.md`.
- Harden `scripts/validate.ps1` to reject unclassified missing skill-like
  references and verify `SKILL_DEPENDENCIES.md` against the physical skill
  inventory.
- Generate `docs/audit-report.md` during validation, including skill inventory,
  accepted planned skills, accepted concepts / technologies, and install
  exclusion warnings.
- Validate the post-install state across checkout, local package, and Codex
  cache: 93 skills, 117 compared files after install exclusions, and zero
  missing files, extra files, or content diffs.
- Confirm `.git` and `.agents` are not distributed, while `docs/audit-report.md`
  is present in both the local package and Codex cache.
- Phase 13 base: add initial multi-agent compatibility with one shared core and
  thin adapters.
- Add `CLAUDE.md` and `.claude-plugin/plugin.json` as the initial Claude Code
  adapter.
- Add `scripts/validate-claude.ps1` and run it from `scripts/validate.ps1`
  after the existing Codex package checks.
- Add multi-agent, Codex, Claude Code, and generic installation documentation.
- Keep existing Codex adapter, install scripts, and `skills/` layout unchanged.

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
