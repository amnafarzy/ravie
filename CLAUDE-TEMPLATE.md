# CLAUDE.md template

This is the file you write once per project. Claude Code reads it first when you open any session in that repo. Without this file, none of the skills do anything.

Copy this entire template into the root of your project repo as `CLAUDE.md`, then fill in the bracketed sections. Delete any section that doesn't apply.

---

## Template starts below this line

---

# [Project Name] — Claude Code context

> Last updated: [YYYY-MM-DD]
> Maintainer: [Your Name]

## What this project is

[1-2 sentences. What does this product do? Who's it for? What's the current stage — MVP, alpha, paying users, internal tool?]

Example: "[Describe your product, who it's for, and what stage it's at. E.g.: 'Task[Project A] is a project management app for freelancers. Currently in beta with 50 users.']"

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
**Commit style:** [Conventional commits? Just plain? Include Linear key?]
**PR template:** see `.github/pull_request_template.md` if exists, otherwise [describe]
**Folder structure:**
```
[paste tree -L 2 output of your repo here, or describe key directories]
```

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

| System | URL / ID | Purpose |
|---|---|---|
| GitHub repo | https://github.com/[user]/[repo] | Code source of truth |
| Linear project | https://linear.app/[workspace]/project/[slug] | Tasks and execution |
| Notion project page | https://notion.so/[page-id] | PRDs, decisions, runbooks |
| Supabase project | https://supabase.com/dashboard/project/[id] | Database, auth |
| Vercel project | https://vercel.com/[user]/[project] | Deploys |
| Figma file | [URL] | Design source |

## Active priorities

[3-5 bullets max. What are you actually working on right now? Update this when priorities shift. This is what Claude uses when you say "what should I work on next?"]

- [Priority 1]
- [Priority 2]
- [Priority 3]

## Decisions Claude should respect

[Things you've already decided. Don't make Claude re-litigate them every session.]

- We use [X] not [Y] because [reason]
- Auth is Supabase Auth, not [other option]. Don't suggest changes.
- We're not adding [feature] until [milestone]
- [Add as decisions accumulate]

Link to full decision log: [Notion URL]

## Approval gates for this project

Default tier: **Tier 2 (draft only)** unless explicitly upgraded for the session.

For this project specifically:
- ✅ Auto-allowed: Reading any file, drafting code, drafting Linear issues, drafting PRDs in Notion-ready markdown
- ⚠️ Ask first: Creating Linear issues, opening PRs, pushing branches, updating Notion pages, applying local migrations
- 🛑 Never without explicit approval: Production deploys, production DB writes, secret changes, merging to main, force-pushes, deleting anything

For the full permission model see `/path/to/ravie/PERMISSION-MODEL.md`

## Available skills

Skills live in the Ravie plugin (`ravie:[skill-name]`) or in `.claude/skills/[name]/SKILL.md` for direct-copy installs.

Most-used for this project:
- `issue-to-pr` — turning a Linear issue into a merged PR
- `debug-root-cause` — when something breaks
- `figma-lovable-handoff` — converting designs/prototypes to code
- `vercel-preview-qa` — checking previews before merge
- `supabase-guardian` — before any DB or RLS change
- `decision-log-adr` — when making a durable decision

Routing logic: see `/path/to/ravie/ROUTER.md`

## Things to never do in this project

- Don't suggest switching deployment provider away from Vercel
- Don't suggest switching ORM/DB layer away from Supabase
- Don't add Prisma, Better Auth, or SendGrid
- Don't create local file-based task tracking — Linear is the system of record
- Don't generate generic "improve this" prompts — use the specific UI skills instead
- [Add project-specific don'ts as they come up]

## Current state and known issues

[1-2 paragraphs about where the project is today. Any partially-finished work? Migration in progress? Auth flow being rebuilt? This prevents Claude from suggesting things that conflict with in-flight work.]

## Notes for AI sessions

- When I say "the dashboard" I mean [specific component/page]
- When I say "the database" I mean the Supabase project, not local
- "Production" means main branch deployed via Vercel — only deployed by explicit approval
- "Preview" means Vercel preview deploys from any non-main branch — these are safe
- I prefer [code style preferences — destructured imports? early returns? etc.]
- When debugging, I want root cause first. Don't suggest patches before we understand the problem.

---

## Template ends. Below are notes on filling it out.

---

## How to fill this out for a new project

**Total time: 30-45 minutes for a project you know well.** Don't try to write this perfectly. Get a rough first version in, then update it as you discover gaps in real sessions.

**Order to fill in:**

1. **Stack** (5 min) — easiest, just list what you're using
2. **Commands** (5 min) — copy from your `package.json` scripts
3. **Connected systems** (10 min) — paste the URLs, this is the most useful part
4. **Active priorities** (5 min) — what are you actually working on?
5. **Repo conventions** (10 min) — `tree -L 2 src/` and describe naming
6. **Decisions** (10 min) — write down what you've already decided so you don't re-decide it
7. **Approval gates** (5 min) — default tier 2 is right for most solo work
8. **Things to never do** (5 min) — your dealbreakers; add to this over time

**What to leave for later:**
- Available skills section — this gets refined as you actually use skills
- Notes for AI sessions — add to this every time you catch yourself re-explaining something

## Updating CLAUDE.md

This file should evolve. Every time you find yourself re-explaining the same thing to Claude in a session, add it to CLAUDE.md so you never have to explain it again.

Sign that CLAUDE.md needs updating:
- Claude keeps suggesting tools/libs you've already rejected → add to "Things to never do"
- Claude keeps asking what your stack is mid-session → expand "Stack"
- Claude keeps generating wrong commit messages → expand "Repo conventions"
- Claude generates code in a style you keep correcting → add to "Notes for AI sessions"

## When to write a separate CLAUDE.md per project

Each project should have its own. Stacks differ, decisions differ, conventions differ. A shared CLAUDE.md ends up watered down to nothing useful.

What you can share across projects:
- The skills (in `ravie` repo, symlinked or copied)
- The router and permission model (in `ravie` repo, referenced by path)
- A "personal preferences" section (your code style, communication preferences) — copy into each project, or use a Claude Code global config file if your setup supports one

What stays project-specific:
- Stack and commands
- Connected system URLs
- Active priorities
- Project-specific don'ts and decisions

## Minimum viable CLAUDE.md

If 45 minutes feels like too much, the absolute minimum is:

```markdown
# [Project] — Claude Code context

## Stack
- [Frontend stack]
- [Backend/DB]
- [Deploy]

## Commands
- Dev: [cmd]
- Build: [cmd]
- Typecheck: [cmd]
- Test: [cmd]

## Connected systems
- GitHub: [url]
- Linear: [url]
- Notion: [url]

## Approval gates
Default tier 2. Ask before any external write or production change.

## Skills available
See /path/to/ravie/skills/

## Things to never do
- [Your dealbreakers]
```

This 5-minute version is enough to start. You'll expand it organically.
