#!/usr/bin/env bash
set -euo pipefail

KIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
RULE_SRC="${KIT_ROOT}/rules/production-devops.mdc"

rules_deploy() {
  local agent="$1"
  local scope="$2"
  local target="$3"
  local dry_run="${4:-false}"

  if [[ ! -f "${RULE_SRC}" ]]; then
    echo "Error: missing ${RULE_SRC}" >&2
    exit 1
  fi

  # Global scope: only Cursor rules in home (others are project-scoped in this kit)
  if [[ "${scope}" == global && "${agent}" != cursor ]]; then
    echo "Note: global rules install is only supported for Cursor; skipping rules for ${agent}." >&2
    return 0
  fi

  while IFS= read -r line; do
    [[ -n "${line}" ]] || continue
    local dest="${line%%|*}"
    local kind="${line##*|}"
    local dest_dir
    dest_dir="$(dirname "${dest}")"

    if [[ "${dry_run}" == true ]]; then
      echo "[dry-run] would deploy rules (${kind}) -> ${dest}"
      continue
    fi

    mkdir -p "${dest_dir}"
    case "${kind}" in
      mdc)
        cp "${RULE_SRC}" "${dest}"
        ;;
      agents_md)
        rules_write_agents_md "${dest}" "${agent}"
        ;;
      claude_rule)
        rules_write_claude_rule "${dest}"
        ;;
      copilot)
        rules_write_copilot "${dest}"
        ;;
      *)
        echo "Unknown rule kind: ${kind}" >&2
        exit 1
        ;;
    esac
    echo "Deployed rules (${kind}) -> ${dest}"
  done < <(agent_rules_targets "${agent}" "${scope}" "${target}")
}

rules_write_agents_md() {
  local dest="$1"
  local agent="$2"
  cat >"${dest}" <<EOF
# Agent instructions (AgentOps Kit)

Follow the **Senior DevOps Engineer** production standards in this repository.

- Production rules source: \`rules/production-devops.mdc\` (installed via [AgentOps Kit](https://github.com/Shannuu2409/agentops-kit)).
- Use **installed Agent Skills** in this project's skills directory for deep domain guidance.
- Agent target: ${agent}

## Production standards (summary)

Behave like a Senior DevOps Engineer: explain reasoning before generating infra code; optimize for production readiness, security, maintainability, and operability.

For the full ruleset, read \`rules/production-devops.mdc\` if present in the project, or re-run \`./install\` from AgentOps Kit.

EOF
}

rules_write_claude_rule() {
  local dest="$1"
  # Strip YAML frontmatter for plain markdown rule file
  awk 'BEGIN{skip=0} /^---$/{skip++; if(skip==1) next; if(skip==2){skip=3; next}} skip<2{next} {print}' "${RULE_SRC}" >"${dest}"
}

rules_write_copilot() {
  local dest="$1"
  {
    echo "# Copilot instructions — production DevOps (AgentOps Kit)"
    echo ""
    awk 'BEGIN{skip=0} /^---$/{skip++; if(skip==1) next; if(skip==2){skip=3; next}} skip<2{next} {print}' "${RULE_SRC}"
  } >"${dest}"
}
