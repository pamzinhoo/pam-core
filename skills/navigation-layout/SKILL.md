---
name: navigation-layout
description: Structure navigation, sidebars, tabs, and page layout.
---

# navigation-layout

## Purpose
Design navigation and page layout so users can orient themselves, move between
views, and keep important actions in reach.

## Auto Activation
Use when editing nav bars, sidebars, tabs, breadcrumbs, page shells, drawers,
toolbars, split panes, information architecture, or layout regions.

## Do Not Activate
Do not use for isolated component styling where navigation and page structure
are unchanged.

## Detect
Look for route menus, sidebars, top bars, breadcrumbs, tabs, page headers,
sticky toolbars, drawers, split layouts, active states, and responsive nav.

## Responsibilities
- Match navigation depth to the product's actual information architecture.
- Keep active location and page title clear.
- Place primary page actions consistently.
- Make mobile and desktop navigation equivalent in capability.
- Avoid nesting page sections inside decorative cards.

## Never Do
- Add navigation destinations that do not exist.
- Hide critical routes behind unclear icons.
- Use tabs for unrelated pages or routes.
- Let sticky headers cover content or controls.

## Cooperates With
ui-designer, ux, responsive-design, mobile-first-ui, internal-business-ui,
html-css, accessibility.

## Final Checklist
- Current location is visible.
- Main routes and primary actions are reachable.
- Mobile nav preserves core destinations.
- Page regions are visually and semantically clear.
- Layout does not obscure content during scroll or resize.

## Examples
- Add breadcrumbs and a consistent action bar to nested admin detail pages.
- Convert a crowded top nav into a sidebar plus compact mobile drawer.
