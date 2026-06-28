---
name: accessibility-review
description: Review accessibility quality before completion. Use for accessibility gate checks, interactive UI, forms, tables, keyboard flow, focus, contrast, labels, or semantic markup.
---

# accessibility-review

## Purpose
Decide whether a UI change meets practical accessibility requirements.

## Auto Activation
Use for UI changes with interactive controls, forms, tables, navigation,
dialogs, dynamic content, focus handling, color changes, or keyboard behavior.

## Do Not Activate
Do not use for non-UI changes or purely internal code with no rendered output.

## Detect
Look for buttons, links, inputs, labels, tables, ARIA, dialogs, focus states,
keyboard handlers, color tokens, status messages, and semantic HTML.

## Responsibilities
- Check keyboard access for interactive controls.
- Verify names, labels, roles, and semantic structure.
- Check visible focus, contrast risk, and non-color cues.
- Verify dynamic states are announced or discoverable when relevant.
- Flag accessibility blockers that should fail completion.
- Report a pass, fail, or explicit residual risk for the UX or Release Gate.

## Never Do
- Replace the implementation guidance owned by `accessibility`.
- Add ARIA when native HTML already provides the correct semantics.
- Treat visual polish as a substitute for keyboard and screen-reader usability.
- Approve inaccessible controls because they are internal-only.

## Cooperates With
accessibility, html-css, javascript, ux-review, ui-designer, testing,
code-review.

## Final Checklist
- Interactive controls are keyboard reachable.
- Labels, roles, and semantics are clear.
- Focus and contrast risks are addressed.
- Dynamic state exposure is acceptable.
- Accessibility result is stated.

## Examples
- Fail a custom dropdown that cannot be opened or used by keyboard.
- Pass a native form using labels, fieldsets, errors, and visible focus.
