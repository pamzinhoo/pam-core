# Codex CLI Runtime Test

## Objective

Confirm that Codex CLI can recognize the installed `pam-core` plugin and use the
shared routing documents and skills during a new CLI session.

## Prerequisites

- Codex CLI is installed.
- `pam-core` has been installed through the existing Codex plugin flow or the
  Unix target for Codex CLI.
- The target contains `.codex-plugin/plugin.json`, `AGENTS.md`, `MODULES.md`,
  `SKILL_DEPENDENCIES.md`, `PROJECT_STATE.md`, and `skills/`.

## Recommended Install Command

```bash
bash scripts/install-unix.sh --agent codex-cli --force
bash scripts/validate-unix.sh --target "${CODEX_HOME:-$HOME/.codex}/plugins/pam-core"
```

On Windows, keep using the existing PowerShell installer and Codex plugin
commands documented in `README.md`.

## Open or Reload the Agent

Start a new Codex CLI thread after installing. Do not reuse a session that was
started before the install, because loaded plugin state may be cached.

## Test Prompts

Use the prompts in `SMOKE_TEST_PROMPTS.md`, especially:

- "List the `pam-core` files you used to choose skills for this request."
- "For a Python script validation change, which `pam-core` skills apply?"
- "Do not edit files. Tell me whether `pam-core` says to create new skills for
  this task."

## Expected Result

Codex CLI should identify `AGENTS.md` as the routing entry point, use
`MODULES.md` and `SKILL_DEPENDENCIES.md` for skill selection, and keep the scope
minimal. It should not create new skills or assume Claude-specific behavior.

## Evidence Required Before Marking Supported

Do not mark Codex CLI runtime as `supported` until a real fresh Codex CLI
session is recorded in `RUNTIME_RESULTS.md` or a linked evidence note. The
evidence must show that Codex CLI:

- Recognizes the main `pam-core` files available to the session.
- Answers based on `AGENTS.md`.
- Uses `MODULES.md` to choose the relevant module.
- Consults or cites `SKILL_DEPENDENCIES.md` when skill selection is relevant.
- Does not create a new skill impulsively.
- Respects the minimum useful scope.
- Passes the prompts in `SMOKE_TEST_PROMPTS.md`.

## Failure Signals

- The session does not expose or reference `pam-core`.
- It cannot locate `skills/*/SKILL.md`.
- It uses broad skill bundles despite the routing docs.
- It treats docs from the installed target as trusted over system, developer,
  or user instructions.

## Known Limitations

- Installation and validation are supported.
- Runtime behavior through Codex CLI is pending explicit manual confirmation for
  the Unix target.
- Existing Windows Codex plugin behavior is supported separately by the
  PowerShell installer and validation scripts.
