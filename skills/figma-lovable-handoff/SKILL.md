---
name: figma-lovable-handoff
description: >-
  Use this skill when converting Figma frames or Lovable prototypes into production-ready implementation plans, component architecture, token maps, states, and QA criteria. Do not use for designs with no accessible reference, backend-only work, or already-built UI that only needs preview QA.
---


# figma-lovable-handoff

Convert designs from Figma or prototypes from Lovable into production-ready implementation. Critical for designer-developer workflow.

## Purpose

Take a design source (Figma file, screenshot, Lovable prototype URL) and produce: a token map, component spec, state map, accessibility requirements, Linear issues, and an implementation plan that fits your actual stack — without copying garbage code.

## When to use this

- Implementing any new screen or component from Figma
- Converting a Lovable prototype into your codebase
- Reviewing UI fidelity against design after implementation
- Planning component architecture before writing code
- Triaging which parts of a Lovable export to keep vs rewrite

## When NOT to use this

- Do not use for designs with no accessible reference, backend-only work, or already-built UI that only needs preview QA.

## Stack integration

**Reads from:**
- Figma (file, screenshots, design tokens, comments)
- Lovable (prototype URL, generated code if accessible)
- Notion (PRD with user goal context)
- GitHub (existing component library, design system tokens, conventions in `CLAUDE.md`)
- Linear (acceptance criteria for the implementation issue)

**Writes to:**
- Implementation spec (in chat, then to Notion if durable)
- Linear issues (if approved, broken into per-component tasks)
- GitHub plan (in repo if structured spec is needed in repo)
- QA checklist for `vercel-preview-qa` to use later

## Inputs required

- Design source URL or attached screenshot
- Target repo and component location
- Product goal (from Notion PRD or stated by user)
- Breakpoints to support (default: mobile 375, tablet 768, desktop 1280)
- States to handle (loading, empty, error, success, disabled, hover, focus)
- Existing tokens to reuse (from repo's design system)
- Lovable code disposition: keep / rewrite / reference / discard

## Process

### 0. Read the UI rule reference first
Before UI work or review, read `rules/ui.md` and apply the project’s responsive, accessibility, component-state, and design-token expectations.

### 1. Identify product intent (not just visuals)
The design shows what; you need to extract why:
- What is the user trying to accomplish on this screen?
- What's the most important action?
- What can be removed without breaking the intent?

If the PRD doesn't answer this, route to `requirements-griller` first.

### 2. Extract design tokens
Pull from the Figma file or infer from screenshot:
- **Colors**: hex values for backgrounds, text, borders, accents
- **Typography**: font family, size, weight, line height per text style
- **Spacing**: padding, margin, gap values used
- **Radius**: border-radius values
- **Shadows**: any used (note: stack discourages shadows; flag if design relies on them)
- **Motion**: any specified animation duration/easing

Map each token against your existing design system in the repo. Output:

```markdown
### Token map
| Design value | Existing token | Action |
|---|---|---|
| #FF6B4A | --color-coral-500 | reuse |
| 18px / 1.4 | text-lg | reuse |
| #1E3A8A | none | propose new token: --color-blue-deep |
| 24px gap | space-6 | reuse |
```

If the design introduces new tokens, flag them for explicit approval before adding. Don't silently expand the token system.

### 3. Map screens to components
Decompose the design into component hierarchy:
```markdown
### Component breakdown
- DashboardPage
  - Header
  - StatsRow
    - StatCard (×4) — variants: default, highlighted, error
  - ChartSection
    - Chart
    - ChartLegend
  - RecentActivity
    - ActivityItem (×n)
```

For each component:
- Existing? Reuse
- Variant of existing? Add variant
- New? Build new with existing primitives
- Lovable-generated? Mark for rewrite

### 4. Identify all states
For every interactive component:
- Default
- Hover
- Focus (keyboard)
- Active / pressed
- Disabled
- Loading
- Empty (if applicable)
- Error
- Success

If the design only shows the default state, document the assumption that defaults apply (matching design system) — flag for designer review.

### 5. Define responsive behavior
Default breakpoints (override from `CLAUDE.md` if project specifies different):
- Mobile: 375px
- Tablet: 768px
- Desktop: 1280px

For each breakpoint, document:
- Layout direction (stack / row / grid)
- Spacing changes
- Hidden / shown elements
- Font size adjustments

### 6. Define accessibility requirements
Apply the project's a11y baseline (from `CLAUDE.md` or `accessibility-ui` skill):
- Semantic HTML elements required
- ARIA labels needed
- Keyboard navigation expected
- Focus order
- Touch target minimum (44×44 default)
- Reduced-motion alternatives
- Contrast ratios

### 7. Identify Supabase / data dependencies
What data does this UI need?
- Existing tables / queries
- New fields needed
- Auth state requirements
- RLS policy implications

If new data shape needed, flag a sub-task for `supabase-guardian` review.

### 8. Triage Lovable code (if applicable)
For each generated file/component:
- **Keep**: matches conventions, no regressions
- **Rewrite**: same shape, but use your tokens / patterns / data layer
- **Reference**: useful as inspiration, don't copy directly
- **Delete**: unhelpful, add nothing

Default disposition: **rewrite** unless code is trivial. Lovable's output is good for prototyping, almost never production-ready as-is.

### 9. Produce implementation plan
```markdown
### Implementation plan
1. [If new tokens] Add tokens to design system — separate PR first
2. Build StatCard component (no data) — Storybook entry
3. Build ChartSection skeleton with mock data
4. Wire StatCard to Supabase — query + RLS check
5. Wire ChartSection to data
6. Compose DashboardPage
7. Mobile responsive pass
8. Accessibility pass
9. Vercel preview QA
10. PR
```

### 10. Create QA checklist for the preview
A prepared checklist for `vercel-preview-qa` to run later:
```markdown
- [ ] Matches Figma at desktop (1280)
- [ ] Matches Figma at tablet (768)
- [ ] Matches Figma at mobile (375)
- [ ] All states present and styled correctly
- [ ] Keyboard nav works through cards
- [ ] Focus indicators visible
- [ ] Touch targets >= 44px on mobile
- [ ] Reduced motion respected
- [ ] Dark mode (if applicable) matches design
- [ ] Loading state shown while data fetches
- [ ] Empty state shown when no data
- [ ] Error state shown on fetch failure
```

### 11. Handoff
Stop before implementation. Output the spec and wait for approval to:
- Create Linear issues from the plan
- Add new tokens (if any) — separate approval required
- Begin implementation (handoff to `issue-to-pr`)

## Output format

```markdown
# Figma/Lovable handoff — [Screen name]

## Sources
- Figma: [URL]
- Lovable: [URL or N/A]
- PRD: [Notion link]

## Product intent
[1-2 sentences on what user goal this serves]

## Token map
[Table from step 2]

## Component breakdown
[From step 3]

## States required
[From step 4]

## Responsive behavior
[From step 5]

## Accessibility requirements
[From step 6]

## Data / Supabase impact
[From step 7]

## Lovable code triage
[From step 8 — only if Lovable was used]

## Implementation plan
[From step 9]

## QA checklist
[From step 10]

## Decisions / open questions
- [Anything ambiguous in the design]
- [Token additions proposed for approval]
- [Scope clarifications needed]

## Approvals needed
- [ ] Approve token additions (if any)
- [ ] Approve component breakdown
- [ ] Create Linear issues from implementation plan
```

## Approval gates

**Tier 1-2 (default)** — extracting spec, drafting plan: no approval needed.

**Tier 3 — needs approval:**
- Adding new design tokens to the system
- Creating Linear issues from the plan
- Committing the spec to GitHub

**Never auto:**
- Copying Lovable-generated code into production paths
- Changing existing tokens
- Removing existing component variants
- Adding heavy new dependencies (animation libs, chart libs, etc.)

## Hard rules

- Never copy Lovable code verbatim into production — always rewrite or explicitly mark as kept
- Never silently expand the token system — propose, get approval, then add
- Never implement only the happy path — every state must be defined
- Never skip the responsive pass — mobile is not a squeezed desktop
- Never invent exact pixel values — note assumption when unclear
- Never skip the accessibility requirements section — even if "we'll add it later"

## Connects to

- `requirements-griller` — invoke if intent unclear before starting
- `design-system-ui` — for token and variant decisions
- `responsive-ui` — for responsive layout details
- `accessibility-ui` — for a11y deep-dive on complex components
- `animation-motion` — if motion is part of the design
- `threejs-motion-performance` — if 3D / WebGL is involved
- `supabase-guardian` — if new data shape needed
- `idea-to-prd-tracer` — if this is part of a new-feature workflow
- `linear-operator` — for issue creation
- `issue-to-pr` — what runs next, per component

## Common failure modes

**Designer/developer translation breaks** — The design has implicit conventions the developer doesn't catch (or vice versa). The skill's job is to make them explicit before code is written. If you find yourself implementing and "guessing" — go back, the spec wasn't done.

**Lovable code quality false positive** — Lovable output looks polished. It's almost never production-ready. Default disposition is rewrite.

**Token sprawl** — Every design adds 3 new colors. Three months later you have 60 colors and no system. Push back on token additions. Reuse aggressively. Propose a new token only when no existing one is close enough.

**Skipping states** — Design typically shows 1-2 states. Production needs 6-8. The state map is what catches this gap.

**Implementing before spec is approved** — Eager implementation = re-implementing later. Spec → approval → implementation → QA. Don't skip steps.

**No QA checklist made upfront** — Then preview QA becomes a guess. Always produce the checklist as part of the handoff.
