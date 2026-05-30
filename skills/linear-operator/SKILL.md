---
name: linear-operator
description: >-
  Use this skill when creating, updating, splitting, linking, triaging, summarizing, or cleaning Linear issues, projects, blockers, acceptance criteria, and execution status. Do not use for durable knowledge, code changes, PR management, or Notion/GitHub records except to link back to Linear.
---


# linear-operator

Manage Linear as the execution system of record. The skill that other skills call when they need to create issues, update status, or query project state.

## Purpose

Treat Linear as the single source of truth for execution. Read issues with proper context. Create issues with acceptance criteria. Update statuses based on real evidence. Resist using Linear as a knowledge base or chat tool.

## When to use this

- Creating new Linear issues from PRDs or notes
- Updating issue status as work progresses
- Splitting large issues into smaller ones
- Cleaning up stale issues
- Adding acceptance criteria to existing issues
- Linking PRs, decisions, and Notion docs to issues
- Triaging blockers
- Generating project status summaries

## When NOT to use this

- Do not use for durable knowledge, code changes, PR management, or Notion/GitHub records except to link back to Linear.

## Stack integration

**Reads from:**
- Linear: projects, issues, statuses, labels, cycles, blockers
- Notion: PRDs and decisions to link from issues
- GitHub: branches, PRs, commits to link to issues
- `CLAUDE.md`: project conventions (label scheme, priority levels, naming)

**Writes to:**
- Linear: projects, issues, comments, status changes, links
- Drafts: in chat or as preview before any Linear writes

## Inputs required

- Target: project, issue key, or workspace-wide query
- Action: read / create / update / link / triage / status / cleanup
- Work description (for create/update)
- Priority and labels (use defaults from `CLAUDE.md` if not specified)
- Acceptance criteria (mandatory for new issues)
- Write mode: read-only / draft / approved-write

## Process

### Reading state

1. **Single issue read**: pull the issue with all linked PRs, Notion docs, comments, and current status. Surface dependencies and blockers.

2. **Project status query**: pull all issues in the project, group by status, identify stale work (no movement in 14+ days), identify blockers.

3. **Personal queue**: issues assigned to [Your Name] with status In Progress, In Review, Blocked. Sort by priority then by age.

### Creating issues

1. **Confirm acceptance criteria exist** before creating. No exceptions. If they don't, route back to `requirements-griller`.

2. **Check for duplicates**: search for similar titles or descriptions in the project. Don't create dupes.

3. **Standard issue template:**
   ```markdown
   ## Context
   [Why this exists. Link to PRD, decision, or originating issue.]

   ## Scope
   [What's in.]

   ## Out of scope
   [What's deliberately not.]

   ## Acceptance criteria
   - [ ] Testable item 1
   - [ ] Testable item 2

   ## Dependencies
   - [Other issues that must finish first]
   - [External: docs, designs, decisions]

   ## Links
   - PRD: [Notion link]
   - Design: [Figma link]
   - Related: [other Linear issues]
   ```

4. **Naming conventions** (read from `CLAUDE.md`, default below):
   - Bug: `Fix: [what's broken]`
   - Feature: `[Verb] [thing]` — e.g., "Add dashboard cards"
   - Spike: `Spike: [question to answer]`
   - Refactor: `Refactor: [what + why]`
   - Chore: `Chore: [what]`

5. **Priority defaults** (override per `CLAUDE.md`):
   - P0: production blocker, drop everything
   - P1: blocking active work, fix this week
   - P2: should fix soon, plan into next cycle
   - P3: nice-to-have, may stay unscheduled

6. **Labels**: project-specific. Only add labels that exist in the workspace or that have been explicitly approved to add.

### Updating issues

1. **Status changes** require evidence:
   - "In Progress": branch exists, work has started
   - "In Review": PR exists, marked ready for review
   - "Done": PR merged, criteria verified
   - "Blocked": specific blocker named in comment

2. **Never mark Done without verification** — verify acceptance criteria are actually met, not just that PR merged.

3. **Comment with context** when status changes:
   ```
   Moved to In Review: PR #47 ready, all acceptance criteria met.
   Preview QA passed: [link]
   ```

### Linking

Create explicit links:
- Issue ↔ PR (use Linear's GitHub integration if available)
- Issue ↔ Notion PRD/decision
- Issue ↔ parent / sub-issues
- Issue ↔ related issues (use "blocks" or "relates to")

### Triaging blockers

1. Identify what type of blocker:
   - Decision needed → log decision in Notion, update issue
   - Information needed → name what's needed, who has it
   - Code dependency → linked issue must finish first
   - External (waiting on third party) → comment with what and when

2. Don't let "Blocked" become a status that just means "I forgot." If blocked >7 days, surface in daily brief.

### Splitting issues

When an issue grew beyond its original scope:
1. Identify natural seams in the work
2. Create child issues for each seam
3. Move acceptance criteria to the right child
4. Mark parent as "epic" or close it if no work happens at parent level
5. Maintain links between parent and children

### Cleanup

Periodic (weekly during `pattern-learner`):
- Issues with no movement in 30+ days: comment asking if still relevant, move to abandoned/archive if not
- Issues with no acceptance criteria: backfill or close
- Issues with no clear owner: assign or close
- Closed issues missing PR links: backfill if PR exists

## Output format

```markdown
# Linear operation — [action] — [target]

## Result
[Summary of what happened or what's proposed if not yet executed]

## Issues affected
- [LIN-XX]: [title] — [action taken or proposed]

## Acceptance criteria
[For created issues, the criteria as written]

## Links established
- Issue → PR: [link]
- Issue → Notion: [link]

## Status changes
- [LIN-XX]: [old] → [new] — evidence: [what]

## Blockers identified
- [LIN-XX] blocked by: [reason]

## Approvals needed
- [ ] Create [N] issues as drafted
- [ ] Move [LIN-XX] to [status]
- [ ] Close stale issues: [list]
```

## Approval gates

**Tier 1 (read-only)** — querying state, summarizing, drafting: always allowed.

**Tier 2 (draft)** — drafting issue text, drafting status changes: always allowed, never executed.

**Tier 3 — needs approval:**
- Creating new issues
- Updating issue statuses
- Adding comments to others' issues
- Linking issues to external resources
- Bulk operations (>3 issues at once)

**Tier 4 — needs explicit approval:**
- Creating new projects
- Closing issues without merged PR
- Bulk closing or archiving
- Changing priorities en masse
- Reassigning to others
- Deleting anything

**Never auto:**
- Marking issues Done without verified acceptance criteria
- Closing without comment explaining why
- Creating duplicate issues

## Hard rules

- Never use Linear as a knowledge base — durable knowledge goes in Notion
- Never create issues without acceptance criteria
- Never create duplicates — always search first
- Never silently expand scope — split into new issue
- Never mark Done without verifying criteria are met
- Never let "Blocked" become >7 days without escalation
- Never bulk edit without explicit approval
- Never assign work to others without their confirmation
- Never close issues without a comment

## Connects to

- `requirements-griller` — invoked before issue creation if scope unclear
- `idea-to-prd-tracer` — produces the issue breakdown this skill creates
- `issue-to-pr` — the daily driver that calls this for status updates
- `notion-brain` — for PRD/decision linking
- `github-operator` — for PR linking
- `daily-brief` — calls this for queue summary
- `pattern-learner` — calls this for weekly cleanup
- `system-of-record-governance` — when Linear and Notion conflict

## Common failure modes

**Linear becomes a chat thread** — Comments balloon into discussions that should be in Slack or the PR. Linear comments should be: status updates, blocker reports, decisions referenced. Not chatter.

**Issues without acceptance criteria** — Someone creates "Fix dashboard" with no criteria. Two weeks later, three different people have three different ideas of what's done. Always require criteria.

**Stale issues accumulate** — 50 open issues, half from 6 months ago. They drown the active work. Cleanup weekly. If something's not getting done in 30 days, decide: do it now, archive, or close.

**Status drift** — PR merged 3 days ago, Linear still says In Progress. Update status immediately, not "later." Stale Linear is worse than no Linear.

**Duplicates** — Two issues for the same thing. Always search before creating. Mark one as duplicate-of and close.

**Bulk operations gone wrong** — "Close all issues older than 90 days" can lose real work. Bulk operations need explicit approval and a preview of what will be affected.
