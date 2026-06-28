---
name: javascript
description: Write small frontend JavaScript with clear state.
---

# javascript

## Purpose
Write frontend JavaScript that keeps state explicit and behavior predictable.

## Auto Activation
Use when editing browser behavior, event handling, client state, DOM updates, validation, async calls, or frontend tests.

## Do Not Activate
Do not use for static markup/CSS-only changes unless behavior is affected.

## Detect
Look for `.js`, `.ts`, JSX, event listeners, fetch calls, form handlers, state stores, local storage, timers, and UI interactions.

## Responsibilities
- Use browser APIs and existing project patterns first.
- Keep state close to the UI it drives.
- Validate user input before use.
- Handle loading, success, empty, and error paths.
- Avoid hidden async side effects.

## Never Do
- Add a framework or state library for a small interaction.
- Store sensitive data in client state or local storage casually.
- Leave promises unhandled.
- Create global mutable state without a clear owner.

## Cooperates With
html-css, ui-designer, ux, accessibility, security, testing, debugging.

## Final Checklist
- State ownership is clear.
- User input is validated.
- Async errors are handled.
- UI states are represented.
- Behavior was checked in the smallest practical way.

## Examples
- Add a submit disabled state while a fetch request is pending.
- Replace duplicated DOM queries with one small helper local to the component.
