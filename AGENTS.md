# AgentOps Kit

This repository distributes **Agent Skills** and **production DevOps rules** for multiple AI coding agents.

## For agents working in this repo

- Skills live under `skills/extras/` (overlay) and `vendor/ops-engineering-skills/` (submodule, 296 upstream skills).
- Canonical production rules: `rules/production-devops.mdc`.
- End users install into their project with `./install` — do not assume `.cursor/` paths only.

## Install

```bash
./install
```

Non-interactive example:

```bash
./install --agent cursor --scope project --target . -y
```
