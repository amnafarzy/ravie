---
name: vercel-preview-qa
description: >-
  Use this skill when a PR has a Vercel preview URL and user-facing acceptance criteria need browser QA across happy path, errors, empty states, responsive behavior, and accessibility basics. Do not use without a preview URL or acceptance criteria, for production deploy approval, or for root-cause debugging before the failure is understood.
---


# vercel-preview-qa

QA a Vercel preview deployment against acceptance criteria before merge. The visual and functional check that catches what unit tests miss.

## Purpose

Take a preview URL and acceptance criteria from a Linear issue, and verify that the implementation actually meets the criteria in a real browser environment.

## When to use this

- PR has a Vercel preview URL
- Changes are user-facing
- Before marking a PR as ready for review
- After fixing issues flagged in a previous QA pass

## When NOT to use this

- Do not use without a preview URL or acceptance criteria, for production deploy approval, or for root-cause debugging before the failure is understood.

## Process

### 0. Read the UI rule reference first
Before UI work or review, read `rules/ui.md` and apply the project’s responsive, accessibility, component-state, and design-token expectations.

### 1. Get the acceptance criteria
Read from the Linear issue. If no criteria exist, stop — route to `requirements-griller`.

### 2. Test each criterion
For each acceptance criterion, test it on the preview:
- Does the happy path work?
- Does the error path work?
- Does the empty state work?

### 3. Responsive check
Test at three breakpoints:
- Mobile: 375px
- Tablet: 768px
- Desktop: 1280px

Check for: horizontal overflow, touch target sizing, layout breaks, text overflow.

### 4. Accessibility quick check
- Tab through the page — is focus order logical?
- Are focus indicators visible?
- Do buttons and links have accessible labels?
- Does the page work with `prefers-reduced-motion: reduce`?

### 5. Classify findings
- **Blocker** — prevents merge. Acceptance criterion not met, broken functionality, security issue.
- **Issue** — should fix before merge. Visual regression, missing state, accessibility gap.
- **Polish** — can fix in follow-up. Minor alignment, copy improvement, animation refinement.

## Output format

```markdown
# Preview QA — [PR #/feature]
Preview URL: [url]

## Acceptance criteria
- [x] [Criterion 1] — verified
- [ ] [Criterion 2] — BLOCKER: [what's wrong]
- [x] [Criterion 3] — verified

## Responsive
- Mobile (375): [pass/issues]
- Tablet (768): [pass/issues]
- Desktop (1280): [pass/issues]

## Accessibility
- Focus order: [pass/issues]
- Focus indicators: [pass/issues]
- Labels: [pass/issues]
- Reduced motion: [pass/issues]

## Findings
### Blockers
- [Finding]

### Issues
- [Finding]

### Polish
- [Finding]

## Verdict: [PASS / BLOCKED — N blockers]
```

## Hard rules

- Never skip preview QA for user-facing changes
- Never mark "PASS" with unresolved blockers
- Never invent acceptance criteria — use the ones from Linear

## Connects to

- `issue-to-pr` — invoked after push, before PR finalized
- `responsive-ui` — for deeper responsive review if needed
- `accessibility-ui` — for deeper a11y review if needed
- `deploy-ready` — complementary checklist

## Common failure modes

**Checking only desktop** — Most users are on mobile. Always check 375px.

**"Looks right to me"** — Compare against acceptance criteria explicitly. Visual impression is not QA.

**Skipping error states** — Happy path looks great. Then a user with no data sees a blank page.
