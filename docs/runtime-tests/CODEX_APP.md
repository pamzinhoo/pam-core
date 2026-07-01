# Codex App Runtime Test

## Objective

Confirm that Codex App can load the installed `pam-core` shared core from the
platform-specific app configuration target.

## Prerequisites

- Codex App is installed.
- `pam-core` has been installed to the Codex App target.
- The target contains `.codex-plugin/plugin.json`, `AGENTS.md`, `MODULES.md`,
  `SKILL_DEPENDENCIES.md`, `PROJECT_STATE.md`, and `skills/`.

## Recommended Install Command

Linux:

```bash
bash scripts/install-unix.sh --agent codex-app --force
bash scripts/validate-unix.sh --target "${XDG_CONFIG_HOME:-$HOME/.config}/codex/plugins/pam-core"
```

macOS:

```bash
bash scripts/install-unix.sh --agent codex-app --force
bash scripts/validate-unix.sh --target "$HOME/Library/Application Support/Codex/plugins/pam-core"
```

## Open or Reload the Agent

Quit Codex App completely and open it again after installation. Start a new
conversation or workspace after the app restarts.

## Test Prompts

Use the prompts in `SMOKE_TEST_PROMPTS.md`, especially:

- "Do you have access to `pam-core` runtime instructions in this app session?"
- "Which module owns frontend UI decisions in `pam-core`?"
- "For a runtime compatibility documentation task, what is the smallest useful
  skill set?"

## Expected Result

Codex App should use the shared core and thin Codex adapter. It should separate
installation support from runtime confirmation and mark unknown runtime behavior
as pending unless the app session demonstrates it.

## Evidence Required Before Marking Supported

Do not mark Codex App runtime as `supported` until a real Codex App session is
recorded in `RUNTIME_RESULTS.md` or a linked evidence note. The evidence must
show that Codex App:

- Recognizes the main `pam-core` files available to the session.
- Answers based on `AGENTS.md`.
- Uses `MODULES.md` to choose the relevant module.
- Consults or cites `SKILL_DEPENDENCIES.md` when skill selection is relevant.
- Does not create a new skill impulsively.
- Respects the minimum useful scope.
- Passes the prompts in `SMOKE_TEST_PROMPTS.md`.

## Failure Signals

- The app does not pick up the installed target after restart.
- It treats Codex App and Codex CLI targets as identical without checking the
  configured path.
- It claims all agents load plugins the same way.
- It cannot refer to `MODULES.md` or `SKILL_DEPENDENCIES.md`.

## Known Limitations

- The default target is platform-specific.
- Runtime loading is pending manual confirmation.
- App-specific cache or plugin registration behavior may require additional
  steps after practical testing.
