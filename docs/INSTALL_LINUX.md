# Install pam-core on Linux

Linux support uses the Unix shell scripts in `scripts/`.

## Validate

From the repository root:

```bash
chmod +x scripts/*.sh
bash scripts/validate-unix.sh
```

## Install

Use automatic detection:

```bash
bash scripts/install-unix.sh --agent auto
```

Install for a specific agent:

```bash
bash scripts/install-unix.sh --agent claude-code
bash scripts/install-unix.sh --agent codex-cli
bash scripts/install-unix.sh --agent codex-app
bash scripts/install-unix.sh --agent generic
```

Use a manual target when the agent expects a different location:

```bash
bash scripts/install-unix.sh --agent generic --target /tmp/pam-core-test --force
```

Preview without writing files:

```bash
bash scripts/install-unix.sh --agent generic --target /tmp/pam-core-test --dry-run
```

## Validate an Install

```bash
bash scripts/validate-unix.sh --target /tmp/pam-core-test
```

## Uninstall

The uninstaller removes only a target that contains `.install-manifest.json`
created by `scripts/install-unix.sh`.

```bash
bash scripts/uninstall-unix.sh --target /tmp/pam-core-test --dry-run
bash scripts/uninstall-unix.sh --target /tmp/pam-core-test
```

## Limitations

- The scripts do not register packages with every agent runtime.
- Agent-specific loading still depends on Claude Code, Codex CLI, Codex App, or
  the generic agent reading the installed files.
- Detection is conservative and falls back to `generic` when no known
  environment or config directory is found.
