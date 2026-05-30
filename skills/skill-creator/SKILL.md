---
name: skill-creator
description: >-
  Use this skill when creating or improving a Ravie skill from a repeated workflow, repeated correction, pattern-learner finding, or existing skill failure. Do not use for one-off tasks, generic documentation, or workflows already covered by an existing skill.
---


# skill-creator

Create new skills from observed patterns. When you find yourself re-explaining the same workflow 3+ times, it should become a skill.

## Purpose

Turn a repeated pattern, workflow, or correction into a valid SKILL.md file with YAML frontmatter so future Claude Code sessions can match it from the description. Also used to improve existing skills based on real friction.

## When to use this

- You've corrected the agent on the same thing 3+ times across sessions
- A workflow you repeat doesn't have a skill yet
- An existing skill keeps producing wrong output and needs rewriting
- `pattern-learner` identified a recurring pattern worth formalizing
- You want to extract a reusable workflow from a completed project

## When NOT to use this

- Do not use for one-off tasks, generic documentation, or workflows already covered by an existing skill.

## Process

### Frontmatter requirements

Every skill must begin with YAML frontmatter. The `description` is the routing surface, so put trigger conditions there, not only in the body. Keep it to 1-3 sentences and include when not to use the skill.

Example:

```yaml
---
name: issue-to-pr
description: Use this skill when the user has an approved Linear issue with acceptance criteria and wants to implement it end-to-end through branch creation, tracer bullet, checks, preview, and PR. Do not use for vague bugs, exploration, or work without acceptance criteria.
---
```

### 1. Identify the trigger
What situation should activate this skill? The answer belongs first in YAML frontmatter `description` because Claude Code uses that description for skill selection. Be specific:
- Bad: "when working on frontend code"
- Good: "when creating a new React component that needs to connect to Supabase data"

### 2. Extract the process
From your past sessions or the pattern-learner output, document what the correct process actually is. Include:
- Steps in order
- Commands to run
- Files to check
- Common mistakes to avoid
- What the output should look like

### 3. Write the SKILL.md
Follow this structure:

```markdown
---
name: [skill-name-matches-directory]
description: Use this skill when [specific trigger conditions Claude should match]. Do not use for [explicit non-goals or situations handled by another skill].
---

# [skill-name]

[One sentence: what this skill does.]

## Purpose
[2-3 sentences on why this exists.]

## When to use this
**You MUST use this skill when:**
- [Specific trigger 1]
- [Specific trigger 2]

## When NOT to use this
- [Thing this is NOT for]
- [Other skill to use instead]

## Process
### 1. [First step]
[Concrete instructions with commands/examples]

### 2. [Second step]
...

## Output format
[Template of what the skill produces]

## Hard rules
- [Non-negotiable constraint 1]
- [Non-negotiable constraint 2]

## Connects to
- [Other skills this uses, references, or feeds into]
- [Rule files or external systems this skill reads/writes]

## Common failure modes
- [Specific failure mode 1]
- [Specific failure mode 2]
- [Specific failure mode 3]
```

### 4. Test the skill
Ask the agent to read the skill and explain when it would use it and what it would do. Check:
- Does it understand the trigger conditions?
- Would it follow the steps correctly?
- Would it produce the right output format?
- Would it respect the hard rules under pressure?

If it fails any of these, tighten the language. Use mandatory framing ("You MUST", "NEVER", "ALWAYS") for critical rules.

### 5. Register in SKILL-INDEX.md
Add the new skill to the index with its group, depth tier, and purpose.

## Output format

When creating or revising a skill, produce a complete skill package plan and the updated `SKILL.md` content:

```markdown
# Skill package: [skill-directory]

## Files changed
- `skills/[skill-directory]/SKILL.md` — [what changed]
- `SKILL-INDEX.md` — [new index entry or "no change"]

## Frontmatter
- name: [must exactly match directory]
- description: [trigger-focused, includes use and do-not-use boundaries]

## Body sections
- Purpose
- When to use this
- When NOT to use this
- Process with concrete commands/examples
- Output format
- Hard rules
- Connects to
- Common failure modes

## Validation
- Existing skill overlap checked in `SKILL-INDEX.md`
- No client-specific or secret content included
- Trigger tested against at least one realistic prompt
```

## Common failure modes

**Duplicate skill creation** — Creating a new skill without first checking `SKILL-INDEX.md` leads to overlapping workflows and unclear routing. Improve the existing skill instead when the trigger already exists.

**Vague trigger description** — A description like "Use for frontend work" does not give Claude Code enough routing signal. The description must state the exact situation, inputs, boundaries, and when not to use the skill.

**Generic checklist content** — A skill body that only says "review, implement, test" is not a reusable workflow. Add concrete commands, files to inspect, output templates, approval gates, and real failure modes.

**No output contract** — Without an output template, future sessions produce inconsistent handoffs. Every skill needs a visible shape for the final answer or artifact it should produce.

## Hard rules

- Never create a skill for a one-time task — skills are for repeated patterns
- Never create a skill that duplicates an existing one — check SKILL-INDEX.md first
- Never put client-specific content in a reusable skill — use `client-boundary-guard`
- Always include valid YAML frontmatter before the title with `name` matching the directory and a trigger-focused `description`
- Always include "When to use this", "When NOT to use this", "Hard rules", "Connects to", and realistic failure modes
- Always test with a fresh session before considering it done
- Use mandatory language ("MUST", "NEVER") for critical behavioral rules — advisory language gets ignored under pressure

## Connects to

- `pattern-learner` — identifies patterns worth formalizing
- `workflow-evaluator` — evaluates whether existing skills are working
- `project-control-plane` — for updating CLAUDE.md to reference new skills
