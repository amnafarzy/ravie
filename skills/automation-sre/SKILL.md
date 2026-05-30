---
name: automation-sre
description: >-
  Use this skill when creating, modifying, debugging, retiring, or documenting scheduled jobs, cron/systemd timers, VPS or automation-server tasks, retries, health checks, logs, or automation secrets. Do not use for normal app feature work, one-off manual scripts that will not recur, or external writes without explicit approval.
---


# automation-sre

Operate your VPS as your background automation runtime. Source-controlled, idempotent, observable, and safely rolled back.

## Purpose

Manage scheduled jobs, cron entries, systemd timers, and recurring automations on your VPS with: source in GitHub, runbooks in Notion, idempotent execution, proper logging, retries with limits, and explicit approval for production-impacting changes.

## When to use this

- Creating a new scheduled job
- Modifying an existing job's schedule, code, or env
- Debugging job failures
- Reviewing VPS/automation server logs
- Adding retries or health checks
- Changing job secrets or env vars
- Creating runbooks for jobs
- Retiring automations no longer in use
- Investigating recurring or silent failures

## When NOT to use this

- Do not use for normal app feature work, one-off manual scripts that will not recur, or external writes without explicit approval.

## Stack integration

**Reads from:**
- your VPS: `crontab`, `systemd` units, job logs at `/var/log/automations/`, `~/automations/`
- GitHub: automation source repos (e.g., `~/code/automations/`)
- Notion: existing runbooks for each automation
- Linear: tasks tracking automation health
- Supabase / Vercel / external APIs: data the automations interact with

**Writes to:**
- GitHub: automation source code
- Notion: runbooks, change notes
- Linear: tasks for failures or improvements
- VPS: cron / systemd entries (only after approval, only via committed config)

## Inputs required

- Job purpose (what business outcome)
- Job source (which repo, which script)
- Schedule + timezone (default: VPS local time, document explicitly)
- Inputs / outputs
- Idempotency status: idempotent / not idempotent / unknown
- Mutation behavior: read-only / writes-internal / writes-external
- Secrets required (env vars, never hardcoded)
- Failure impact: low / medium / high
- Logs path
- Retry behavior
- Production data flag: yes / no
- Alerting setup

## Recommended directory structure

On the VPS:
```
~/code/
├── automations/                  ← source-controlled (GitHub)
│   ├── README.md
│   ├── data-sync-job/
│   │   ├── job.ts
│   │   ├── runbook.md
│   │   └── README.md
│   ├── daily-brief/
│   │   ├── job.ts
│   │   └── runbook.md
│   ├── _shared/
│   │   ├── notion-client.ts
│   │   └── env.ts
│   └── package.json
└── ravie/                        ← cloned for skill reference

/etc/systemd/system/              ← systemd units (root, source-controlled snapshot in GitHub)
~/.config/systemd/user/           ← user-scope services
/var/log/automations/                ← logs by job
~/.automation/state/                ← persistent state per job
~/.automation/secrets/              ← env files (chmod 600), gitignored
```

## Process

### 1. Define the job in plain language

Write 1-2 sentences describing what the job does and why it exists. If you can't, the job isn't ready.

### 2. Confirm source is in GitHub

No automation should run from un-tracked code. Either:
- Existing repo with the job
- New folder under `~/code/automations/[job-name]/`

Commit before deploying.

### 3. Confirm schedule and timezone

- Cron syntax for cron jobs
- `OnCalendar=` for systemd timers
- Always specify timezone explicitly (don't rely on VPS default)
- Avoid "every minute" unless truly justified — adds noise to logs

### 4. Confirm idempotency

Before scheduling, verify the job is idempotent:
- Running it twice in a row should produce the same final state
- Running it after a partial failure should recover correctly
- It should detect "already done" and exit cleanly

If the job isn't idempotent, **stop**. Either make it idempotent, or accept it's a one-shot manual job, not a scheduled one.

### 5. Confirm secrets are env-managed

- Never hardcode tokens, keys, passwords
- Use `.env` files in `~/.automation/secrets/` (chmod 600)
- Or systemd `Environment=` directives loaded from secret files
- Never commit secrets, even encrypted

### 6. Confirm logging

Each job should:
- Write to `/var/log/automations/[job-name]/[job-name].log`
- Use ISO timestamps
- Log at start, log at end, log on error
- Rotate logs (logrotate or built-in)
- Retain at least 30 days

### 7. Confirm retry behavior

- Define max retries (typically 3)
- Define backoff (linear or exponential)
- Define what counts as "retriable" vs "fail-and-alert"
- Don't retry forever silently

### 8. Confirm alerting

For high-impact jobs:
- Failure → email or Slack notification
- Repeated failure → escalation
- Silence breaks (job didn't run when expected) → alert

For low-impact jobs:
- Logged but no notification
- Surfaced in `daily-brief` skill

### 9. Confirm manual run command

Every job must be runnable manually:
```bash
cd ~/code/automations/data-sync-job
npx ts-node job.ts --once
```
or
```bash
systemctl --user start data-sync-job.service
```

If you can't trigger it manually, you can't debug it.

### 10. Confirm rollback / disable command

Every job must be disablable without losing data:
```bash
systemctl --user disable --now data-sync-job.timer
# or
crontab -e  # comment out the line
```

Document the disable command in the runbook.

### 11. Test manually before scheduling

- Run the job once manually
- Verify output is correct
- Verify log captures it
- Verify it handles "already done" state correctly
- Verify it handles failure (kill mid-run, restart)

Only after this passes: enable the schedule.

### 12. Write the runbook

In `automations/[job-name]/runbook.md`:
```markdown
# Runbook: [job-name]

## Purpose
[What this does, why it exists]

## Schedule
[Cron / systemd schedule, with timezone]

## Source
- Code: [GitHub path]
- Service: [systemd unit name or cron entry]

## Run manually
```
[commands]
```

## Disable
```
[commands]
```

## Logs
- Path: `/var/log/automations/[name]/`
- Retention: [days]

## Secrets required
- ENV_VAR_1
- ENV_VAR_2
- (location: `~/.automation/secrets/[name].env`)

## Idempotency
[How the job handles duplicate runs]

## Failure modes
- [Common failure 1]: [how to detect, how to fix]
- [Common failure 2]: [how to detect, how to fix]

## Alerting
[Where notifications go on failure]

## Last reviewed
[Date]
```

Push runbook to GitHub. Mirror in Notion if it's a high-impact automation.

### 13. Create / update Linear task

Track the work as a Linear issue:
- Title: "Automation: [name]"
- Acceptance criteria: deployed, runbook written, manual test passed
- Linked: GitHub commit, runbook

### 14. Monitor the first scheduled run

After enabling, verify the first scheduled run actually fires:
- Logs show start and end
- Output matches expected
- No unexpected errors

## Output format

```markdown
# Automation SRE — [job-name]

## Purpose
[What this does]

## Source
- Repo: [GitHub path]
- Branch: [name]

## Schedule
- Cron / systemd: [expression]
- Timezone: [tz]

## Inputs / Outputs
- Reads from: [systems]
- Writes to: [systems]
- Mutates: [yes/no, what]

## Idempotency
- Status: idempotent / not idempotent / unknown
- Mechanism: [how it handles re-runs]

## Secrets
- [list of required env vars, no values]
- Storage: [location]

## Logging
- Path: [...]
- Retention: [days]

## Retry / alerts
- Retries: [count]
- Backoff: [strategy]
- Alerting: [channel]

## Manual run command
```
[commands]
```

## Disable command
```
[commands]
```

## Test result (manual)
- [Pass / fail, what was verified]

## Runbook
- GitHub: [path]
- Notion: [link if mirrored]

## Approvals needed
- [ ] Approve job for scheduled run
- [ ] Approve secrets configuration
- [ ] Approve alert channel
```

## Approval gates

**Tier 1 (read-only)** — inspecting logs, jobs, runbooks: always allowed.

**Tier 2 (draft)** — drafting job code, runbook, schedule: always allowed.

**Tier 3 — needs approval:**
- Committing job code to GitHub
- Updating runbook in Notion
- Manual test runs (if they touch real data)

**Tier 4 — needs explicit approval naming exact action:**
- Enabling a new scheduled job
- Changing schedule on a production job
- Adding or rotating secrets
- Mutating production data via job
- Changing retry behavior
- Disabling an existing job
- Restarting services on the VPS

**Tier 5 — always blocked:**
- Storing secrets in code or markdown
- Running unknown remote scripts with broad permissions
- Disabling backup or monitoring
- Deleting logs or state files

## Hard rules

- Never schedule a non-idempotent job
- Never store secrets in code, markdown, or repo
- Never deploy a job without a runbook
- Never deploy a job that can't be manually run or disabled
- Never leave failed jobs unaddressed for >24h
- Never let job code drift from GitHub source
- Never enable a job without a successful manual test
- Never bypass alerting for high-impact jobs
- Never grant a job more permissions than needed (least privilege)

## Connects to

- `permission-guardian` — for tier classification
- `github-operator` — for source code commits
- `notion-brain` — for runbook publishing
- `linear-operator` — for tracking automation work
- `observability-incident-loop` — invoked when a job's failure is part of an incident
- `daily-brief` — surfaces automation status
- `pattern-learner` — surfaces automations that fail repeatedly

## Common failure modes

**Untracked drift** — Job runs from a script that's not in GitHub. You change it, forget what changed, can't roll back. Always source-control.

**Silent failures** — Job fails but no alert. Days later, you notice. Always have alerting for high-impact jobs.

**Non-idempotent scheduled jobs** — Job does something twice when it shouldn't. Data corruption. Always verify idempotency before scheduling.

**Hardcoded secrets** — Token in the script. Repo gets compromised. Account compromised. Always env-manage.

**No manual disable** — Job is broken and you can't stop it. Always have a `disable` command in the runbook.

**Schedule drift** — Job runs in UTC but you assume local time. Output looks wrong. Always specify timezone.

**Untested before scheduling** — Job goes live without a manual test. First run fails. Always test manually first.

**Stale runbook** — Runbook says X, but the code does Y now. During weekly review, verify runbooks against code.

**Permission creep** — Job started read-only, now has write access "just in case." Audit periodically. Least privilege.
