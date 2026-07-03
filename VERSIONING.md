# Versioning

`pam-core` follows semantic versioning with practical rules for a multi-agent
skill pack.

## Source of Truth
The official project version is stored in the root `VERSION` file.

Python packaging reads `VERSION` through `pyproject.toml` dynamic metadata.
Codex and Claude plugin manifests must keep their `version` fields synchronized
with `VERSION`, and tests enforce that alignment. API Server `/version` also
returns the value from `VERSION`.

## Version Lines
- `1.x`: compatible improvements to skills, docs, routing, validation, and
  installer behavior.
- `2.x`: architectural changes that alter module ownership, routing behavior, or
  expected skill metadata in a way future users must account for.

## Patch Versions
Use a patch release for compatible fixes:

- typo or wording fixes;
- validation script fixes that do not change policy;
- small skill clarifications;
- documentation corrections;
- installer bug fixes without behavior change.

Example: `1.0.0` to `1.0.1`.

## Minor Versions
Use a minor release for compatible additions:

- new skills that follow existing standards;
- new project profiles;
- new module roadmap items;
- new agent adapters that reuse the existing shared core without breaking
  Codex behavior;
- stronger validation that existing valid skills can pass with small updates;
- new documentation that does not change architecture.

Example: `1.0.0` to `1.1.0`.

## Major Versions
Use a major release for architecture or contract changes:

- new required skill frontmatter fields;
- changed module ownership model;
- changed orchestration order;
- incompatible installer or manifest behavior;
- agent adapter changes that require moving, copying, renaming, or rewriting
  public skills;
- removal or rename of public skills;
- validation rules that require broad migration.

Example: `1.x` to `2.0.0`.

## Release Rules
- Validate before every release.
- Update `PROJECT_STATE.md` and `CHANGELOG.md`.
- Add or update decisions in `DECISIONS.md` for architecture changes.
- Reinstall the plugin only after explicit approval.
