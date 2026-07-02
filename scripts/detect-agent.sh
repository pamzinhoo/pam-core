#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/detect-agent.sh [--help]

Detect a likely pam-core target agent and print:
  agent<TAB>suggested-target

Detection is intentionally conservative and uses known environment variables
and common configuration directories only.
EOF
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
      printf 'Unsupported agent: %s\n' "$agent" >&2
      return 1
      ;;
  esac
}

if [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if [ "$#" -gt 0 ]; then
  printf 'Unexpected argument: %s\n' "$1" >&2
  usage >&2
  exit 2
fi

detected="generic"

if [ -n "${CLAUDE_CONFIG_DIR:-}" ] || [ -n "${CLAUDE_CODE_ENTRYPOINT:-}" ] || [ -d "$HOME/.claude" ]; then
  detected="claude-code"
elif [ -n "${CODEX_HOME:-}" ] || [ -d "$HOME/.codex" ]; then
  detected="codex-cli"
elif [ -d "$HOME/Library/Application Support/Codex" ] || [ -d "${XDG_CONFIG_HOME:-$HOME/.config}/codex" ]; then
  detected="codex-app"
fi

printf '%s\t%s\n' "$detected" "$(agent_target "$detected")"
