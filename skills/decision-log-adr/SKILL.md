---
name: decision-log-adr
description: >-
  Use this skill when a durable technical, product, scope, tool, convention, or trade-off decision should be recorded so future sessions do not re-litigate it. Do not use for temporary notes, unresolved debates, or routine task status that belongs in Linear.
---


# decision-log-adr

Record durable product or technical decisions so future sessions don't re-litigate them. The skill that prevents "why did we choose X?" three months from now.

## Purpose

When a meaningful decision is made during development — architecture, tool choice, scope cut, trade-off — log it with context, alternatives considered, and rationale. Future sessions read these decisions and respect them.

## When to use this

- Choosing between technical approaches (e.g., server actions vs API routes)
- Deciding to use or reject a tool/library
- Cutting scope on a feature
- Setting a convention that future work should follow
- Making a trade-off that future-you will question

## When NOT to use this

- Do not use for temporary notes, unresolved debates, or routine task status that belongs in Linear.

## Process

### 1. Identify the decision
State it in one sentence: "We will use [X] instead of [Y] because [Z]."

### 2. Write the ADR

```markdown
# ADR-[number]: [Decision title]

**Status:** Accepted
**Date:** [YYYY-MM-DD]
**Context:** [What situation or problem prompted this decision]

## Decision
[What was decided, in one clear paragraph]

## Alternatives considered
- **[Alternative A]:** [Pros, cons, why rejected]
- **[Alternative B]:** [Pros, cons, why rejected]

## Consequences
- [What this enables]
- [What this prevents or complicates]
- [What we'll need to revisit if conditions change]

## Review trigger
[When should this decision be reconsidered? E.g., "When we have 1000+ users" or "In 6 months" or "Never — this is foundational"]
```

### 3. Store it
- GitHub: `docs/adr/[number]-[slug].md` in the repo
- Notion: in the project's Decisions database
- Link from the relevant Linear issue or PR

## Output format

The ADR template above, filled in.

## Hard rules

- Never make a durable decision without logging it
- Never delete an ADR — supersede it with a new one that links back
- Always include alternatives considered — "we picked X" without "instead of Y and Z" is incomplete
- Always include a review trigger — when should this be reconsidered?

## Connects to

- `idea-to-prd-tracer` — decisions surface during planning
- `notion-brain` — for storing decisions in Notion
- `github-operator` — for storing ADRs in the repo
- `pattern-learner` — feed recurring decision patterns into the system

## Common failure modes

**Decision made in chat, never written down** — Three months later, someone asks "why did we do X?" and nobody remembers. Log it when it happens.

**No alternatives section** — "We chose Supabase" is not a decision log. "We chose Supabase over Firebase because [reasons], accepting the trade-off of [Y]" is.

**Never reviewed** — A decision from 6 months ago may no longer apply. Review triggers exist for this reason.
