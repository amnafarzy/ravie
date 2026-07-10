---
name: client-boundary-guard
description: >-
  Use this skill when working across client, agency, consulting, or personal projects where code, data, credentials, prompts, or reusable patterns could leak between contexts. Do not use for ordinary single-project work with no cross-client or cross-workspace boundary risk.
---


# client-boundary-guard

Prevent cross-client data leakage in agency or consulting work. Keep client content, code, credentials, and patterns isolated.

## Purpose

When working with client material alongside personal projects, ensure no client data leaks into personal repos, Notion, Linear, or skills — and no personal project data leaks into client deliverables.

## When to use this

- Working on a client project alongside personal projects
- Extracting reusable patterns from client work
- Importing or exporting data between client and personal workspaces
- Setting up a new client project

## When NOT to use this

- Do not use for ordinary single-project work with no cross-client or cross-workspace boundary risk.

## Process

### 1. Client project isolation
Each client project should have:
- Its own GitHub repo (never mixed with personal code)
- Its own Linear workspace or team (never shared issues)
- Its own Notion space or isolated section
- Its own environment variables and credentials
- Its own CLAUDE.md (never referencing other clients)

### 2. Pattern extraction rules
When you learn something useful from client work that you want to reuse:
- Extract the **principle**, not the **implementation**
- Never include client-specific code, data, or naming
- Never reference the client by name in reusable skills
- Frame as: "When building [generic category], [principle]" — not "From the Acme Corp project"

Example:
- Bad: "Use the same onboarding flow we built for ClientX"
- Good: "Multi-step onboarding with progress indicator, email verification before account access"

### 3. Context switch protocol
When switching between client and personal work:
- Clear Claude Code context (`/clear`)
- Verify CLAUDE.md loaded is for the correct project
- Never carry conversation context from one client to another

### 4. Credential isolation
- Each client's API keys, database credentials, and env vars live in that project only
- Never reference one client's credentials from another project
- Never store client credentials in personal password managers alongside personal ones without clear labeling

## Output format

When reviewing a boundary concern:
```markdown
# Boundary check — [what was reviewed]

## Leakage found: [yes/no]
- [Specific instance]: [where it is, what leaked, fix]

## Isolation status
- Code: [isolated/shared — issue if shared]
- Tasks: [isolated/shared]
- Knowledge: [isolated/shared]
- Credentials: [isolated/shared]

## Remediation
- [ ] [Action needed]
```

## Hard rules

- Never reference a client by name in reusable skills or personal project code
- Never share credentials across client boundaries
- Never carry Claude Code context between client sessions — clear first
- When extracting patterns, extract the principle not the implementation
- When in doubt about whether something is client-specific, treat it as client-specific

## Connects to

- `pattern-learner` — for safely extracting reusable patterns from client work
- `memory-import-sanitizer` — for cleaning imported data
- `permission-guardian` — client data operations are Tier 3+
- `notion-brain` — for maintaining isolated client knowledge spaces

## Common failure modes

**Pattern extraction includes client details** — "Use the dropdown component from the Acme project." This leaks the client name and implies copying their code. Extract the principle instead.

**Shared Linear workspace** — Client issues mixed with personal issues. One client sees another's task names. Use separate workspaces.
