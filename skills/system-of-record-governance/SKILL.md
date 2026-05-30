---
name: system-of-record-governance
description: >-
  Use this skill when Notion, Linear, GitHub, or other sources disagree; when duplicate task/docs sources appear; or when it is unclear where information should live. Do not use for normal feature implementation or single-system edits with no source-of-truth conflict.
---


# system-of-record-governance

Resolve conflicts between Notion, Linear, and GitHub. Prevent duplicate sources of truth. The rule: three systems, zero overlap, no fourth source.

## Purpose

When information exists in multiple places and they disagree, this skill determines which source is authoritative and how to reconcile. Prevents the slow death of "which one is the real version?"

## When to use this

- Status in Linear says "Done" but the PR is still open
- A PRD in Notion contradicts what was actually built
- Someone created a task tracker in a markdown file instead of Linear
- A decision was made in chat but never logged anywhere
- You're unsure where to store a piece of information

## When NOT to use this

- Do not use for normal feature implementation or single-system edits with no source-of-truth conflict.

## The three systems of record

| System | Owns | Does NOT own |
|---|---|---|
| **Notion** | Durable knowledge: PRDs, decisions, runbooks, briefs, learnings | Tasks, code, deployment status |
| **Linear** | Execution: tasks, priorities, status, blockers, sprints | Knowledge, code, long-form docs |
| **GitHub** | Code: source, PRs, CI, releases, repo docs | Tasks, product knowledge, decisions |

### The rule

Every piece of project information belongs in exactly one of these three systems. If you can't map it to one, it probably belongs in Notion (durable knowledge). If someone creates a fourth source (local markdown task list, Slack pinned messages, Google Doc), migrate it to the correct system and delete the duplicate.

## Process

### 1. Identify the conflict
What information disagrees? Which systems hold it?

### 2. Determine the authoritative source
Use the table above. The system that "owns" that type of information is authoritative.

### 3. Update the stale source
Bring the non-authoritative source in sync with the authoritative one. Add a note about when it was synced.

### 4. Prevent recurrence
- If the conflict was caused by manual duplication, add a link instead of copying content
- If the conflict was caused by a missing workflow step, update the relevant skill

## Examples

**Linear says "In Progress", PR was merged yesterday:**
→ Linear is stale. Update Linear status to "Done" with a link to the merged PR.

**PRD in Notion says "include dark mode", implementation doesn't have it:**
→ Was dark mode cut? If yes, update the PRD with a decision note. If no, create a Linear issue for it.

**Someone made a `TODO.md` in the repo root:**
→ Move items to Linear issues. Delete the file. Add a note to CLAUDE.md: "Tasks go in Linear, not local files."

## Hard rules

- Never create a fourth source of truth — migrate to the correct system
- Never copy content between systems — link to the authoritative source
- When systems disagree, the one that "owns" that data type wins
- Every reconciliation should include a note on what was changed and why

## Output format

```markdown
# Reconciliation — [what conflicted]

## Systems involved: [e.g., Linear vs GitHub]
## Authoritative source: [system] (owns this data type)
## Action taken: [what was synced/updated/deleted]
## Recurrence prevention: [link added / workflow step / skill updated]
## Synced on: [YYYY-MM-DD]
```

## Connects to

- `notion-brain` — Notion-side of the governance model
- `linear-operator` — Linear-side of the governance model
- `github-operator` — GitHub-side of the governance model
- `decision-log-adr` — decisions about governance get logged

## Common failure modes

**The Slack channel becomes source of truth** — Decisions made in chat disappear. Log them in Notion via `decision-log-adr`.

**Copy-paste between Notion and Linear** — Now both have the content, both drift. Link instead of copy.

**Silent status drift** — Linear issues left in "In Progress" after the PR merged, week after week, until the board no longer reflects reality and nobody trusts it. Reconcile status at a fixed cadence (e.g., when closing a PR, flip the linked issue), not "eventually."
