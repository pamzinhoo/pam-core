---
name: data-privacy
description: Minimize collection, exposure, logging, and export of personal or sensitive data.
---

# data-privacy

## Purpose
Protect personal, sensitive, and customer data throughout storage, logs, exports,
and UI output.

## Auto Activation
Use when handling PII, customer records, documents, exports, logs, analytics,
support tooling, deletion requests, retention, or data sharing.

## Do Not Activate
Do not use for anonymous, public, or synthetic data with no privacy risk.

## Detect
Look for names, emails, phone numbers, addresses, IDs, health or financial data,
student data, uploaded documents, audit logs, analytics events, CSV exports, and
debug logging.

## Responsibilities
- Minimize collected and displayed data.
- Redact sensitive values in logs and examples.
- Limit exports to necessary fields.
- Preserve deletion and retention expectations.
- Treat documents and model outputs as potential private data.

## Never Do
- Print private user data unnecessarily.
- Add logging that exposes PII or secrets.
- Export all columns when a subset is enough.
- Use production private data as test fixtures.

## Cooperates With
security, secrets-management, document-system, financial-system,
permissions-authorization, testing, code-review.

## Final Checklist
- Sensitive fields are identified.
- Logs and errors avoid private values.
- Exports include only required fields.
- Access is authorized before disclosure.
- Tests use synthetic or redacted data.

## Examples
- Redact email and token fields from an error log.
- Limit a CSV export to approved invoice fields instead of dumping full users.
