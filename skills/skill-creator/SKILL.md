---
name: skill-creator
description: >-
  Use this whenever creating or improving a Ravie skill — the user says "make this a skill", "we
  keep repeating this", or a workflow or correction has recurred enough to codify. Also owns
  evaluating existing skills after real usage. NOT for one-off tasks.
---

# skill-creator

Create new skills from observed patterns. When you find yourself re-explaining the same workflow 3+ times, it should become a skill.

## Purpose

Turn a repeated pattern, workflow, or correction into a valid SKILL.md file with YAML frontmatter so future Claude Code sessions can match it from the description. Also used to improve existing skills based on real friction.

## Process

### Frontmatter requirements

Every skill must begin with YAML frontmatter. The `description` is the ENTIRE routing surface: what the skill does plus the exact contexts and phrases that should fire it, max 60 words, phrased assertively (Claude under-triggers skills), with explicit NOT-boundaries naming the neighboring skill. When-to-use info never goes in the body.

Example:

```yaml
---
name: issue-to-pr
description: Use this whenever the user wants to implement an approved Linear issue that has acceptance criteria — "build PROJ-42", "implement this issue", "pick up the next ticket". Covers the full loop: branch, tracer bullet, checks, preview, PR. The daily driver for feature work.
---
```

### 1. Identify the trigger
What situation should activate this skill? The answer belongs first in YAML frontmatter `description` because Claude Code uses that description for skill selection. Be specific:
- Bad: "when working on frontend code"
- Good: "when creating a new React component that needs to connect to Supabase data"

### 2. Extract the process
From your past sessions and repeated corrections, document what the correct process actually is. Include:
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
description: Use this whenever [specific trigger contexts and phrases]. NOT for [explicit non-goal] — use [neighboring skill]. (Max 60 words; the whole trigger contract lives here.)
---

# [skill-name]

[One sentence: what this skill does.]

## Purpose
[2-3 sentences on why this exists.]

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

### 5. Register in ROUTER.md
Add the new skill to the index with its group, depth tier, and purpose.

## Output format

When creating or revising a skill, produce a complete skill package plan and the updated `SKILL.md` content:

```markdown
# Skill package: [skill-directory]

## Files changed
- `skills/[skill-directory]/SKILL.md` — [what changed]
- `ROUTER.md` — [new index entry or "no change"]

## Frontmatter
- name: [must exactly match directory]
- description: [the FULL trigger contract, max 60 words: what it does + exact phrases/contexts that fire it, phrased assertively ("Use this whenever…"), with explicit NOT-boundaries naming the neighboring skill. The description is paid in every session — every word counts. No when-to-use content in the body.]

## Body sections
- Purpose
- Process with concrete commands/examples
- Output format
- Hard rules
- Connects to
- Common failure modes

## Validation
- Existing skill overlap checked in `ROUTER.md`
- No client-specific or secret content included
- Trigger tested against at least one realistic prompt
```

## Common failure modes

**Duplicate skill creation** — Creating a new skill without first checking `ROUTER.md` leads to overlapping workflows and unclear routing. Improve the existing skill instead when the trigger already exists.

**Vague trigger description** — A description like "Use for frontend work" does not give Claude Code enough routing signal. The description must state the exact situation, inputs, boundaries, and when not to use the skill.

**Generic checklist content** — A skill body that only says "review, implement, test" is not a reusable workflow. Add concrete commands, files to inspect, output templates, approval gates, and real failure modes.

**No output contract** — Without an output template, future sessions produce inconsistent handoffs. Every skill needs a visible shape for the final answer or artifact it should produce.

## Hard rules

- Never create a skill for a one-time task — skills are for repeated patterns
- Never create a skill that duplicates an existing one — check ROUTER.md first
- Never put client-specific content in a reusable skill
- Always include valid YAML frontmatter before the title with `name` matching the directory and a trigger-contract `description` (max 60 words — all when-to-use info lives here, never in the body)
- Always include "Hard rules", "Connects to", and realistic failure modes; keep the body under 500 lines (use a references/ subfolder beyond that)
- Never let two skill descriptions overlap in trigger conditions — merge the skills or add an explicit "NOT for X — use [other]" boundary
- Always test with a fresh session before considering it done
- Use mandatory language ("MUST", "NEVER") for critical behavioral rules — advisory language gets ignored under pressure

## Connects to

- This skill also owns pattern-mining and skill-health evaluation (deeper checklists archived in `archive/skills/pattern-learner/` and `archive/skills/workflow-evaluator/`)
- `project-control-plane` — for updating CLAUDE.md to reference new skills
