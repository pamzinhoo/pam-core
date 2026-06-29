---
name: prompt-understanding
description: Understand the user's real intent when a prompt is short, vague, ambiguous, mixed, subjective, or high-risk before routing or execution.
---

# prompt-understanding

## Purpose
Identify what the user actually wants before choosing skills, tools, or success
criteria.

## Auto Activation
Use before `skill-orchestrator` when the user prompt is short, vague,
ambiguous, mixed, subjective, high-risk, or likely to hide an unstated product
goal.

## Do Not Activate
Do not use for explicit one-step requests with clear scope, clear target files,
and obvious completion criteria.

## Detect
Look for prompts such as "fix this", "make it better", "improve the UI",
"clean up", "do the thing", "review this", "finish it", "looks bad", or
requests that name a symptom but not the desired outcome.

## Responsibilities
- Restate the likely user goal in concrete terms.
- Separate the user's desired outcome from implementation hints.
- Identify the target audience, workflow, or business purpose when implied.
- Preserve explicit user constraints and dates.
- Flag where intent is inferred instead of stated.

## Never Do
- Treat a technical change as complete when the user asked for an outcome.
- Invent business rules, design taste, or acceptance criteria without marking
  them as assumptions.
- Override explicit user constraints with inferred intent.
- Ask for clarification when a safe assumption and verification path are enough.

## Cooperates With
prompt-normalization, prompt-gap-analysis, task-extraction, success-criteria,
skill-orchestrator, project-understanding, security, prompt-injection-defense.

## Final Checklist
- The real user outcome is stated.
- Explicit constraints are preserved.
- Inferences are labeled.
- Implementation hints are not confused with the goal.
- Routing can proceed with a clear intent statement.

## Examples
- User says "CSS changed but still ugly"; infer the goal is visual quality, not
  merely edited CSS, and route to UI and UX skills.
- User says "fix login"; identify whether the likely goal is access recovery,
  auth correctness, user experience, or a failing test before choosing skills.
