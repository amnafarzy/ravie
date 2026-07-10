# UI conventions

- **Component states:** every interactive component needs ALL of: default, hover, focus (keyboard), active/pressed, disabled (if applicable), loading, empty, error, success. If the design shows only default, implement the rest from design-system defaults and flag for designer review.
- **Tokens:** reuse existing tokens first; new tokens need approval; semantic names, never raw values. Tailwind inline; extract to a component at 3+ uses.
- **Everything else** — responsive breakpoints, touch targets, accessibility, and UI copy standards — is specified once in the `ui-quality` skill (`skills/ui-quality/SKILL.md`). Follow it for any UI work; don't restate it here.
