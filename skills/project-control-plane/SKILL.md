---
name: project-control-plane
description: >-
  Use this skill when onboarding a repo to Claude Code, creating or repairing CLAUDE.md, copying skills, configuring hooks, or verifying project setup. Do not use for ordinary feature work inside an already-onboarded repo.
---


# project-control-plane

Onboard a new repo to Claude Code. Creates the CLAUDE.md, copies skills, configures hooks, and verifies the setup works.

## Purpose

When starting a new project or adding Ravie to an existing repo, this skill walks through the full setup: create the context file, install skills, configure enforcement, and verify with a test task.

## When to use this

- New repo being set up for the first time
- Existing project getting Claude Code support
- Migrating from a different AI coding setup
- Resetting a project's CLAUDE.md after it drifted

## When NOT to use this

- Do not use for ordinary feature work inside an already-onboarded repo.

## Process

### 1. Gather project context
Read the repo to understand:
```bash
cat package.json          # stack, dependencies, scripts
ls -la                    # project structure
cat README.md             # what the project does
cat .env.example          # what env vars are needed
```

### 2. Create CLAUDE.md from template
Copy `CLAUDE-TEMPLATE.md` or `quickstart/CLAUDE.md` to the project root. Fill in:
- What the project is (1-2 sentences)
- Stack (from package.json + repo structure)
- Commands (from package.json scripts)
- Connected systems (GitHub URL, Linear workspace, Notion space, etc.)
- Active priorities (from Linear or current work)

### 3. Install skills
```bash
# Option A: Symlink (recommended — stays in sync with your ravie repo)
ln -s ~/code/ravie/.claude .claude

# Option B: Copy (independent, won't get updates)
cp -r ~/code/ravie/.claude .
```

### 4. Configure hooks
Review the project's settings (`hooks/hooks.json` for plugin installs, `.claude/settings.json` for direct-copy) — adjust allow/deny lists for this project's specific commands.

### 5. Create CLAUDE.local.md
```bash
touch CLAUDE.local.md
echo "CLAUDE.local.md" >> .gitignore
```
This is for personal WIP notes that shouldn't be committed.

### 6. Verify setup
Open Claude Code in the project and test:
```
> "Read CLAUDE.md and tell me what you understand about this project."
```
If it summarizes your stack correctly, the setup works.

Then test a real skill:
```
> "Run the daily-brief skill for this project."
```

## Output format

```markdown
# Project onboarded: [project name]

## Files created
- CLAUDE.md — [path]
- skills, agents, hooks/, scripts/, rules/ — [installed via plugin or direct copy]
- CLAUDE.local.md — [created, gitignored]

## Commands configured
- dev: [command]
- build: [command]
- test: [command]

## Hooks active
- [list active hooks]

## Verification
- Claude reads context: [pass/fail]
- Test skill invoked: [pass/fail]
```

## Hard rules

- Never create CLAUDE.md without reading the project first — it should reflect the real stack, not a template
- Always add CLAUDE.local.md to .gitignore
- Always verify the setup with a real test, not just file creation
- Keep CLAUDE.md under 100 lines — move domain-specific rules to `rules/`

## Connects to

- `decision-log-adr` — decisions made during setup should be logged
- `notion-brain` — for linking the project's Notion workspace
- `linear-operator` — for linking the Linear workspace

## Common failure modes

**CLAUDE.md too long** — 200+ lines of context. Agent spends tokens reading it every turn. Keep it under 100 lines, move the rest to rules files.

**Copy instead of symlink** — Skills get out of sync with the master repo. Symlink is better unless you need project-specific skill modifications.
