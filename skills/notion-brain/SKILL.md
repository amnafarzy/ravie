---
name: notion-brain
description: >-
  Use this skill when creating, updating, cleaning, or organizing Notion as durable knowledge for PRDs, decisions, runbooks, briefs, learnings, and sanitized memory imports. Do not use for task status, code truth, deployment status, or any write to Notion without approval.
---


# notion-brain

Notion is the durable knowledge base. This skill governs what goes there, how it's structured, and how it stays clean.

## Purpose

Maintain Notion as the single durable source for PRDs, decisions, runbooks, operating logs, briefs, and project memory. Prevent it from becoming a duplicate task list or a chat dump.

## When to use this

- Creating PRDs from `idea-to-prd-tracer`
- Logging decisions from `decision-log-adr`
- Writing runbooks for automations from `automation-sre`
- Saving daily/weekly briefs from `daily-brief` or `pattern-learner`
- Updating project memory after significant changes
- Importing cleaned content from old conversations (via `memory-import-sanitizer`)
- Cleaning up stale or duplicate pages
- Reorganizing knowledge structure

## When NOT to use this

- Do not use for task status, code truth, deployment status, or any write to Notion without approval.

## Stack integration

**Reads from:**
- Notion: existing pages, databases, decisions, runbooks
- Linear: project / issue context to link from Notion
- GitHub: repo docs and ADRs to cross-link
- VPS/automation server: automation logs that feed runbook updates
- Vercel / Supabase: incident details for runbook entries
- `CLAUDE.md`: project conventions

**Writes to:**
- Notion: PRDs, decision logs, runbooks, briefs, operating manuals
- Drafts: in chat first, written to Notion only after approval

## Notion structure (recommended)

If your workspace doesn't have this structure yet, this skill can propose it. Don't restructure without explicit approval.

```
AI Operating Workspace
├── Projects
│   ├── [Project A]
│   │   ├── PRDs
│   │   ├── Decisions
│   │   ├── Runbooks
│   │   ├── Daily briefs
│   │   └── Weekly reviews
│   ├── [Project B]
│   │   └── (same structure)
│   └── [other projects]
├── Cross-project
│   ├── Operating manual
│   ├── Skill backlog
│   ├── Pattern library
│   └── Meta-decisions
├── Clients (if agency work)
│   └── [Per-client space, isolated]
└── Reference
    ├── Stack documentation
    ├── Convention library
    └── External research
```

## Inputs required

- Target Notion location (page or database)
- Content type: PRD / decision / runbook / brief / log / manual
- Source material (the actual content to add)
- Linked artifacts (Linear issues, GitHub PRs, decisions)
- Sensitivity: general / project-internal / client-confidential
- Review trigger date (if decision; "review in 90 days" etc.)
- Write approval

## Process

### 1. Classify content type

Different types live in different places and have different templates:

| Content type | Lives in | Template |
|---|---|---|
| PRD | Projects/[project]/PRDs | Idea-to-PRD output |
| Decision | Projects/[project]/Decisions | ADR template |
| Runbook | Projects/[project]/Runbooks | Step-by-step ops |
| Daily brief | Projects/[project]/Daily briefs | Daily template |
| Weekly review | Projects/[project]/Weekly reviews | Weekly template |
| Pattern | Cross-project/Pattern library | Pattern template |
| Operating manual update | Cross-project/Operating manual | (in-place edit) |
| Imported memory | Project-specific OR Pattern library | After sanitization |

### 2. Check if page exists already

Before writing new content:
- Is there an existing PRD for this feature? Update vs create.
- Is there an existing runbook for this automation? Update vs create.
- Is there a decision that supersedes the one being logged?

Don't create duplicates. Update or supersede.

### 3. Pull linked context

For PRDs: link Linear project, GitHub repo, Figma file, related decisions.
For decisions: link the PRD or issue that triggered it.
For runbooks: link the GitHub automation source.
For briefs: link the source data (Linear queue, PR list, etc.).

### 4. Write concisely, durably

Notion content is for future-you. Optimize for readability later, not for thoroughness now.

Rules:
- Lead with the conclusion / answer / current state
- Background goes lower
- Bullet points > walls of text
- Mark uncertainty explicitly (`[?]` or `TBD`)
- Date everything that might decay

### 5. Remove transient noise

Notion is durable. So:
- No "let me think out loud" content
- No chat-style back-and-forth
- No working notes that won't be useful in 3 months

If it's transient, it stays in chat or local notes — not Notion.

### 6. Add review triggers

For decisions and runbooks that may decay:
- "Review by [date]" if time-bound
- "Review when [condition]" if conditional (e.g., "when we hit 1000 users")
- No review date = "permanent" — applies to architectural foundations

### 7. Cross-link aggressively

Notion's value is the graph, not individual pages. Always:
- Link related decisions
- Link superseded decisions (with status)
- Link Linear project
- Link GitHub repo if the topic is technical
- Link Figma if design-relevant

### 8. Mark stale or superseded

When a page no longer reflects current state:
- Add a banner at top: "Superseded by [link] on [date]"
- Don't delete — historical context matters
- Move to an Archive section if needed

### 9. Templates

Use existing templates when adding to a database. Don't reinvent structure each time.

If a template doesn't exist for a content type you're using often, propose one (separate approval).

### 10. Draft before write

For non-trivial content:
- Draft in chat first
- Show full Notion-ready markdown
- Wait for explicit approval
- Then write to Notion

For tiny updates (a single line, a status change), drafting is overkill — but the skill should still note what it did.

## Output format

```markdown
# Notion operation — [action] — [target]

## Content type
[PRD / Decision / Runbook / etc.]

## Destination
[Page or database path]

## Action
[Create / update / supersede / archive]

## Summary
[1-2 sentences on what's being added or changed]

## Linked artifacts
- Linear: [link]
- GitHub: [link]
- Related decision: [link]

## Notion content (draft)
---
[Full Notion-ready markdown]
---

## Review trigger
[Date or condition, if applicable]

## Approvals needed
- [ ] Approve content
- [ ] Approve writing to Notion
```

## Approval gates

**Tier 1 (read-only)** — querying Notion, summarizing pages: always allowed.

**Tier 2 (draft)** — drafting content for chat: always allowed.

**Tier 3 — needs approval:**
- Writing to existing Notion pages
- Creating new pages within existing databases
- Adding cross-links
- Updating runbooks

**Tier 4 — needs explicit approval:**
- Creating new Notion databases
- Restructuring existing databases
- Deleting pages
- Importing old memory (route through `memory-import-sanitizer` first)
- Adding client-sensitive content
- Changing durable architectural decisions

**Never auto:**
- Storing secrets or credentials in Notion (always blocked)
- Mixing client confidential with general project memory
- Mass deletion or bulk changes

## Hard rules

- Never store secrets, API keys, or credentials in Notion
- Never duplicate GitHub technical facts when linking is enough (e.g., don't paste schema definitions; link to the migration file)
- Never use Notion as a task queue — Linear is for that
- Never use Notion as a chat — that's what chat is for
- Never import old memory without `memory-import-sanitizer`
- Never mix client knowledge into general operating workspace
- Never delete pages — supersede or archive instead
- Never let pages drift without review triggers if they may decay
- Never add to Notion if it's transient — chat or local notes are fine

## Connects to

- `idea-to-prd-tracer` — produces PRDs that this skill writes
- `decision-log-adr` — produces decisions that this skill writes
- `automation-sre` — produces runbooks that this skill writes
- `daily-brief` — produces briefs that this skill writes
- `pattern-learner` — produces patterns that this skill writes
- `memory-import-sanitizer` — sanitizes old content before this skill writes it
- `system-of-record-governance` — resolves Notion vs Linear vs GitHub conflicts
- `client-boundary-guard` — enforced for client-facing content

## Common failure modes

**Notion becomes a chat archive** — Pages full of "I think we should..." and "let me explore..." Notion is for durable. Move exploration to chat or scratch notes.

**Duplicate PRDs** — Two PRDs for the same feature because no one searched. Always check before creating.

**Stale runbooks** — Runbook says do X, but reality is now Y. Add review triggers. During weekly review (`pattern-learner`), check runbooks against actual practice.

**No cross-linking** — Pages exist but you can't find them. The graph is the value. Link aggressively.

**Notion competes with Linear** — Tasks live in Notion as bullet points. They drift from Linear. Linear is the task system. Notion only describes tasks at the project level (in PRDs, decisions, briefs).

**Client data in general workspace** — A project PRD references client X by name. That's a leak. Use `client-boundary-guard` for client-adjacent content.

**Death by template** — Every template creates 8 sections, most empty. Templates should encode minimums, not exhaustive structure.
