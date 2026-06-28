---
name: html-css
description: Build accessible, stable HTML and CSS layouts.
---

# html-css

## Purpose
Build semantic, responsive HTML and CSS that stays readable and stable.

## Auto Activation
Use when editing markup, layout, CSS, responsive behavior, visual states, or static frontend pages.

## Do Not Activate
Do not use for backend-only work or UI decisions that do not affect HTML/CSS.

## Detect
Look for `.html`, `.css`, templates, JSX markup, layout classes, media queries, forms, tables, navigation, and design tokens.

## Responsibilities
- Use semantic HTML before ARIA.
- Prefer flex and grid for layout.
- Keep dimensions stable to avoid layout shift.
- Maintain contrast, readable spacing, and text that fits.
- Include loading, empty, error, and disabled states where relevant.

## Never Do
- Scale font size directly with viewport width.
- Let text overlap, clip, or resize containers unpredictably.
- Use ARIA to compensate for incorrect semantics when semantic HTML exists.
- Add decorative clutter that hurts usability.

## Cooperates With
ui-designer, anti-ai-ui, accessibility, javascript, ux, testing, code-review.

## Final Checklist
- Markup is semantic.
- Layout works across expected viewport sizes.
- Text fits without overlap.
- Contrast is readable.
- Interactive states are visible.

## Examples
- Replace nested div buttons with real `button` elements and accessible labels.
- Use CSS grid with fixed control dimensions for a stable settings toolbar.
