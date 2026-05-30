# Workflows

Runbooks for Ravie.

Every workflow must respect Notion as durable knowledge, Linear as execution, GitHub as source, Supabase as database/auth/storage, Vercel as preview/deployment, VPS/automation server as scheduled automation runtime, and explicit approval gates for risky actions.

---

## Idea / Figma / Lovable → PRD → Linear → GitHub Plan

### Trigger
Use when a rough idea, Figma design, Lovable prototype, client request, or founder note needs to become executable product work.

### Inputs
- Idea or request.
- Figma file, screenshot, or notes if available.
- Lovable prototype URL/export if available.
- Target repo or proposed repo.
- Relevant Notion docs.
- Existing Linear project or decision to create one.
- Constraints, deadline, desired outcome, and known non-goals.

### Tools
- Notion
- Linear
- GitHub
- Claude Code
- Figma
- Lovable

### Steps
1. Create or open the Notion Product Inbox item.
2. Pull related context from Notion, Linear, and GitHub.
3. Run `requirements-griller` until scope is clear.
4. Identify user, problem, desired outcome, non-goals, constraints, and risks.
5. If Figma or Lovable is involved, run `figma-lovable-handoff`.
6. Draft the PRD in Notion-ready markdown.
7. Draft acceptance criteria.
8. Identify the smallest tracer bullet.
9. Draft a GitHub implementation plan.
10. Create or update the Linear project.
11. Create Linear issues from the approved plan.
12. Link Notion PRD, GitHub plan, and Linear project/issues.
13. Mark the tracer issue as the first executable unit.

### Outputs
- Notion PRD.
- Linear project.
- Linear issues with acceptance criteria.
- GitHub implementation plan.
- First tracer bullet.
- Decision log entry if a meaningful tradeoff was made.

### Approval gates
- Human approval before Linear issue generation.
- Human approval before implementation.
- Human approval before scope expansion.
- Human approval before committing to production-impacting architecture.

### System of record
- PRD: Notion.
- Execution: Linear.
- Technical plan: GitHub.
- Decisions: Notion or GitHub ADR, linked from both.

### Failure handling
- If scope is unclear, return to requirements grilling.
- If Figma/Lovable output is incomplete, document assumptions explicitly.
- If repo context conflicts with PRD, flag the conflict before planning.
- If no target repo exists, create a repo proposal instead of implementation tasks.
- If the idea is too large, define one tracer and create follow-up issues.

---

## Linear Issue → Branch → Implementation → Vercel Preview → PR

### Trigger
Use when a Linear issue is approved and ready for implementation.

### Inputs
- Approved Linear issue.
- Linked PRD or plan.
- Target GitHub repo.
- Acceptance criteria.
- Environment rules.
- Required Supabase/Vercel context.
- Test/check commands.

### Tools
- Claude Code
- Linear
- GitHub
- Supabase
- Vercel
- Browser tooling
- Notion

### Steps
1. Pull the Linear issue and linked context.
2. Confirm the issue is approved and has acceptance criteria.
3. Pull repo context from `CLAUDE.md`, docs, and recent PRs.
4. Run `current-docs-guard` if touching version-sensitive APIs.
5. Create a branch named from the Linear issue key and short slug.
6. Run baseline install/typecheck/lint/test commands.
7. If database changes are needed, draft a Supabase migration.
8. Run `supabase-guardian` before applying schema or RLS changes.
9. Build the smallest vertical tracer bullet.
10. Run checks.
11. Commit the tracer.
12. Expand only within the approved issue scope.
13. Run checks again.
14. Push branch.
15. Get the Vercel preview.
16. Run `vercel-preview-qa`.
17. Fix preview blockers.
18. Update docs if behavior, architecture, setup, or commands changed.
19. Open GitHub PR with summary, test results, preview URL, screenshots/notes, risks, and Linear link.
20. Move Linear issue to review.

### Outputs
- GitHub branch.
- Commits.
- Test/check report.
- Vercel preview URL.
- GitHub PR.
- Updated Linear status.
- Updated docs if needed.

### Approval gates
- Human approval before expanding beyond tracer.
- Human approval before production database changes.
- Human approval before changing secrets or environment variables.
- Human approval before merging.
- Human approval before enabling new automation.

### System of record
- Execution state: Linear.
- Code and review: GitHub.
- Deployment preview: Vercel.
- Durable product context: Notion.

### Failure handling
- If baseline checks fail before changes, open a Linear blocker note.
- If Vercel preview fails, inspect build/runtime logs before changing code.
- If Supabase migration fails, stop and run `supabase-guardian`.
- If acceptance criteria are incomplete, return to `requirements-griller`.
- If issue scope expands, create follow-up Linear issues instead of silently expanding.
- If production impact is discovered mid-work, stop and request approval.

---

## Weekly Ravie Learning and Maintenance Loop

### Trigger
Run once per week or after an unusually dense product, client, or automation week.

### Inputs
- Closed Linear issues.
- Merged GitHub PRs.
- Updated Notion docs.
- Vercel incidents or failed deployments.
- Supabase warnings, migration issues, or RLS problems.
- VPS/automation server cron/job logs.
- Failed prompts or workflows.
- Repeated manual work.
- Skills that helped or failed.

### Tools
- Claude Code
- GitHub
- Linear
- Notion
- VPS/automation server
- Vercel
- Supabase

### Steps
1. Pull closed Linear issues for the week.
2. Pull merged GitHub PRs for the week.
3. Pull Notion decisions and PRDs updated this week.
4. Pull failed Vercel deployments or warnings.
5. Pull Supabase migration/auth/RLS issues.
6. Pull VPS/automation server job failures and noisy logs.
7. Summarize what shipped.
8. Identify work that stalled and why.
9. Identify repeated manual tasks.
10. Identify repeated bugs or review comments.
11. Identify skills that helped.
12. Identify skills that failed, were missing, or created friction.
13. Propose skill updates.
14. Propose runbook updates.
15. Propose workflow deletions or simplifications.
16. Create Linear improvement tasks for approved changes.
17. Write a Notion weekly operating log.

### Outputs
- Notion weekly Ravie log.
- Linear improvement tasks.
- Skill backlog updates.
- Runbook updates.
- Automation reliability notes.
- Discard/deprecation list.

### Approval gates
- Human approval before editing skills.
- Human approval before deleting workflows.
- Human approval before enabling new automations.
- Human approval before permission changes.
- Human approval before touching secrets or production data.

### System of record
- Weekly log: Notion.
- Improvement work: Linear.
- Skill source: GitHub.
- Automation source: GitHub.
- Job history/runbooks: Notion + VPS/automation server logs.

### Failure handling
- If source data is unavailable, log the missing source explicitly.
- If repeated failures appear, create a Linear incident/improvement issue.
- If a skill repeatedly misroutes work, update `ROUTER.md`.
- If a workflow is not used for two review cycles, mark it for deletion or simplification.
- If a workflow creates unsafe writes, route through `permission-guardian` and block until fixed.

---

## Daily Operating Brief

### Trigger
Run at the start of the workday or through a scheduled VPS/automation server job.

### Inputs
- Date.
- Active projects.
- Today’s explicit priorities if provided.
- Open Linear issues.
- GitHub PRs/checks.
- Vercel deployment status.
- Supabase warnings/migrations if relevant.
- VPS/automation server job status.
- Notion active project pages and decisions.

### Tools
- Notion
- Linear
- GitHub
- Vercel
- Supabase
- VPS/automation server
- Claude Desktop or Claude Code

### Steps
1. Pull active Linear issues.
2. Pull open GitHub PRs and failed checks.
3. Pull failed Vercel deployments or production warnings.
4. Pull Supabase issues relevant to active work.
5. Pull VPS/automation server failed jobs or stale schedules.
6. Pull Notion active project notes.
7. Identify blockers.
8. Identify urgent production/automation issues.
9. Identify the highest-leverage task for today.
10. Identify risky tasks requiring approval.
11. Draft a short daily brief.
12. Create/update Linear tasks only if explicitly approved or configured for safe draft write.

### Outputs
- Notion daily brief or chat brief.
- Prioritized task list.
- Blocker list.
- Risk/approval list.
- Suggested focus task.

### Approval gates
- Human approval before creating or modifying external tasks unless configured for safe draft write.
- Human approval before changing schedules, secrets, permissions, or production data.

### System of record
- Durable brief: Notion.
- Tasks: Linear.
- Code/PRs: GitHub.
- Automation status: VPS/automation server logs + Notion runbook.

### Failure handling
- If a connector fails, produce the brief with a “missing context” section.
- If priorities conflict, prefer active Linear deadlines over unstructured notes.
- If production or automation failure exists, surface it before new feature work.
- If context is too noisy, summarize only blockers, active PRs, and top focus.

---

## Requirements Grilling

### Trigger
Use when a request is ambiguous, high-leverage, expensive, product-facing, client-facing, or likely to become a GitHub/Linear task.

### Inputs
- Initial request.
- Existing Notion/GitHub/Linear context.
- Constraints.
- User goal.
- Known deadline or launch target.

### Tools
- Claude Code
- Notion
- Linear
- GitHub

### Steps
1. Restate the request in operational terms.
2. Check Notion, Linear, and GitHub for existing context.
3. Identify missing decisions.
4. Ask one sharp question at a time.
5. Recommend defaults when the answer is obvious.
6. Separate goals from implementation assumptions.
7. Identify non-goals.
8. Identify risks.
9. Convert confirmed scope into acceptance criteria.
10. Identify whether this becomes a PRD, Linear issue, decision log, or quick code task.

### Outputs
- Clarified scope.
- Non-goals.
- Assumptions.
- Acceptance criteria.
- Risks.
- Recommended next workflow.

### Approval gates
- Human approval before converting to Linear issues.
- Human approval before making product or architecture assumptions permanent.
- Human approval before treating inferred context as confirmed.

### System of record
- PRD/decision: Notion.
- Execution tasks: Linear.
- Technical implementation plan: GitHub.

### Failure handling
- If the user does not answer, propose safe defaults and mark assumptions.
- If context conflicts, flag the conflict.
- If the task is too large, split into tracer and follow-up issues.
- If the request is not worth building, recommend discarding it.

---

## Current Docs Guard

### Trigger
Use before implementing with version-sensitive systems, APIs, SDKs, auth providers, deployment tooling, MCP servers, package managers, or AI tool APIs.

### Inputs
- Target library/tool/API.
- Current implementation context.
- Proposed change.
- Repo package/config files.
- Relevant docs links if already known.

### Tools
- Official docs
- GitHub
- Claude Code
- Notion

### Steps
1. Identify all version-sensitive components.
2. Inspect package files, config files, and lockfiles.
3. Check current official docs.
4. Compare repo implementation against current docs.
5. Identify deprecated APIs or outdated assumptions.
6. Recommend the safest implementation path.
7. Record doc-sensitive decisions in the implementation plan.

### Outputs
- Current-docs check summary.
- Approved API pattern.
- Risks.
- Links or notes for durable docs if needed.

### Approval gates
- Human approval before package upgrades.
- Human approval before auth/deployment/database changes.
- Human approval before installing new MCP servers.
- Human approval before changing production integration behavior.

### System of record
- Implementation notes: GitHub.
- Durable decision: Notion or GitHub ADR.
- Execution: Linear.

### Failure handling
- If current docs cannot be verified, mark uncertainty.
- If docs conflict with repo implementation, propose a migration path.
- If upgrade risk is high, create a separate Linear issue.
- If official docs are unavailable, do not treat unofficial examples as authoritative.

---

## Supabase Migration and RLS Review

### Trigger
Use for schema, migration, auth, RLS, storage, edge function, generated type, or seed data changes.

### Inputs
- Proposed schema change.
- Existing migrations.
- Supabase project context.
- Affected app features.
- User roles and permissions.
- Local/preview/prod environment rules.

### Tools
- Supabase
- GitHub
- Claude Code
- Linear

### Steps
1. Identify affected tables, policies, functions, triggers, storage buckets, and generated types.
2. Confirm local migration file exists.
3. Check whether RLS is required for every affected table.
4. Review insert/select/update/delete policies separately.
5. Confirm user ownership rules.
6. Confirm service-role use is isolated and never exposed to client code.
7. Check generated types need updating.
8. Check seed data impact.
9. Check rollback or forward-fix path.
10. Link migration to Linear issue and PR.

### Outputs
- Migration review.
- RLS review.
- Generated type update plan.
- Environment risk notes.
- PR checklist items.

### Approval gates
- Human approval before production migrations.
- Human approval before destructive changes.
- Human approval before disabling or weakening RLS.
- Human approval before using service-role keys.
- Human approval before modifying auth flows.

### System of record
- Migrations/types: GitHub.
- Execution status: Linear.
- Durable schema decisions: Notion or GitHub ADR.

### Failure handling
- If RLS is incomplete, block merge.
- If migration history is out of sync, stop and reconcile.
- If rollback is unclear for destructive change, block production application.
- If client code needs service role access, reject the design.

---

## Vercel Preview QA

### Trigger
Use whenever a PR has a Vercel preview deployment or a user-facing UI/API change.

### Inputs
- Vercel preview URL.
- GitHub PR.
- Linear issue.
- Acceptance criteria.
- Screenshots/design references if available.
- Test credentials if approved.

### Tools
- Vercel
- GitHub
- Linear
- Browser tooling
- Claude Code

### Steps
1. Confirm preview deployment succeeded.
2. Open preview URL.
3. Check the main user path from acceptance criteria.
4. Check console errors.
5. Check failed network requests.
6. Check responsive breakpoints.
7. Check accessibility basics: keyboard, focus, labels, contrast, reduced motion if relevant.
8. Check visual alignment against provided design references.
9. Check loading, empty, error, and success states.
10. Inspect Vercel logs if runtime behavior fails.
11. Document findings in PR.
12. Update Linear status or comments.

### Outputs
- QA report.
- Screenshots or notes if useful.
- Blocking issues.
- Non-blocking polish notes.
- Updated PR and Linear comments.

### Approval gates
- Human approval before merge.
- Human approval before production deploy if preview has unresolved issues.
- Human approval before ignoring acceptance criteria.
- Human approval before testing with production data.

### System of record
- Review: GitHub PR.
- Execution state: Linear.
- Deployment: Vercel.

### Failure handling
- If preview is unavailable, inspect Vercel build logs.
- If acceptance criteria are missing, send issue back to planning.
- If design mismatch is subjective, document and request decision.
- If production-only issue is suspected, do not test production without approval.

---

## Debug Root Cause

### Trigger
Use whenever something breaks, tests fail, deployment fails, UI behaves unexpectedly, data is wrong, or AI keeps patching symptoms.

### Inputs
- Observed behavior.
- Expected behavior.
- Error messages.
- Recent changes.
- Relevant logs.
- Reproduction steps.
- Linked Linear issue or PR.

### Tools
- GitHub
- Linear
- Vercel logs
- Supabase logs
- Browser tools
- VPS/automation server logs
- Claude Code

### Steps
1. Restate expected vs actual behavior.
2. Reproduce the issue.
3. Capture exact error messages and logs.
4. Check recent Git changes.
5. Identify the smallest failing unit.
6. Form a root-cause hypothesis.
7. Test the hypothesis.
8. Apply the smallest fix.
9. Run verification checks.
10. Document root cause and fix.
11. Add regression test if appropriate.
12. Update Linear/PR.

### Outputs
- Root-cause summary.
- Fix.
- Verification evidence.
- Regression test or follow-up task.
- Updated PR/Linear notes.

### Approval gates
- Human approval before broad refactors.
- Human approval before data repair.
- Human approval before production hotfix.
- Human approval before rollback.
- Human approval before disabling tests.

### System of record
- Bug task/status: Linear.
- Fix and tests: GitHub.
- Incident/runbook: Notion if durable.

### Failure handling
- If reproduction fails, document conditions and gather more logs.
- If root cause is unclear, stop after hypothesis list.
- If fix scope expands, create follow-up Linear issue.
- If production data may be corrupted, escalate to high-risk tier.

---

## Decision Log / ADR

### Trigger
Use when choosing architecture, tooling, data model, integration, product scope, permissions, pricing, or a workflow convention that future-you may question.

### Inputs
- Decision topic.
- Options considered.
- Constraints.
- Context.
- Tradeoffs.
- Recommendation.
- Links to PRD, issue, PR, or prototype.

### Tools
- Notion
- GitHub
- Linear

### Steps
1. Name the decision.
2. Summarize context.
3. List options.
4. List tradeoffs.
5. Identify constraints.
6. Recommend one option.
7. Record final choice.
8. Record consequences.
9. Add review date if decision may expire.
10. Link Notion, Linear, and GitHub artifacts.

### Outputs
- Notion decision log or GitHub ADR.
- Links from relevant Linear issues and PRs.
- Follow-up tasks if needed.

### Approval gates
- Human approval before recording final choice.
- Human approval before reversing an existing durable decision.
- Human approval before creating implementation tasks from the decision.

### System of record
- Product/ops decisions: Notion.
- Repo-specific technical ADRs: GitHub.
- Execution tasks: Linear.

### Failure handling
- If options are incomplete, mark uncertainty.
- If source facts are not verified, block final recommendation.
- If decision is reversible and low-risk, record as a lightweight decision.
- If decision conflicts with an existing ADR, create a supersession note.

---

## Figma / Lovable → Production Handoff

### Trigger
Use when a Figma design or Lovable prototype needs to become maintainable production code.

### Inputs
- Figma file/screenshot/spec.
- Lovable output/prototype if available.
- Target repo.
- Design tokens.
- Component list.
- Responsive states.
- Interaction notes.
- Acceptance criteria.

### Tools
- Figma
- Lovable
- GitHub
- Claude Code
- Vercel
- Notion
- Linear

### Steps
1. Extract product intent, not just visuals.
2. Identify design tokens: colors, spacing, type, radius, shadows, motion.
3. Identify components and variants.
4. Identify responsive behavior.
5. Identify states: loading, empty, error, success, disabled, hover, focus.
6. Identify accessibility requirements.
7. Identify data and Supabase dependencies.
8. Identify what Lovable generated that should be kept, rewritten, or deleted.
9. Create an implementation spec.
10. Create Linear issues.
11. Update GitHub plan.
12. Run preview QA after implementation.

### Outputs
- Implementation spec.
- Token map.
- Component map.
- State map.
- Linear issues.
- GitHub plan.
- QA checklist.

### Approval gates
- Human approval before treating prototype code as production code.
- Human approval before changing design system tokens.
- Human approval before scope expansion.
- Human approval before discarding prototype behavior.
- Human approval before adding new dependencies.

### System of record
- Durable design/product spec: Notion.
- Implementation tasks: Linear.
- Production code: GitHub.
- Preview validation: Vercel/GitHub.

### Failure handling
- If design is incomplete, list missing states.
- If Lovable code is messy, extract behavior and rewrite cleanly.
- If visual fidelity conflicts with accessibility, escalate decision.
- If implementation is too large, start with one tracer screen/flow.

---

## VPS/automation server Automation Runbook

### Trigger
Use when creating, modifying, debugging, or reviewing scheduled VPS automations.

### Inputs
- Job purpose.
- Schedule.
- Source repo.
- Environment variables.
- Data inputs/outputs.
- Retry rules.
- Failure impact.
- Logs.
- Existing runbook if available.

### Tools
- VPS/automation server
- GitHub
- Notion
- Linear
- Supabase where relevant

### Steps
1. Define the job in plain language.
2. Confirm source repo and owner.
3. Confirm schedule and timezone.
4. Confirm idempotency.
5. Confirm secrets are environment-managed.
6. Confirm logs path and retention.
7. Confirm retry behavior.
8. Confirm alert behavior.
9. Confirm manual run command.
10. Confirm rollback/disable command.
11. Add or update Notion runbook.
12. Add GitHub workflow/script changes.
13. Create Linear task for implementation or follow-up.
14. Test manually before enabling schedule.
15. Monitor first scheduled run.

### Outputs
- Job spec.
- Runbook.
- GitHub changes.
- Linear task.
- Test result.
- Monitoring/alert notes.

### Approval gates
- Human approval before enabling a new scheduled job.
- Human approval before changing production schedule.
- Human approval before adding secrets.
- Human approval before mutating production data.
- Human approval before deleting logs or state.

### System of record
- Source/scripts: GitHub.
- Runbook: Notion.
- Execution task: Linear.
- Runtime logs: VPS/automation server.

### Failure handling
- If job fails, capture logs before editing.
- If job is not idempotent, block schedule.
- If secrets are missing, stop and request secure setup.
- If job has repeated failures, create Linear incident.
- If the job mutates production data, require rollback/repair notes.

---

## System-of-Record Cleanup

### Trigger
Use when information is duplicated, stale, conflicting, or living in the wrong place.

### Inputs
- Conflicting docs/tasks/files.
- Related Notion pages.
- Related Linear issues/projects.
- Related GitHub files/PRs.
- Project context.

### Tools
- Notion
- Linear
- GitHub
- Claude Code

### Steps
1. Classify each artifact: PRD, decision, runbook, task, code, migration, automation source, transient note.
2. Identify the correct system of record.
3. Compare duplicates.
4. Identify the newest reliable version.
5. Preserve links.
6. Propose updates, archives, or deletions.
7. Execute only approved writes.
8. Record cleanup result.

### Outputs
- Source-of-truth map.
- Conflict list.
- Proposed updates.
- Proposed deletions/archives.
- Updated links if approved.

### Approval gates
- Human approval before deleting/archiving.
- Human approval before changing Linear status.
- Human approval before rewriting durable docs.
- Human approval before changing repo docs.

### System of record
Depends on artifact type. Governance rules live in Notion or repo operating docs.

### Failure handling
- If ownership is unclear, stop and create a decision log.
- If duplicates contain conflicting facts, do not merge silently.
- If stale but historically useful, archive instead of delete.
- If the same conflict recurs, update the router or project control plane.

---

## Production Incident / Observability Loop

### Trigger
Use when Vercel, Supabase, GitHub, or VPS/automation server shows failures, warnings, degraded behavior, or recurring incidents.

### Inputs
- Incident description.
- Affected system.
- Logs.
- Time window.
- Recent deploys/PRs.
- User impact.
- Severity.

### Tools
- Vercel
- Supabase
- GitHub
- VPS/automation server
- Linear
- Notion
- Claude Code

### Steps
1. Classify severity.
2. Identify affected systems.
3. Preserve relevant logs.
4. Check recent PRs/deployments.
5. Check whether issue is ongoing.
6. Identify likely root-cause path.
7. Route to `debug-root-cause`.
8. Create Linear incident/fix issue if approved.
9. Document durable incident notes in Notion if warranted.
10. Update runbook after resolution.

### Outputs
- Incident summary.
- Timeline.
- Evidence.
- Suspected or confirmed cause.
- Fix path.
- Linear task.
- Runbook update.

### Approval gates
- Human approval before production rollback.
- Human approval before production hotfix.
- Human approval before data repair.
- Human approval before disabling automations.
- Human approval before client/public communication.

### System of record
- Incident task: Linear.
- Fix: GitHub.
- Runbook/incident notes: Notion.
- Logs: originating system.

### Failure handling
- If logs are missing, improve observability as a follow-up task.
- If root cause is unknown, do not invent one.
- If incident repeats, create a reliability improvement issue.
- If production data is involved, escalate permission tier.

---

## Memory Import and Sanitization

### Trigger
Use when importing old AI conversations, reference notes, local memory folders, summaries, or project notes into the operating system.

### Inputs
- Source files.
- Target Notion destination.
- Client/project sensitivity rules.
- Retention preference.
- Whether write is approved.

### Tools
- Local files
- Notion
- GitHub if repo-specific
- Linear if tasks are created

### Steps
1. Inventory source material.
2. Classify each item: durable project memory, decision, runbook, reusable pattern, active task, stale task, client-sensitive, secret risk, discard.
3. Redact secrets.
4. Redact or isolate client-sensitive content.
5. Deduplicate.
6. Extract durable facts and reusable patterns.
7. Map each item to Notion, GitHub, Linear, or discard.
8. Produce import preview.
9. Write only after approval.
10. Log what was discarded.

### Outputs
- Import preview.
- Redaction list.
- Destination map.
- Notion pages if approved.
- GitHub docs if repo-specific and approved.
- Linear tasks if approved.
- Discard log.

### Approval gates
- Human approval before writing to Notion.
- Human approval before committing repo docs.
- Human approval before creating Linear tasks.
- Human approval before storing client-sensitive content.
- Human approval before deleting source files.

### System of record
- Durable knowledge: Notion.
- Repo-specific facts: GitHub.
- Execution: Linear.
- Discard rationale: Notion or repo docs.

### Failure handling
- If secrets are found, stop and flag rotation review.
- If client data is found, route to `client-boundary-guard`.
- If imported content conflicts with current docs, route to `system-of-record-governance`.
- If source quality is low, discard rather than preserve noise.
