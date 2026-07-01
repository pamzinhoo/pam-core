#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

AGENT="auto"
TARGET=""
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: scripts/uninstall-unix.sh [options]

Options:
  --agent claude-code|codex-cli|codex-app|generic|auto
  --target PATH       Override the resolved install target.
  --dry-run           Show what would happen without deleting files.
  --help              Show this help.
EOF
}

fail() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

agent_target() {
  local agent="$1"
  local os_name
  os_name="$(uname -s)"

  case "$agent" in
    claude-code)
      printf '%s/.claude/plugins/pam-core\n' "$HOME"
      ;;
    codex-cli)
      printf '%s/plugins/pam-core\n' "${CODEX_HOME:-$HOME/.codex}"
      ;;
    codex-app)
      if [ "$os_name" = "Darwin" ]; then
        printf '%s/Library/Application Support/Codex/plugins/pam-core\n' "$HOME"
      else
        printf '%s/codex/plugins/pam-core\n' "${XDG_CONFIG_HOME:-$HOME/.config}"
      fi
      ;;
    generic)
      printf '%s/pam-core\n' "$HOME"
      ;;
    *)
      fail "Unsupported agent: $agent"
      ;;
  esac
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --agent)
      [ "$#" -ge 2 ] || fail "--agent requires a value"
      AGENT="$2"
      shift 2
      ;;
    --target)
      [ "$#" -ge 2 ] || fail "--target requires a path"
      TARGET="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --help)
      usage
      exit 0
      ;;
    *)
      fail "Unknown option: $1"
      ;;
  esac
done

case "$AGENT" in
  claude-code|codex-cli|codex-app|generic|auto) ;;
  *) fail "Invalid --agent value: $AGENT" ;;
esac

if [ "$AGENT" = "auto" ] && [ -z "$TARGET" ]; then
  detected_line="$("$SCRIPT_DIR/detect-agent.sh")"
  AGENT="${detected_line%%	*}"
fi

if [ -z "$TARGET" ]; then
  TARGET="$(agent_target "$AGENT")"
fi

case "$TARGET" in
  ""|"/"|"$HOME") fail "Refusing unsafe target: $TARGET" ;;
esac

TARGET="${TARGET%/}"
target_name="$(basename "$TARGET")"
case "$target_name" in
  "."|"..") fail "Refusing unsafe target: $TARGET" ;;
esac

if [ -d "$TARGET" ]; then
  TARGET="$(cd "$TARGET" && pwd -P)"
fi

case "$TARGET" in
  ""|"/"|"$HOME") fail "Refusing unsafe target: $TARGET" ;;
esac

manifest="$TARGET/.install-manifest.json"

printf 'pam-core Unix uninstall\n'
printf 'Agent: %s\n' "$AGENT"
printf 'Target: %s\n' "$TARGET"

if [ ! -d "$TARGET" ]; then
  fail "Target does not exist: $TARGET"
fi

if [ ! -f "$manifest" ]; then
  fail "Refusing to uninstall without pam-core manifest: $manifest"
fi

if ! grep -q '"package"[[:space:]]*:[[:space:]]*"pam-core"' "$manifest"; then
  fail "Manifest does not identify a pam-core installation: $manifest"
fi

if ! grep -q '"managed_by"[[:space:]]*:[[:space:]]*"scripts/install-unix.sh"' "$manifest"; then
  fail "Manifest was not created by scripts/install-unix.sh: $manifest"
fi

if [ "$DRY_RUN" -eq 1 ]; then
  printf 'Dry run: would remove only %s\n' "$TARGET"
  exit 0
fi

rm -rf -- "$TARGET"
printf 'Removed pam-core installation: %s\n' "$TARGET"
printf 'Parent directories were left unchanged.\n'
