---
name: css-architecture
description: Keep CSS organized, predictable, and easy to change.
---

# css-architecture

## Purpose
Structure CSS so styles are local enough to understand and shared enough to
avoid drift.

## Auto Activation
Use when editing CSS organization, selectors, cascade issues, tokens, layers,
component styles, utility classes, theming, or style conflicts.

## Do Not Activate
Do not use for tiny CSS tweaks that do not touch shared rules, naming, cascade,
or maintainability.

## Detect
Look for global selectors, duplicated rules, CSS variables, cascade layers,
utility classes, component CSS, specificity fights, theme files, and responsive
style sprawl.

## Responsibilities
- Prefer existing naming, token, and component style patterns.
- Keep selectors low-specificity and scoped to the component or region.
- Use CSS variables for shared decisions that actually repeat.
- Separate layout, component, and state rules where the project already does.
- Remove dead or duplicated styles when safe.

## Never Do
- Add `!important` to win avoidable specificity fights.
- Create a new naming system inside an existing one.
- Move styles globally for one component's convenience.
- Add a CSS framework or preprocessor without explicit need.

## Cooperates With
html-css, design-system, responsive-design, anti-ai-ui, frontend-performance,
testing, code-review.

## Final Checklist
- The cascade is understandable.
- Selectors are no broader than needed.
- Shared tokens are reused instead of duplicated.
- State and responsive rules are easy to find.
- The change does not create visual regressions elsewhere.

## Examples
- Replace repeated hard-coded spacing with an existing CSS variable.
- Lower selector specificity in a modal so disabled and error states apply
  correctly.
