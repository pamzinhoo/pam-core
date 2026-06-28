---
name: ux
description: Make user workflows clear, efficient, recoverable, and supported by complete states.
---

# ux

## Purpose
Shape product workflows around the user's next action and recovery paths.

## Auto Activation
Use when changing screens, forms, tables, dashboards, navigation, modals,
destructive actions, onboarding, empty states, loading states, error states, or
success feedback.

## Do Not Activate
Do not use for backend-only changes with no user-visible workflow impact.

## Detect
Look for primary actions, task flows, confirmations, validation messages,
filters, sorting, navigation paths, async states, destructive actions, and
recoverable errors.

## Responsibilities
- Make the primary next action obvious.
- Keep common workflows efficient.
- Provide clear empty, loading, success, partial, and failure states.
- Make destructive actions reversible or confirmed.
- Keep recovery instructions actionable and concise.

## Never Do
- Add noisy instructional text instead of clearer workflow design.
- Hide primary actions behind decorative layouts.
- Leave users stranded after errors.
- Make destructive actions ambiguous.

## Cooperates With
ui-designer, accessibility, html-css, javascript, loading-empty-error-states,
copywriting-ui, ux-review, testing, code-review.

## Final Checklist
- The main task is clear.
- Common paths are efficient.
- Error and empty states help recovery.
- Destructive actions are clear and constrained.
- Workflow risk is checked or disclosed.

## Examples
- Add an empty state with the exact action needed to create the first record.
- Change a destructive bulk action to require confirmation and show affected
  count.
