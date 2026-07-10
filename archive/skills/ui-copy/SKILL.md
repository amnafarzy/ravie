---
name: ui-copy
description: >-
  Use this skill when UI text is vague, generic, missing, or confusing, including buttons, errors, empty states, loading messages, success feedback, and recovery guidance. Do not use for long-form marketing copy, PRDs, or product positioning that belongs to growth-launch-pack or requirements-griller.
---


# ui-copy

Interface copy that helps users: buttons, errors, empty states, success feedback, loading messages.

## Purpose

Replace generic or confusing UI text with specific, helpful copy. Every string the user reads should help them understand what's happening or what to do next.

## When to use this

- Generic button labels ("Submit", "OK", "Click here")
- Vague error messages ("An error occurred")
- Unhelpful empty states ("No data")
- Missing loading or success feedback

## When NOT to use this

- Do not use for long-form marketing copy, PRDs, or product positioning that belongs to growth-launch-pack or requirements-griller.

## Process

### 0. Read the UI rule reference first
Before UI work or review, read `rules/ui.md` and apply the project’s responsive, accessibility, component-state, and design-token expectations.

### 1. Buttons: specific verb
- Bad: "Submit", "OK", "Click here"
- Good: "Save changes", "Send invitation", "Delete project"
- The label should tell you what happens when you click it.

### 2. Errors: what happened + what to do
- Bad: "An error occurred"
- Good: "Email already registered. Try logging in instead."
- Never blame the user. Never show raw error codes.

### 3. Empty states: what goes here + how to start
- Bad: "No data"
- Good: "No projects yet. Create your first project to get started."
- Include a CTA button in the empty state when possible.

### 4. Loading: what's happening
- Bad: spinner with no text
- Good: "Loading your dashboard..." or skeleton screens
- For operations >2s, show progress or a message.

### 5. Success: confirm what happened
- Bad: nothing (page refreshes silently)
- Good: toast: "Changes saved" — brief and auto-dismiss.

### 6. Destructive actions: confirm with consequences
- Bad: "Are you sure?"
- Good: "Delete 'Project Alpha'? This removes all tasks and files permanently."

## Output format

```markdown
# Copy audit — [screen/flow]

| Location | Current text | Problem | Suggested |
|---|---|---|---|
| [Save button] | "Submit" | generic verb | "Save changes" |
| [Empty list] | "No data" | no next action | "No projects yet. Create your first one." |
| [Error toast] | "Error 500" | raw code, no recovery | "Couldn't save — check your connection and retry." |
```

## Hard rules

- Never blame the user in error messages
- Never show raw error codes or stack traces to users
- Never use developer language in user-facing copy
- Every empty state needs a CTA for the next action

## Connects to

- `design-system-ui` — copy is part of the component
- `accessibility-ui` — error messages need ARIA live regions
- `growth-launch-pack` — landing page copy follows positioning

## Common failure modes

**Developer language in UI** — "null reference exception" in a user-facing error. Catch and translate to something helpful.

**"Are you sure?" without consequences** — Users click "yes" reflexively. Show what they're about to lose.

**Optimistic copy that lies** — A toast says "Saved!" the instant the button is clicked, before the request resolves. When the save then fails, the user has already navigated away believing it worked. Confirm success only on the actual success response; show a pending state in between.
