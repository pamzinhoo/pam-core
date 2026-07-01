# Runtime Evidence Template

Copy this template into `RUNTIME_RESULTS.md` notes or a linked evidence record
after running a real agent session.

## Test Metadata

- Agent tested:
- Agent version:
- Operating system:
- Test date:
- Tester:

## Install and Validation

- Install command used:
- Validation command used:
- Target used:
- File smoke command used:
- File smoke result:

## Runtime Session

- Reload or restart step used:
- Workspace or project opened:
- Prompt source: `docs/runtime-tests/SMOKE_TEST_PROMPTS.md`

## Prompts Sent

```text
Paste the prompts sent to the agent here.
```

## Observed Response

```text
Paste or summarize the observed response here. Do not include secrets, tokens,
cookies, private keys, or unrelated private project data.
```

## Criteria Passed

- Recognized main `pam-core` files:
- Answered based on `AGENTS.md`:
- Used `MODULES.md` to choose a module:
- Consulted or cited `SKILL_DEPENDENCIES.md` when relevant:
- Did not create a new skill impulsively:
- Respected minimal scope:
- Passed `SMOKE_TEST_PROMPTS.md` prompts:

## Criteria Failed

- Failed criteria:
- Reproduction notes:

## Conclusion

- Conclusion:
- Recommended final status: `supported` / `partial` / `failed` / `pending` /
  `manual` / `unknown`
- Follow-up needed:
