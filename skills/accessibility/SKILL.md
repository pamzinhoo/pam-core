---
name: accessibility
description: Make interfaces usable with semantic controls, labels, keyboard access, focus, and contrast.
---

# accessibility

## Purpose
Cover practical accessibility basics for product interfaces.

## Auto Activation
Use when creating or changing interactive UI, forms, tables, navigation,
dialogs, error states, focus behavior, labels, or semantic markup.

## Do Not Activate
Do not use for backend-only work or purely internal scripts with no user-facing
interface.

## Detect
Look for buttons, links, inputs, labels, ARIA, keyboard handlers, focus styles,
contrast-sensitive colors, tables, forms, modals, and validation messages.

## Responsibilities
- Prefer semantic HTML and native controls.
- Ensure labels, names, and roles are clear.
- Preserve keyboard access and visible focus.
- Keep contrast readable and avoid color-only meaning.
- Make errors and status messages meaningful.

## Never Do
- Use ARIA as a replacement for correct HTML when native elements fit.
- Hide focus outlines without replacing them.
- Rely only on color, icons, or placeholders for meaning.
- Ship interactive controls that cannot be reached by keyboard.

## Cooperates With
ui-designer, html-css, javascript, ux, accessibility-review, testing,
code-review.

## Final Checklist
- Controls have semantic roles and accessible names.
- Keyboard flow reaches interactive elements.
- Focus is visible.
- Contrast and non-color cues are adequate.
- Errors and status text are understandable.

## Examples
- Add labels and described-by error text to a settings form.
- Replace a clickable `div` with a real `button` and visible focus state.
