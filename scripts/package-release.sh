#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd -P)"
cd "$ROOT"
DIST="dist"
STAGING="$DIST/_staging"
PACKAGE_NAME="pam-core"

INCLUDED_PATHS=(
  "AGENTS.md"
  "README.md"
  "MODULES.md"
  "SKILL_DEPENDENCIES.md"
  "PROJECT_STATE.md"
  "DECISIONS.md"
  "VERSIONING.md"
  "skills"
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
  "docs/runtime-tests"
)

EXCLUDED_PATTERNS=(
  ".git/"
  "dist/"
  "logs/"
  "tmp/"
  "cache/"
  "*.bak"
  "*.tmp"
  "node_modules/"
  "__pycache__/"
  ".pytest_cache/"
  ".mypy_cache/"
  ".DS_Store"
  "Thumbs.db"
)

usage() {
  cat <<'EOF'
Usage: scripts/package-release.sh [--help]

Create versioned pam-core release packages in dist/.
EOF
}

fail() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

json_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
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

runtime_pending() {
  if [ ! -f "$ROOT/docs/runtime-tests/RUNTIME_RESULTS.md" ]; then
    printf 'true'
    return
  fi

  local agent
  for agent in "Claude Code" "Codex CLI" "Codex App"; do
    if ! grep -E "^\|[[:space:]]*$agent[[:space:]]*\|" "$ROOT/docs/runtime-tests/RUNTIME_RESULTS.md" |
      grep -qE '\|[[:space:]]*supported[[:space:]]*\|'; then
      printf 'true'
      return
    fi
  done

  printf 'false'
}

copy_item() {
  local rel="$1"
  local src="$ROOT/$rel"
  local dest="$PACKAGE_ROOT/$rel"

  [ -e "$src" ] || fail "Missing required package input: $rel"
  mkdir -p "$(dirname "$dest")"
  cp -R "$src" "$dest"
}

write_json_array() {
  local count="$#"
  local i=0
  local value
  for value in "$@"; do
    local suffix=","
    i=$((i + 1))
    [ "$i" -eq "$count" ] && suffix=""
    printf '    "%s"%s\n' "$(json_escape "$value")" "$suffix"
  done
}

write_manifest() {
  local format="$1"
  local manifest="$PACKAGE_ROOT/PACKAGE_MANIFEST.json"
  local created_at
  created_at="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  local source_commit=""
  if command -v git >/dev/null 2>&1; then
    source_commit="$(git -C "$ROOT" rev-parse HEAD 2>/dev/null || true)"
  fi
  local runtime_is_pending
  runtime_is_pending="$(runtime_pending)"

  {
    printf '{\n'
    printf '  "name": "%s",\n' "$PACKAGE_NAME"
    printf '  "version": "%s",\n' "$(json_escape "$VERSION")"
    printf '  "created_at": "%s",\n' "$created_at"
    if [ -n "$source_commit" ]; then
      printf '  "source_commit": "%s",\n' "$(json_escape "$source_commit")"
    else
      printf '  "source_commit": null,\n'
    fi
    printf '  "package_format": "%s",\n' "$format"
    printf '  "runtime_pending": %s,\n' "$runtime_is_pending"
    printf '  "evidence_file": "docs/runtime-tests/RUNTIME_RESULTS.md",\n'
    printf '  "included_paths": [\n'
    write_json_array "${INCLUDED_PATHS[@]}"
    printf '  ],\n'
    printf '  "excluded_patterns": [\n'
    write_json_array "${EXCLUDED_PATTERNS[@]}"
    printf '  ]\n'
    printf '}\n'
  } > "$manifest"
}

write_checksums() {
  local checksums="$DIST/CHECKSUMS.txt"
  : > "$checksums"
  if command -v sha256sum >/dev/null 2>&1; then
    (cd "$DIST" && sha256sum "$ROOT_NAME.zip" "$ROOT_NAME.tar.gz") > "$checksums"
  elif command -v shasum >/dev/null 2>&1; then
    (cd "$DIST" && shasum -a 256 "$ROOT_NAME.zip" "$ROOT_NAME.tar.gz") > "$checksums"
  else
    fail "sha256sum or shasum is required to write CHECKSUMS.txt"
  fi
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

VERSION="$(read_version)"
[ -n "$VERSION" ] || fail "Could not read version from PROJECT_STATE.md"
ROOT_NAME="$PACKAGE_NAME-$VERSION"
PACKAGE_ROOT="$STAGING/$ROOT_NAME"
ZIP_PATH="$DIST/$ROOT_NAME.zip"
TAR_PATH="$DIST/$ROOT_NAME.tar.gz"

mkdir -p "$DIST"
if [ -e "$STAGING" ]; then
  [ "$STAGING" = "dist/_staging" ] || fail "Refusing to remove unexpected staging path: $STAGING"
  rm -rf "$STAGING"
fi

mkdir -p "$PACKAGE_ROOT"
for item in "${INCLUDED_PATHS[@]}"; do
  copy_item "$item"
done

write_manifest "tar.gz"
rm -f "$TAR_PATH"
tar -czf "$TAR_PATH" -C "$STAGING" "$ROOT_NAME"

write_manifest "zip"
rm -f "$ZIP_PATH"
if command -v zip >/dev/null 2>&1; then
  (cd "$STAGING" && zip -qr "$ROOT/$ZIP_PATH" "$ROOT_NAME")
elif command -v powershell.exe >/dev/null 2>&1; then
  ps_package_root="$PACKAGE_ROOT"
  ps_zip_path="$ROOT/$ZIP_PATH"
  if command -v cygpath >/dev/null 2>&1; then
    ps_package_root="$(cygpath -w "$PACKAGE_ROOT")"
    ps_zip_path="$(cygpath -w "$ROOT/$ZIP_PATH")"
  fi
  PACKAGE_ROOT_WIN="$ps_package_root" ZIP_PATH_WIN="$ps_zip_path" powershell.exe -NoProfile -Command '
$ErrorActionPreference = "Stop"
$PackageRoot = $env:PACKAGE_ROOT_WIN
$ZipPath = $env:ZIP_PATH_WIN
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
if (Test-Path -LiteralPath $ZipPath) {
  Remove-Item -LiteralPath $ZipPath -Force
}
$zip = [System.IO.Compression.ZipFile]::Open($ZipPath, [System.IO.Compression.ZipArchiveMode]::Create)
try {
  $packageName = Split-Path -Leaf $PackageRoot
  $rootPath = (Resolve-Path -LiteralPath $PackageRoot).Path.TrimEnd("\", "/")
  Get-ChildItem -LiteralPath $PackageRoot -Recurse -File | ForEach-Object {
    $relative = $_.FullName.Substring($rootPath.Length).TrimStart("\", "/") -replace "\\", "/"
    $entryName = "$packageName/$relative"
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
      $zip,
      $_.FullName,
      $entryName,
      [System.IO.Compression.CompressionLevel]::Optimal
    ) | Out-Null
  }
} finally {
  $zip.Dispose()
}
' >/dev/null
else
  fail "zip or powershell.exe is required to create $ZIP_PATH"
fi

write_checksums
rm -rf "$STAGING"

printf 'Created package: %s\n' "$ZIP_PATH"
printf 'Created package: %s\n' "$TAR_PATH"
printf 'Created checksums: %s\n' "$DIST/CHECKSUMS.txt"
