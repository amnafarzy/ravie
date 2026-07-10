---
name: ui-quality
description: >-
  Use this whenever you build or review ANY frontend UI — components, layouts, forms, styling, or user-facing text — even if the user just says "build the page". Covers design tokens, responsive/mobile-first layout, accessibility (keyboard, ARIA, contrast), and UI copy (buttons, errors, empty states). NOT for animation (animation-motion), WebGL (threejs-motion-performance), or live-preview QA (vercel-preview-qa).
---

# ui-quality

One pass, four lenses: design-system consistency, responsive layout, accessibility, and UI copy. Merged from the former accessibility-ui, responsive-ui, design-system-ui, and ui-copy skills (originals in `skills/archive/`).

## Purpose

Every piece of UI ships coherent (tokens, not raw values), responsive (mobile-first), usable by everyone (keyboard, screen reader, low vision), and with copy that tells users what's happening and what to do next.

## Process

### 0. Read the UI rule reference first
Read `rules/ui.md` and apply the project's responsive, accessibility, component-state, and design-token expectations.

## Lens 1 — Design system

### Check existing tokens first
```bash
grep -r 'colors\|spacing\|fontSize' tailwind.config.*
```
Map the design's values against what exists. Reuse aggressively. Add a new token only when nothing existing is close enough — and new tokens require approval with a justification.

### Component variant audit
Before building a new component: does a similar one exist? Could this be a variant instead?

### Naming conventions
Semantic names, not raw values:
- Colors: `background`, `surface`, `accent`, `muted` — not `blue-500`
- Spacing: `space-1`…`space-8` or `xs/sm/md/lg/xl`
- Typography: `text-sm`, `text-base`, `text-lg` — not `14px`

## Lens 2 — Responsive layout

### Start from mobile (375px)
Build mobile first, then add complexity upward. Never squeeze desktop into mobile.

### Test at three breakpoints
- 375px (mobile, the floor) · 768px (tablet, stack → side-by-side) · 1280px (desktop)

### Check for horizontal overflow
```css
/* Temporary debug — remove after */
* { outline: 1px solid red; }
```
Common culprits: tables, code blocks, images without `max-width: 100%`, fixed-width containers.

### Touch targets
Minimum 44x44px for any interactive element on mobile — buttons, links, inputs, toggles.

### Text overflow
Long strings (emails, URLs, names) need `overflow-wrap: break-word` or `text-overflow: ellipsis`.

## Lens 3 — Accessibility

### Semantic elements first
- `<button>` for actions, `<a>` for navigation — never `<div onclick>`
- `<nav>`, `<main>`, `<article>`, `<aside>` landmarks; `<h1>`–`<h6>` in order, no skipped levels
- `<label>` for every form input (visible or `sr-only`)

### Keyboard navigation
Tab through the entire page:
- Focus order matches visual reading order
- Focus indicators visible (never `outline: none` without replacement)
- All interactive elements keyboard-reachable
- Modals trap focus; Escape closes and returns focus to the trigger

### ARIA labels
- Icon-only buttons need `aria-label`; decorative images need `aria-hidden="true"` or empty `alt=""`
- Dynamic updates need `aria-live` regions; custom widgets (tabs, accordions) need proper roles

### Color contrast
- Regular text ≥ 4.5:1; large text (18px+ / 14px+ bold) ≥ 3:1; interactive elements ≥ 3:1 vs adjacent
- Never use color as the only indicator of state

### Reduced motion
```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

## Lens 4 — UI copy

- **Buttons:** specific verb — "Save changes", not "Submit"/"OK"/"Click here"
- **Errors:** what happened + what to do — "Email already registered. Try logging in instead." Never blame the user; never show raw error codes.
- **Empty states:** what goes here + how to start, with a CTA — "No projects yet. Create your first project."
- **Loading:** say what's happening ("Loading your dashboard…") or use skeletons; show progress for operations >2s
- **Success:** confirm it happened (toast: "Changes saved") — only on the actual success response
- **Destructive actions:** confirm with consequences — "Delete 'Project Alpha'? This removes all tasks and files permanently."

## Output format

```markdown
# UI review — [component/feature]

## Design system: tokens reused / new tokens proposed (with justification) / consistency issues
## Responsive: issues per breakpoint (375 / 768 / 1280)
## Accessibility: issues by WCAG level (A, AA) with element + fix
## Copy: | Location | Current | Problem | Suggested |
```

## Hard rules

- Never add tokens without approval; never use raw hex/px when a semantic token exists
- Never build desktop-first and squeeze to mobile; never ship horizontal overflow
- Touch targets ≥ 44x44 on mobile; always test at 375, 768, 1280
- Never remove focus indicators without custom replacements; never use color as the only state indicator
- Semantic HTML first, ARIA second — ARIA is a patch, not a replacement
- Never blame the user or show raw error codes/stack traces; every empty state needs a CTA

## Connects to

- `figma-lovable-handoff` — produces the token maps this skill evaluates
- `animation-motion` — motion polish and reduced-motion support
- `vercel-preview-qa` — this skill's checks re-run against the live preview

## Common failure modes

**Token sprawl** — every design adds 3 new colors; three months later, 60 colors and no system. Push back.

**Raw values in components** — `text-[14px]`, `mt-[13px]`, `gap-[7px]` instead of scale values. Individually invisible; in aggregate the UI reads as misaligned.

**Desktop-first squeeze** — built at 1280px, then "made responsive" by shrinking. Always breaks.

**`100vh` on mobile** — taller than the visible area on iOS Safari. Use `100dvh` with a `100vh` fallback, or `min-height: 100svh`.

**`div` with onclick / `outline: none`** — not keyboard-accessible, not announced, no focus management.

**Optimistic copy that lies** — "Saved!" before the request resolves. Confirm on the success response; show pending in between.
