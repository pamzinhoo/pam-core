#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd -P)"

AGENT="auto"
TARGET=""
DRY_RUN=0
CODEX_RUNTIME_CACHE=0

usage() {
  cat <<'EOF'
Usage: scripts/uninstall-unix.sh [options]

Options:
  --agent claude-code|codex-cli|codex-app|generic|auto
  --target PATH       Override the resolved install target.
  --codex-runtime-cache
                      Explicitly uninstall the observed Codex CLI runtime
                      cache target instead of the generic Codex CLI target.
  --dry-run           Show what would happen without deleting files.
  --help              Show this help.
EOF
}

fail() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

read_version() {
  if [ -f "$ROOT/VERSION" ]; then
    local version
    version="$(tr -d '[:space:]' < "$ROOT/VERSION")"
    case "$version" in
      [0-9]*.[0-9]*.[0-9]*) printf '%s\n' "$version"; return ;;
      *) fail "VERSION exists but does not contain a simple semver value" ;;
    esac
  fi

  if [ -f "$ROOT/VERSIONING.md" ]; then
    local versioning_version
    versioning_version="$(sed -n 's/^[[:space:]]*\(Current version\|Manifest version\|Version\):[[:space:]]*`\{0,1\}\([^`[:space:]]*\)`\{0,1\}[[:space:]]*$/\2/p' "$ROOT/VERSIONING.md" | head -n 1)"
    if [ -n "$versioning_version" ]; then
      printf '%s\n' "$versioning_version"
      return
    fi
  fi

  sed -n 's/^- Manifest version:[[:space:]]*`\{0,1\}\([^`[:space:]]*\)`\{0,1\}[[:space:]]*$/\1/p' "$ROOT/PROJECT_STATE.md" | head -n 1
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

codex_runtime_cache_target() {
  local version
  version="$(read_version)"
  [ -n "$version" ] || fail "Could not read pam-core version for Codex runtime cache target"
  printf '%s/plugins/cache/personal/pam-core/%s\n' "${CODEX_HOME:-$HOME/.codex}" "$version"
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
    --codex-runtime-cache)
      CODEX_RUNTIME_CACHE=1
      shift
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

if [ "$CODEX_RUNTIME_CACHE" -eq 1 ]; then
  [ "$AGENT" = "codex-cli" ] || fail "--codex-runtime-cache is only supported for --agent codex-cli or auto-detected codex-cli"
  [ -z "$TARGET" ] || fail "--codex-runtime-cache cannot be combined with --target; use one explicit target mode"
fi

if [ -z "$TARGET" ]; then
  if [ "$CODEX_RUNTIME_CACHE" -eq 1 ]; then
    TARGET="$(codex_runtime_cache_target)"
  else
    TARGET="$(agent_target "$AGENT")"
  fi
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
if [ "$CODEX_RUNTIME_CACHE" -eq 1 ]; then
  printf 'Runtime cache target: true\n'
fi

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

if [ "$CODEX_RUNTIME_CACHE" -eq 1 ] && ! grep -q '"runtime_cache_target"[[:space:]]*:[[:space:]]*true' "$manifest"; then
  fail "Refusing runtime cache uninstall without runtime_cache_target=true in manifest: $manifest"
fi

if [ "$DRY_RUN" -eq 1 ]; then
  printf 'Dry run: would remove only %s\n' "$TARGET"
  exit 0
fi

rm -rf -- "$TARGET"
printf 'Removed pam-core installation: %s\n' "$TARGET"
printf 'Parent directories were left unchanged.\n'
