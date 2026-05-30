---
name: observability-incident-loop
description: >-
  Use this skill when production or operational systems fail: Vercel errors, Supabase issues, automation/server failures, GitHub Actions failures on main, user-reported production bugs, or recurring monitoring warnings. Do not use for ordinary local debugging or unshipped preview QA unless it indicates a production incident.
---


# observability-incident-loop

Production incident → triage → fix → Linear task → runbook update. The structured response when something breaks in production.

## Purpose

Convert failures across Vercel, Supabase, GitHub Actions, and VPS/automation into a structured incident response: triage, fix, document, and prevent recurrence.

## When to use this

- Vercel deployment fails or shows errors
- Supabase returns errors or performance degrades
- VPS/automation jobs fail or produce unexpected output
- GitHub Actions CI fails on main branch
- Users report errors in production
- Recurring warnings in any monitoring system

## When NOT to use this

- Do not use for ordinary local debugging or unshipped preview QA unless it indicates a production incident.

## Process

### 1. Triage (5 minutes max)
Determine severity:
- **P1 — Service down**: Users can't access the product. Fix now.
- **P2 — Feature broken**: Core feature doesn't work. Fix within hours.
- **P3 — Degraded**: Something is slow or intermittent. Fix within 24h.
- **P4 — Warning**: Logs show concerning patterns. Investigate this week.

### 2. Gather evidence
Before fixing anything:
```bash
# Vercel: check deployment logs
# Supabase: check database logs, auth logs, edge function logs
# VPS: check job logs
cat /var/log/automations/[job-name]/[job-name].log | tail -50
# GitHub: check CI output
```
Capture: exact error messages, timestamps, affected users/routes, recent deployments.

### 3. Identify root cause
Route to `debug-root-cause` if the cause isn't immediately obvious. Common patterns:
- Recent deploy introduced a bug → check `git log --oneline -5`
- Supabase migration broke something → check latest migration
- Env var missing in production → check `.env.example` vs deployed env
- VPS job failed silently → check job logs and retry count

### 4. Fix
Apply minimal fix to restore service. Don't refactor during an incident.

### 5. Document
Create a Linear issue with:
```markdown
## Incident: [short description]
**Severity:** P[1-4]
**Duration:** [start] — [resolved]
**Impact:** [what was affected]
**Root cause:** [what caused it]
**Fix applied:** [what was done]
**Prevention:** [what to change so this doesn't recur]
```

### 6. Update runbook
If a runbook exists for this system, update it with the new failure mode and fix. If no runbook exists and the system has failed twice, create one.

### 7. Prevent recurrence
- If caused by a missing check → add a hook or CI step
- If caused by a missing test → add the test
- If caused by manual error → add automation
- If caused by a monitoring gap → add alerting

## Output format

```markdown
# Incident report — [date] — [short description]

## Severity: P[1-4]
## Duration: [start] — [resolved]
## Impact: [what was affected, how many users]

## Timeline
- [time]: [event]
- [time]: [event]
- [time]: [resolution]

## Root cause
[What actually caused the failure]

## Fix applied
[What was done to restore service]

## Prevention
- [ ] [Change to prevent recurrence]
- [ ] [Test/hook/monitoring to add]

## Runbook updated: [yes/no — link if yes]
```

## Hard rules

- Never fix without capturing evidence first — you need the logs before the fix overwrites them
- Never refactor during an incident — minimal fix to restore service, clean up later
- Never close an incident without a prevention step — "it's fixed" is not enough
- Always create a Linear issue for P1-P3 incidents
- Always update or create a runbook after the second failure of the same type

## Connects to

- `debug-root-cause` — for non-obvious root causes
- `automation-sre` — for VPS/automation job failures
- `supabase-guardian` — for database-related incidents
- `vercel-preview-qa` — for deployment-related incidents
- `notion-brain` — for storing runbooks
- `linear-operator` — for creating incident issues

## Common failure modes

**Fixing before capturing evidence** — You restart the service, the error logs are gone. Always capture first.

**No prevention step** — "We fixed the bug" but didn't add a test, hook, or check. The same bug returns in 3 weeks.
