---
name: design-system-ui
description: >-
  Use this skill when creating components, implementing Figma designs, cleaning inconsistent styling, adding or reviewing tokens, spacing, typography, or component variants. Do not use for backend work, feature scoping, or visual QA that requires a live preview instead of design-system decisions.
---


# design-system-ui

Design tokens, spacing, typography, component variants. The source of truth for visual consistency across the project.

## Purpose

Maintain a coherent design system: reuse tokens aggressively, propose new ones only when nothing existing fits, and ensure every component follows the established patterns.

## When to use this

- Creating new components
- Implementing from Figma
- Cleaning up inconsistent styling
- Reviewing token additions proposed by figma-lovable-handoff

## When NOT to use this

- Do not use for backend work, feature scoping, or visual QA that requires a live preview instead of design-system decisions.

## Process

### 0. Read the UI rule reference first
Before UI work or review, read `rules/ui.md` and apply the project’s responsive, accessibility, component-state, and design-token expectations.

### 1. Check existing tokens first
```bash
grep -r 'colors\|spacing\|fontSize' tailwind.config.*
```
Map the design's values against what exists. Reuse aggressively. A new token should only be added when no existing token is close enough.

### 2. Component variant audit
For any new component: does a similar component already exist? Could this be a variant rather than a new component? Check the existing component library before building from scratch.

### 3. Token addition requires approval
New colors, spacing values, or typography scales must be proposed and approved before adding. Include a justification: what existing token doesn't work and why.

### 4. Naming conventions
Tokens use semantic names (not raw values):
- Colors: `background`, `surface`, `accent`, `muted` — not `blue-500`
- Spacing: `space-1` through `space-8` or `xs/sm/md/lg/xl`
- Typography: `text-sm`, `text-base`, `text-lg` — not `14px`

## Output format

```markdown
# Design system review — [component/feature]

## Tokens reused: [list]
## New tokens proposed: [list with justification]
## Component variants: [new vs variant of existing]
## Consistency issues found: [list]
```

## Hard rules

- Never add tokens without approval
- Never use raw hex values when a semantic token exists
- Never create a new component when a variant of an existing one would work
- Reuse first, propose second, create last

## Connects to

- `figma-lovable-handoff` — produces token maps this skill evaluates
- `responsive-ui` — spacing tokens must work across breakpoints
- `accessibility-ui` — color tokens must meet contrast requirements

## Common failure modes

**Token sprawl** — Every design adds 3 new colors. Three months later you have 60 colors and no system. Push back on additions.

**Raw values in components** — `text-[14px]` instead of `text-sm`. Kills consistency when you later change the scale.

**Spacing improvisation** — Padding and gaps chosen by eye (`mt-[13px]`, `gap-[7px]`) instead of from the spacing scale. Individually invisible; in aggregate the UI reads as subtly misaligned. Snap every spacing value to the scale (`space-2`, `gap-4`) and propose a new step only if nothing fits.
