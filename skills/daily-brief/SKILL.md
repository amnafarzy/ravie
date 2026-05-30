---
name: daily-brief
description: >-
  Use this skill when starting a workday, returning after a context break, preparing for planning, or needing a concise cross-system state summary from Linear, GitHub, Vercel, Supabase, automation servers, and Notion. Do not use when the user asks for a single-system lookup or a deep investigation of one issue.
---


# daily-brief

Generates a structured morning brief across all your systems so you don't open 6 tabs to figure out what to do.

## Purpose

Pull active state from Linear, GitHub, Vercel, Supabase, VPS/automation server, and Notion. Surface blockers, urgent items, and the highest-leverage focus task for today. Output a concise brief — to chat by default, to a Notion daily brief page if approved.

## When to use this

- Start of workday (manual or scheduled via VPS/automation server)
- Returning from a context-break (sick day, weekend, vacation)
- Before a planning session
- When you've lost track of what's in flight

## When NOT to use this

- Do not use when the user asks for a single-system lookup or a deep investigation of one issue.

## Stack integration

**Reads from:**
- Linear: open issues assigned to you, in-progress, blocked, recently updated
- GitHub: open PRs needing review, failed CI checks, recent merges
- Vercel: failed deployments, production warnings, preview build status
- Supabase: migration warnings, auth errors in logs (if connector available)
- VPS/automation server: failed jobs in last 24h, jobs scheduled for today
- Notion: today's daily page (if exists), updated decisions in last 24h, active project pages

**Writes to:**
- Chat (default): full brief output
- Notion: today's daily brief page (only if approved)
- Linear: nothing by default — drafts only if explicitly approved

## Inputs required

- Date (default: today)
- Active project filter (default: all active projects)
- Output mode: chat-only / write-to-Notion (default: chat-only)
- Linear write mode: read-only / draft / approved-write (default: read-only)

## Process

### 1. Pull Linear state
- Issues assigned to you with status: in progress, blocked, in review
- Issues with "urgent" label or P0/P1 priority
- Recently moved to blocked in last 24h
- Sub-issues nearing milestone deadlines

### 2. Pull GitHub state
- Open PRs you authored
- PRs assigned for your review
- Failed CI checks on PRs you authored
- Recent merges to main (24h)
- Stale branches (>7 days, no PR)

### 3. Pull Vercel state
- Failed production deployments (24h)
- Production warnings or 500s (if log connector available)
- Preview deployments stuck building

### 4. Pull Supabase state (if connector available)
- Recent migration failures
- Auth errors spike
- RLS policy violations spike

### 5. Pull VPS/automation server state
- Jobs that failed in last 24h
- Jobs scheduled to run today
- Jobs that haven't run in expected window (silently skipped)

### 6. Pull Notion state
- Today's daily page if it exists
- Decisions logged in last 24h
- Active project pages updated in last 24h

### 7. Identify blockers and urgent items
A blocker is anything that:
- Stops a Linear issue's progress
- Fails CI on a critical PR
- Breaks a production deploy
- Causes a recurring automation failure

### 8. Identify the highest-leverage focus
Apply this priority:
1. Production incidents (always first)
2. Blockers on issues nearing deadline
3. PRs awaiting your review (others are blocked on you)
4. Issues with "urgent" label
5. The active issue with the most-aged "in progress" status (oldest first)

### 9. Identify approval-needed items
Anything Claude noticed but won't act on without explicit go-ahead:
- Stale issue that should probably move to blocked
- PR ready to merge (waits for your call)
- Failed automation that needs disabling
- Decision flagged for review (review trigger reached)

### 10. Output the brief
Default format below. Adjust if you want shorter / different sections.

## Output format

```markdown
# Daily brief — [Date]

## ⚡ Top focus
[Single sentence: the one highest-leverage thing to start with]

## 🔥 Production / urgent
[Any production issues, P0/P1 blockers, automation failures. Empty if none.]

## 🟢 Active work
[Linear issues in progress, GitHub PRs in flight]
- PROJ-42: Dashboard cards — branch pushed, preview QA pending
- PROJ-138: Auth refactor — blocked on Supabase migration review

## 👀 Awaiting review (yours)
[PRs assigned to you for review]
- PR #47: [Feature] onboarding — 2 days old

## 🛑 Blockers
[Anything stopping forward progress on active work]
- PROJ-138 blocked on RLS policy decision (logged 1d ago)

## 🤖 Automations
[VPS/automation server jobs status]
- ✅ Fitness tracker → Notion sync ran at 06:00, success
- ❌ Weekly research scan failed at 02:00 — see logs

## 📋 Decisions / docs
[Notion updates worth knowing about]
- Decision logged: switched landing page hero to Three.js variant
- PRD updated: [Your feature] spec

## ⚠️ Approvals needed
[Things Claude noticed but won't act on without you]
- Should PROJ-103 move to blocked? (no movement in 7d)
- PR #47 ready to merge after review

## ⏭ Suggested order
1. [First thing — usually the top focus]
2. [Second thing]
3. [Third thing]

## 🧊 Stale or deferred
[Items worth glancing at occasionally — not today's priority]
- 3 issues with no movement in 14+ days
- Branch PROJ-100-experiments is 30 days stale
```

## Approval gates

**Tier 1 (default)** — read everything, output to chat. No writes.

**Tier 3 — needs approval:**
- Writing brief to Notion (creating today's daily page)
- Drafting Linear status updates as comments
- Creating Linear follow-up tasks

**Never auto:**
- Moving issue status (Linear write requires per-action approval)
- Closing or archiving anything
- Disabling automations
- Sending notifications to others

## Hard rules

- Never invent status — if a connector fails, say so explicitly in a "missing context" section
- Never hide automation failures — surface them even if minor
- Never prioritize new features over production incidents without explicitly noting it
- Never include secrets or sensitive client data in a general brief
- Never auto-create Linear tasks — drafts only, even at Tier 3
- Never assume what you didn't pull — if Notion connector wasn't available, say so

## Connects to

- `notion-brain` — for writing brief to Notion if approved
- `linear-operator` — for status drafts if approved
- `github-operator` — for PR/check details
- `automation-sre` — for routing to VPS/automation server failure investigation
- `observability-incident-loop` — invoke if production incident is found
- `permission-guardian` — for any escalation requests

## Variants

**Short brief (mid-day check-in):**
Skip stale/deferred section. Focus on top focus, urgent, and approvals.

**Weekly version:**
Run `pattern-learner` skill instead, which produces a different output (patterns + skill updates) rather than a daily snapshot.

**Pre-meeting brief:**
Add a section "What's relevant for [meeting topic]" pulling Notion docs tagged with that topic.

## Common failure modes

**Brief is too long** — Default to 1-screen output. If you have 15 active issues, the brief shows top 5 and counts the rest.

**Brief is generic / unhelpful** — Means the tool integrations aren't connected. With only chat + memory, the brief becomes a guess. Either wire up actual Linear/GitHub/Notion read access or accept the brief is just a "what should I do today" prompt.

**Brief includes everything stale** — Stale items go in the deferred section. Don't let them dominate the actual focus.

**You never read it after week 1** — That means it's not useful. Either make it shorter, change what's in it, or drop it. Don't keep generating a brief no one reads.
