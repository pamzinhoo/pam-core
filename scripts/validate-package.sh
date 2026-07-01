#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd -P)"
cd "$ROOT"
DIST="dist"

REQUIRED_PATHS=(
  "PACKAGE_MANIFEST.json"
  "AGENTS.md"
  "README.md"
  "MODULES.md"
  "SKILL_DEPENDENCIES.md"
  "PROJECT_STATE.md"
  "DECISIONS.md"
  "VERSIONING.md"
  "skills/"
  "scripts/install-unix.sh"
  "scripts/uninstall-unix.sh"
  "scripts/validate-unix.sh"
  "scripts/detect-agent.sh"
  "scripts/runtime-smoke-test.sh"
  "scripts/validate.ps1"
  "scripts/validate-claude.ps1"
  "docs/INSTALL_LINUX.md"
  "docs/INSTALL_MACOS.md"
  "docs/AGENT_COMPATIBILITY.md"
  "docs/PACKAGING.md"
  "docs/USAGE.md"
  "docs/LINUX_TEST_PLAN.md"
  "docs/KNOWN_LIMITATIONS.md"
  "docs/RELEASE_READINESS.md"
  "docs/runtime-tests/"
)

FORBIDDEN_PATTERNS=(
  '(^|/)\.git(/|$)'
  '(^|/)dist(/|$)'
  '(^|/)logs(/|$)'
  '(^|/)tmp(/|$)'
  '(^|/)cache(/|$)'
  '(^|/)node_modules(/|$)'
  '(^|/)__pycache__(/|$)'
  '(^|/)\.pytest_cache(/|$)'
  '(^|/)\.mypy_cache(/|$)'
  '\.bak$'
  '\.tmp$'
  '(^|/)\.DS_Store$'
  '(^|/)Thumbs\.db$'
)

usage() {
  cat <<'EOF'
Usage: scripts/validate-package.sh [--help]

Validate pam-core release packages in dist/.
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

normalize_entry() {
  printf '%s' "$1" | sed 's#\\#/#g; s#^/*##'
}

has_required_path() {
  local list_file="$1"
  local required="${2%/}"
  awk -v required="$required" '
    {
      entry=$0
      gsub(/\\/, "/", entry)
      sub(/^[^/]+\//, "", entry)
      if (entry == required || index(entry, required "/") == 1) {
        found=1
      }
    }
    END { exit(found ? 0 : 1) }
  ' "$list_file"
}

check_forbidden_entries() {
  local list_file="$1"
  local pattern
  local normalized_file
  normalized_file="$(mktemp)"
  sed 's#\\#/#g; s#^/*##' "$list_file" > "$normalized_file"
  for pattern in "${FORBIDDEN_PATTERNS[@]}"; do
    if grep -Eq "$pattern" "$normalized_file"; then
      local entry
      entry="$(grep -E "$pattern" "$normalized_file" | head -n 1)"
      rm -f "$normalized_file"
      fail "Forbidden archive entry found: $entry"
    fi
  done
  rm -f "$normalized_file"
}

extract_and_check_manifest() {
  local archive="$1"
  local format="$2"
  local temp
  temp="$(mktemp -d)"
  if [ "$format" = "zip" ]; then
    command -v unzip >/dev/null 2>&1 || fail "unzip is required to inspect zip packages"
    unzip -q "$archive" -d "$temp" || {
      rm -rf "$temp"
      fail "unzip failed while extracting manifest from $archive"
    }
  else
    tar -xzf "$archive" -C "$temp"
  fi

  local manifest
  manifest="$(find "$temp" -name PACKAGE_MANIFEST.json -type f | head -n 1)"
  if [ -z "$manifest" ]; then
    rm -rf "$temp"
    fail "PACKAGE_MANIFEST.json not found in $archive"
  fi
  grep -q '"name"[[:space:]]*:[[:space:]]*"pam-core"' "$manifest" ||
    fail "Manifest name must be pam-core in $archive"
  grep -q "\"package_format\"[[:space:]]*:[[:space:]]*\"$format\"" "$manifest" ||
    fail "Manifest package_format must be $format in $archive"
  grep -q '"runtime_pending"[[:space:]]*:[[:space:]]*true' "$manifest" ||
    fail "Manifest runtime_pending must be true while runtime is unconfirmed"
  rm -rf "$temp"
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --help)
      usage
      exit 0
      ;;
    *)
      fail "Unknown option: $1"
      ;;
  esac
done

[ -d "$DIST" ] || fail "dist directory does not exist: $DIST"
VERSION="$(read_version)"
[ -n "$VERSION" ] || fail "Could not read version from PROJECT_STATE.md"

ZIP_PATH="$DIST/pam-core-$VERSION.zip"
TAR_PATH="$DIST/pam-core-$VERSION.tar.gz"
CHECKSUMS="$DIST/CHECKSUMS.txt"

[ -f "$ZIP_PATH" ] || fail "Missing zip package: $ZIP_PATH"
[ -f "$TAR_PATH" ] || fail "Missing tar.gz package: $TAR_PATH"
[ -f "$CHECKSUMS" ] || fail "Missing CHECKSUMS.txt: $CHECKSUMS"

ZIP_LIST="$(mktemp)"
TAR_LIST="$(mktemp)"
trap 'rm -f "$ZIP_LIST" "$TAR_LIST"' EXIT

command -v unzip >/dev/null 2>&1 || fail "unzip is required to inspect zip packages"
unzip -Z1 "$ZIP_PATH" > "$ZIP_LIST"
tar -tzf "$TAR_PATH" > "$TAR_LIST"

for required in "${REQUIRED_PATHS[@]}"; do
  has_required_path "$ZIP_LIST" "$required" || fail "Zip package is missing required path: $required"
  has_required_path "$TAR_LIST" "$required" || fail "tar.gz package is missing required path: $required"
done

check_forbidden_entries "$ZIP_LIST"
check_forbidden_entries "$TAR_LIST"
extract_and_check_manifest "$ZIP_PATH" "zip"
extract_and_check_manifest "$TAR_PATH" "tar.gz"

grep -q "pam-core-$VERSION.zip" "$CHECKSUMS" || fail "CHECKSUMS.txt is missing zip package"
grep -q "pam-core-$VERSION.tar.gz" "$CHECKSUMS" || fail "CHECKSUMS.txt is missing tar.gz package"

if command -v sha256sum >/dev/null 2>&1; then
  (cd "$DIST" && sha256sum -c CHECKSUMS.txt)
elif command -v shasum >/dev/null 2>&1; then
  (cd "$DIST" && shasum -a 256 -c CHECKSUMS.txt)
else
  fail "sha256sum or shasum is required to validate CHECKSUMS.txt"
fi

printf 'pam-core package validation passed: %s\n' "$DIST"
