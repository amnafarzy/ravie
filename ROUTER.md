# Router

Human-readable routing reference for classifying incoming requests, pulling required context, applying permission tiers, and selecting the intended workflow or skill. Claude Code selects skills from their YAML descriptions; this file documents the intended routing.

This file documents intended routing for human and AI reference. It is not automatic routing logic by itself; Claude Code selects skills from YAML descriptions.

## Purpose

Use this map to classify work, gather minimum required context from Notion, Linear, GitHub, Supabase, Vercel, and the automation server, apply permission tiers, and choose the right skill or workflow.

## Operating assumptions

- Notion is durable knowledge.
- Linear is execution.
- GitHub is source truth for code, migrations, automation, repo docs, and PRs.
- Supabase is database, auth, storage, and edge functions.
- Vercel is frontend deployment and preview.
- VPS/automation server is scheduled automation runtime.
- Claude Code is primary implementation.
- Claude Desktop is connected-app planning and broad context.
- ChatGPT is secondary analysis, review, research, and specialized support.

## Classification logic

### 1. What kind of work is this?

| Request type | Route |
|---|---|
| Loose product idea | `requirements-griller` deep interrogation mode, then `idea-to-prd-tracer` |
| Ambiguous request | `requirements-griller` |
| Approved Linear issue | `issue-to-pr` |
| Bug or failure | `debug-root-cause` |
| Supabase schema/auth/RLS/data | `supabase-guardian` |
| Vercel preview/deployment | `vercel-preview-qa` or `deploy-ready` |
| Figma/Lovable handoff | `figma-lovable-handoff` |
| UI consistency | `design-system-ui` |
| Accessibility | `accessibility-ui` |
| Responsive layout | `responsive-ui` |
| Motion | `animation-motion` |
| Three.js/WebGL | `threejs-motion-performance` |
| UI copy | `ui-copy` |
| Durable decision | `decision-log-adr` |
| Notion docs/memory | `notion-brain` |
| Linear operations | `linear-operator` |
| GitHub operations | `github-operator` |
| VPS/automation server automation | `automation-sre` |
| Daily brief | `daily-brief` |
| Weekly learning | `pattern-learner` |
| Permission uncertainty | `permission-guardian` |
| Source-of-truth conflict | `system-of-record-governance` |
| Incident loop | `observability-incident-loop` |
| Client boundary | `client-boundary-guard` |
| Workflow quality review | `workflow-evaluator` |
| Old memory import | `memory-import-sanitizer` |

### 2. Is the request approved for action?

If not approved, route to planning, drafting, or review mode. Do not write externally unless the request clearly asks for the write, the action is within the allowed permission tier, approval has been given, and the system of record is clear.

### 3. Is it version-sensitive?

Route through `current-docs-guard` before touching Claude Code behavior, MCP, Supabase, Vercel, Next.js/frontend APIs, auth, AI APIs, Three.js, browser APIs, package/deployment tooling, or external APIs.

### 4. Does it touch production, secrets, permissions, destructive actions, customer data, or client data?

Route through `permission-guardian`. If high-risk or critical/blocked, stop for explicit approval or refuse unsafe action.

### 5. What is the system of record?

| Artifact | System |
|---|---|
| Product strategy, PRD, durable memory, runbooks, briefs | Notion |
| Tasks, acceptance criteria, status, incidents | Linear |
| Code, migrations, repo docs, ADRs, PRs, skill source | GitHub |
| Deployment preview/production frontend | Vercel |
| Database/auth/storage runtime | Supabase |
| Automation source | GitHub |
| Automation runbook | Notion |
| Automation schedule/logs | VPS/automation server |

## Context pulling before routing

- Pull Notion for PRDs, decisions, runbooks, project memory, daily/weekly reviews, and durable knowledge.
- Pull Linear for issues, status, priority, blockers, acceptance criteria, and review state.
- Pull GitHub for code, PRs, branches, checks, migrations, repo docs, automation source, and deployment config.
- Pull Supabase for schema, RLS, auth, storage, generated types, data visibility, migrations, and edge functions.
- Pull Vercel for previews, production deployments, build/runtime logs, env vars, domains, and config.
- Pull VPS/automation server for cron, systemd, scheduled jobs, logs, runbooks, retries, and health checks.

## Fallback behavior

If no route is obvious:

1. Identify closest request type.
2. Pull minimal context from Notion, Linear, and GitHub.
3. Ask one clarifying question only if safe progress is blocked.
4. If safe as draft, produce draft.
5. If writing externally or touching production, stop for approval.
6. If spanning routes, sequence them.

Default sequences:

```text
requirements-griller deep interrogation mode if needed → decision-log-adr if needed → idea-to-prd-tracer → linear-operator → issue-to-pr
debug-root-cause → current-docs-guard if API/version issue → issue-to-pr
figma-lovable-handoff → design-system-ui / responsive-ui / accessibility-ui / animation-motion → vercel-preview-qa
automation-sre → permission-guardian → github-operator → notion-brain → linear-operator
memory-import-sanitizer → client-boundary-guard if sensitive → notion-brain → system-of-record-governance
```

## Multi-model routing

- Claude Code: repo work, implementation, tests, local commands, Git, skill/source updates.
- Claude Desktop: connected-app planning and broad cross-system context.
- ChatGPT: second-opinion review, synthesis, strategy, artifact drafting, technical explanation, research.

## Hard rules

- Do not route directly to implementation when scope is unclear.
- Do not skip Notion/Linear/GitHub context for non-trivial work.
- Do not create a new source of truth.
- Do not write externally without checking permission tier.
- Do not route everything to an all-purpose agent.
- Do not ask for context already available in connected systems.
- Do not install or enable connectors by default.
- Do not preserve template defaults over active project reality.
