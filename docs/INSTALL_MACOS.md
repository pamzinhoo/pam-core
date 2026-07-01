# Install pam-core on macOS

macOS support uses the same Unix shell scripts as Linux.

## Validate

From the repository root:

```bash
chmod +x scripts/*.sh
bash scripts/validate-unix.sh
```

## Install

Automatic detection:

```bash
bash scripts/install-unix.sh --agent auto
```

Specific agents:

```bash
bash scripts/install-unix.sh --agent claude-code
bash scripts/install-unix.sh --agent codex-cli
bash scripts/install-unix.sh --agent codex-app
bash scripts/install-unix.sh --agent generic
```

On macOS, the default Codex App target is:

```text
~/Library/Application Support/Codex/plugins/pam-core
```

Use `--target` when your agent uses another location:

```bash
bash scripts/install-unix.sh --agent codex-app --target "$HOME/Library/Application Support/Codex/plugins/pam-core" --force
```

## Validate an Install

```bash
bash scripts/validate-unix.sh --target "$HOME/Library/Application Support/Codex/plugins/pam-core"
```

## Uninstall

```bash
bash scripts/uninstall-unix.sh --target "$HOME/Library/Application Support/Codex/plugins/pam-core" --dry-run
bash scripts/uninstall-unix.sh --target "$HOME/Library/Application Support/Codex/plugins/pam-core"
```

## Limitations

- The scripts copy the shared core and thin adapter metadata; they do not force
  any running agent to reload it.
- Claude Code and Codex runtime loading still need to be verified in the target
  application.
- Detection uses known environment variables and common directories only.
- Phase 19 did not run on macOS native because no macOS host was available in
  the validation environment. macOS support remains pending until these scripts
  are run on a real macOS host and evidence is recorded.
