# [Project Name] — Claude Code context

> Copy this file to the root of your project as CLAUDE.md. Fill in the bracketed sections. Delete what doesn't apply. Takes ~5 minutes.

## What this project is

[1-2 sentences. What does this product do? Who's it for? What stage — MVP, beta, production?]

## Stack

- **Frontend:** [e.g., Next.js 15 + TypeScript + Tailwind]
- **Backend/DB:** [e.g., Supabase Postgres with RLS]
- **Auth:** [e.g., Supabase Auth]
- **Deploy:** [e.g., Vercel]

## Commands

| Purpose | Command |
|---|---|
| Install | `[pnpm install]` |
| Dev server | `[pnpm dev]` |
| Build | `[pnpm build]` |
| Typecheck | `[pnpm typecheck]` |
| Lint | `[pnpm lint]` |
| Test | `[pnpm test]` |

## Connected systems

| System | URL |
|---|---|
| GitHub | [https://github.com/...] |
| Tasks | [https://linear.app/... or equivalent] |
| Docs | [https://notion.so/... or equivalent] |

## Active priorities

- [What are you working on right now?]
- [What's next?]

## Approval gates

Default tier: **Tier 2 (draft only)**. Ask before any external write or production change.

## Rule references

Rule files in `rules/` (in plugin) or `.claude/rules/` (direct copy) do not auto-load just because they exist. When a task touches Git, Supabase, UI, or context-heavy debugging, read the relevant rule file first.

## Available skills

Skills are in the Ravie plugin (referenced as `ravie:[skill-name]`) or in `.claude/skills/[name]/SKILL.md` for direct-copy installs. Key skills:
- `issue-to-pr` — the daily driver for building features
- `debug-root-cause` — for finding actual bug causes
- `requirements-griller` — for clarifying vague requests
- `code-review` — review AI-generated code before committing

## Things to never do

- [Your dealbreakers — e.g., "Don't suggest switching away from Supabase"]
- Don't create local file-based task tracking — use the task system above
- Don't skip baseline checks before pushing code
- Don't commit secrets or .env files
