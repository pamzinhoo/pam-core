#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd -P)"
TARGET=""

usage() {
  cat <<'EOF'
Usage: scripts/runtime-smoke-test.sh --target PATH
       scripts/runtime-smoke-test.sh --help

Check that a pam-core install target contains files needed for a manual runtime
test. This script does not test AI behavior.
EOF
}

fail() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

check_target_file() {
  [ -f "$TARGET/$1" ] || fail "Target is missing required file: $1"
}

check_source_file() {
  [ -f "$ROOT/$1" ] || fail "Source is missing runtime test document: $1"
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

[ -n "$TARGET" ] || fail "--target is required"
TARGET="${TARGET%/}"
[ -d "$TARGET" ] || fail "Target does not exist: $TARGET"

check_target_file "AGENTS.md"
check_target_file "MODULES.md"
check_target_file "SKILL_DEPENDENCIES.md"
check_target_file "PROJECT_STATE.md"
check_target_file ".install-manifest.json"
[ -d "$TARGET/skills" ] || fail "Target is missing skills directory"

check_source_file "docs/runtime-tests/README.md"
check_source_file "docs/runtime-tests/CLAUDE_CODE.md"
check_source_file "docs/runtime-tests/CODEX_CLI.md"
check_source_file "docs/runtime-tests/CODEX_APP.md"
check_source_file "docs/runtime-tests/GENERIC_AGENT.md"
check_source_file "docs/runtime-tests/SMOKE_TEST_PROMPTS.md"
check_source_file "docs/runtime-tests/EVIDENCE_TEMPLATE.md"
check_source_file "docs/runtime-tests/RUNTIME_RESULTS.md"

if grep -q '"runtime_cache_target"[[:space:]]*:[[:space:]]*true' "$TARGET/.install-manifest.json"; then
  printf 'Runtime cache target: true\n'
else
  printf 'Runtime cache target: false\n'
fi
printf 'pam-core runtime smoke file check passed: %s\n' "$TARGET"
