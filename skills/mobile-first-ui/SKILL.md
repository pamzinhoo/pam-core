---
name: mobile-first-ui
description: Design product screens from the smallest useful viewport upward.
---

# mobile-first-ui

## Purpose
Create mobile product UI where core tasks work first on small screens, then
enhance for larger viewports.

## Auto Activation
Use when building mobile web, responsive app screens, mobile-heavy workflows,
touch controls, compact navigation, or forms intended for phones.

## Do Not Activate
Do not use when the product is explicitly desktop-only and no small-screen
behavior is required.

## Detect
Look for mobile breakpoints, touch targets, bottom navigation, stacked forms,
responsive drawers, viewport overflow, mobile screenshots, and compact
toolbars.

## Responsibilities
- Keep the primary task reachable without horizontal scrolling.
- Use touch-friendly controls and readable spacing.
- Move secondary actions into clear menus only when necessary.
- Preserve labels, validation, and recovery paths on small screens.
- Enhance layout progressively for tablet and desktop.

## Never Do
- Shrink desktop UI until it technically fits.
- Remove labels or essential context to save space.
- Depend on hover-only interactions.
- Hide primary actions below unrelated content.

## Cooperates With
responsive-design, navigation-layout, form-design, accessibility, html-css,
ux, testing.

## Final Checklist
- Primary actions work on phone-sized screens.
- Touch targets and spacing are usable.
- Labels and errors remain visible.
- Navigation has a clear mobile pattern.
- Desktop enhancements do not change the task meaning.

## Examples
- Turn a desktop sidebar into a compact mobile nav with the same destinations.
- Stack a two-column form into logical sections while preserving validation
  messages.
