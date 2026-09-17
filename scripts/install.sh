#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# shellcheck source=lib/agents.sh
source "${SCRIPT_DIR}/lib/agents.sh"
# shellcheck source=lib/skills.sh
source "${SCRIPT_DIR}/lib/skills.sh"
# shellcheck source=lib/rules.sh
source "${SCRIPT_DIR}/lib/rules.sh"

AGENT=""
SCOPE=""
TARGET=""
ASSUME_YES=false
DRY_RUN=false
PREFER_EXTRAS=false

usage() {
  cat <<EOF
AgentOps Kit installer

Usage:
  $0 [options]

Options:
  --agent <cursor|claude|codex|antigravity|copilot|all>
  --scope <project|global>
  --target <path>     Project root (required for project scope; default: pwd)
  -y, --yes           Non-interactive; skip confirmations
  --dry-run           Print actions only
  --prefer-extras     Overwrite upstream skills when extra skill names collide
  -h, --help

Examples:
  $0
  $0 --agent cursor --scope project --target ~/my-app -y
  $0 --agent all --scope project --target . -y
EOF
  exit "${1:-0}"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --agent) AGENT="$2"; shift 2 ;;
    --scope) SCOPE="$2"; shift 2 ;;
    --target) TARGET="$2"; shift 2 ;;
    -y|--yes) ASSUME_YES=true; shift ;;
    --dry-run) DRY_RUN=true; shift ;;
    --prefer-extras) PREFER_EXTRAS=true; shift ;;
    -h|--help) usage 0 ;;
    *) echo "Unknown option: $1" >&2; usage 1 ;;
  esac
done

prompt_select() {
  local prompt="$1"
  shift
  local options=("$@")
  local i choice
  echo "${prompt}"
  for i in "${!options[@]}"; do
    echo "  $((i + 1))) ${options[$i]}"
  done
  read -r -p "Choice [1-${#options[@]}]: " choice
  if [[ ! "${choice}" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#options[@]} )); then
    echo "Invalid choice" >&2
    exit 1
  fi
  REPLY="${options[$((choice - 1))]}"
}

if [[ -z "${AGENT}" ]]; then
  prompt_select "Which AI agent are you using?" \
    "cursor" "claude" "codex" "antigravity" "copilot" "all"
  AGENT="${REPLY}"
fi

if [[ -z "${SCOPE}" ]]; then
  prompt_select "Install scope?" "project" "global"
  SCOPE="${REPLY}"
fi

if [[ "${SCOPE}" == project ]]; then
  TARGET="${TARGET:-$(pwd)}"
  TARGET="$(cd "${TARGET}" && pwd)"
else
  TARGET="${TARGET:-${HOME}}"
fi

if [[ "${ASSUME_YES}" != true && "${DRY_RUN}" != true ]]; then
  echo ""
  echo "Agent:  $(agent_display_name "${AGENT}")"
  echo "Scope:  ${SCOPE}"
  echo "Target: ${TARGET}"
  read -r -p "Proceed? [y/N]: " confirm
  case "${confirm}" in
    y|Y|yes|YES) ;;
    *) echo "Aborted."; exit 0 ;;
  esac
fi

install_one_agent() {
  local a="$1"
  local skills_dest
  skills_dest="$(agent_skills_dir "${a}" "${SCOPE}" "${TARGET}")"

  echo ""
  echo "=== $(agent_display_name "${a}") ==="
  echo "Skills -> ${skills_dest}"

  skills_install_upstream "${skills_dest}" "${DRY_RUN}"
  skills_install_extras "${skills_dest}" "${PREFER_EXTRAS}" "${DRY_RUN}"
  rules_deploy "${a}" "${SCOPE}" "${TARGET}" "${DRY_RUN}"
}

if [[ "${AGENT}" == all ]]; then
  for a in cursor claude codex antigravity copilot; do
    install_one_agent "${a}"
  done
else
  install_one_agent "${AGENT}"
fi

echo ""
echo "Done. Restart your IDE or reload the workspace so skills and rules are picked up."
