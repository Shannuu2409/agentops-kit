# AgentOps Kit

**One-click AgentOps for every major coding agent** — 296 upstream ops skills, 30 overlay runbooks, and production-grade DevOps rules in a single installer.

<p align="center">

[![Agent Skills](https://img.shields.io/badge/skills-326%2B-brightgreen)](vendor/ops-engineering-skills/docs/SKILLS_INDEX.md)
[![Agents](https://img.shields.io/badge/agents-Cursor%20%7C%20Claude%20%7C%20Codex%20%7C%20Antigravity%20%7C%20Copilot-blue)](#supported-agents)
[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)

</p>

---

## Why AgentOps Kit?

You should not copy hundreds of `SKILL.md` files by hand or maintain five different directory layouts. AgentOps Kit:

1. **Pulls the full** [ops-engineering-skills](https://github.com/selvarajmurugesan90/ops-engineering-skills) catalog (296 skills, 22 domains) via git submodule.
2. **Adds 30 overlay skills** under [`skills/extras/`](skills/extras/) (deep DevOps runbooks: Docker, Kubernetes, Terraform, troubleshooting, and more).
3. **Deploys production rules** from [`rules/production-devops.mdc`](rules/production-devops.mdc) — Senior DevOps engineer standards for infra, CI/CD, and reliability work.
4. **Targets your agent** — Cursor, Claude Code, Codex, Antigravity, or GitHub Copilot — project-wide or global.

---

## Quick start

```bash
git clone --recurse-submodules git@github.com:Shannuu2409/agentops-kit.git
cd agentops-kit
./install
```

Follow the prompts (agent + scope). Restart your IDE when finished.

**Non-interactive (Cursor, current project):**

```bash
./install --agent cursor --scope project --target /path/to/your/repo -y
```

**Install everything for all agents in one repo:**

```bash
./install --agent all --scope project --target . -y
```

---

## What you get

| Layer | Count | Location in this repo |
|-------|------:|------------------------|
| Upstream ops skills | 296 | `vendor/ops-engineering-skills/plugins/*/skills/` |
| Overlay runbooks | 30 | `skills/extras/` |
| Production rules | 1 | `rules/production-devops.mdc` |

After install, skills land in your agent’s skills directory (see table below). Rules are copied or adapted per agent.

---

## Supported agents

| Agent | Project skills | Global skills | Rules |
|-------|----------------|---------------|--------|
| **Cursor** | `<target>/.cursor/skills/` | `~/.cursor/skills/` | `<target>/.cursor/rules/production-devops.mdc` |
| **Claude Code** | `<target>/.claude/skills/` | `~/.claude/skills/` | `<target>/AGENTS.md` + `.claude/rules/production-devops.md` |
| **OpenAI Codex** | `<target>/.codex/skills/` | `~/.codex/skills/` | `<target>/AGENTS.md` |
| **Google Antigravity** | `<target>/.agents/skills/` | `~/.gemini/config/skills/` | `<target>/AGENTS.md` |
| **GitHub Copilot** | `<target>/.github/skills/` | `~/.github/skills/` | `<target>/.github/copilot-instructions.md` |

> **Cursor:** Do not install into `~/.cursor/skills-cursor/` — that directory is reserved for Cursor built-ins.

---

## Installer reference

```text
./install [options]

  --agent <cursor|claude|codex|antigravity|copilot|all>
  --scope <project|global>
  --target <path>       # default: pwd (project) or $HOME (global)
  -y, --yes             # skip confirmation
  --dry-run             # print actions only
  --prefer-extras       # overwrite upstream on name collision
  -h, --help
```

---

## Updating

```bash
cd agentops-kit
git pull
git submodule update --init --recursive
./install --agent cursor --scope project --target /path/to/repo -y
```

Pin the submodule to a specific upstream commit in your fork if you need reproducible installs.

---

## Repository layout

```text
agentops-kit/
├── install                 # entrypoint
├── scripts/
│   ├── install.sh
│   └── lib/                # agents, skills, rules
├── rules/production-devops.mdc
├── skills/extras/          # 30 overlay skills
├── vendor/ops-engineering-skills/   # submodule
├── AGENTS.md
├── LICENSE
└── NOTICE
```

---

## Name collisions (extras vs upstream)

Upstream installs first; overlay skills with the **same folder name** are skipped. Examples where upstream wins: `ci-cd-pipeline-design`, `secrets-management` (upstream DevSecOps skill). Use `--prefer-extras` to force overlay copies.

Legacy overlay names (e.g. `docker`, `kubernetes`, `terraform`) are intentionally separate from upstream’s longer tool-specific skill names.

---

## Credits

- **[ops-engineering-skills](https://github.com/selvarajmurugesan90/ops-engineering-skills)** — 296 skills, [Agent Skills standard](https://agentskills.io). Apache-2.0. See [NOTICE](NOTICE).
- **AgentOps Kit** overlay and installer — [Shannuu2409](https://github.com/Shannuu2409).

Full upstream index: [docs/SKILLS_INDEX.md](vendor/ops-engineering-skills/docs/SKILLS_INDEX.md) (after submodule init).

---

## Contributing

1. Add overlay skills under `skills/extras/<skill-name>/SKILL.md`.
2. Keep `rules/production-devops.mdc` agent-agnostic (no single-vendor paths).
3. Run `bash -n scripts/*.sh scripts/lib/*.sh` before opening a PR.

---

## License

Apache-2.0 for this repository’s overlay and scripts. Upstream skills remain under their respective licenses in `vendor/ops-engineering-skills/`.
