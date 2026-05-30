# Codex roadmap

> **Codex support is planned for v1.2. This document tracks the planned port.**
>
> Ravie v1.1 ships as a **Claude Code plugin only**. All Codex-specific guidance,
> templates, and notes that previously lived in other files have been consolidated
> here so they are preserved for the future port without cluttering the Claude Code
> experience. Nothing in this file is wired into the plugin yet — treat it as design
> notes and ready-to-port material.

---

## Why Codex was split out

The original v1.0 docs interleaved Claude Code and Codex instructions in many files
(README, INSTALLATION, START-HERE, ROUTER, several skills, and two AGENTS.md
templates). That made the Claude Code path harder to read and implied a level of
Codex support that does not exist yet. v1.1 removes Codex from the shipping surface
and parks the work here until it can be done properly and tested.

When the Codex port lands (planned v1.2), it should:

- Ship a Codex plugin manifest and marketplace catalog so the install experience
  matches Claude Code's.
- Provide an `AGENTS.md` entry-file flow (templates below are the head start).
- Port the deterministic guard hooks to Codex's native hook system.

---

## Planned Codex-native port structure

Codex has native equivalents to Ravie's Claude Code assets, in different locations:

- **Hooks → `.codex/hooks/`** for hook scripts, wired through `hooks.json` files or
  an inline `[hooks]` table in `config.toml` next to an active config layer. Codex
  hooks are now a **stable** feature; the canonical feature key is `hooks` (the older
  `codex_hooks` flag still works as a deprecated alias). Verified against OpenAI's
  Codex docs (Hooks, Config Reference) as of early 2026.
- **Skills → `.agents/skills/`** for Codex skills, with explicit and implicit
  invocation. Codex scans `.agents/skills` in every directory from the current
  working directory up to the repository root, parses `SKILL.md` frontmatter, and
  loads skills on demand. The `skills/*/SKILL.md` format is shared between Claude Code
  and Codex, so the existing skill tree can be copied or symlinked into `.agents/skills/`.
- **Subagents → `.codex/agents/*.toml`** for Codex custom agents (one TOML file per
  agent; project-scoped under `.codex/agents/`, personal under `~/.codex/agents/`).
  Global subagent settings live under `[agents]` in `config.toml`.

Until the port exists, a Codex user can still read individual Ravie skill files by
path and inline the critical safety gates into `AGENTS.md`.

---

## AGENTS.md and instruction-file behavior (reference)

Codex reads `AGENTS.md` as instruction context. It reads global/home guidance first,
then project and nested `AGENTS.md` files; more specific (deeper) files take
precedence because they appear later in the combined prompt. The default
project-instruction cap is **32 KiB** (`project_doc_max_bytes` in `config.toml`);
content past the cap is silently truncated, so keep entry files lean (~6 KB is a good
practical target) and split detail into referenced files.

---

## Extracted: START-HERE "Codex support" section

> Source: `START-HERE.md` (v1.0)

Ravie targets Claude Code. A Codex dual-plugin port is planned for a future release.

The skill files themselves use the shared `SKILL.md` format that both Claude Code and
Codex understand, so a Codex user can already read individual skills by path today.
What the port adds is a proper Codex plugin manifest, marketplace catalog, and an
`AGENTS.md` entry-file flow so the install experience matches Claude Code's. The
`AGENTS.md` templates below ship here as a head start for that workflow.

---

## Extracted: multi-model routing notes

> Source: `ROUTER.md` (v1.0)

When routing across multiple models/tools, the intended split was:

- **Claude Code:** repo work, implementation, tests, local commands, Git, skill/source updates.
- **Claude Desktop:** connected-app planning and broad cross-system context.
- **ChatGPT:** second-opinion review, synthesis, strategy, artifact drafting, technical explanation, research.
- **Codex:** focused code review, implementation alternatives, patches, tests, debugging.

ROUTER.md documents intended routing for human and AI reference; it is not automatic
routing logic. Claude Code selects skills from YAML descriptions. Codex requires
explicit skill references by path until the native port lands.

---

## Extracted: hooks-guide "Codex compatibility" section

> Source: `docs/hooks-guide.md` (v1.0)

Ravie hooks are Claude Code-native because they live under `.claude/` and are wired
through `.claude/settings.json` (plugin installs use `hooks/hooks.json`). Codex has
its own native hook system: hooks are now a stable feature, configured via
`hooks.json` files or inline `[hooks]` tables in `config.toml` next to a config layer
(for example a project's `.codex/`), with scripts commonly kept under `.codex/hooks/`.
The canonical feature key is `hooks`; the older `codex_hooks` flag still works as a
deprecated alias. Until a Codex-native hook port exists, duplicate the critical safety
gates in `AGENTS.md` or implement equivalent Codex hooks for Codex projects.

---

## Extracted: context-hygiene Codex note

> Source: `docs/context-hygiene.md` (v1.0)

When checking context usage:

- Claude Code: `/context` or watch the status line.
- Codex: watch the token counter.

---

## Extracted: Superpowers install for Codex

> Source: `docs/superpowers-setup.md` (v1.0). Verified against the official
> `obra/superpowers` README as of early 2026.

Superpowers is available via the official Codex plugin marketplace. To install it in
Codex:

```
/plugins
```

Search for "superpowers" and select Install Plugin. (In the Codex app, click
**Plugins** in the sidebar, find Superpowers in the Coding section, click the **+**,
and follow the prompts.)

---

## Extracted: project-control-plane Codex onboarding step

> Source: `skills/project-control-plane/SKILL.md`, step 7 (v1.0)

### For Codex: create AGENTS.md

Copy an `AGENTS.md` template (see below) to the project root. Fill in the same content
as `CLAUDE.md`, with critical rules inlined because Ravie does not yet port to
Codex-native `.codex/hooks/`. Reference rule files and skill files by path unless the
project has copied or symlinked skills into `.agents/skills/`.

When this step is active again, the onboarding output should also record:

```
- AGENTS.md — [if Codex, path]
```

---

## Template: compact AGENTS.md starter

> Source: `AGENTS-TEMPLATE.md` (v1.0), moved here intact.

This is the compact project entry point for OpenAI Codex. Codex reads `AGENTS.md` as
instruction context. This template tells Codex which skill markdown files to read by
path until a Codex-native port exists.

Copy this starter into your project root as `AGENTS.md`, fill in brackets, and keep it
parallel with `CLAUDE.md`.

```markdown
# [Project name] — Codex context

## Project snapshot

[1-2 paragraphs: what this product is, who it serves, and the current build phase. Include the repo's real purpose, not marketing copy.]

## Stack and commands

- Frontend: [Next.js / React / TypeScript / Tailwind / other]
- Backend/DB: [Supabase / other]
- Deploy: [Vercel / other]
- Package manager: [pnpm/npm/yarn]

Use these commands unless the user says otherwise:

[pnpm install]
[pnpm dev]
[pnpm typecheck]
[pnpm lint]
[pnpm test]
[pnpm build]

## Systems of record

- Tasks: [Linear/Jira URL or convention]
- Knowledge: [Notion/Docs URL]
- Source: [GitHub repo URL]
- Deploys: [Vercel/project URL]
- Design: [Figma URL]

Do not create duplicate local task trackers or knowledge stores when one of these systems is authoritative.

## Operating rules

- Prefer small, reversible changes over broad rewrites.
- State assumptions before acting when requirements are ambiguous.
- Read the relevant skill or rule file before doing specialized work.
- Run the smallest meaningful validation before claiming done.
- Ask before production-impacting changes, dependency additions, schema changes, or external writes.

## Approval gates

Default to Tier 2: safe local edits and read-only inspection are okay; external writes, deploys, migrations, secrets, billing, and production actions require explicit approval.

Never push directly to `main` or `master`. Never commit secrets, `.env` files, private keys, tokens, passwords, or connection strings. Never use a service-role key in code reachable from client components.

## Ravie files available by path

Read the plugin's skill markdown files by path when the task matches (paths assume a local checkout of the ravie repo or a copy into `.agents/skills/`):

- `skills/issue-to-pr/SKILL.md` — approved issue to branch, checks, preview, PR.
- `skills/debug-root-cause/SKILL.md` — debug symptoms by finding the actual cause first.
- `skills/requirements-griller/SKILL.md` — convert vague requests into scope and acceptance criteria.
- `skills/figma-lovable-handoff/SKILL.md` — convert design/Lovable handoff into implementation plan and QA.
- `skills/supabase-guardian/SKILL.md` — schema, RLS, auth, storage, edge functions, or service-role changes.
- `skills/code-review/SKILL.md` — review AI-generated code before merge.

Rule references:

- `rules/git.md` — before branch, commit, PR, merge, or release work.
- `rules/supabase.md` — before migration, RLS, auth, storage, or service-role work.
- `rules/ui.md` — before UI, responsive, accessibility, motion, or copy work.
- `rules/context-hygiene.md` — before broad investigation or long debugging.
- `rules/karpathy-guidelines.md` — baseline engineering behavior.

## Current priorities

1. [Priority 1]
2. [Priority 2]
3. [Priority 3]

## Project-specific conventions

- Branch names: `[feature/short-description]`
- Commit style: `[convention]`
- Test policy: `[what must pass before PR]`
- UI style: `[design system notes]`
- Data policy: `[privacy, RLS, tenancy, retention]`

## Known issues and active work

[Short notes on migrations, refactors, flaky tests, incomplete features, or decisions in progress.]

## Things to never do in this project

- Do not make broad refactors while solving a narrow issue.
- Do not bypass RLS to fix frontend data bugs.
- Do not invent requirements when acceptance criteria are missing.
- Do not skip validation because a change "looks small."
- [Add project-specific dealbreakers.]
```

### Minimum viable AGENTS.md

```markdown
# [Project] — Codex context

## Stack
- [Frontend]
- [Backend/DB]
- [Deploy]

## Commands
- Dev: [cmd]
- Build: [cmd]
- Typecheck: [cmd]
- Test: [cmd]

## Approval gates
Default Tier 2. Ask before external writes, production changes, migrations, secrets, dependency additions, or deploys. Never push main/master or write secrets.

## Ravie paths
Read `skills/[name]/SKILL.md` and `rules/[domain].md` when the task matches.
```

---

## Template: quickstart AGENTS.md

> Source: `quickstart/AGENTS.md` (v1.0), moved here intact.

```markdown
# [Project Name] — Agent context (Codex)

> Copy this file to the root of your project as AGENTS.md for Codex. Same depth as CLAUDE.md, adapted for Codex instruction files. Takes ~5 minutes.

## What this project is

[1-2 sentences. Product, stage, who it's for.]

## Stack

- [Frontend stack]
- [Backend/DB]
- [Deploy]
- [Auth]

## Commands

- Install: `[pnpm install]`
- Dev: `[pnpm dev]`
- Build: `[pnpm build]`
- Typecheck: `[pnpm typecheck]`
- Test: `[pnpm test]`

## Connected systems

- GitHub: [url]
- Tasks: [url]
- Docs: [url]

## Available skills

Codex can read the skill files in this repo by path. The shared `skills/*/SKILL.md` tree is the same one Claude Code uses. Key skills:
- `issue-to-pr` — the daily driver for building features
- `debug-root-cause` — for finding actual bug causes
- `requirements-griller` — for clarifying vague requests
- `code-review` — review AI-generated code before committing

## Hard rules (non-negotiable)

- Never commit secrets or .env files
- Never push directly to main
- Never start implementation without acceptance criteria
- Never skip baseline checks before pushing
- Surface assumptions explicitly — don't guess
- Minimum code that solves the problem — nothing speculative
- Surgical changes only — don't modify adjacent code
- If a skill exists for the task, read its `SKILL.md` by path and follow it first

## Things to never do

- [Your stack dealbreakers]
- Don't create local file-based task tracking
- Don't skip checks to save time
```

---

## Full reference: expanded AGENTS.md

> Source: `docs/agents-template-full-reference.md` (v1.0), moved here intact.

This is the expanded reference for writing an OpenAI Codex `AGENTS.md`. Use the compact
starter above for the quick version. Use this full reference when you want a more
comprehensive AGENTS.md or need examples for a specific section. If you copy large
sections, keep them maintained and remove parts that do not apply to the project.

```markdown
# [Project Name] — Codex agent context

> Last updated: [YYYY-MM-DD]
> Maintainer: [Maintainer name or team]

## What this project is

[1-2 sentences. What does this product do? Who is it for? What is the current stage — MVP, alpha, paying users, internal tool?]

Example: "[Project] is a [category] for [audience]. It is currently [stage] and the current priority is [priority]."

## Stack

**Frontend:** [Next.js 14? Vite + React? Lovable export? — be specific including version]
**Backend:** [Supabase / Edge Functions / API routes / Node server]
**Database:** Supabase Postgres with RLS
**Auth:** Supabase Auth
**Deploy:** Vercel (preview + production)
**Frontend libs of note:** [Tailwind? shadcn/ui? Framer Motion? Three.js?]
**State management:** [Zustand? React Query? Context?]
**Other tools:** [Lovable for prototyping, Figma for design, etc.]

## Repo conventions

**Branch naming:** `[issue-key]-short-slug` — e.g. `PROJ-42-dashboard-cards`
**Commit style:** [Conventional commits? Plain commits? Include Linear key?]
**PR template:** see `.github/pull_request_template.md` if it exists, otherwise [describe]
**Folder structure:**
[paste tree -L 2 output of your repo here, or describe key directories]

## Commands

| Purpose | Command |
|---|---|
| Install | `pnpm install` |
| Dev server | `pnpm dev` |
| Build | `pnpm build` |
| Typecheck | `pnpm typecheck` |
| Lint | `pnpm lint` |
| Test | `pnpm test` |
| Supabase types | `pnpm gen:types` |
| Migration (local) | `supabase migration new [name]` |
| Migration (push) | `supabase db push` |

## Connected systems

| System | URL / ID | Purpose | Codex behavior |
|---|---|---|---|
| GitHub repo | https://github.com/[user]/[repo] | Code source of truth | Read freely; ask before pushing branches or opening PRs |
| Linear project | https://linear.app/[workspace]/project/[slug] | Tasks and execution | Draft updates locally unless explicitly approved to write |
| Notion project page | https://notion.so/[page-id] | PRDs, decisions, runbooks | Draft pages locally unless explicitly approved to write |
| Supabase project | https://supabase.com/dashboard/project/[id] | Database, auth | Treat schema, RLS, auth, and data writes as high-risk |
| Vercel project | https://vercel.com/[user]/[project] | Deploys | Preview reads are okay; production deploy needs explicit approval |
| Figma file | [URL] | Design source | Use for handoff; do not invent missing design details |

## Active priorities

[3-5 bullets max. What are you actually working on right now? Update this when priorities shift.]

- [Priority 1]
- [Priority 2]
- [Priority 3]

## Decisions Codex should respect

[Things already decided. Do not re-litigate them every session.]

- We use [X] not [Y] because [reason].
- Auth is Supabase Auth, not [other option]. Do not suggest changes.
- We are not adding [feature] until [milestone].
- [Add as decisions accumulate.]

Link to full decision log: [Notion URL]

## Approval gates for this project

Codex does not run Ravie `scripts/`. Treat these gates as explicit instructions unless you have ported equivalent hooks into `.codex/hooks/`. When in doubt, stop and ask.

Default tier: **Tier 2 (draft only)** unless explicitly upgraded for the session.

For this project specifically:
- Auto-allowed: reading files, searching the repo, drafting code, drafting Linear issues, drafting PRDs in Notion-ready markdown, proposing commands.
- Ask first: creating Linear issues, opening PRs, pushing branches, updating Notion pages, applying local migrations, changing dependency versions.
- Never without explicit approval naming the exact target: production deploys, production DB writes, secret changes, merging to main, force-pushes, deleting data, changing billing or auth settings.

Exact approval format for Tier 4 actions:

approved: [exact action] on [exact target]

For the full permission model see `/path/to/ravie/PERMISSION-MODEL.md`.

## Available Ravie skills

Skill files live at `skills/[name]/SKILL.md` in this repo, or at `/path/to/ravie/.claude/skills/[name]/SKILL.md` if Ravie is installed externally.

Codex can discover skills natively from `.agents/skills/` once they are copied or symlinked there. Before acting, when a task matches one of these workflows, read the relevant `skills/*/SKILL.md` file by path or use the Codex-native copy if your project has one.

Most-used for this project:
- `skills/issue-to-pr/SKILL.md` — approved Linear issue to branch, tracer bullet, checks, preview, PR.
- `skills/debug-root-cause/SKILL.md` — failing tests, broken preview, wrong data, automation failure, or unknown bug root cause.
- `skills/requirements-griller/SKILL.md` — vague requests, unclear scope, or deep interrogation mode for pre-spec ideas.
- `skills/figma-lovable-handoff/SKILL.md` — converting Figma/Lovable designs to production implementation plans.
- `skills/vercel-preview-qa/SKILL.md` — checking preview URLs against acceptance criteria before merge.
- `skills/supabase-guardian/SKILL.md` — before any DB, RLS, auth, storage, edge function, or service-role change.
- `skills/code-review/SKILL.md` — review non-trivial or AI-generated changes before commit or PR.
- `skills/permission-guardian/SKILL.md` — classify risk when an action may write externally or affect production.

Routing reference: `/path/to/ravie/ROUTER.md`. Use it as documentation for unclear or multi-skill requests, not as automatic routing logic.

## Rule files Codex should read explicitly

Codex should read these reference files by path when relevant:

- `rules/git.md` — before Git, branch, commit, PR, merge, or release work.
- `rules/supabase.md` — before schema, migration, RLS, auth, storage, or service-role work.
- `rules/ui.md` — before UI, design-system, responsive, a11y, motion, or copy work.
- `rules/context-hygiene.md` — before broad investigations or long-running debugging.
- `rules/karpathy-guidelines.md` — baseline engineering behavior: do not assume, keep changes surgical, verify claims.

## Things to never do in this project

- Do not commit secrets, `.env` files, tokens, passwords, or connection strings.
- Do not push directly to `main` or `master`; use branches and PRs.
- Do not start implementation without acceptance criteria unless the user explicitly asks for exploration.
- Do not skip baseline checks before claiming done.
- Do not create local file-based task tracking; Linear is the system of record.
- Do not create parallel knowledge stores; Notion is durable knowledge.
- Do not suggest switching major stack choices already listed in Decisions.
- Do not make broad refactors while solving a narrow issue.
- Do not silently assume missing product decisions; ask one sharp question or propose a default and mark it as an assumption.
- [Add project-specific don'ts as they come up.]

## Current state and known issues

[1-2 paragraphs about where the project is today. Any partially finished work? Migration in progress? Auth flow being rebuilt? Known flaky tests? This prevents Codex from suggesting things that conflict with in-flight work.]

## Notes for AI sessions

- When I say "the dashboard" I mean [specific component/page].
- When I say "the database" I mean the Supabase project, not local SQLite or a generated mock.
- "Production" means main branch deployed via Vercel; production actions require explicit approval.
- "Preview" means Vercel preview deploys from non-main branches; these are safer but still need QA.
- Prefer [code style preferences — destructured imports? early returns? server components?].
- When debugging, find root cause first. Do not stack patches until the symptom disappears.
- When a skill exists for the task, read it by path before acting.
```

### How to fill this out for a new project

Total time: 30-45 minutes for a project you know well. Keep it parallel with CLAUDE.md so Claude Code and Codex share the same context.

Order to fill in: stack and commands; connected systems; active priorities; repo conventions; decisions to respect; approval gates; things to never do; available skills and rule paths.

### Updating AGENTS.md

Update the file whenever Codex gets something wrong because context was missing. Common triggers: Codex suggests rejected tools (add to Decisions or Things to never do); misses a safety gate (strengthen Approval gates); implements without reading a skill (add the exact skill path); violates a Claude Code convention (inline the relevant rule file summary).

### Sharing across projects

Share between projects: the skills (symlinked or copied), a personal-preferences section, and standard approval-gate defaults. Keep project-specific: stack and commands, connected-system URLs, active priorities, and project-specific don'ts and decisions. The pattern: keep one shared `~/.codex/AGENTS.md` for personal defaults, and project-specific `AGENTS.md` files for each repo. Codex reads both.
