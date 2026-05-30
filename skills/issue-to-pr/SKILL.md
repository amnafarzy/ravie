---
name: issue-to-pr
description: >-
  Use this skill when the user has an approved Linear issue with acceptance criteria and wants to implement it end-to-end: branch creation, tracer bullet, checks, preview, and PR. Do not use for vague bugs, exploration, multi-issue refactors, or work without acceptance criteria.
---


# issue-to-pr

The daily driver. Takes one approved Linear issue and produces a merged-ready PR.

## Purpose

Execute one approved Linear issue through branch creation, tracer bullet, full implementation, checks, Vercel preview QA, and a clean PR linked back to Linear.

## When to use this

Trigger this skill when:
- A Linear issue exists with status "Ready for Dev" or equivalent
- Acceptance criteria are written in the issue
- The repo and target branch are clear
- The work is scoped to one issue (not a multi-issue refactor)

Don't use this skill for:
- Vague requests without a Linear issue → run `requirements-griller` first
- Bug investigation where root cause is unknown → run `debug-root-cause` first
- Multi-issue refactors → break into separate issues, run this per issue
- Spike / exploration work → that's not a PR-track task

## When NOT to use this

- Do not use for vague bugs, exploration, multi-issue refactors, or work without acceptance criteria.

## Stack integration

**Reads from:**
- Linear (the issue, its acceptance criteria, linked PRD/decisions)
- Notion (PRD if linked, related decisions, runbook entries)
- GitHub (current repo state, recent PRs for style/convention reference, `CLAUDE.md`)
- Supabase (schema state if data work is involved)
- Vercel (preview deployment status)

**Writes to:**
- GitHub (branch, commits, PR description)
- Linear (status updates, comments linking PR)
- Repo docs (README, ADRs) only when behavior or setup changed

## Inputs required

- Linear issue key (e.g. `PROJ-42`)
- Repo name and target base branch (usually `main`)
- Acceptance criteria (read from issue, but verify before starting)
- Test/check commands (read from `CLAUDE.md`)
- Permission tier for this session (default Tier 2; Tier 3 if approved to push)

## Process

### 0. Read relevant rule references first
Before acting, read `rules/git.md`, `rules/context-hygiene.md`, and `rules/karpathy-guidelines.md`. If the issue touches database/auth/RLS, also read `rules/supabase.md`. If it touches UI, also read `rules/ui.md`.

### 1. Pull context
Mental checklist before starting:
- Read the Linear issue end to end
- Read any linked Notion PRD
- Look at the last 3 PRs in the repo for style conventions
- Read `CLAUDE.md` for project-specific rules
- Note any "things to never do" from `CLAUDE.md`

If acceptance criteria are missing or ambiguous, **stop here** and route to `requirements-griller`. Do not proceed.

### 2. Plan before code
Write a brief plan to chat (not to the repo yet):
- What's the smallest tracer bullet that proves this works?
- What files will change?
- What dependencies (DB migration, env vars, new packages) are needed?
- What are the risks?

### 3. Get approval to start
Stop and wait for user approval on the plan before any file changes. This is the gate that prevents going off the rails on day one.

### 4. Create branch
Naming convention (read from `CLAUDE.md`, default below):
```
[ISSUE-KEY]-[short-slug]
# e.g. PROJ-42-dashboard-cards
```

```bash
git checkout main
git pull origin main
git checkout -b PROJ-42-dashboard-cards
```

### 5. Run baseline checks
Before changing anything, confirm the baseline is green:
```bash
pnpm install
pnpm typecheck
pnpm lint
pnpm test
pnpm build  # only if quick
```

If baseline is red: **stop**. Don't introduce new changes onto a broken baseline. Open a Linear blocker note.

### 6. If touching DB: route to supabase-guardian
Any schema, RLS, auth, or storage change → run `supabase-guardian` skill before writing migration files. This is non-negotiable.

### 7. If touching version-sensitive APIs: route to current-docs-guard
Touching Supabase APIs, Next.js APIs, MCP setup, auth flows, or AI APIs → run `current-docs-guard` skill before implementing.

### 8. Build the tracer bullet
Smallest possible end-to-end vertical slice:
- One feature path through schema → API → UI → preview
- Hardcoded values are fine for the tracer
- Goal is to prove the architecture works, not to be complete

### 9. Verify tracer
- Run checks locally
- Test the actual flow in dev
- Commit the tracer with a clear message:
  ```
  git commit -m "PROJ-42: tracer bullet for dashboard cards"
  ```

### 10. Expand within scope
Now build out the full feature within the acceptance criteria:
- Each commit should be self-contained
- Stop and ask if scope creep tempts you
- Run checks regularly

### 11. Run full check suite
```bash
pnpm typecheck && pnpm lint && pnpm test && pnpm build
```
All must pass. Don't ignore failing tests by deleting them.

### 12. Push and get preview
```bash
git push -u origin PROJ-42-dashboard-cards
```
Wait for Vercel preview to build. Get the URL.

### 13. Run vercel-preview-qa
Run `vercel-preview-qa` skill against the preview URL using acceptance criteria from the Linear issue. Document blockers vs polish items.

### 14. Update repo docs if needed
- README updated if setup commands changed
- New env vars documented in `.env.example` (without values)
- ADR added in `docs/adr/` if architectural decision was made

### 15. Open the PR
PR description template:
```markdown
## Linear: [PROJ-42](https://linear.app/...)

## Summary
[1-2 sentences on what shipped]

## Acceptance criteria (from Linear)
- [x] Criterion 1
- [x] Criterion 2
- [ ] Criterion 3 — see follow-up notes

## Changes
- [Bullet list of meaningful changes]

## Testing
- [What tests were added or run]
- [Manual verification done]

## Preview
- URL: [Vercel preview link]
- Tested on: [browsers/devices]

## Risks
- [Anything reviewer should pay attention to]

## Follow-ups
- [Linear keys for any deferred items]
```

### 16. Update Linear
- Move issue to "In Review" / equivalent
- Comment with PR link
- If criteria deferred, create a follow-up Linear issue

### 17. Hand off
Stop here. Do not merge. Merge requires explicit Tier 4 approval naming the exact PR and target branch.

## Output format

```markdown
# issue-to-pr report — PROJ-42

## Issue
- Title: Dashboard cards
- Acceptance criteria: 3 (2 met, 1 deferred)

## Branch
PROJ-42-dashboard-cards

## Tracer bullet
- Path: schema.cards table → /api/cards endpoint → DashboardCards component
- Verified: yes

## Changes
- [files]

## Checks
- typecheck: pass
- lint: pass
- tests: pass
- build: pass

## Supabase review
- Migration: [filename] — RLS reviewed via supabase-guardian

## Vercel preview
- URL: [link]
- QA: 2 blockers fixed, 1 polish item logged for follow-up

## PR
- [Link]

## Follow-ups
- PROJ-145: deferred animation polish
```

## Approval gates

**Tier 2 (default)** — drafting plan, writing code locally, running checks. No external writes.

**Tier 3 — needs explicit approval:**
- Pushing the branch
- Opening the PR
- Updating Linear status

**Tier 4 — needs explicit approval each time, naming exact target:**
- Merging the PR
- Force-pushing the branch
- Production deploy
- Production DB migration
- Secret/env var changes

**Tier 5 — always blocked:**
- Bypassing failing checks
- Hiding test failures
- Committing secrets
- Skipping acceptance criteria

## Hard rules

- Never start without acceptance criteria
- Never skip baseline checks
- Never silently expand scope — create follow-up issues instead
- Never mix unrelated issues in one PR
- Never mutate production without explicit Tier 4 approval
- Never hide failing checks or skip them via flags
- Never copy Lovable output to production without `figma-lovable-handoff`
- Never merge — only the human merges, after review

## Connects to

- `requirements-griller` — invoke before this if scope is unclear
- `current-docs-guard` — invoke during for version-sensitive work
- `supabase-guardian` — invoke during for DB/auth/RLS changes
- `vercel-preview-qa` — invoke after push, before PR description finalized
- `linear-operator` — for status updates and follow-up issue creation
- `github-operator` — for branch/PR mechanics
- `debug-root-cause` — invoke if checks fail and the cause isn't obvious
- `decision-log-adr` — invoke if a meaningful architectural choice was made mid-work

## Common failure modes

**The tracer turns into the whole feature** — Stop at the first commit. If you're 30 minutes in and haven't committed, you're not doing tracer-bullet, you're doing big-bang.

**Acceptance criteria are vague** — "Looks good" / "works well" are not criteria. Push back to `requirements-griller`. Otherwise the PR review becomes the spec discussion.

**Scope expands during implementation** — As soon as you think "while I'm in here, I'll also..." stop. Create a follow-up Linear issue. Stay in scope.

**Preview fails and you patch blindly** — Route to `debug-root-cause`. Don't add `try/catch` to make errors disappear.

**Linear and PR drift apart** — Update Linear *immediately* on status change. Stale Linear is worse than no Linear.
