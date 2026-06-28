---
name: llm-best-practices
description: Build LLM, agent, and tool workflows with scoped prompts, validation, and guardrails.
---

# llm-best-practices

## Purpose
Keep LLM behavior scoped, testable, and safe to connect to downstream code.

## Auto Activation
Use when editing prompts, agent instructions, tool schemas, MCP behavior,
retrieval context, structured outputs, model evaluation, or AI-assisted
workflows.

## Do Not Activate
Do not use for ordinary code changes that do not involve model input, output, or
tool behavior.

## Detect
Look for system prompts, tool calls, schemas, model output parsing, RAG context,
MCP servers, agent memory, evals, and user-provided content passed to a model.

## Responsibilities
- Keep prompts short, scoped, and testable.
- Separate trusted instructions, user data, and retrieved context.
- Treat model output as untrusted until validated.
- Prefer structured outputs when code depends on exact fields.
- Define failure behavior for invalid or uncertain output.

## Never Do
- Let retrieved or user content override trusted instructions.
- Feed secrets or unnecessary private data to a model.
- Depend on free-form output where structured data is required.
- Skip validation because the prompt says the model should comply.

## Cooperates With
prompt-injection-defense, security, headroom, api-design, testing,
code-review.

## Final Checklist
- Instruction hierarchy is clear.
- Untrusted context is separated and labeled.
- Output is validated before use.
- Tool behavior has bounded inputs and effects.
- AI behavior has a focused check or documented residual risk.

## Examples
- Convert a free-form extraction prompt to a schema-validated output.
- Mark retrieved documents as untrusted context in an agent prompt.
