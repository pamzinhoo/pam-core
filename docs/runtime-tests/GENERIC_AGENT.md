# Generic Agent Runtime Test

## Objective

Confirm that an agent without a native `pam-core` adapter can still use the
shared core when pointed at the installed files.

## Prerequisites

- The agent can read local files from an explicit directory.
- `pam-core` has been installed to a known target.
- The target contains `AGENTS.md`, `MODULES.md`, `SKILL_DEPENDENCIES.md`,
  `PROJECT_STATE.md`, and `skills/`.

## Recommended Install Command

```bash
bash scripts/install-unix.sh --agent generic --target "$HOME/pam-core" --force
bash scripts/validate-unix.sh --target "$HOME/pam-core"
```

Use another explicit `--target` if the agent requires a different directory.

## Open or Reload the Agent

Configure the agent to read the installed target as context or project
instructions. Start a fresh session after the files are available.

## Test Prompts

Use the prompts in `SMOKE_TEST_PROMPTS.md`, especially:

- "Read `AGENTS.md`, `MODULES.md`, and `SKILL_DEPENDENCIES.md` from the
  installed `pam-core` target before answering."
- "Which existing `pam-core` skills apply to a docs-only compatibility update?"
- "If you cannot read a file, say that explicitly instead of guessing."

## Expected Result

The agent should use the shared routing docs as context, say when it cannot
read a required file, and avoid inventing agent-specific loading behavior.

## Evidence Required Before Marking Supported

Do not mark a generic agent runtime as `supported` until a real session for that
specific agent is recorded in `RUNTIME_RESULTS.md` or a linked evidence note.
The evidence must show that the generic agent:

- Recognizes the main `pam-core` files available to the session.
- Answers based on `AGENTS.md`.
- Uses `MODULES.md` to choose the relevant module.
- Consults or cites `SKILL_DEPENDENCIES.md` when skill selection is relevant.
- Does not create a new skill impulsively.
- Respects the minimum useful scope.
- Passes the prompts in `SMOKE_TEST_PROMPTS.md`.

## Failure Signals

- The agent cannot read the installed target.
- It hallucinates a plugin mechanism for its runtime.
- It claims runtime support is confirmed without a manual session result.
- It creates or requests new skills for compatibility testing.

## Known Limitations

- Generic mode is manual by design.
- There is no universal plugin registration path for generic agents.
- Runtime confirmation depends on the agent's own context-loading features.
