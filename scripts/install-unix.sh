#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
SOURCE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd -P)"

AGENT="auto"
TARGET=""
DRY_RUN=0
FORCE=0
CODEX_RUNTIME_CACHE=0

REQUIRED_ITEMS=(
  "AGENTS.md"
  "README.md"
  "MODULES.md"
  "SKILL_DEPENDENCIES.md"
  "PROJECT_STATE.md"
  "DECISIONS.md"
  "VERSIONING.md"
  "skills"
)

OPTIONAL_COMMON_ITEMS=(
  "CLAUDE.md"
  "CHANGELOG.md"
  "CONTRIBUTING.md"
  "PROJECT_PROFILES.md"
  "QUALITY_GATES.md"
  "SKILL_GUIDELINES.md"
  "docs/PACKAGING.md"
)

EXCLUDED_DIRS=(
  ".git"
  ".agents"
  ".codex"
  ".cache"
  ".tmp"
  "node_modules"
  "__pycache__"
  ".pytest_cache"
  ".mypy_cache"
  ".ruff_cache"
)

EXCLUDED_FILE_PATTERNS=(
  "*.tmp"
  "*.temp"
  "*.log"
  "*.pyc"
  "*.pyo"
  "*.swp"
  "*.swo"
  "*~"
  ".DS_Store"
)

usage() {
  cat <<'EOF'
Usage: scripts/install-unix.sh [options]

Options:
  --agent claude-code|codex-cli|codex-app|generic|auto
  --target PATH       Override the resolved install target.
  --codex-runtime-cache
                      Explicitly install to the observed Codex CLI runtime
                      cache target instead of the generic Codex CLI target.
  --dry-run           Show what would happen without writing files.
  --force             Replace an existing target after creating a backup.
  --help              Show this help.
EOF
}

fail() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

say() {
  printf '%s\n' "$*"
}

resolve_path_for_create() {
  local path="$1"
  local parent
  parent="$(dirname "$path")"
  local name
  name="$(basename "$path")"
  mkdir -p "$parent"
  parent="$(cd "$parent" && pwd -P)"
  printf '%s/%s\n' "$parent" "$name"
}

detect_agent_line() {
  "$SCRIPT_DIR/detect-agent.sh"
}

read_version() {
  if [ -f "$SOURCE_ROOT/VERSION" ]; then
    local version
    version="$(tr -d '[:space:]' < "$SOURCE_ROOT/VERSION")"
    case "$version" in
      [0-9]*.[0-9]*.[0-9]*) printf '%s\n' "$version"; return ;;
      *) fail "VERSION exists but does not contain a simple semver value" ;;
    esac
  fi

  if [ -f "$SOURCE_ROOT/VERSIONING.md" ]; then
    local versioning_version
    versioning_version="$(sed -n 's/^[[:space:]]*\(Current version\|Manifest version\|Version\):[[:space:]]*`\{0,1\}\([^`[:space:]]*\)`\{0,1\}[[:space:]]*$/\2/p' "$SOURCE_ROOT/VERSIONING.md" | head -n 1)"
    if [ -n "$versioning_version" ]; then
      printf '%s\n' "$versioning_version"
      return
    fi
  fi

  sed -n 's/^- Manifest version:[[:space:]]*`\{0,1\}\([^`[:space:]]*\)`\{0,1\}[[:space:]]*$/\1/p' "$SOURCE_ROOT/PROJECT_STATE.md" | head -n 1
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

copy_item() {
  local item="$1"
  local src="$SOURCE_ROOT/$item"
  local dest="$TARGET/$item"

  if [ -d "$src" ]; then
    copy_tree "$src" "$dest"
  else
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
  fi
}

is_excluded_dir() {
  local name="$1"
  local excluded
  for excluded in "${EXCLUDED_DIRS[@]}"; do
    [ "$name" = "$excluded" ] && return 0
  done
  return 1
}

is_excluded_file() {
  local name="$1"
  local pattern
  for pattern in "${EXCLUDED_FILE_PATTERNS[@]}"; do
    case "$name" in
      $pattern) return 0 ;;
    esac
  done
  return 1
}

copy_tree() {
  local src="$1"
  local dest="$2"
  local rel
  local base

  mkdir -p "$dest"
  while IFS= read -r -d '' rel; do
    rel="${rel#./}"
    [ "$rel" = "." ] && continue
    base="$(basename "$rel")"

    if [ -d "$src/$rel" ]; then
      is_excluded_dir "$base" && continue
      mkdir -p "$dest/$rel"
      continue
    fi

    is_excluded_file "$base" && continue
    mkdir -p "$(dirname "$dest/$rel")"
    cp "$src/$rel" "$dest/$rel"
  done < <(cd "$src" && find . -print0)
}

json_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

write_manifest() {
  local manifest="$TARGET/.install-manifest.json"
  local installed_at
  installed_at="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  local os_name
  os_name="$(uname -s)"

  {
    printf '{\n'
    printf '  "package": "pam-core",\n'
    printf '  "agent": "%s",\n' "$(json_escape "$AGENT")"
    printf '  "target": "%s",\n' "$(json_escape "$TARGET")"
    printf '  "source": "%s",\n' "$(json_escape "$SOURCE_ROOT")"
    printf '  "os": "%s",\n' "$(json_escape "$os_name")"
    printf '  "installed_at": "%s",\n' "$installed_at"
    if [ "$CODEX_RUNTIME_CACHE" -eq 1 ]; then
      printf '  "runtime_cache_target": true,\n'
    else
      printf '  "runtime_cache_target": false,\n'
    fi
    printf '  "managed_by": "scripts/install-unix.sh"\n'
    printf '}\n'
  } > "$manifest"
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
    --force)
      FORCE=1
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

if [ "$AGENT" = "auto" ]; then
  detected_line="$(detect_agent_line)"
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

target_name="$(basename "$TARGET")"
case "$target_name" in
  "."|"..") fail "Refusing unsafe target: $TARGET" ;;
esac

if [ "$DRY_RUN" -eq 0 ]; then
  TARGET="$(resolve_path_for_create "$TARGET")"
else
  TARGET="${TARGET%/}"
fi

case "$TARGET" in
  ""|"/"|"$HOME") fail "Refusing unsafe target: $TARGET" ;;
esac

resolved_source="$SOURCE_ROOT"
if [ -d "$TARGET" ]; then
  resolved_target="$(cd "$TARGET" && pwd -P)"
  [ "$resolved_source" != "$resolved_target" ] || fail "Source and target are the same path: $TARGET"
fi

for item in "${REQUIRED_ITEMS[@]}"; do
  [ -e "$SOURCE_ROOT/$item" ] || fail "Missing required source item: $item"
done

say "pam-core Unix install"
say "OS: $(uname -s)"
say "Agent: $AGENT"
say "Source: $SOURCE_ROOT"
say "Target: $TARGET"
if [ "$CODEX_RUNTIME_CACHE" -eq 1 ]; then
  say "Runtime cache target: true"
  say "Warning: installing to the observed Codex CLI runtime cache. This is explicit and may be overwritten by Codex internals."
fi

if [ "$DRY_RUN" -eq 1 ]; then
  say "Dry run: no files will be copied."
  exit 0
fi

if [ -e "$TARGET" ]; then
  [ "$FORCE" -eq 1 ] || fail "Target already exists: $TARGET. Re-run with --force to replace it."
  if [ "$CODEX_RUNTIME_CACHE" -eq 1 ]; then
    backup_parent="$(dirname "$(dirname "$TARGET")")/pam-core-backups"
    mkdir -p "$backup_parent"
    backup="$backup_parent/$(basename "$TARGET").backup.$(date -u '+%Y%m%d%H%M%S')"
  else
    backup="${TARGET}.backup.$(date -u '+%Y%m%d%H%M%S')"
  fi
  mv "$TARGET" "$backup"
  say "Existing target moved to backup: $backup"
fi

mkdir -p "$TARGET"

for item in "${REQUIRED_ITEMS[@]}"; do
  copy_item "$item"
done

for item in "${OPTIONAL_COMMON_ITEMS[@]}"; do
  if [ -e "$SOURCE_ROOT/$item" ]; then
    copy_item "$item"
  fi
done

case "$AGENT" in
  claude-code)
    [ -e "$SOURCE_ROOT/.claude-plugin" ] && copy_item ".claude-plugin"
    ;;
  codex-cli|codex-app)
    [ -e "$SOURCE_ROOT/.codex-plugin" ] && copy_item ".codex-plugin"
    ;;
esac

write_manifest

for item in "${REQUIRED_ITEMS[@]}"; do
  [ -e "$TARGET/$item" ] || fail "Installed target is missing required item: $item"
done
[ -f "$TARGET/.install-manifest.json" ] || fail "Installed target is missing .install-manifest.json"

file_count="$(find "$TARGET" -type f | wc -l | tr -d ' ')"
say "Installed pam-core to $TARGET"
say "Files installed: $file_count"
say "Manifest: $TARGET/.install-manifest.json"
