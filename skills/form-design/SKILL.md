---
name: form-design
description: Design clear, validated, recoverable product forms.
---

# form-design

## Purpose
Create forms that are easy to scan, complete, validate, submit, and recover
from errors.

## Auto Activation
Use when creating or editing forms, field groups, validation messages, submit
flows, filters, settings panels, onboarding steps, or data-entry screens.

## Do Not Activate
Do not use for read-only layouts, backend validation alone, or form styling that
does not affect interaction or structure.

## Detect
Look for `form`, `input`, `select`, `textarea`, labels, validation errors,
required fields, disabled submit buttons, filter panels, and multi-step flows.

## Responsibilities
- Use clear labels, grouping, helper text, and validation placement.
- Preserve user-entered data across errors.
- Show loading, success, validation, and submission failure states.
- Choose native controls before custom widgets when they fit.
- Align form density with the workflow frequency and risk.

## Never Do
- Rely on placeholder text as the only label.
- Clear user input after a recoverable error.
- Disable submit without explaining what must change.
- Invent business validation rules without backend or domain context.

## Cooperates With
ui-designer, html-css, javascript, accessibility, frontend-api-integration,
loading-empty-error-states, testing.

## Final Checklist
- Every field has a visible label.
- Required and invalid states are clear.
- Keyboard and focus behavior work.
- Submit state prevents duplicate work.
- Errors tell the user what to fix.

## Examples
- Add inline validation and a pending submit state to an account settings form.
- Restructure a long intake form into named sections with preserved values after
  failed submission.
