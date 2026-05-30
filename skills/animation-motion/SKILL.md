---
name: animation-motion
description: >-
  Use this skill when adding, polishing, or debugging UI transitions and animations, especially before launch or when reviewing prototype motion for production readiness. Do not use for decorative animation without user value, WebGL/Three.js work, or layout/responsive issues that belong to responsive-ui.
---


# animation-motion

Restrained, performant motion. Transform and opacity only. Reduced motion respected. No decorative animation without purpose.

## Purpose

Add motion that helps users understand state changes, direct attention, and feel the interface responding — without causing jank, nausea, or distraction.

## When to use this

- Adding transitions or animations to components
- Polishing interactions before launch
- Fixing animation stutter or jank
- Reviewing Lovable prototype animations for production-readiness

## When NOT to use this

- Do not use for decorative animation without user value, WebGL/Three.js work, or layout/responsive issues that belong to responsive-ui.

## Process

### 0. Read the UI rule reference first
Before UI work or review, read `rules/ui.md` and apply the project’s responsive, accessibility, component-state, and design-token expectations.

### 1. Purpose test
Every animation must answer: what does this help the user understand?
- State change (button pressed, panel opened) → yes
- Attention direction (new content appeared) → yes
- Decoration (logo spins, background particles) → almost always no

### 2. Performance constraint
Only animate `transform` and `opacity`. These are GPU-composited and don't trigger layout recalculation. Animating `width`, `height`, `top`, `left`, `margin`, or `padding` causes jank.

### 3. Duration guidelines
- Micro-interactions (button, toggle): 100-200ms
- Panel/modal transitions: 200-300ms
- Page transitions: 300-500ms
- Never >500ms unless intentionally dramatic

### 4. Easing
- Entrances: `ease-out` (fast start, slow end)
- Exits: `ease-in` (slow start, fast end)
- State changes: `ease-in-out`
- Never use `linear` for UI animation (feels mechanical)

### 5. Reduced motion is mandatory
```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

## Hard rules

- Only animate `transform` and `opacity`
- Always support `prefers-reduced-motion`
- Every animation needs a purpose — remove decorative motion
- Never exceed 500ms for standard UI transitions

## Output format

```markdown
# Motion review — [component/flow]

| Animation | Property animated | Duration | Easing | Purpose | Verdict |
|---|---|---|---|---|---|
| [modal open] | transform+opacity | 250ms | ease-out | state change | keep |
| [logo spin] | transform | 2s loop | linear | decorative | remove |

## Reduced motion: [respected? Y/N]
## Jank risk: [any layout-property animations? file:line]
```

## Connects to

- `accessibility-ui` — reduced motion is an a11y requirement
- `threejs-motion-performance` — for WebGL/3D motion
- `design-system-ui` — motion tokens (duration, easing) are part of the system

## Common failure modes

**Animating layout properties** — `width`, `height`, `top` cause jank. Use `transform: scale()` and `transform: translate()` instead.

**No reduced motion** — ~10% of users have this enabled. Ignoring it is both an a11y and UX failure.

**Motion that blocks interaction** — A 400ms entrance animation that the user must wait out before the element responds to clicks, or a transition with no interruptible/exit path so rapid navigation stacks animations. Keep UI transitions short, make them interruptible, and never gate a click behind an animation finishing.
