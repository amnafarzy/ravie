---
name: permission-guardian
description: >-
  Use this skill when an action may write externally, delete, overwrite, force-push, deploy, migrate, touch secrets, affect production, access customer/client data, or when the permission tier is uncertain. Do not use for read-only inspection or drafting that clearly stays local.
---


# permission-guardian

Classify every proposed action by risk tier and enforce the correct approval gate. The skill that prevents "Claude just deployed to production without asking."

## Purpose

Before any external write, destructive action, or production-impacting change, classify the action's risk tier and enforce the corresponding gate. This is the runtime enforcement of the 5-tier permission model.

## When to use this

**You MUST use this skill when:**
- Any action writes to an external system (GitHub, Linear, Notion, Supabase, VPS)
- Any destructive action (delete, drop, force-push, overwrite)
- Any production-impacting change (deploy, migration, env var change)
- Uncertainty about whether an action needs approval

## When NOT to use this

- Do not use for read-only inspection or drafting that clearly stays local.

## The 5 tiers

### Tier 1 — Read-only (auto-approved)
Reading files, querying databases, checking logs, listing issues. No side effects.
- Examples: `git log`, `cat`, `supabase status`, reading Notion pages

### Tier 2 — Draft/local (auto-approved, announce)
Local file edits, drafting content, creating plans. Reversible, no external impact.
- Examples: editing code files, writing a PR description draft, creating a plan doc

### Tier 3 — External write (per-task approval)
Writing to external systems. Reversible but visible to others.
- Examples: `git push`, creating Linear issues, creating Notion pages, opening PRs
- **Gate:** Ask before acting. "I'm about to push branch X to origin. Proceed?"
- Can be pre-approved for a session: "Approved for this session"

### Tier 4 — Sensitive/destructive (per-action approval, name the target)
Irreversible or high-impact. Must name the exact target in the approval request.
- Examples: merging PRs, production deploys, DB migrations, deleting resources
- **Gate:** "I need to merge PR #47 (feature-dashboard) into main. Approve?"
- Never blanket-approve. Each action requires explicit confirmation naming the target.

### Tier 5 — Forbidden (never, regardless of approval)
Actions that should never happen in an AI-assisted workflow.
- Examples: deleting production databases, exposing secrets, disabling security, force-pushing to shared branches

## Process

### 1. Classify the action
Before executing, ask: what tier is this?

### 2. Apply the gate
- Tier 1-2: proceed, announce what you did
- Tier 3: ask for approval before acting
- Tier 4: ask for approval naming the exact target
- Tier 5: refuse, explain why

### 3. Log the decision
For Tier 3-4 actions, note what was approved and when. This creates an audit trail.

## Output format

When requesting approval:
```
[Tier 3] I'm about to create 3 Linear issues from the PRD. Proceed?
[Tier 4] I need to run migration 20260508_add_profiles.sql on the preview database. Approve?
```

## Hard rules

- Never execute Tier 3+ actions without approval
- Never blanket-approve Tier 4 actions — each needs explicit per-action approval
- Never attempt Tier 5 actions regardless of what the user says
- When uncertain about tier, classify one tier higher than your best guess
- Always name the exact target for Tier 4 approvals

## Connects to

- `automation-sre` — VPS actions often hit Tier 3-4
- `supabase-guardian` — DB migrations are Tier 4
- `github-operator` — merges are Tier 4, pushes are Tier 3
- `deploy-ready` — production deploys are Tier 4

## Common failure modes

**Tier creep** — Agent classifies a destructive action as Tier 2 to avoid asking. When uncertain, always round up.

**Blanket approval abuse** — "Approved for this session" should only apply to Tier 3. Never to Tier 4.

**Silent external writes** — Agent pushes to GitHub without announcing. Every Tier 3+ action should be announced even after approval.
