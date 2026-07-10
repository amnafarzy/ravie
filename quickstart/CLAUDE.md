# [Project Name] — Claude Code context

> Copy this file to the root of your project as CLAUDE.md. Fill in the brackets, delete this line. Takes ~5 minutes.

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
| Dev / Build | `[pnpm dev]` / `[pnpm build]` |
| Typecheck / Lint / Test | `[pnpm typecheck]` / `[pnpm lint]` / `[pnpm test]` |

## Connected systems

- GitHub: [url] · Tasks: [Linear url] · Docs: [Notion url]

## Current state

Priorities and known issues live in `STATE.md` — read it at session start; update it, not this file.

## Non-negotiables

- Approval gates: default **Tier 2 (draft only)**. Ask before any external write or production change.
- Task tracking lives in the task system above — never create local file-based tracking.
- [Your dealbreakers — e.g., "Don't suggest switching away from Supabase"]

Rule files (`rules/git.md`, `rules/supabase.md`, `rules/ui.md`, `rules/context-hygiene.md`) load on demand — read the relevant one when the task touches its domain. Enforcement (no main pushes, no .env writes, no secret reads) is handled by Ravie hooks.
