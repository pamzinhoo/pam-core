---
name: deployment
description: Deploy apps with explicit config, secrets safety, health checks, rollback, and repeatable steps.
---

# deployment

## Purpose
Make hosted delivery repeatable, observable, and reversible enough for the risk.

## Auto Activation
Use when changing deployment scripts, hosting config, environment variables,
runtime settings, migrations during deploy, health checks, release handoff, or
rollback notes.

## Do Not Activate
Do not use for local-only packaging or development commands unless deployment
behavior is affected.

## Detect
Look for Dockerfiles, CI/CD configs, process managers, hosting manifests,
environment variables, health endpoints, migration commands, logs, and release
steps.

## Responsibilities
- Separate build-time and runtime config.
- Keep secrets out of source and images.
- Define repeatable build and deploy steps.
- Include health checks, logs, and rollback awareness.
- Coordinate migrations and release risk with the owning skills.

## Never Do
- Bake secrets into artifacts.
- Treat local success as production readiness.
- Hide required manual steps.
- Run destructive deploy steps without a rollback or approval path.

## Cooperates With
security, secrets-management, packaging, python-packaging, testing,
release-readiness, code-review.

## Final Checklist
- Config sources are clear.
- Secrets are not embedded or printed.
- Deploy steps are repeatable.
- Health and rollback behavior are known.
- Required validation ran or is disclosed.

## Examples
- Add a deployment note that migrations must run before starting workers.
- Move an API key from a committed config file to an environment variable.
