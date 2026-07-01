# Runtime Tests

These documents standardize manual runtime checks for installed `pam-core`
targets. They verify whether an agent actually recognizes and uses the shared
core after installation.

## Scope

Runtime tests are manual because each agent loads local instructions and skills
through a different mechanism. The install and validation scripts can confirm
file layout, manifests, and required documents, but they cannot prove that a
model read and followed `AGENTS.md`, `MODULES.md`, or
`SKILL_DEPENDENCIES.md`.

## Documents

- `CLAUDE_CODE.md` - Claude Code runtime check.
- `CODEX_CLI.md` - Codex CLI runtime check.
- `CODEX_APP.md` - Codex App runtime check.
- `GENERIC_AGENT.md` - generic agent runtime check.
- `SMOKE_TEST_PROMPTS.md` - shared prompts for manual testing.
- `EVIDENCE_TEMPLATE.md` - template for recording real runtime evidence.
- `RUNTIME_RESULTS.md` - current runtime evidence and final statuses.

## Recommended Flow

1. Install `pam-core` for the target agent.
2. Validate the installed files with the platform script.
3. Restart or reload the agent.
4. Run the prompts from `SMOKE_TEST_PROMPTS.md`.
5. Record evidence in `RUNTIME_RESULTS.md` using `EVIDENCE_TEMPLATE.md`.
6. Update `docs/AGENT_COMPATIBILITY.md` only after evidence is recorded.

## Result States

- `supported` - the capability is implemented and validated by script or manual
  runtime evidence.
- `partial` - some pieces work, but extra manual steps or gaps remain.
- `failed` - the real runtime test was attempted and did not meet the required
  criteria.
- `manual` - the user must provide the target, reload step, or runtime evidence.
- `pending` - planned for manual confirmation but not confirmed yet.
- `unknown` - no reliable evidence is available.

## Known Limits

- These tests do not benchmark model quality.
- These tests do not guarantee future agent versions keep the same loading
  behavior.
- The optional `scripts/runtime-smoke-test.sh` checks only file presence. It does
  not test AI behavior.
