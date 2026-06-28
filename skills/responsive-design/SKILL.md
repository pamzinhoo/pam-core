---
name: responsive-design
description: Make product UI work across real viewport sizes.
---

# responsive-design

## Purpose
Design and implement responsive UI behavior without layout breaks, overlap, or
device-specific hacks.

## Auto Activation
Use when editing breakpoints, mobile layouts, desktop layouts, resizable panels,
fluid grids, or any screen that must work across multiple viewport sizes.

## Do Not Activate
Do not use for static backend work, copy-only changes, or component changes
where viewport behavior is unaffected.

## Detect
Look for media queries, container queries, CSS grid, flex layouts, viewport
units, mobile screenshots, overflow bugs, responsive nav, sidebars, and fixed
width components.

## Responsibilities
- Define stable layout rules for small, medium, and large screens.
- Prefer intrinsic layout, grid, flex, and container constraints over device
  sniffing.
- Keep controls, labels, and data visible without overlap.
- Preserve task priority when content stacks or collapses.
- Check important breakpoints with the smallest practical verification.

## Never Do
- Hide core workflow controls on mobile without an equivalent path.
- Scale text with viewport width.
- Fix one viewport by breaking another.
- Use arbitrary breakpoints without checking the content that needs them.

## Cooperates With
html-css, ui-designer, mobile-first-ui, navigation-layout, accessibility,
testing, code-review.

## Final Checklist
- Main workflows fit on mobile and desktop.
- Text wraps cleanly and remains readable.
- Horizontal scrolling is intentional only for dense data.
- Navigation and actions remain reachable.
- Responsive behavior was checked at representative sizes.

## Examples
- Convert a fixed settings page into a two-column desktop layout that stacks
  into one column on phones.
- Replace fragile pixel widths with grid tracks and `minmax()` so cards stop
  overlapping at tablet widths.
