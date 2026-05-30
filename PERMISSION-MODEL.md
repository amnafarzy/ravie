# Permission Model

Use this permission model in every skill, workflow, automation, connector, MCP setup, and AI-assisted execution path.

Default to the lowest tier that can complete the task.

## Core rule

AI may read and draft freely. AI may not write externally, mutate production, expose secrets, delete data, merge code, apply production migrations, or enable unattended automations without explicit approval.

Default flow:

```text
read → draft → review → approved write → verify → record
```

## Approval standards

For ordinary controlled writes, approval must clearly authorize the write:

```text
Approved: create the Linear issues from this PRD.
Approved: update the Notion runbook with this version.
Approved: push the branch and open a PR.
```

For high-risk actions, approval must name the exact target system, environment, action, and rollback or verification expectation.

```text
Approved: apply migration 2026-05-07-add-billing-events.sql to staging Supabase only, then regenerate types and report the result. Do not apply to production.
```

Vague language such as “looks good,” “sounds fine,” or “go ahead” is not enough for high-risk work.

## Tier 1 — Read-only

### Allowed
- Read repo files and `CLAUDE.md`.
- Read Notion pages.
- Read Linear issues/projects.
- Read GitHub issues, PRs, checks, and commits.
- Read Vercel deployment status and logs.
- Read Supabase schema metadata, local migrations, and generated types.
- Read VPS/automation server logs and job definitions.
- Summarize, diagnose, draft recommendations, draft plans, and identify risks.

### Blocked
- Writing to external systems.
- Creating/updating Linear, Notion, or GitHub artifacts.
- Applying migrations.
- Changing Vercel settings or env vars.
- Running destructive shell commands.
- Touching production data.
- Changing schedules.
- Enabling unattended jobs.
- Deleting files, logs, branches, pages, issues, or records.

## Tier 2 — Draft/internal write

### Allowed
- Create or edit local draft files.
- Draft PRDs, ADRs, runbooks, Linear issues, PR descriptions, Notion pages, Supabase migrations, RLS policies, VPS/automation server job specs, and scripts.
- Generate code changes locally when requested.
- Stage proposed changes for review.

### Blocked
- Posting externally.
- Creating/updating external systems.
- Pushing to GitHub.
- Opening PRs.
- Applying migrations.
- Deploying.
- Enabling automations.
- Changing secrets.
- Mutating production data.
- Merging code.

## Tier 3 — Controlled external write

### Allowed after explicit approval
- Create/update Notion pages.
- Create/update Linear issues, comments, status, and links.
- Create GitHub branches, commit approved changes, push branches, open PRs, add PR comments, update docs.
- Trigger safe preview deployments through normal Git flow.
- Update non-production configuration.
- Write to approved staging/preview databases.
- Update VPS/automation server runbooks.

### Blocked
- Production database mutation.
- Destructive migrations.
- Production env var changes.
- Secret rotation/exposure.
- Merging PRs.
- Force-pushing shared branches.
- Changing branch protection.
- Disabling/weakening RLS.
- Changing auth providers.
- Enabling unattended automations.
- Deleting logs/state.
- Bulk deleting pages, issues, branches, or records.
- Exporting customer/client data.
- Client-facing communications.

## Tier 4 — High-risk

Requires explicit approval every time.

Examples:
- Production Supabase migrations.
- Production data mutation/repair/deletion.
- RLS or auth changes.
- Production Vercel env var changes.
- Secret rotation.
- Write-capable MCP setup.
- Enabling unattended VPS/automation server jobs.
- Production cron/systemd changes.
- Rollbacks.
- Force-pushes.
- Merging with unresolved warnings.
- Exporting customer/client data.
- Importing old memory that may contain secrets/client data.
- Permission model changes.

## Tier 5 — Critical / blocked

Always blocked unless handled outside the AI workflow:

- Exfiltrating, printing, committing, or storing secrets.
- Disabling security controls without a verified emergency protocol.
- Deleting production databases or backups.
- Bulk deleting customer/client data.
- Running unreviewed destructive shell commands.
- Installing unknown remote scripts with broad permissions.
- Granting broad permanent write access to all systems.
- Bypassing legal, privacy, NDA, or contractual obligations.
- Using client-sensitive data in reusable public/general skills.
- Fabricating status, test results, or approvals.
- Hiding failed checks, broken deployments, or incidents.
- Committing `.env` files.

## Environment rules

### Local
Default tier: Tier 1 or Tier 2. Safe for reads, drafts, local checks, local migrations, and local builds. Still never expose secrets.

### Preview / staging
Default tier: Tier 3 with approval for writes. Use test data. Do not assume staging equals production.

### Production
Default tier: Tier 4. Requires exact target, exact action, verification plan, rollback/forward-fix path, evidence logging, and follow-up issue if needed.

## System-specific examples

### Notion
Tier 1: read PRDs, decisions, runbooks.  
Tier 2: draft pages.  
Tier 3: approved updates.  
Tier 4: database restructuring, memory imports, client-sensitive content.  
Tier 5: storing secrets or mixing client confidential data into general memory.

### Linear
Tier 1: read issues.  
Tier 2: draft issues.  
Tier 3: approved issue/project updates.  
Tier 4: bulk status changes or closing/deleting many issues.  
Tier 5: fabricating completion.

### GitHub
Tier 1: inspect code/PRs/checks.  
Tier 2: local edits/drafts.  
Tier 3: approved push/open PR/comment.  
Tier 4: merge, force-push, branch protection, secrets, tags/releases.  
Tier 5: commit secrets or falsify check status.

### Supabase
Tier 1: inspect migrations/types/policies.  
Tier 2: draft migrations/RLS.  
Tier 3: approved local/staging migration.  
Tier 4: production migrations, RLS changes, service-role operations, data repair.  
Tier 5: expose service-role key, disable RLS broadly, delete production database.

### Vercel
Tier 1: inspect deployments/logs.  
Tier 2: draft env/deploy checklist.  
Tier 3: preview through Git flow and non-production settings.  
Tier 4: production env vars, rollback, domains/DNS.  
Tier 5: printing secrets or exposing env vars to client bundle.

### VPS/automation server / VPS
Tier 1: inspect logs/status.  
Tier 2: draft job scripts/runbooks.  
Tier 3: approved repo code/runbook updates and safe manual test.  
Tier 4: enable jobs, production schedules, secrets, state/log deletion, service restart.  
Tier 5: unknown root scripts, deleting backups, silently disabling monitoring.

## MCP and connector rules

Use least privilege, prefer read-only, prefer project-scoped access, prefer time-bounded access, review permissions after workflow completion, and remove unused connectors.

## Secret handling rules

Never paste secrets into prompts, print secrets in chat, commit secrets, store secrets in docs, expose server-only keys to client code, or include secrets in screenshots.

Safe documentation example:

```text
Required env vars:
- SUPABASE_URL
- SUPABASE_ANON_KEY
- SUPABASE_SERVICE_ROLE_KEY server-only
- VERCEL_PROJECT_ID
```

## Default behavior when uncertain

1. Treat as read-only.
2. Draft the proposed action.
3. State permission tier.
4. Identify approval needed.
5. Provide safer alternative if risky.
6. Do not proceed with risky writes on ambiguous approval.
