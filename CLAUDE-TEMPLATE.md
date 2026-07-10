# CLAUDE.md template

Copy the template below into your project root as `CLAUDE.md` and fill in the brackets (~15 minutes). Every line here is paid in tokens at the start of every session, so the test for adding anything is: **does EVERY session need this?** If not, it goes elsewhere — churning state in `STATE.md`, procedures in skills, enforcement in hooks, reference material in `docs/`.

---

## Template starts below this line

---

# [Project Name] — Claude Code context

## What this is

[1-2 sentences: what the product does, who it's for, current stage — MVP, beta, production.]

## Stack

- **Frontend:** [e.g. Next.js 15 + TypeScript + Tailwind + shadcn/ui]
- **Backend/DB:** [e.g. Supabase Postgres with RLS, Edge Functions]
- **Auth:** [e.g. Supabase Auth]
- **Deploy:** [e.g. Vercel — preview on branches, production on main]

## Commands

| Purpose | Command |
|---|---|
| Dev / Build | `[pnpm dev]` / `[pnpm build]` |
| Typecheck / Lint / Test | `[pnpm typecheck]` / `[pnpm lint]` / `[pnpm test]` |
| DB migration / types | `[supabase migration new <name>]` / `[pnpm gen:types]` |

## Connected systems

- GitHub: [url] · Linear: [url] · Notion: [url]
- Supabase: [dashboard url] · Vercel: [url] · Figma: [url]

## Current state

Active priorities, in-flight work, and known issues live in `STATE.md` — read it at session start. Update `STATE.md` (not this file) when state changes.

## Non-negotiables

- Approval gates: default **Tier 2 (draft only)**. Ask before any external write; never touch production, secrets, main, or delete anything without explicit approval. Full model: `PERMISSION-MODEL.md` in the Ravie repo.
- Decisions already made live in the decision log: [Notion URL]. Don't re-litigate them.
- Vocabulary: "production" = main branch via Vercel (explicit approval only); "preview" = non-main Vercel deploys (safe).
- [Your dealbreakers — e.g. "Don't suggest replacing Supabase or Vercel." Add as they come up.]

---

## Template ends. Notes on filling it out (delete on install).

---

- **Where the rest went:** branch/commit conventions → `rules/git.md`; DB rules → `rules/supabase.md`; UI rules → `rules/ui.md` (read on demand when the task touches them). Skill routing → skill descriptions themselves (auto-loaded) and `ROUTER.md` for humans. Enforcement ("never push to main", "never commit .env", "no secret reads") → Ravie hooks, which cost zero tokens and can't be ignored — don't restate them here.
- **Never duplicate content between CLAUDE.md and a skill or rule file** — single source of truth, pointers only.
- **Create `STATE.md`** next to this file: 5-10 bullets of current priorities, in-flight work, known issues. It churns; CLAUDE.md shouldn't.
- **Grow it from friction:** every time you re-explain something in a session, add one line here (if every session needs it) or to the relevant rule/skill (if not).
