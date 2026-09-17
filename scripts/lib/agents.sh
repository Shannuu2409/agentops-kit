#!/usr/bin/env bash
# Agent path mappings for AgentOps Kit.
set -euo pipefail

# shellcheck disable=SC2034
AGENT_CHOICES=(cursor claude codex antigravity copilot all)

agent_skills_dir() {
  local agent="$1"
  local scope="$2"
  local target="${3:-}"

  case "${agent}" in
    cursor)
      if [[ "${scope}" == global ]]; then
        echo "${HOME}/.cursor/skills"
      else
        echo "${target}/.cursor/skills"
      fi
      ;;
    claude)
      if [[ "${scope}" == global ]]; then
        echo "${HOME}/.claude/skills"
      else
        echo "${target}/.claude/skills"
      fi
      ;;
    codex)
      if [[ "${scope}" == global ]]; then
        echo "${HOME}/.codex/skills"
      else
        echo "${target}/.codex/skills"
      fi
      ;;
    antigravity)
      if [[ "${scope}" == global ]]; then
        echo "${HOME}/.gemini/config/skills"
      else
        echo "${target}/.agents/skills"
      fi
      ;;
    copilot)
      if [[ "${scope}" == global ]]; then
        echo "${HOME}/.github/skills"
      else
        echo "${target}/.github/skills"
      fi
      ;;
    *)
      echo "Unknown agent: ${agent}" >&2
      return 1
      ;;
  esac
}

agent_rules_targets() {
  # Prints lines: dest_path|type (mdc|agents_md|copilot)
  local agent="$1"
  local scope="$2"
  local target="${3:-}"

  case "${agent}" in
    cursor)
      if [[ "${scope}" == global ]]; then
        echo "${HOME}/.cursor/rules/production-devops.mdc|mdc"
      else
        echo "${target}/.cursor/rules/production-devops.mdc|mdc"
      fi
      ;;
    claude)
      if [[ "${scope}" != global ]]; then
        echo "${target}/AGENTS.md|agents_md"
        echo "${target}/.claude/rules/production-devops.md|claude_rule"
      fi
      ;;
    codex)
      if [[ "${scope}" != global ]]; then
        echo "${target}/AGENTS.md|agents_md"
      fi
      ;;
    antigravity)
      if [[ "${scope}" != global ]]; then
        echo "${target}/AGENTS.md|agents_md"
      fi
      ;;
    copilot)
      if [[ "${scope}" != global ]]; then
        echo "${target}/.github/copilot-instructions.md|copilot"
      fi
      ;;
  esac
}

agent_display_name() {
  case "$1" in
    cursor) echo "Cursor" ;;
    claude) echo "Claude Code" ;;
    codex) echo "OpenAI Codex" ;;
    antigravity) echo "Google Antigravity" ;;
    copilot) echo "GitHub Copilot" ;;
    all) echo "All agents" ;;
    *) echo "$1" ;;
  esac
}
