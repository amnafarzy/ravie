---
name: accessibility-ui
description: >-
  Use this skill when implementing or reviewing UI that needs semantic HTML, keyboard navigation, focus management, ARIA labels, color contrast, reduced motion, forms, modals, or public-facing pages. Do not use as a standalone product-planning or backend workflow; pair it with design-system-ui, responsive-ui, or vercel-preview-qa when broader UI review is needed.
---


# accessibility-ui

Semantic HTML, keyboard navigation, focus management, ARIA labels, color contrast, reduced motion.

## Purpose

Ensure UI is usable by everyone: keyboard users, screen reader users, users with low vision, users who prefer reduced motion.

## When to use this

- Any UI implementation (always — this is a baseline, not an add-on)
- Forms and interactive components
- Modals and overlays
- Client-facing or public pages

## When NOT to use this

- Do not use as a standalone product-planning or backend workflow; pair it with design-system-ui, responsive-ui, or vercel-preview-qa when broader UI review is needed.

## Process

### 0. Read the UI rule reference first
Before UI work or review, read `rules/ui.md` and apply the project’s responsive, accessibility, component-state, and design-token expectations.

### 1. Semantic elements first
- `<button>` for actions, `<a>` for navigation — never `<div onclick>`
- `<nav>`, `<main>`, `<article>`, `<aside>` for landmarks
- `<h1>` through `<h6>` in order, no skipped levels
- `<label>` for every form input (visible or `sr-only`)

### 2. Keyboard navigation
Tab through the entire page. Verify:
- Focus order matches visual reading order
- Focus indicators are visible (never `outline: none` without replacement)
- All interactive elements are keyboard-reachable
- Modals trap focus while open
- Escape closes modals and returns focus to the trigger

### 3. ARIA labels
- Every icon-only button needs `aria-label`
- Every decorative image needs `aria-hidden="true"` or empty `alt=""`
- Dynamic content updates need `aria-live` regions
- Custom components (tabs, accordions) need appropriate ARIA roles

### 4. Color contrast
- Regular text: minimum 4.5:1 contrast ratio
- Large text (18px+ or 14px+ bold): minimum 3:1
- Interactive elements: minimum 3:1 against adjacent colors
- Never use color as the only indicator of state

### 5. Reduced motion
```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

## Output format

Accessibility audit listing issues by WCAG level (A, AA) with specific elements and fixes.

## Hard rules

- Never remove focus indicators without providing custom ones
- Never use color as the only state indicator
- Never skip keyboard navigation testing
- Semantic HTML first, ARIA second — ARIA is a patch, not a replacement

## Connects to

- `responsive-ui` — touch targets overlap with a11y
- `animation-motion` — reduced motion support
- `vercel-preview-qa` — a11y quick check is part of preview QA
- `design-system-ui` — color tokens must meet contrast requirements

## Common failure modes

**outline: none everywhere** — Removes focus indicators. Keyboard users can't navigate. Never remove without providing a custom focus style.

**div with onclick instead of button** — Not keyboard-accessible, not announced by screen readers, no focus management. Use `<button>`.
