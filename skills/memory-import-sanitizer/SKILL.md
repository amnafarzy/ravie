---
name: memory-import-sanitizer
description: >-
  Use this skill when importing ChatGPT or Claude exports, old Notion databases, local notes, or messy knowledge dumps into a durable knowledge system after redaction, deduplication, and classification. Do not use for live project planning, raw unredacted client data, or content that should remain out of Notion.
---


# memory-import-sanitizer

Import AI conversation exports and external notes into your knowledge system after redaction, deduplication, and classification.

## Purpose

When migrating from ChatGPT exports, old Claude conversations, Notion imports, or local markdown notes, clean and classify the content before it enters your system of record.

## When to use this

- Importing ChatGPT conversation exports
- Migrating Claude conversation history
- Importing old Notion databases
- Consolidating local markdown notes into Notion
- Cleaning up a messy knowledge dump

## When NOT to use this

- Do not use for live project planning, raw unredacted client data, or content that should remain out of Notion.

## Process

### 1. Inventory the import
```bash
find /path/to/export -type f | head -50
wc -l /path/to/export/**/*.md
```
How many files? What format? How old? Any obvious junk?

### 2. Redaction pass
Remove before importing:
- API keys, tokens, passwords (even expired ones)
- Client names and confidential details (use `client-boundary-guard` rules)
- Personal information that shouldn't be in a shared system
- Credentials embedded in code snippets

### 3. Deduplication
- Same conversation exported multiple times? Keep the latest.
- Same decision recorded in 3 places? Keep the most detailed, note the others.
- Same code snippet in 5 conversations? Extract once, reference by location.

### 4. Classification
Sort into:
- **Decisions** → `decision-log-adr` format, store in Notion Decisions DB
- **Runbooks/processes** → format as runbook, store in Notion
- **Code patterns** → extract to skill or pattern library
- **Project context** → update relevant project's CLAUDE.md
- **Stale/irrelevant** → discard (most imports are 60%+ stale)

### 5. Import to Notion
For each classified item, create or update the appropriate Notion page. Link to source context where relevant.

## Output format

```markdown
# Import summary — [source]

## Inventory
- Total items: [N]
- After dedup: [N]
- After stale removal: [N]

## Classification
- Decisions: [N] → Notion Decisions DB
- Runbooks: [N] → Notion Runbooks
- Patterns: [N] → skill library / pattern-learner
- Project context: [N] → CLAUDE.md updates
- Discarded: [N] (stale/irrelevant)

## Redactions made
- [N] credentials removed
- [N] client references anonymized

## Follow-ups
- [ ] [Items needing human review before import]
```

## Hard rules

- Never import without a redaction pass — assume exports contain secrets
- Never import duplicates — deduplicate first
- Most imports are majority stale — don't preserve everything out of completeness instinct
- Client data follows `client-boundary-guard` rules even in imports

## Connects to

- `client-boundary-guard` — for redacting client-specific content
- `notion-brain` — destination for imported knowledge
- `system-of-record-governance` — imports must go to the right system
- `decision-log-adr` — for decisions found in imports

## Common failure modes

**Importing everything** — 500 conversations, 450 are stale. Importing all of them pollutes your knowledge base. Be aggressive about discarding.

**Credentials in old exports** — ChatGPT exports from 2024 may contain API keys you pasted in. Always scan before importing.
