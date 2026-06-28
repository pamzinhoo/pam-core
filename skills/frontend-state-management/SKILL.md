---
name: frontend-state-management
description: Keep frontend state local, explicit, and predictable.
---

# frontend-state-management

## Purpose
Manage client-side state with the smallest reliable owner for the UI behavior.

## Auto Activation
Use when editing component state, stores, reducers, URL state, local storage,
derived state, optimistic updates, filters, selections, or multi-step UI flows.

## Do Not Activate
Do not use for static markup, pure CSS changes, or backend state transitions
that do not affect client state.

## Detect
Look for `useState`, reducers, stores, event state, selected rows, filters,
query params, local storage, caches, optimistic updates, and undo flows.

## Responsibilities
- Keep state close to the UI that owns it.
- Store durable state in the URL or backend when users need sharing or reloads.
- Derive values instead of duplicating state.
- Handle pending, success, empty, error, and rollback paths.
- Avoid storing secrets or sensitive data in browser storage.

## Never Do
- Add a global store for isolated component behavior.
- Duplicate server truth without invalidation or refresh rules.
- Put sensitive tokens or private data in local storage casually.
- Let optimistic UI hide failed writes.

## Cooperates With
javascript, frontend-api-integration, loading-empty-error-states, security,
ux, testing, code-review.

## Final Checklist
- State ownership is clear.
- Derived state is not stored unnecessarily.
- Reload, back button, and error behavior are considered.
- Sensitive data stays out of unsafe storage.
- Async transitions have visible UI states.

## Examples
- Move table filters into query parameters so a shared link preserves the view.
- Replace duplicated `isOpen` flags with one selected item id for a details
  drawer.
