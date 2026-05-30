---
name: workflow-evaluator
description: >-
  Use this skill when evaluating whether Ravie skills, workflows, routing, or approval gates are working after real usage, recurring friction, skipped gates, or a monthly health check. Do not use for product feature work or to blame a skill without evidence from actual sessions.
---


# workflow-evaluator

Evaluate whether skills and workflows are actually working. Find the skills that route incorrectly, produce bad output, or get bypassed.

## Purpose

The quality check for the system itself. After real usage, evaluate which skills helped, which produced wrong output, which got ignored, and which gates got bypassed.

## When to use this

- After `pattern-learner` identifies a skill that produced bad output
- When a permission gate was skipped during a session
- When a workflow felt slow or wrong
- Monthly system health check

## When NOT to use this

- Do not use for product feature work or to blame a skill without evidence from actual sessions.

## Process

### 1. Collect evidence
For each skill being evaluated:
- How many times was it invoked this week/month?
- Did it produce output that was used as-is, or required heavy editing?
- Did it route correctly (triggered for the right tasks)?
- Did it miss triggers (should have activated but didn't)?
- Were approval gates respected?

### 2. Classify skill health

| Status | Meaning | Action |
|---|---|---|
| **Healthy** | Triggers correctly, output is usable | No change needed |
| **Noisy** | Triggers too often for irrelevant tasks | Tighten trigger conditions |
| **Silent** | Should trigger but doesn't | Broaden trigger conditions or update router |
| **Stale** | Output references outdated patterns | Update the skill content |
| **Wrong** | Produces incorrect or harmful output | Rewrite or remove |
| **Unused** | Never triggered in 4+ weeks | Evaluate if still needed |

### 3. Check gate compliance
Review Tier 3-4 actions from the past week:
- Were approval gates respected?
- Were any Tier 4 actions blanket-approved (violation)?
- Were any actions misclassified to a lower tier?

### 4. Propose fixes
For each unhealthy skill:
- Specific change to make
- Evidence for why
- Expected improvement

## Output format

```markdown
# Workflow evaluation — [date range]

## Skill health
| Skill | Status | Invocations | Notes |
|---|---|---|---|
| issue-to-pr | Healthy | 12 | Output used as-is |
| deploy-ready | Stale | 3 | References outdated Vercel config |
| figma-lovable-handoff | Silent | 0 | Should have triggered for UI work |

## Gate compliance
- Tier 3 actions: [N] total, [N] properly gated
- Tier 4 actions: [N] total, [N] properly gated
- Violations: [list]

## Proposed changes
- [ ] [Skill]: [change] — because [evidence]

## Skills to consider removing
- [Skill]: unused for [N] weeks, no clear use case remaining
```

## Hard rules

- Never evaluate based on theory — only based on observed usage
- Never remove a skill without checking whether it was silent (should have triggered but didn't)
- Never ignore gate violations — they indicate a structural problem
- Always cite specific evidence for proposed changes

## Connects to

- `pattern-learner` — feeds findings into the weekly review
- `skill-creator` — for creating skills to fill gaps identified here
- `permission-guardian` — for reviewing gate compliance

## Common failure modes

**Blaming the skill when the router is wrong** — A skill produces bad output because it was triggered for the wrong task. Check the routing logic, not just the skill.

**Removing unused skills prematurely** — A skill might be unused because it's rare, not because it's useless. Check whether situations where it should trigger actually occurred.
