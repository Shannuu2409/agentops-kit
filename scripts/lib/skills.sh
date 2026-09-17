#!/usr/bin/env bash
set -euo pipefail

KIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
VENDOR="${KIT_ROOT}/vendor/ops-engineering-skills"
EXTRAS="${KIT_ROOT}/skills/extras"
UPSTREAM_INSTALL="${VENDOR}/installers/install.sh"

skills_init_vendor() {
  if [[ ! -d "${VENDOR}/.git" ]]; then
    echo "Initializing ops-engineering-skills submodule..." >&2
    git -C "${KIT_ROOT}" submodule update --init --recursive
  fi
  if [[ ! -f "${UPSTREAM_INSTALL}" ]]; then
    echo "Error: upstream installer missing at ${UPSTREAM_INSTALL}" >&2
    echo "Run: git submodule update --init --recursive" >&2
    exit 1
  fi
}

skills_install_upstream() {
  local dest="$1"
  local dry_run="${2:-false}"
  skills_init_vendor
  mkdir -p "${dest}"
  if [[ "${dry_run}" == true ]]; then
    echo "[dry-run] would run: ${UPSTREAM_INSTALL} --plugin all --target ${dest}"
    return 0
  fi
  bash "${UPSTREAM_INSTALL}" --plugin all --target "${dest}"
}

skills_install_extras() {
  local dest="$1"
  local prefer_extras="${2:-false}"
  local dry_run="${3:-false}"

  if [[ ! -d "${EXTRAS}" ]]; then
    echo "Warning: no extras directory at ${EXTRAS}" >&2
    return 0
  fi

  local count=0
  for skill_dir in "${EXTRAS}"/*/; do
    [[ -d "${skill_dir}" ]] || continue
    local name
    name="$(basename "${skill_dir}")"
    local out="${dest}/${name}"

    if [[ -d "${out}" && "${prefer_extras}" != true ]]; then
      echo "Skipping extra '${name}' (already exists; use --prefer-extras to overwrite)" >&2
      continue
    fi

    if [[ "${dry_run}" == true ]]; then
      echo "[dry-run] would copy extra skill: ${name} -> ${out}"
    else
      rm -rf "${out}"
      cp -a "${skill_dir}" "${out}"
    fi
    count=$((count + 1))
  done
  echo "Installed ${count} extra skill(s) into ${dest}"
}
