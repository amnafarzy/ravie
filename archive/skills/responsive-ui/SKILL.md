---
name: responsive-ui
description: >-
  Use this skill when implementing or reviewing responsive layouts, mobile-first behavior, breakpoints, touch targets, overflow, or layout bugs across mobile, tablet, and desktop. Do not use for backend work, generic visual polish, or accessibility-only issues handled by accessibility-ui.
---


# responsive-ui

Mobile-first responsive layouts. Breakpoints, fluid spacing, touch targets, overflow prevention.

## Purpose

Ensure UI works across all device sizes. Start from mobile (375px) and expand upward. Never squeeze a desktop layout into mobile.

## When to use this

- Any UI implementation work
- Layout bugs on specific screen sizes
- Lovable prototype review
- Preview QA responsive check

## When NOT to use this

- Do not use for backend work, generic visual polish, or accessibility-only issues handled by accessibility-ui.

## Process

### 0. Read the UI rule reference first
Before UI work or review, read `rules/ui.md` and apply the project’s responsive, accessibility, component-state, and design-token expectations.

### 1. Start from mobile (375px)
Build mobile layout first. Then add complexity for larger screens. Never the reverse.

### 2. Test at three breakpoints
- 375px (mobile) — the floor
- 768px (tablet) — where layout often switches from stack to side-by-side
- 1280px (desktop) — the comfortable maximum

### 3. Check for horizontal overflow
```css
/* Temporary debug — remove after */
* { outline: 1px solid red; }
```
Any element wider than viewport creates a horizontal scrollbar. Common culprits: tables, code blocks, images without `max-width: 100%`, fixed-width containers.

### 4. Touch targets
Minimum 44x44px for any interactive element on mobile. Smaller = unusable for thumb navigation. Check buttons, links, form inputs, toggles.

### 5. Text overflow
Long strings (emails, URLs, names) without `overflow-wrap: break-word` or `text-overflow: ellipsis` will break layouts on mobile.

## Output format

Responsive review report listing issues per breakpoint with specific components and fixes.

## Hard rules

- Never build desktop-first and squeeze to mobile
- Never ship horizontal overflow
- Touch targets minimum 44x44 on mobile — no exceptions
- Always test at 375, 768, and 1280

## Connects to

- `design-system-ui` — spacing tokens must work across breakpoints
- `accessibility-ui` — touch targets overlap with a11y requirements
- `figma-lovable-handoff` — responsive behavior defined during handoff
- `vercel-preview-qa` — responsive check is part of preview QA

## Common failure modes

**Desktop-first squeeze** — Built for 1280px, then "made responsive" by shrinking. Always breaks. Start at 375px.

**Horizontal overflow from one element** — A single `min-width: 500px` table breaks the entire mobile layout.

**`100vh` on mobile** — `height: 100vh` is taller than the visible area on iOS Safari because the URL bar is excluded, cutting off content or forcing scroll. Use `100dvh` (dynamic viewport height) with a `100vh` fallback, or `min-height: 100svh`.
