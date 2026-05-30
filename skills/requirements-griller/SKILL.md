---
name: requirements-griller
description: >-
  Use this skill when a request, idea, or product/design direction is ambiguous, high-leverage, user-facing, likely to become Linear/GitHub work, or needs one-question-at-a-time clarification into scope and acceptance criteria. Do not use for simple factual questions, pure exploration, already-approved PRDs/issues, or implementation-ready work that belongs to issue-to-pr.
---


# requirements-griller

Turn vague requests into precise, executable scope. Stops the failure mode where AI starts implementing on assumptions and you re-do it three times.

## Purpose

Take an unclear request — "build a dashboard" / "make it better" / "add some kind of profile thing" — and produce: clarified scope, acceptance criteria, non-goals, assumptions, risks, and recommended next workflow.

Ask one sharp question at a time. Recommend defaults. Push back on overbroad scope. Use deep interrogation mode when the request is pre-spec. Stop the moment work could become a Linear issue.

## When to use this

- Request is ambiguous ("improve the dashboard" — improve how?)
- Request is high-leverage (involves shipped features, clients, or production)
- Request is product-facing or user-facing
- Request is going to become Linear/GitHub work
- Request implies decisions that haven't been stated
- You catch yourself about to implement on assumptions

Don't use this for:
- One-line answer questions ("how do I run the dev server?")
- Spike / exploration where you genuinely just want to play
- Already-grilled requests with PRD and acceptance criteria — just route to `issue-to-pr`


## When NOT to use this

- Do not use for simple factual questions, pure exploration, already-approved PRDs/issues, or implementation-ready work that belongs to issue-to-pr.

## Deep interrogation mode

Use deep interrogation mode when the idea is still a feeling rather than a spec, the done-state is not testable, multiple interpretations exist, or the user wants to stress-test a design before committing to build it.

This mode handles pre-spec interrogation. It is pre-planning: no PRD, no acceptance criteria, and no implementation until the shared mental model is approved.

### How deep interrogation differs from normal requirements grilling

- **Deep interrogation mode** surfaces hidden assumptions and builds a shared mental model.
- **Normal requirements grilling** converts semi-clear scope into acceptance criteria, non-goals, risks, and next workflow.
- The flow is: deep interrogation mode → normal requirements grilling → `idea-to-prd-tracer` or `issue-to-pr`.

### Deep interrogation process

1. Ask the user to state the seed idea in one sentence. Accept vague language.
2. Check existing context before asking questions: relevant docs, Linear issues, code, and decisions. Use a research subagent if available.
3. Ask one question at a time. Each question must be specific, answerable, and include a recommended answer or 2-4 options when useful.
4. Walk decision branches briefly: explain what option A implies versus option B, then ask which trade-off matters more.
5. Surface hidden assumptions, edge cases, implied mobile/accessibility requirements, and technical constraints the user may not know about.
6. After 8-15 questions, present the shared mental model in 200-300 word chunks: problem/user, what it does, what it does not do. Ask for sign-off after each chunk.
7. Only after sign-off, continue into the normal requirements-griller output format or hand off to `idea-to-prd-tracer`, `decision-log-adr`, or `debug-root-cause`.

### Deep interrogation hard rules

- Never ask more than one question per message.
- Never skip existing-context exploration when code or docs can answer the question.
- Always propose an answer when one is inferable.
- Never let the user skip non-goals.
- Never produce a PRD or acceptance criteria in deep interrogation mode; that comes after the mental model is approved.
- Present the mental model in chunks, not walls of text.
- Push back when scope grows and ask whether to split it.

## Stack integration

**Reads from:**
- Notion (existing PRDs, decisions, runbooks for this area)
- Linear (related projects, prior issues, themes)
- GitHub (existing code in the affected area)
- `CLAUDE.md` (project-specific conventions and constraints)

**Writes to:**
- Clarified spec (chat first, then to Notion as PRD draft if scope warrants)
- Linear acceptance criteria (drafted, awaiting approval)
- GitHub plan (if implementation is imminent)
- Decision log entry (if the grilling surfaces a real decision)

## Inputs required

- Initial request (whatever the user said)
- Project / repo context
- Any deadline or priority signal
- Customer / client context (if relevant)
- Existing design references (Figma / Lovable)
- Existing constraints (technical, business, user-facing)

## Process

### 1. Restate the request operationally
Convert vague language to operational language:
- "Make the dashboard better" → "Improve [specific aspect: speed / clarity / data shown / UX] of the dashboard at [route]"
- "Add a profile thing" → "Add user profile [view / edit / settings] capability with [scope]"

If you can't restate it without inventing scope, ask the first question.

### 2. Check existing context first
Don't ask questions Notion or Linear or the repo can answer:
- Is there a Notion PRD that already covers this?
- Are there past Linear issues in this area?
- Is there code that handles part of this already?
- Is there a relevant decision in the decision log?

### 3. Identify what you actually need
Five things turn vague into precise:
- **Goal**: what business / user outcome are we after?
- **User**: who experiences this? (not "users" — be specific)
- **Done state**: how do we know it's done?
- **Constraints**: timeline, budget, technical, UX, brand
- **Non-goals**: what we explicitly won't do

If any of these are unclear, that's your next question.

### 4. Ask one sharp question at a time
Bad: "Tell me about the goal, user, success criteria, constraints, non-goals, and timeline."

Good: "Who is the primary user of this dashboard — the founder reviewing metrics, or the operator triaging tasks?"

One question. Specific answer choices when possible. Wait for the answer before the next question.

### 5. Recommend defaults when obvious
If the answer is obvious from context, propose it instead of asking:
- "Defaulting to: support same auth as rest of app, Tailwind tokens already in repo, mobile breakpoint at 375. Push back if any of these are wrong."

This saves time when the answer is implicit. The user just confirms or corrects.

### 6. Separate product decisions from implementation
- Product: "Should users be able to delete their own data?" (decision)
- Implementation: "Soft delete or hard delete?" (decision)
- Implementation detail: "Use a `deleted_at` timestamp or a separate `archived` table?" (engineering — don't ask the user)

Don't ask the user implementation details they don't care about. Make those decisions yourself with `decision-log-adr` if they're durable.

### 7. Push back on scope creep
If the request grows during grilling, name it:
- "You started with 'add user profiles.' Now we have profiles + settings + privacy controls + admin override. That's a project, not an issue. Should we split it?"

Then split it explicitly into a project with multiple issues, or trim back to the original ask.

### 8. Convert confirmed scope into acceptance criteria
Acceptance criteria are testable. Examples:

Bad: "User can edit their profile."
Good:
- User can update display name (1-50 chars, validated for emoji)
- User can update email (must be unique, sends verification)
- User can update avatar (image upload, max 5MB, square crop)
- Save shows loading state, success toast, and persists on refresh
- Edit fails gracefully with field-level errors

Each criterion should be:
- Testable (you'd know it's done)
- Specific (no "good UX" — say what good UX means)
- Bounded (no "and also...")

### 9. Identify the smallest tracer bullet
What's the smallest end-to-end slice that proves the architecture works?
- Often: one happy path, hardcoded values, no edge cases
- Goal: find broken assumptions in 50 lines, not 500

### 10. Recommend the next workflow
Based on what came out of grilling:
- New product feature with PRD scope → `idea-to-prd-tracer`
- One Linear issue with criteria, ready to build → `issue-to-pr`
- Architectural choice surfaced → `decision-log-adr`, then resume
- It's actually a bug, not a feature → `debug-root-cause`
- It's a question, not work → just answer it, no skill needed

## Output format

```markdown
# Requirements grilled — [topic]

## Restated request
[The operational version of the original ask]

## Goal
[Business or user outcome]

## User
[Who experiences this]

## Scope
- [Bullet list of what's in]

## Non-goals
- [What we're explicitly not doing]

## Assumptions
- [What we're assuming, marked clearly]
- [Defaults proposed]

## Constraints
- [Technical, timeline, brand, etc.]

## Risks
- [What could go wrong, flagged]

## Acceptance criteria
- [Testable item 1]
- [Testable item 2]
- [Testable item 3]

## Tracer bullet
[Smallest path that proves the architecture]

## Next workflow
Recommended: `[skill-name]` — because [reason]

## Open questions
- [Anything still unclear, with proposed default if any]

## Approvals needed
- [ ] Approve scope and acceptance criteria
- [ ] Confirm assumptions
- [ ] Begin next workflow
```

## Approval gates

**Tier 1-2 (default)** — asking, drafting, restating: no approval needed.

**Tier 3 — needs approval:**
- Writing the PRD to Notion
- Creating Linear issues from acceptance criteria
- Beginning implementation (this is the gate that sends control to `issue-to-pr`)

**Never auto:**
- Treating assumptions as confirmed without explicit approval
- Expanding scope based on related context you found
- Skipping criteria because it "seems obvious"

## Hard rules

- Never start implementation before acceptance criteria are confirmed
- Never accept "make it better" or "improve UX" as scope
- Never silently expand scope — name it and split if needed
- Never bury uncertainty — flag assumptions explicitly
- Never ask questions existing context can answer
- Never ask 5 questions at once
- Never invent acceptance criteria the user didn't approve

## Connects to

- `idea-to-prd-tracer` — for new feature work after grilling
- `issue-to-pr` — when criteria are ready and implementation is the next step
- `decision-log-adr` — when a durable architectural choice surfaces
- `debug-root-cause` — when grilling reveals it's a bug
- `linear-operator` — for issue creation after approval
- `notion-brain` — for PRD writing after approval

## Common failure modes

**Asking too many questions** — 7-question initial salvo kills momentum. One sharp question at a time. Defaults where obvious.

**Skipping the restate step** — If you can't restate the request operationally, you definitely can't implement it. The restate is the test.

**Treating implicit answers as approval** — User said "yeah do it" — but you proposed three things. Get explicit approval per item, not blanket.

**Not pushing back on scope** — User says "while we're at it, also add..." Each addition is a slippery slope. Name it and split it.

**Acceptance criteria that aren't testable** — "Looks good" / "feels fast" / "modern UX" — none of these are criteria. Force specificity. If the user can't tell you when it's done, neither can the AI.

**Drowning in edge cases** — The first pass should focus on the happy path. Edge cases get acknowledged but boxed for follow-up issues. Don't let "what if the user has no data" derail the dashboard spec.
