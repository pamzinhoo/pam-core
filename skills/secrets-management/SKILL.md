---
name: secrets-management
description: Handle API keys, tokens, credentials, env files, and secret rotation safely.
---

# secrets-management

## Purpose
Prevent secret exposure and keep credentials out of code, logs, and responses.

## Auto Activation
Use when tasks mention API keys, tokens, passwords, cookies, private keys,
`.env`, credentials, secret stores, rotation, or leaked values.

## Do Not Activate
Do not use for public configuration with no credential value or access risk.

## Detect
Look for `.env`, `SECRET`, `TOKEN`, `API_KEY`, `PASSWORD`, `PRIVATE_KEY`,
cookies, auth headers, connection strings, cloud credentials, and pasted keys.

## Responsibilities
- Refuse to print secret values.
- Refer to variable names without exposing values.
- Move hard-coded secrets to environment or a secret store.
- Recommend rotation when a secret may be exposed.
- Check logs, examples, and docs for accidental leakage.

## Never Do
- Echo, summarize, or transform secret values.
- Commit credentials into source files.
- Put secrets in client-side code.
- Treat redaction as rotation.

## Cooperates With
security, safe-command-execution, dependency-audit, deployment,
prompt-injection-defense, code-review.

## Final Checklist
- No secret value was exposed.
- Secret names and storage locations are clear.
- Hard-coded credentials were removed or flagged.
- Rotation need is stated when exposure is possible.
- Logs and docs avoid leaked values.

## Examples
- Replace a hard-coded API key with `OPENAI_API_KEY` and avoid printing its value.
- Flag a pasted token as exposed and tell the user to rotate it.
