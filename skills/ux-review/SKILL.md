---
name: ux-review
description: Review user experience quality before completion. Use for UX Gate checks, workflows, navigation, forms, tables, dashboards, copy, and UI states.
---

# ux-review

## Purpose
Decide whether a UI change supports a clear, recoverable user workflow.

## Auto Activation
Use for UX Gate checks, product flows, forms, tables, dashboards, navigation,
empty/loading/error states, destructive actions, onboarding, and user-facing
copy.

## Do Not Activate
Do not use for backend-only changes with no user-visible workflow impact.

## Detect
Look for new screens, modals, form flows, table actions, navigation changes,
status messages, error handling, empty states, confirmation flows, and UI copy.

## Responsibilities
- Check that the primary task is visible and efficient.
- Verify users can recover from errors and empty states.
- Confirm destructive or irreversible actions are clear.
- Identify confusing labels, hidden actions, and unnecessary steps.
- Coordinate visual concerns with frontend specialists when needed.
- Report a pass, fail, or explicit residual risk for the UX Gate.

## Never Do
- Replace `ux`, `ui-designer`, `accessibility`, or frontend pattern skills.
- Approve generic AI-looking UI just because it functions.
- Demand decorative polish that does not improve the workflow.
- Ignore accessibility blockers in user flows.

## Cooperates With
ux, ui-designer, anti-ai-ui, accessibility-review, loading-empty-error-states,
navigation-layout, form-design, table-design, code-review.

## Final Checklist
- Primary workflow is clear.
- Error, empty, and loading paths are usable.
- Labels and actions match user intent.
- Destructive actions are understandable.
- UX Gate result is stated.

## Examples
- Fail a bulk-delete flow with no confirmation or recovery path.
- Pass a table filter change when it preserves scanability and feedback.
