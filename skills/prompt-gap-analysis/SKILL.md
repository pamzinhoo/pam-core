---
name: prompt-gap-analysis
description: Detect missing information, ambiguities, contradictions, hidden risks, and unsafe assumptions before executing a user request.
---

# prompt-gap-analysis

## Purpose
Find prompt gaps that could make the agent solve the wrong problem or declare
success too early.

## Auto Activation
Use when a request has unclear targets, missing acceptance criteria,
contradictions, subjective quality goals, risky operations, or high-impact
domains such as auth, money, data, files, deployment, or UI quality.

## Do Not Activate
Do not use for clear low-risk commands where missing context cannot materially
change the outcome.

## Detect
Look for unspecified files, unknown users, unclear current behavior, missing
desired behavior, subjective words, time-sensitive claims, broad verbs, or
requests that combine investigation, implementation, and release.

## Responsibilities
- Identify missing facts that block correct execution.
- Separate blocking questions from safe assumptions.
- Name contradictions between requested scope, constraints, and success.
- Identify risks that require specialist skills or quality gates.
- Recommend when to ask the user before proceeding.

## Never Do
- Stall execution for non-blocking questions.
- Hide uncertainty after making an assumption.
- Treat passing tests as enough when the success criteria are subjective or
  user-visible.
- Ignore safety gaps around secrets, permissions, files, or destructive actions.

## Cooperates With
prompt-understanding, prompt-normalization, success-criteria, task-extraction,
security, scope-control, testing, code-review.

## Final Checklist
- Blocking gaps are identified.
- Non-blocking assumptions are stated.
- Contradictions are surfaced.
- Risky areas are routed to the right skills or gates.
- The next action is clear.

## Examples
- For "make checkout faster", flag missing baseline, user path, acceptable
  latency, and whether backend or frontend behavior is in scope.
- For "delete old files", flag target path, age rule, backup expectation, and
  destructive-action confirmation.
