#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd -P)"
TARGET=""

usage() {
  cat <<'EOF'
Usage: scripts/validate-unix.sh [--target PATH] [--help]

Validate Unix installation support for pam-core. With --target, also validate
that the target contains a pam-core Unix installation.
EOF
}

fail() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

check_file() {
  [ -f "$ROOT/$1" ] || fail "Missing required file: $1"
}

check_dir() {
  [ -d "$ROOT/$1" ] || fail "Missing required directory: $1"
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target)
      [ "$#" -ge 2 ] || fail "--target requires a path"
      TARGET="$2"
      shift 2
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

scripts=(
  "scripts/install-unix.sh"
  "scripts/uninstall-unix.sh"
  "scripts/validate-unix.sh"
  "scripts/detect-agent.sh"
  "scripts/runtime-smoke-test.sh"
  "scripts/package-release.sh"
  "scripts/validate-package.sh"
)

for script in "${scripts[@]}"; do
  check_file "$script"
  [ -x "$ROOT/$script" ] || fail "Script is not executable: $script"
  if grep -q $'\r' "$ROOT/$script"; then
    fail "Script contains CRLF line endings: $script"
  fi
done

required_items=(
  "AGENTS.md"
  "README.md"
  "MODULES.md"
  "SKILL_DEPENDENCIES.md"
  "PROJECT_STATE.md"
  "DECISIONS.md"
  "VERSIONING.md"
  "docs/PACKAGING.md"
  "docs/USAGE.md"
  "docs/LINUX_TEST_PLAN.md"
  "docs/KNOWN_LIMITATIONS.md"
  "docs/RELEASE_READINESS.md"
)

for item in "${required_items[@]}"; do
  check_file "$item"
done
check_dir "skills"

runtime_docs=(
  "docs/runtime-tests/README.md"
  "docs/runtime-tests/CLAUDE_CODE.md"
  "docs/runtime-tests/CODEX_CLI.md"
  "docs/runtime-tests/CODEX_APP.md"
  "docs/runtime-tests/GENERIC_AGENT.md"
  "docs/runtime-tests/SMOKE_TEST_PROMPTS.md"
  "docs/runtime-tests/EVIDENCE_TEMPLATE.md"
  "docs/runtime-tests/RUNTIME_RESULTS.md"
)

for doc in "${runtime_docs[@]}"; do
  check_file "$doc"
done

"$ROOT/scripts/install-unix.sh" --help >/dev/null
"$ROOT/scripts/uninstall-unix.sh" --help >/dev/null
"$ROOT/scripts/detect-agent.sh" >/dev/null
"$ROOT/scripts/runtime-smoke-test.sh" --help >/dev/null
"$ROOT/scripts/package-release.sh" --help >/dev/null
"$ROOT/scripts/validate-package.sh" --help >/dev/null
grep -q -- '--codex-runtime-cache' "$ROOT/scripts/install-unix.sh" ||
  fail "install-unix.sh must document --codex-runtime-cache"
grep -q -- '--codex-runtime-cache' "$ROOT/scripts/uninstall-unix.sh" ||
  fail "uninstall-unix.sh must document --codex-runtime-cache"

if [ -n "$TARGET" ]; then
  TARGET="${TARGET%/}"
  [ -d "$TARGET" ] || fail "Target does not exist: $TARGET"
  [ -f "$TARGET/.install-manifest.json" ] || fail "Target is missing .install-manifest.json"
  grep -q '"package"[[:space:]]*:[[:space:]]*"pam-core"' "$TARGET/.install-manifest.json" ||
    fail "Target manifest does not identify pam-core"

  for item in "${required_items[@]}"; do
    [ -f "$TARGET/$item" ] || fail "Target is missing required file: $item"
  done
  [ -d "$TARGET/skills" ] || fail "Target is missing skills directory"
fi

printf 'pam-core Unix validation passed: %s\n' "$ROOT"
