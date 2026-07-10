# Router & skill index

Human-readable reference: every active skill, what routes where, and the system-of-record map. **This file is documentation, not routing logic** — Claude Code selects skills from their YAML descriptions automatically; it costs zero context tokens unless deliberately read. (Formerly two files: ROUTER.md + SKILL-INDEX.md.)

## Operating assumptions

- Notion = durable knowledge. Linear = execution. GitHub = source truth for code, migrations, docs, PRs.
- Supabase = database/auth/storage. Vercel = frontend deploys and previews. VPS = scheduled automation runtime.
- Claude Code is primary implementation; Claude Desktop for connected-app planning; ChatGPT for second opinions.

## Skill index (24 active)

| Request type / trigger | Skill | Group |
|---|---|---|
| Ambiguous or vague request | `requirements-griller` | Daily driver |
| Validated idea → PRD + issues | `idea-to-prd-tracer` | Daily driver |
| Approved Linear issue → PR | `issue-to-pr` | Daily driver |
| Pre-ship failure, unknown cause | `debug-root-cause` | Daily driver |
| Review changed code before commit | `code-review` | Daily driver |
| Morning cross-system status | `daily-brief` | Daily driver |
| Figma/Lovable → implementation plan | `figma-lovable-handoff` | Daily driver |
| Linear issue operations | `linear-operator` | System operator |
| Standalone git/GitHub operations | `github-operator` | System operator |
| Durable knowledge in Notion | `notion-brain` | System operator |
| Cron/scheduled jobs, VPS automation | `automation-sre` | System operator |
| Version-sensitive API about to be used | `current-docs-guard` | Guard |
| Any Supabase schema/RLS/auth change | `supabase-guardian` | Guard |
| Preview URL + acceptance criteria QA | `vercel-preview-qa` | Guard |
| About to merge/deploy to production | `deploy-ready` | Guard |
| Any frontend UI build or review | `ui-quality` | UI |
| CSS/JS transitions and animation | `animation-motion` | UI |
| Three.js/WebGL/GPU work | `threejs-motion-performance` | UI |
| Durable decision made | `decision-log-adr` | Planning |
| Positioning/SEO/CRO/launch artifacts | `growth-launch-pack` | Growth |
| Production/live failure | `observability-incident-loop` | Operational |
| Onboard a repo to Claude Code | `project-control-plane` | Meta |
| Create/improve/evaluate a skill | `skill-creator` | Meta |
| "Wrap up" / "save state" / stopping work | `session-handoff` | Meta |

Archived (restorable via `git mv skills/archive/<name> skills/<name>`): router, permission-guardian, pattern-learner, workflow-evaluator, memory-import-sanitizer, system-of-record-governance, client-boundary-guard, plus the four skills merged into `ui-quality` (accessibility-ui, responsive-ui, design-system-ui, ui-copy). See `skills/archive/README.md`.

## Routing checks

1. **Approved for action?** If not: plan, draft, or review. No external writes without approval, the right permission tier (`PERMISSION-MODEL.md`), and a clear system of record.
2. **Version-sensitive?** Route through `current-docs-guard` before touching MCP, Supabase, Vercel, Next.js, auth, AI APIs, Three.js, browser APIs, or deployment tooling.
3. **Touches production, secrets, destructive actions, customer data?** Check `PERMISSION-MODEL.md`; hooks block env writes, main pushes, and secret reads deterministically. Stop for explicit approval on anything Tier 4.

## System of record

| Artifact | System |
|---|---|
| Strategy, PRDs, runbooks, durable memory | Notion |
| Tasks, acceptance criteria, status, incidents | Linear |
| Code, migrations, repo docs, ADRs, PRs, automation source | GitHub |
| Preview/production frontend | Vercel |
| Database/auth/storage runtime | Supabase |
| Automation schedule/logs | VPS/automation server |

## Fallback and sequences

If no route is obvious: identify the closest request type, pull minimal context from Notion/Linear/GitHub, ask one clarifying question only if blocked, draft if safe, stop for approval before external writes. Common sequences:

```text
requirements-griller → decision-log-adr (if needed) → idea-to-prd-tracer → linear-operator → issue-to-pr
debug-root-cause → current-docs-guard (if API/version issue) → issue-to-pr
figma-lovable-handoff → ui-quality / animation-motion → vercel-preview-qa
automation-sre → github-operator → notion-brain → linear-operator
```

## Hard rules

- Do not route to implementation when scope is unclear; do not skip Notion/Linear/GitHub context for non-trivial work.
- Do not create a new source of truth; do not write externally without checking the permission tier.
- Do not ask for context already available in connected systems; do not preserve template defaults over project reality.

## Adoption strategy

Week 1: just `issue-to-pr` on one Linear issue. Week 2: add `debug-root-cause` and `daily-brief`. Week 3: `idea-to-prd-tracer` and `figma-lovable-handoff` for new features. Month 2: the guards start mattering. A skill that keeps producing bad output gets improved via `skill-creator` or archived — the package is meant to shrink to fit you.
