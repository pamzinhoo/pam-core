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

## Codex CLI Runtime Cache Adapter

Phase 18.1 observed Codex CLI `0.142.5` on Windows/Git Bash reading `pam-core`
from the personal plugin cache:

```text
~/.codex/plugins/cache/personal/pam-core/1.2.0
```

It did not read from the Phase 15 generic Unix target:

```text
~/.codex/plugins/pam-core
```

The current Codex CLI runtime status is `supported` for this explicit cache
adapter only because Phase 18.2 installed it explicitly and verified it in a
real Codex CLI session. The generic Unix target remains unconfirmed as a
runtime source. A cache target is riskier than a normal install target because
Codex internals may rewrite, ignore, or remove cache contents without treating
them as a stable public install contract.

Install explicitly to the observed runtime cache only when that is the intended
test target:

```bash
bash scripts/install-unix.sh --agent codex-cli --codex-runtime-cache --force
bash scripts/runtime-smoke-test.sh --target "${CODEX_HOME:-$HOME/.codex}/plugins/cache/personal/pam-core/1.2.0"
```

The installer writes `.install-manifest.json` with
`"runtime_cache_target": true` for this mode. This mode is never selected
silently by `--agent codex-cli`; it requires `--codex-runtime-cache`.

To test with a sentinel, create this file in the cache target after installing:

```text
RUNTIME_SENTINEL.md
```

with content:

```text
CODEX_RUNTIME_SENTINEL_PHASE_18_2_CACHE_TARGET
```

Then run a fresh Codex CLI session with:

```text
Procure no pam-core por RUNTIME_SENTINEL.md e informe o conteúdo exato. Também
diga o caminho de onde ele foi lido.
```

Codex CLI must remain `supported` for this explicit cache adapter only while
`RUNTIME_RESULTS.md` records that a fresh runtime session found the sentinel in
the cache target and passed the main smoke prompts from
`SMOKE_TEST_PROMPTS.md`. If a future sentinel test does not find the cache
target, the status must move back to `partial` or to `failed`, depending on
reproducibility.

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

## Evidence Required Before Marking Additional Targets Supported

Do not mark any additional Codex CLI target as `supported` until a real fresh
Codex CLI session is recorded in `RUNTIME_RESULTS.md` or a linked evidence
note. The evidence must show that Codex CLI:

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
- Runtime behavior through Codex CLI is supported only for the explicit runtime
  cache adapter. The generic Unix target is still pending runtime confirmation.
- Existing Windows Codex plugin behavior is supported separately by the
  PowerShell installer and validation scripts.
