---
name: loading-empty-error-states
description: Design complete loading, empty, error, and success states.
---

# loading-empty-error-states

## Purpose
Make UI states explicit so users understand what is happening and what to do
next.

## Auto Activation
Use when creating or editing async screens, lists, tables, forms, dashboards,
search results, uploads, mutations, or any component with missing or failed
data.

## Do Not Activate
Do not use for static content with no alternate states or backend-only error
handling.

## Detect
Look for loading spinners, skeletons, empty lists, no-results views, form
errors, toast messages, retry buttons, disabled controls, and success messages.

## Responsibilities
- Distinguish initial loading, refresh, empty, no-results, error, partial, and
  success states.
- Provide next actions where recovery is possible.
- Preserve layout stability while content loads or fails.
- Keep messages specific, short, and user-facing.
- Avoid exposing raw internal errors or sensitive details.

## Never Do
- Use one spinner for every async condition.
- Treat empty data and failed data as the same state.
- Leave users stuck with no retry, back, or edit path.
- Print raw stack traces, tokens, IDs, or private details in the UI.

## Cooperates With
ux, copywriting-ui, frontend-api-integration, form-design, table-design,
dashboard-design, accessibility, security.

## Final Checklist
- Initial loading and refresh states are distinct when needed.
- Empty and no-results states have appropriate copy.
- Error states are actionable and safe.
- Success states do not block continued work.
- Layout remains stable across state changes.

## Examples
- Add a no-results state for a filtered table separate from the first-run empty
  state.
- Replace a permanent spinner with an error message and retry action after a
  failed API request.
