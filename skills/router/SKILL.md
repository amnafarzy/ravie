---
name: router
description: >-
  Use this skill when you are unsure which Ravie skill applies, need to sequence multiple workflows, or need a human-readable routing reference for a mixed request. Do not use when the request clearly matches one specific skill; use that skill directly.
---


# router

Routing reference for when no single skill clearly matches. This is a human-readable map, not automatic routing logic.

> **Note:** This skill contains an abbreviated quick-reference routing map. For the full route list across all 33 skills, see [`ROUTER.md`](../../../ROUTER.md) at the repo root.

## Purpose

When you are unsure which skill applies, determine: what type of work is this, which skill should be read next, what context must be gathered first, and what permission tier applies.

## When to use this

Use this skill when the request matches the YAML description and you need to choose among Ravie workflows.

## When NOT to use this

- Do not use when the request clearly matches one specific skill; use that skill directly.

## Routing table

| Request pattern | Route to | Gather first |
|---|---|---|
| "Build feature X" / "Implement Y" | `requirements-griller` → `issue-to-pr` | Linear issue, acceptance criteria |
| "I have an idea for..." / "What if we..." | `requirements-griller` deep interrogation mode | Nothing — start deep interrogation mode |
| "Fix bug" / "This is broken" / "Error in..." | `debug-root-cause` | Error message, reproduction steps |
| "Create issues from PRD" / "Plan this feature" | `idea-to-prd-tracer` | Notion PRD or design file |
| "Implement this design" / "Build from Figma" | `figma-lovable-handoff` → `issue-to-pr` | Design file/URL |
| "What should I work on?" / "Morning brief" | `daily-brief` | Nothing — skill pulls from systems |
| "Review this code" / "Check before merging" | `code-review` | Diff or branch name |
| "Deploy" / "Ship it" / "Is this ready?" | `deploy-ready` | Branch, preview URL |
| "Log this decision" | `decision-log-adr` | The decision and context |
| "Create Linear issues" / "Update status" | `linear-operator` | Issue details |
| "Update Notion" / "Save this to Notion" | `notion-brain` | Content to save |
| "Check the VPS" / "Job failed" | `automation-sre` | Job name, error |
| "Launch plan" / "Positioning" / "Competitors" | `growth-launch-pack` | Product context |
| "Something is down" / "Production error" | `observability-incident-loop` | Error evidence |
| "Set up Claude Code for this project" | `project-control-plane` | Repo path |

## System of record routing

| Data type | System | Skill |
|---|---|---|
| Durable knowledge (PRDs, decisions, runbooks) | Notion | `notion-brain` |
| Execution (tasks, status, priorities) | Linear | `linear-operator` |
| Code (source, PRs, CI, releases) | GitHub | `github-operator` |
| Database/auth/storage | Supabase | `supabase-guardian` |
| Preview/deploy | Vercel | `vercel-preview-qa` |
| Automation/scheduled jobs | VPS | `automation-sre` |

## Permission classification

Before executing any routed action, classify the permission tier:
- Reading from any system → Tier 1 (auto)
- Drafting content locally → Tier 2 (auto, announce)
- Writing to external systems → Tier 3 (ask first)
- Destructive or production actions → Tier 4 (name the target)

## Routing rules

1. If a skill exists for the task, use it. Don't improvise when there's a defined workflow.
2. If the request is ambiguous, ask one clarifying question — don't guess.
3. If multiple skills apply, route to the first one in the chain (e.g., `requirements-griller` deep interrogation mode before scope finalization, then `issue-to-pr`).
4. If no skill matches, handle directly but flag that a skill might be worth creating.

## Hard rules

- Never skip a skill that matches the task
- Never guess which system to write to — check the routing table
- When uncertain about routing, ask the user rather than picking the wrong skill
- Every external action goes through permission classification first

## Output format

```markdown
# Routing recommendation

## Request
[The user's request, summarized]

## Recommended skill
`[skill-name]`

## Reason
[Why this skill matches the request]

## Required context
[What context to gather before invoking the skill]

## Permission tier
Tier [1-5] — [classification reason]

## Next action
[Specific first step the user or Claude should take]

## Alternative skills considered
- `[skill]` — rejected because [reason]
```

## Connects to

- All 33 skills — this is the routing index
- `permission-guardian` — for permission tier classification
- `system-of-record-governance` — for system-of-record routing decisions

## Common failure modes

**Over-routing** — Routing to a skill when a 2-line direct answer would work. Skills are for repeated, structured workflows, not every request. If the answer is "run X", just say so.

**Skipping permission classification** — Routing to a skill that does external writes without flagging the permission tier. Every routing decision must include the permission classification.

**Choosing implementation before requirements** — Routing to `issue-to-pr` when scope isn't clear. Always check if the request has acceptance criteria first. If not, route to `requirements-griller` regardless of how implementation-shaped the request looks.

**Picking the wrong skill from the chain** — When multiple skills apply, route to the earliest in the chain. Idea → grill (deep mode of requirements-griller) → requirements-griller → idea-to-prd-tracer → issue-to-pr. Don't jump to issue-to-pr if requirements aren't done.
