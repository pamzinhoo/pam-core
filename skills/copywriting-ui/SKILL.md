---
name: copywriting-ui
description: Write concise UI text for actions, states, and recovery.
---

# copywriting-ui

## Purpose
Write product UI copy that helps users act, recover, and understand state
without adding instructional clutter.

## Auto Activation
Use when editing button labels, field labels, error messages, empty states,
success messages, confirmations, navigation labels, helper text, or onboarding
microcopy.

## Do Not Activate
Do not use for long-form marketing copy, docs, legal text, or backend messages
not shown to users.

## Detect
Look for labels, CTAs, toasts, alerts, validation messages, modal titles,
empty-state copy, placeholders, confirmation dialogs, and menu text.

## Responsibilities
- Use specific, plain labels tied to the user action.
- Keep state messages short and actionable.
- Explain recovery without exposing internal details.
- Match tone to the product and workflow risk.
- Remove redundant feature-explaining text from the UI.

## Never Do
- Use vague labels like "Submit" when the action has a clearer verb.
- Blame the user in error messages.
- Expose raw exceptions, stack traces, tokens, or internal IDs.
- Add paragraphs of instructions where labels and layout should carry the task.

## Cooperates With
ux, loading-empty-error-states, form-design, navigation-layout,
visual-hierarchy, accessibility, security.

## Final Checklist
- Actions use clear verbs.
- Errors say what happened and what to do next.
- Empty states distinguish first use from no results.
- Labels are specific without being long.
- Sensitive or internal details are not exposed.

## Examples
- Change "Submit" to "Invite user" on a team form.
- Replace "Error 500" with a safe retry message on an activity feed.
