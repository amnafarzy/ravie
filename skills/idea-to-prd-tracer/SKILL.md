---
name: idea-to-prd-tracer
description: >-
  Use this skill when a new feature, founder request, design, prototype, or product idea needs to become a PRD, Linear issues, implementation plan, and first tracer bullet. Do not use for vague ideas that still need requirements-griller, already-approved Linear issues that should go to issue-to-pr, or pure bug investigations.
---


# idea-to-prd-tracer

Convert an idea into a structured PRD, Linear issues, GitHub plan, and a first tracer bullet. The bridge between "I have an idea" and "first PR is ready to start."

## Purpose

Take a rough product idea, founder note, design file, or prototype and produce: a PRD in Notion, broken-down Linear issues with acceptance criteria, a GitHub implementation plan, and a defined tracer bullet. Stop just before implementation.

## When to use this

- New product feature you want to build
- Idea sparked from a conversation or note
- Founder request that needs structured planning
- Figma file that needs implementation planning
- Lovable prototype that needs translation to production
- Client request that needs scoping into deliverables

## When NOT to use this

- Do not use for vague ideas that still need requirements-griller, already-approved Linear issues that should go to issue-to-pr, or pure bug investigations.

## Stack integration

**Reads from:**
- Notion (existing PRDs, decisions, project context)
- Linear (related projects, prior similar issues)
- GitHub (current code in affected area, patterns, conventions)
- Figma / Lovable (if design source exists)
- `CLAUDE.md` (project-specific constraints)

**Writes to:**
- Notion: PRD draft, decision log entries
- Linear: project (if needed), issues with acceptance criteria
- GitHub: implementation plan in `docs/plans/[feature].md` if structured plan needed in repo
- Chat: full output before any external writes

## Inputs required

- The idea (rough is fine — that's why you're using this skill)
- Target user / customer
- Desired outcome (what does success look like?)
- Design / prototype reference if exists
- Target repo
- Constraints: deadline, budget, technical
- Non-goals: what you're NOT building (often as important as goals)

## Process

### 1. Pull related context
Before the idea takes shape, check what's already there:
- Notion: any existing PRD or decision in this area?
- Linear: prior issues, attempted work, lessons learned?
- GitHub: existing code that touches this surface?
- Recent decisions that constrain the design?

### 2. Run requirements-griller if scope is unclear
If the idea is "make it better" or "add a thing," route to `requirements-griller` first. Come back here when scope is clearer.

### 3. Identify the core 5 things
Hard structure that makes a PRD useful:
- **Problem**: what user pain or business gap?
- **User**: who specifically?
- **Outcome**: what changes if this exists?
- **Success criteria**: how do we measure?
- **Non-goals**: what we won't do

### 4. Run figma-lovable-handoff if design exists
If there's a Figma file or Lovable prototype, route to `figma-lovable-handoff`. The output of that skill becomes part of this PRD.

### 5. Draft the PRD
Use this structure (Notion-ready markdown):

```markdown
# [Feature name] PRD

> Status: Draft
> Owner: [Your Name]
> Last updated: [date]
> Linear project: [link if exists]

## Summary
[1-2 sentences. What's the feature, in plain language.]

## Problem
[The user pain or business gap. Be specific. "Users want X" is weak — "Users currently have to do Y, which fails because Z" is better.]

## Target user
[Specific user type, not "users." E.g.: "Solo founders managing their own product roadmap, ~3-10 active issues at a time."]

## Desired outcome
[What's true after this ships that isn't true now? Quantify if possible.]

## Scope
### In scope
- [Specific capability 1]
- [Specific capability 2]
- [Specific capability 3]

### Out of scope
- [Things we considered but explicitly removed — important for not getting talked into them later]

## UX notes
[Key flows, key states, key edge cases. Reference Figma if exists.]

## Data / Supabase impact
[New tables? New columns? New RLS policies? Auth changes?]

## Deployment impact
[New env vars? New routes? New external services? Performance considerations?]

## Risks
- [Technical risks]
- [Product risks: might users not adopt this?]
- [Operational risks: maintenance burden, cost]

## Success criteria
- [Testable / measurable indicators of success]

## Open questions
- [Things still ambiguous — flag for later resolution]

## Decisions logged
- [Link to any decision-log entries made during planning]

## Implementation plan
[High-level phases — not detailed steps]
1. [Phase 1: tracer bullet]
2. [Phase 2: full happy path]
3. [Phase 3: edge cases and polish]
4. [Phase 4: launch readiness]

## Tracer bullet
[Defined smallest end-to-end slice]

## Linear issues
- [Issue 1: tracer bullet implementation]
- [Issue 2: ...]
- [Issue 3: ...]
```

### 6. Identify Supabase / Vercel / UI impact
For each affected layer:
- **Supabase**: schema changes, RLS impact, auth changes — flag for `supabase-guardian` review
- **Vercel**: new routes, env vars, performance implications
- **UI**: new components, new states, design system additions

### 7. Define acceptance criteria
Per the issue level, not the PRD level. The PRD says "user can edit their profile." The Linear issues say:
- "User can update display name (1-50 chars)"
- "User can update email (must be unique, sends verification email)"
- Etc.

Each acceptance criterion is one Linear issue if it's substantial, or grouped if small.

### 8. Identify the tracer bullet
The smallest end-to-end slice that proves the architecture works:
- One happy path through schema → API → UI → preview
- Hardcoded values OK
- Goal: 50-100 lines that compile, run, and produce visible output
- If it works, the architecture is sound and the rest is filling in

### 9. Split into Linear-ready issues
- One issue per acceptance criterion (or small group)
- Each issue has: context, scope, acceptance criteria, non-goals, dependencies, links to PRD
- Mark the tracer-bullet issue as "first executable unit"
- Order by dependency

### 10. Draft the GitHub plan
Optional: `docs/plans/[feature].md` in the repo if a structured plan is helpful for implementation. For small features, the Linear issues are enough.

### 11. Link everything
- PRD links to Linear project
- Linear project links back to PRD
- Each issue links to the PRD section it implements
- Decision log entries link bidirectionally

### 12. Stop before implementation
This skill ends at the plan. Implementation runs through `issue-to-pr` per Linear issue.

## Output format

```markdown
# idea-to-prd-tracer output — [Feature]

## Sources
- Idea source: [conversation, doc, prototype]
- Design: [Figma link if exists]
- Related Notion docs: [links]
- Related Linear: [project / issues]

## PRD draft
[Full PRD as drafted in step 5 — ready to paste into Notion]

## Linear issues
- [TBD-XX]: tracer bullet — [scope] — acceptance: [...]
- [TBD-XX]: [next] — acceptance: [...]
- [TBD-XX]: [next] — acceptance: [...]

## GitHub plan
[Optional path: docs/plans/[feature].md content]

## Tracer bullet
- Path: [layer 1] → [layer 2] → [layer 3]
- Scope: [what it proves]
- Estimate: [rough size]

## Decisions to log
- [Decision 1 surfaced]
- [Decision 2 surfaced]

## Open questions
- [Things still ambiguous]

## Approvals needed
- [ ] Approve PRD content
- [ ] Approve Linear project + issues creation
- [ ] Approve plan committed to repo (if applicable)
- [ ] Begin implementation (handoff to issue-to-pr)

## Next workflow
Recommended: `issue-to-pr` starting with the tracer bullet issue
```

## Approval gates

**Tier 1-2 (default)** — drafting PRD, defining tracer, drafting issues: no approval.

**Tier 3 — needs approval:**
- Writing PRD to Notion
- Creating Linear project (if new)
- Creating Linear issues from the breakdown
- Committing plan file to repo
- Beginning implementation (handoff to `issue-to-pr`)

**Never auto:**
- Treating draft PRD assumptions as final
- Expanding scope from "in scope" without approval
- Generating issues from criteria without explicit approval

## Hard rules

- Never turn a loose idea directly into code — always pass through PRD + acceptance criteria
- Never create issues without acceptance criteria
- Never copy Lovable / prototype output without explicitly running `figma-lovable-handoff`
- Never define "everything" as scope — non-goals are mandatory
- Never define a plan without a tracer bullet
- Never let the tracer bullet expand into the whole feature — it's deliberately small
- Never expand scope beyond the approved problem

## Connects to

- `requirements-griller` — for vague ideas, run first
- `figma-lovable-handoff` — for design / prototype sources
- `linear-operator` — for project and issue creation
- `github-operator` — for plan file commit
- `decision-log-adr` — for decisions surfaced during planning
- `issue-to-pr` — what runs next, per issue
- `notion-brain` — for PRD writing
- `supabase-guardian` — for any DB impact identified
- `vercel-preview-qa` — generates the QA checklist used later

## Common failure modes

**PRD becomes a wishlist** — Every stakeholder adds something and now scope is impossible. Strict non-goals section. Force the question: "what are we NOT doing?" If the answer is "nothing" — scope is broken.

**Acceptance criteria that aren't testable** — "Modern UX" / "Smooth flow" / "Engaging." These are aesthetics, not criteria. Force specificity per item.

**No tracer bullet defined** — Then "implementation plan" is just hope. The tracer is what makes the plan real.

**Linear issues too big** — If an issue would take >2 days, split it. Smaller issues = faster feedback = fewer surprises.

**Decisions not logged** — During planning you'll naturally make architectural choices. Log them. Future-you will thank you.

**Skipping non-goals section** — Most PRD failures are scope creep from week 2. Non-goals are armor against this.

**Going straight to implementation** — Tempting when the idea is small. Don't. Even small features benefit from acceptance criteria written down.
