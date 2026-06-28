---
name: dashboard-design
description: Design dashboards around decisions, not decorative metrics.
---

# dashboard-design

## Purpose
Build dashboards that help users monitor status, find work, and decide what to
do next.

## Auto Activation
Use when creating or editing dashboards, overview pages, KPI panels, work
queues, operational summaries, charts, alerts, or admin home screens.

## Do Not Activate
Do not use for simple detail pages, marketing pages, or dashboards requested as
pure visual mockups without real workflow content.

## Detect
Look for metrics, charts, summary cards, activity feeds, work queues, alerts,
filters, date ranges, admin overview pages, and status panels.

## Responsibilities
- Tie every metric or panel to a user decision or next action.
- Prefer work queues, filters, tables, and alerts for operational software.
- Make date ranges, data freshness, and empty states visible.
- Keep visual hierarchy calm and domain-specific.
- Avoid decorative or generic AI dashboard patterns.

## Never Do
- Add fake KPIs, fake charts, or filler cards.
- Use oversized hero layouts for operational dashboards.
- Hide data definitions or freshness when they affect decisions.
- Let visual symmetry outrank useful ordering.

## Cooperates With
ui-designer, anti-ai-ui, table-design, visual-hierarchy,
loading-empty-error-states, frontend-api-integration, accessibility.

## Final Checklist
- Each panel has a clear operational purpose.
- Primary next actions are visible.
- Time range and freshness are understandable.
- Empty and unavailable data states are handled.
- The layout reads as product software, not a template.

## Examples
- Replace a decorative KPI wall with an overdue-work queue and status filters.
- Add clear data freshness and no-data messaging to a revenue overview.
