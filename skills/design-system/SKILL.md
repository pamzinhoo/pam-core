---
name: design-system
description: Maintain practical UI tokens, components, and patterns.
---

# design-system

## Purpose
Create or adjust design system pieces that make product UI consistent without
adding unnecessary abstraction.

## Auto Activation
Use when editing tokens, themes, component primitives, shared UI patterns,
spacing scales, typography rules, variants, or reusable frontend components.

## Do Not Activate
Do not use for one-off screen styling unless the change clearly belongs in a
shared pattern.

## Detect
Look for design tokens, CSS variables, component libraries, style dictionaries,
theme files, shared buttons, inputs, tables, modals, navigation, and variant
props.

## Responsibilities
- Reuse existing tokens and components before adding new ones.
- Keep variants limited to real product needs.
- Document component behavior through names, props, or examples already used by
  the project.
- Preserve accessibility and responsive behavior in shared primitives.
- Remove duplicated local styles when a shared pattern already exists.

## Never Do
- Build a design system before there are repeated patterns.
- Add theme flexibility that no product screen uses.
- Create components that hide semantics or accessibility.
- Rename tokens broadly without a migration need.

## Cooperates With
ui-designer, html-css, css-architecture, accessibility, anti-ai-ui,
frontend-state-management, code-review.

## Final Checklist
- The shared pattern has more than one real use or clear ownership.
- Tokens map to product decisions, not decoration.
- Variants are minimal and named plainly.
- Existing screens are not visually regressed.
- Accessibility is preserved in the primitive.

## Examples
- Consolidate duplicated button styles into an existing button component.
- Add a compact table density token because multiple admin tables use it.
