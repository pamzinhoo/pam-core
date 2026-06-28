---
name: table-design
description: Build readable tables for scanning and repeated work.
---

# table-design

## Purpose
Design tables and data grids that support scanning, comparison, filtering, and
routine business actions.

## Auto Activation
Use when creating or editing tables, lists with columns, data grids, row
actions, sorting, filtering, pagination, bulk actions, or dense record views.

## Do Not Activate
Do not use for decorative card lists, simple prose lists, or backend query work
without a visible table concern.

## Detect
Look for `table`, grid components, column definitions, row actions, filters,
sort controls, pagination, sticky headers, empty result states, and bulk
selection.

## Responsibilities
- Choose table, list, or card layout based on comparison needs.
- Keep column order, alignment, and density scannable.
- Make sorting, filtering, pagination, and row actions explicit.
- Provide useful empty, loading, error, and no-results states.
- Preserve accessibility for headers, row controls, and selection.

## Never Do
- Replace comparable tabular data with unrelated cards.
- Hide primary row actions behind unclear controls.
- Use fake metrics or placeholder rows as final UI.
- Let mobile tables collapse into unreadable fragments.

## Cooperates With
ui-designer, html-css, accessibility, javascript, loading-empty-error-states,
frontend-performance, testing.

## Final Checklist
- The table supports the user's comparison task.
- Numeric and status columns align predictably.
- Filters and sort state are visible.
- Empty and no-results states are distinct.
- Row actions are keyboard reachable.

## Examples
- Add a no-results state and visible filter chips to an invoice table.
- Convert a card-heavy admin list into a compact table with status, owner, and
  last-updated columns.
