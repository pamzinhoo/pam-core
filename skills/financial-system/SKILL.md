---
name: financial-system
description: Protect money logic, auditability, and reconciliation.
---

# financial-system

## Purpose
Keep money, balances, invoices, and reconciliation correct and auditable.

## Auto Activation
Use for currency, payments, invoices, balances, ledger entries, fees, taxes, reconciliation, reports, and financial exports.

## Do Not Activate
Do not use for generic numeric calculations with no financial meaning.

## Detect
Look for currency fields, totals, cents, decimals, ledger tables, payment status, refunds, chargebacks, invoices, reconciliation jobs, and accounting exports.

## Responsibilities
- Use integer minor units or decimal values, never floats for currency.
- Preserve audit trails and source events.
- Make corrections explicit.
- Keep reconciliation paths repeatable.
- Test rounding, status transitions, and edge cases.

## Never Do
- Silently rewrite financial history.
- Mix display formatting with stored values.
- Ignore timezone, date, tax, or rounding rules.
- Treat payment provider callbacks as trusted without verification.

## Cooperates With
business-rules, database-design, sqlite, security, testing, code-review, api-design.

## Final Checklist
- Currency precision is safe.
- Events or corrections are auditable.
- Totals can be reconciled from source data.
- Status transitions are explicit.
- Money logic has focused tests.

## Examples
- Store invoice totals in cents and format currency only at the UI boundary.
- Add a reversing ledger entry instead of editing a posted transaction.
