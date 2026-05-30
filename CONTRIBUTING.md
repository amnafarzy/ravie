# Contributing to Ravie

Thanks for wanting to contribute. This project is better when it reflects real workflows from real builders.


## Skill quality requirements

Every new or changed skill must meet this bar before a PR is ready:

- **Valid YAML frontmatter:** `name` must exactly match the directory name, and `description` must be trigger-focused. Start with "Use when..." or "Use this skill when..." and include both when to use and when not to use the skill.
- **Explicit routing boundaries:** Include "When to use this" and "When NOT to use this" in the body, even if the frontmatter already summarizes them.
- **Concrete process:** Include at least one real command, file path, query, checklist item, or example that another agent can execute or inspect. Avoid generic bullets only.
- **Real output template:** Provide a markdown template or structured output shape the skill should produce.
- **Failure modes:** Include at least three specific failure modes from realistic use, not generic warnings.
- **Mandatory language for critical rules:** Use MUST, NEVER, ALWAYS, or STOP for non-negotiable safety and quality rules.
- **Connects to section:** List the systems, rule files, agents, and related skills this skill reads from, writes to, or hands off to.
- **No personal data:** Do not include personal names, project names, client names, secrets, issue keys, or client-specific content. Use placeholders such as `[Project A]`, `[Client]`, or `PROJ-42`.

A good skill should make a future session more reliable than a generic prompt. If the workflow is one-off, keep it in chat or docs instead of creating a skill.

## The easiest contribution: add a skill

If you've built a repeatable workflow that saves you time, turn it into a skill and submit a PR.

### How to create a skill

1. Create a new directory: `.claude/skills/[skill-name]/SKILL.md`
2. Follow this structure:

```markdown
---
name: [skill-name-matches-directory]
description: Use this skill when [specific trigger conditions]. Do not use when [specific non-triggers or safer alternate skills].
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
- [What this is NOT for]

## Process
### 1. [First step]
[Concrete instructions — commands, examples, not vague bullets]

### 2. [Second step]
...

## Output format
[Template showing what the skill produces]

## Approval gates
[What requires human approval before the agent acts]

## Hard rules
- [Non-negotiable constraint 1]
- [Non-negotiable constraint 2]

## Connects to
- [Other skills this uses, references, or feeds into]

## Common failure modes
- [Specific failure mode 1 from real usage]
- [Specific failure mode 2 from real usage]
- [Specific failure mode 3 from real usage]
```

3. Add the skill to `SKILL-INDEX.md` in the appropriate group
4. Submit a PR with a description of when you use this skill and why it exists


## Other contributions

### Add a rule
Create a new file in `.claude/rules/[domain].md`. Rules are domain-specific reference files. They do not auto-load; the relevant skill or project `CLAUDE.md` must explicitly tell Claude when to read them.

### Add a hook
Create a script in `.claude/scripts/` and add the configuration to `.claude/settings.json`. Hooks are for local actions that must be blocked or checked by the runtime — not general guidance.

### Improve an existing skill
If a skill produces bad output or misses a common case, submit a PR improving it. Include in the PR description: what went wrong, what the fix addresses, and ideally an example of the improved behavior.

### Add a stack preset
Create a `quickstart/[stack-name]/CLAUDE.md` with pre-filled values for a specific stack (e.g., Rails + Heroku + Jira, Django + AWS + GitHub Issues). This helps people get started faster.

## PR guidelines

- One skill per PR (don't bundle unrelated changes)
- Include a description of when you use this workflow and why it exists
- If modifying an existing skill, explain what was wrong and how your change fixes it
- Keep PRs focused — don't refactor adjacent files

## Code of conduct

This project follows the [Contributor Covenant](https://www.contributor-covenant.org/version/2/1/code_of_conduct/). Be respectful, constructive, and assume good intent.

## Questions?

Open a [Discussion](https://github.com/amnafarzy/ravie/discussions) on GitHub. Issues are for bugs and specific improvement requests.
