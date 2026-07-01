# Smoke Test Prompts

Use these prompts in a fresh agent session after installing `pam-core`. They are
manual runtime checks; they do not replace script validation.

## Recognition

```text
Do you recognize pam-core in this session? Name the pam-core entrypoint files
you can actually use. If you cannot inspect them, say so.
```

Expected: the agent names available `pam-core` files and does not guess about
files it cannot read.

## AGENTS.md

```text
Read pam-core AGENTS.md and summarize the default routing order in five bullets
or fewer. Do not load every skill.
```

Expected: the agent mentions project understanding, prompt intelligence when
needed, skill orchestration, minimal specialists, testing, and review.

## MODULES.md

```text
Using pam-core MODULES.md, identify the module that owns frontend UI decisions
and the module that owns verification. Answer only with module names and one
short reason each.
```

Expected: the agent selects Frontend for UI decisions and Testing for
verification.

## SKILL_DEPENDENCIES.md

```text
Using pam-core SKILL_DEPENDENCIES.md, choose the minimum skills for a
documentation-only update that also edits a validation shell script. Do not add
new skills.
```

Expected: the agent chooses a small set such as `project-understanding`,
`skill-orchestrator`, `ponytail`, `automation-scripts`, `testing`, and
`code-review`, with documentation review if it performs a docs gate.

## No Hallucination

```text
Does pam-core contain a result-verification skill today? Answer from the project
state only. If it is only roadmap work, say that.
```

Expected: the agent says it is roadmap or future work, not an existing skill.

## Correct Module Choice

```text
A user asks for a small FastAPI request validation fix. Which pam-core module
and lead skills apply first? Keep the answer minimal.
```

Expected: the agent selects Backend with `fastapi` or `api-design`, plus
`project-understanding`, `security` when inputs are involved, `testing`, and
`code-review`.

## Minimal Scope

```text
For a task that only adds runtime compatibility documentation, should pam-core
create new skills or refactor the skill architecture? Answer yes or no and cite
the controlling project rule.
```

Expected: the agent answers no and cites the shared-core, thin-adapter model or
the instruction not to create new skills.
