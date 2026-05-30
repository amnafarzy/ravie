# Skill index

All 33 active skills, grouped by purpose. Marked by depth:

- 🟢 **Deep** — fully expanded with concrete commands, output templates, and failure modes. Daily-driver and core skills.
- 🟡 **Situational** — complete and usable, lighter on examples. Domain-specific skills that activate when relevant.

You're not meant to read every SKILL.md file manually. Claude Code selects skills from YAML descriptions, and other skills may explicitly reference them. Read individual ones when you want to understand or modify a specific workflow.

---

## Daily drivers (most-used)

| Skill | Depth | Purpose |
|---|---|---|
| `issue-to-pr` | 🟢 | Linear issue → tracer → PR. Daily driver. |
| `debug-root-cause` | 🟢 | Find actual cause of bugs, not patch symptoms |
| `daily-brief` | 🟢 | Morning brief across Linear/GitHub/Vercel/Supabase/VPS/automation server/Notion |
| `requirements-griller` | 🟢 | Vague request → precise scope + acceptance criteria |
| `idea-to-prd-tracer` | 🟢 | Idea → PRD → Linear issues → first tracer |
| `figma-lovable-handoff` | 🟢 | Design/prototype → token map + components + plan |
| `code-review` | 🟢 | Review AI-generated code for quality before committing |

## System operators

These skills are called by other skills, not directly invoked usually.

| Skill | Depth | Purpose |
|---|---|---|
| `linear-operator` | 🟢 | Manage Linear as execution system of record |
| `github-operator` | 🟢 | Manage GitHub as code source of truth |
| `notion-brain` | 🟢 | Manage Notion as durable knowledge base |
| `automation-sre` | 🟢 | Manage your VPS scheduled jobs |

## Stack-specific guards

Claude should select these from their YAML descriptions when relevant.

| Skill | Depth | Purpose |
|---|---|---|
| `current-docs-guard` | 🟡 | Verify current official docs before version-sensitive changes |
| `supabase-guardian` | 🟡 | Review DB / auth / RLS / migration changes |
| `vercel-preview-qa` | 🟡 | QA Vercel previews before merge |
| `deploy-ready` | 🟡 | Pre-deployment checklist (env vars, performance, metadata) |

## UI / design skills

| Skill | Depth | Purpose |
|---|---|---|
| `design-system-ui` | 🟡 | Tokens, spacing, typography, component variants |
| `responsive-ui` | 🟡 | Mobile-first responsive layouts |
| `accessibility-ui` | 🟡 | Semantics, keyboard, focus, contrast, reduced-motion |
| `animation-motion` | 🟡 | Restrained, performant motion |
| `threejs-motion-performance` | 🟡 | Three.js / WebGL discipline for 3D product and marketing work |
| `ui-copy` | 🟡 | Buttons, errors, empty states, success feedback |

## Planning & decisions

| Skill | Depth | Purpose |
|---|---|---|
| `decision-log-adr` | 🟡 | Record durable architectural / product decisions |

## Meta / governance

| Skill | Depth | Purpose |
|---|---|---|
| `project-control-plane` | 🟡 | Onboard a new repo to Claude Code (writes CLAUDE.md) |
| `router` | 🟡 | Reference: intended routing map when no single skill clearly applies |
| `permission-guardian` | 🟡 | Classify actions by risk tier, enforce gates |
| `system-of-record-governance` | 🟡 | Resolve Notion/Linear/GitHub conflicts |
| `pattern-learner` | 🟡 | Weekly review: extract reusable patterns, propose skill updates |
| `workflow-evaluator` | 🟡 | Evaluate whether skills/workflows are working |
| `skill-creator` | 🟢 | Create new skills from observed patterns |

## Growth / launch

| Skill | Depth | Purpose |
|---|---|---|
| `growth-launch-pack` | 🟢 | Positioning, competitors, segments, SEO, CRO, launch checklist |

## Operational

| Skill | Depth | Purpose |
|---|---|---|
| `observability-incident-loop` | 🟡 | Production incident → triage → fix → runbook |

## Privacy & boundaries

| Skill | Depth | Purpose |
|---|---|---|
| `client-boundary-guard` | 🟡 | Prevent cross-client leakage in agency work |
| `memory-import-sanitizer` | 🟡 | Clean old AI conversation exports before importing to Notion |

---

## Strategy: which to use first

**Week 1:** Just install and use `issue-to-pr` for one Linear issue. That's it.

**Week 2:** Add `debug-root-cause` and `daily-brief` to your routine.

**Week 3:** Use `idea-to-prd-tracer` and `figma-lovable-handoff` when starting any new feature.

**Month 2:** The guard skills (`supabase-guardian`, `vercel-preview-qa`, `current-docs-guard`) start mattering as you work more in the stack.

**Month 3:** Run `pattern-learner` weekly. Use `workflow-evaluator` if any skill keeps feeling off.

**As needed:** UI skills, `automation-sre`, the meta skills. Don't force them.

## Strategy: which to delete

After 2 weeks, if you haven't touched a skill, that's fine — many are situational. But if a skill keeps producing bad output when invoked, either:
1. Improve its SKILL.md based on what was missing (concrete commands, examples, failure modes), or
2. Delete it. A 5-skill system you actually use beats 33 active skills that drift.

The package is meant to shrink to fit you, not stay at the original count forever.
