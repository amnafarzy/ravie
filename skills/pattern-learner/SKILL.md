---
name: pattern-learner
description: >-
  Use this skill when repeated corrections, a significant feature, a slow debugging session, or a weekly review create evidence for reusable patterns and skill or CLAUDE.md updates. Do not use for one-off annoyances, immediate implementation, or unverified patterns without evidence.
---


# pattern-learner

Weekly review: extract reusable patterns from the week's work, identify repeated friction, and propose improvements to skills and CLAUDE.md.

## Purpose

The system that makes the system better. After each week of real use, review what happened and feed improvements back into skills, rules, and project context.

## When to use this

- End of week (Friday or Monday morning)
- After shipping a significant feature
- After a debugging session that took too long
- After noticing the same correction 3+ times

## When NOT to use this

- Do not use for one-off annoyances, immediate implementation, or unverified patterns without evidence.

## Process

### 1. Pull the week's data
- Linear: issues closed, issues created, blockers encountered
- GitHub: PRs merged, review comments, failed CI
- Notion: decisions logged, runbooks updated
- VPS/automation: job failures, new automations

### 2. Identify patterns
Look for:
- **Repeated corrections** — same thing fixed 3+ times → update a skill or CLAUDE.md
- **Repeated friction** — same slow step every PR → automate or simplify
- **Repeated bugs** — same bug class recurring → add a rule or hook
- **Unused skills** — invoked but didn't help → improve or remove
- **Missing skills** — did something manually that should be a skill → create one

### 3. Score pattern confidence
- **LOW** — seen once. Note it, don't act yet.
- **MEDIUM** — seen 2-3 times. Draft the improvement.
- **HIGH** — seen 4+ times. Apply the improvement now.

### 4. Propose changes
For each HIGH confidence pattern:
- Which file to update (SKILL.md, CLAUDE.md, rules, hooks)
- What specific change to make
- Why (cite the evidence from this week)

### 5. Apply approved changes
After human approval, commit improvements to the ravie repo.

## Output format

```markdown
# Weekly review — [date range]

## Work summary
- Issues closed: [count]
- PRs merged: [count]
- Decisions logged: [count]

## Patterns identified
### HIGH confidence (apply now)
- [Pattern]: seen [N] times. Proposed fix: [change to file X]

### MEDIUM confidence (draft, revisit next week)
- [Pattern]: seen [N] times. Watching.

### LOW confidence (noted)
- [Pattern]: seen once.

## Proposed changes
- [ ] [File]: [specific change]
- [ ] [File]: [specific change]

## Skills usage
- Most used: [skill names]
- Never used: [skill names]
- Produced bad output: [skill names — what was wrong]
```

## Hard rules

- Never skip the weekly review — this is what makes the system improve
- Never act on LOW confidence patterns — wait for repetition
- Never change skills based on theory — only change based on observed friction
- Always cite specific evidence for proposed changes

## Connects to

- `skill-creator` — for creating new skills from HIGH confidence patterns
- `workflow-evaluator` — for evaluating whether existing skills are working
- `notion-brain` — for storing review output
- `linear-operator` — for pulling closed issues
- `github-operator` — for pulling merged PRs

## Common failure modes

**Acting on one-off annoyance** — Something annoyed you once, you propose a new skill. Wait for HIGH confidence (4+ occurrences) before changing the system. One-time friction often doesn't recur.

**Proposing skill edits without evidence** — "Maybe issue-to-pr should also do X." Stop. What specifically went wrong? Cite the session, the correction, the friction. Without evidence, the change is guessing.

**Summarizing activity without converting to repo changes** — "This week we shipped 8 PRs and closed 12 issues." Useful for retrospectives, useless for system improvement. Pattern-learner's output must be specific changes to specific files, with evidence.

**Updating CLAUDE.md instead of skills** — The fix goes in the most general place, bloating project context. Domain-specific patterns belong in the relevant skill or rule, not CLAUDE.md.
