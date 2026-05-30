# Ravie

A four-layer operating system for Claude Code. 33 active skills, 5 rule reference files, 4 subagents, and 4 hook scripts — built for solo founders and designer-developers who are tired of re-explaining themselves every AI session.

---

## The problem

Every AI coding session starts blank. You re-explain your stack, your conventions, your safety rules, your project state. By the third session of the day, you've spent more time on context than on code.

Ravie fixes this. Drop these files into your project, and the agent starts with your stack, conventions, safety gates, and reusable workflows available.

## How it works

Four layers, each with a specific job:

```
┌─────────────────────────────────────────────┐
│  Layer 1: Companion plugins                 │
│  Superpowers + Karpathy Guidelines          │
│  → HOW the agent approaches any work        │
├─────────────────────────────────────────────┤
│  Layer 2: Rules + Hooks                     │
│  rules/ + scripts/ (via hooks/hooks.json)   │
│  → reference guidance + deterministic hooks │
├─────────────────────────────────────────────┤
│  Layer 3: CLAUDE.md                         │
│  Per-project entry point                    │
│  → WHAT the agent knows about this project  │
├─────────────────────────────────────────────┤
│  Layer 4: Skills + Agents                   │
│  skills/ + agents/                          │
│  → 33 specific workflows, 4 subagents       │
└─────────────────────────────────────────────┘
```

**Layer 1** handles process — when to brainstorm vs implement, TDD discipline, subagent dispatch. External plugins, auto-maintained.

**Layer 2** handles reference guidance plus enforcement. Rule files are domain references that the project entry file and skills instruct the agent to read when relevant; hooks are scripts that physically block or run covered actions.

**Layer 3** handles context — your stack, commands, connected systems, active priorities. You write this once per project (~100 lines).

**Layer 4** handles execution — domain-specific skills the agent selects based on YAML skill descriptions, plus 4 subagents that run in isolated context for code review, research, security, and UX checks.

## Who this is for

- Solo founders using Claude Code as their primary dev tool
- Designer-developers who work across Figma, code, and deployment
- Indie hackers who want repeatable workflows across multiple projects
- Anyone tired of the blank-slate session problem

## Quick start

Ravie is a Claude Code plugin. Install it once, then add a `CLAUDE.md` entry file to your project.

**1. Add the marketplace and install the plugin**

```
/plugin marketplace add amnafarzy/ravie
/plugin install ravie@ravie
```

**2. Drop an entry file into your project**

```bash
cd /path/to/your/project
curl -O https://raw.githubusercontent.com/amnafarzy/ravie/main/quickstart/CLAUDE.md
# Edit CLAUDE.md — fill in your stack and commands
```

**3. Reload and test**

```
/reload-plugins
```

In a new Claude Code session in your project:
```
> "Read CLAUDE.md and tell me what you understand about this project."
```

If the agent summarizes your stack correctly, it's working. Try a real task:
```
> "Help me debug this: [your current bug]"
```

The agent should match the debug request to the `debug-root-cause` skill based on its description.

> Prefer not to use a plugin? See [INSTALLATION.md](INSTALLATION.md) for direct git install, local plugin testing, or manual file copy.

**4. (Optional) Install the companion plugins**
```
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace

/plugin marketplace add forrestchang/andrej-karpathy-skills
/plugin install andrej-karpathy-skills@karpathy-skills
```

Superpowers handles workflow discipline (brainstorm → plan → TDD). Karpathy Guidelines reinforce surgical engineering behavior. Ravie handles project context. They're complementary.

## What's inside

### 33 active skills

**Daily drivers** (fully expanded with commands, templates, failure modes):

| Skill | What it does |
|---|---|
| `issue-to-pr` | Linear issue → branch → tracer bullet → checks → preview → PR |
| `debug-root-cause` | Find actual cause, not patch symptoms |
| `requirements-griller` | Vague request → precise scope + acceptance criteria |
| `idea-to-prd-tracer` | Idea → PRD → issues → plan → tracer bullet |
| `figma-lovable-handoff` | Design → token map + components + states + QA checklist |
| `code-review` | 8-dimension review of AI-generated code before commit |
| `growth-launch-pack` | Positioning, competitors, SEO, CRO, launch checklist |

**System operators** — manage your tools as systems of record:

`linear-operator` · `github-operator` · `notion-brain` · `automation-sre`

**Stack guards** — the agent should select these when touching sensitive areas:

`supabase-guardian` · `vercel-preview-qa` · `current-docs-guard` · `deploy-ready`

**Design skills** — for founders who also design:

`design-system-ui` · `responsive-ui` · `accessibility-ui` · `animation-motion` · `threejs-motion-performance` · `ui-copy`

**Meta skills** — the system improves itself:

`pattern-learner` · `skill-creator` · `workflow-evaluator` · `decision-log-adr`

[Full index →](SKILL-INDEX.md)

### 5 rule reference files

These files do not auto-load just because they exist. Skills and the project entry file instruct the agent to read the relevant rule file when working in that domain.

| Rule | Reference for |
|---|---|
| `karpathy-guidelines.md` | Behavioral baseline and surgical-change discipline |
| `git.md` | Git operations |
| `supabase.md` | Database/auth/RLS work |
| `ui.md` | Frontend/component work |
| `context-hygiene.md` | Session management |

### 4 subagents

Spawn in isolated context to avoid confirmation bias:

| Agent | Purpose |
|---|---|
| `code-reviewer` | 8-dimension code review in fresh context |
| `research-scout` | Explore codebase without polluting main context |
| `security-auditor` | Auth, RLS, secrets, injection review |
| `ux-checker` | State completeness, responsive, accessibility |

### 3 guard hooks plus auto-format

Deterministic enforcement for covered agent hook calls:

| Hook | What it does |
|---|---|
| `block-env-writes.sh` | Prevents writes to real `.env` files while allowing sanitized examples |
| `block-bash-secrets.sh` | Blocks Bash reads/searches/staging of `.env`, keys, `secrets/`, and credential files |
| `block-main-push.sh` | Prevents direct, forced, mirrored, or bulk pushes to main/master branches |
| `auto-format.sh` | Runs Prettier after Write/Edit/MultiEdit when possible |

## How it's different from Superpowers

Ravie and [Superpowers](https://github.com/obra/superpowers) are **complementary, not competing**.

| | Superpowers | Ravie |
|---|---|---|
| Handles | Workflow discipline | Project context |
| Scope | Process-agnostic | Stack-specific |
| Design skills | Not the focus | Yes (Figma, responsive, a11y, motion) |
| Growth/launch | Not the focus | Yes (positioning, SEO, CRO) |
| System-of-record rules | Not the focus | Yes (Notion/Linear/GitHub governance) |
| Permission tiers | Not the focus | Yes (5-tier model) |

Install both. Superpowers tells the agent *how* to approach work. Ravie tells the agent *what* it needs to know about your specific project.

## Stack assumptions

The default configuration assumes a modern indie-hacker stack:

- **Frontend:** Next.js / React + TypeScript + Tailwind
- **Backend/DB:** Supabase (Postgres + Auth + Storage)
- **Deploy:** Vercel
- **Tasks:** Linear
- **Knowledge:** Notion
- **Code:** GitHub

All of these are configurable. The skills reference these tools but the patterns work with any equivalent. Swap Supabase for Firebase, Linear for Jira, Notion for Obsidian — the workflow structure stays the same.

## Documentation

| Doc | Purpose |
|---|---|
| [START-HERE.md](START-HERE.md) | Onboarding — read first |
| [MASTER-GUIDE.md](MASTER-GUIDE.md) | Architecture deep-dive and principles |
| [CHEATSHEET.md](CHEATSHEET.md) | Daily reference — what to say for common tasks |
| [INSTALLATION.md](INSTALLATION.md) | Full setup for Claude Code |
| [SKILL-INDEX.md](SKILL-INDEX.md) | Complete catalog of all active skills |
| [docs/context-hygiene.md](docs/context-hygiene.md) | The "smart zone" — critical for session quality |
| [docs/superpowers-setup.md](docs/superpowers-setup.md) | Superpowers plugin integration |
| [docs/hooks-guide.md](docs/hooks-guide.md) | How to write and use hooks |

## Roadmap

- [ ] Community skill library — submit your own skills via PR
- [ ] Stack presets — one-command setup for Rails, Django, Go, etc.
- [ ] Automated skill testing — verify skills produce correct output
- [ ] Interactive visualizer in the repo (web-based system map)
- [ ] VS Code extension for skill browsing

## Contributing

Contributions welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

The easiest way to contribute: **add a new skill.** If you've built a workflow that saves you time, turn it into a SKILL.md and submit a PR. See `skills/skill-creator/SKILL.md` for the template and process.

## License

[MIT](LICENSE) — use it, fork it, build on it.

---

Built for solo founders and designer-developers who are tired of re-explaining everything to AI coding agents. If this saves you time, star the repo.
