# Start here

Read this once, 15 minutes. After this you'll know what every file does, how the layers connect, and what to do first.

---

## What is Ravie?

It's a set of instruction files that teach your AI coding agent (Claude Code) how *you* work — your stack, your tools, your rules — so you stop re-explaining yourself every session.

Right now when you open Claude Code, the agent starts without your project operating context. This package is the fix: add the entry-point file, skills, rules, and hooks to a project so the agent has your stack, conventions, and workflows available before doing work.

It is **not** a course, a tutorial, or something you "complete." It's infrastructure. Install once, runs in the background, improves from use.

---

## The 4-layer architecture

```
Layer 1 — Plugins (external, maintained by others)
  ├── Superpowers        → brainstorm/plan/TDD/subagent discipline
  └── Karpathy Guidelines → don't assume, minimum code, surgical changes

Layer 2 — Rules + Hooks (enforcement)
  ├── rules/             → domain reference files (git, supabase, ui)
  ├── scripts/           → deterministic hook scripts (formatting, secrets, protected pushes)
  └── hooks/hooks.json    → plugin hook configuration

Layer 3 — Project context (you write this per project)
  ├── CLAUDE.md          → stack, commands, systems, priorities
  └── CLAUDE.local.md    → personal WIP notes, gitignored

Layer 4 — Skills + Agents (invoked on demand)
  ├── skills/             → 33 specific workflows
  └── agents/            → 4 focused subagents
```

**Layer 1 handles process** — how the agent approaches any work (brainstorm before building, test before shipping, verify before claiming done). Maintained externally, you don't edit these.

**Layer 2 handles domain references plus enforcement** — skills and CLAUDE.md instruct Claude to read the relevant rule file when working in that domain. Hooks are deterministic scripts for covered Claude Code tool calls, such as formatting files, blocking `.env` writes, blocking Bash secret access, and blocking direct/bulk main/master pushes.

**Layer 3 handles context** — what the agent knows about THIS project. Stack, commands, linked systems, active priorities. You write this once per project, ~100 lines.

**Layer 4 handles execution** — 33 active skills for specific tasks (issue-to-pr, debug-root-cause, figma-handoff, etc.) plus 4 subagents that run in isolated context for research, review, security, and UX checks.

---

## How a real session looks

You open Claude Code in a project repo. Behind the scenes:

1. **Superpowers plugin** activates → enforces brainstorm-before-code discipline
2. **Karpathy guidelines** load → enforce don't-assume, minimum-code, surgical-changes
3. **CLAUDE.md** loads → agent knows the project's stack, commands, conventions
4. **Rule references** stay available → relevant skills tell Claude to read the matching `rules/*.md` file before acting
5. **Hooks** are active in Claude Code → auto-format on file edits, block .env writes, block Bash secret access, block main/master pushes
6. You say: *"Build the dashboard from PROJ-42"*
7. **Superpowers** kicks in → brainstorms the design with you before any code
8. **Skill matching** → Claude matches your request to `issue-to-pr` based on its YAML description
9. **Permission model** → flags as Tier 3 (needs approval before merge)
10. **issue-to-pr** runs → pulls Linear, checks Notion, creates branch, builds tracer, opens PR
11. **Code reviewer agent** spawns → reviews in separate context, reports back
12. Approval gate fires → Claude stops and asks before merge

**You did not read any skills yourself.** Claude matched the request to a skill from its YAML description, then followed that skill. Your job: write CLAUDE.md once, keep the descriptions accurate, and tune from friction.

---

## What to do, in order

### Step 1: Install the two plugins in Claude Code
```
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace

/plugin marketplace add forrestchang/andrej-karpathy-skills
/plugin install andrej-karpathy-skills@karpathy-skills
```

Restart Claude Code after installing.

### Step 2: Read MASTER-GUIDE.md
20 minutes. The architecture deep-dive and principles. Read once so you understand *why* each piece exists.

### Step 3: Create your ravie GitHub repo
```bash
mkdir ~/code/ravie
cd ~/code/ravie
# Copy everything from this package
rsync -a /path/to/this/package/ .
# This preserves hidden directories such as `.claude` and `.github`.
git init && git add . && git commit -m "Initial Ravie"
gh repo create ravie --public --source=. --remote=origin --push
```

### Step 4: Pick one project to install on first
Pick one of your active projects. See `INSTALLATION.md` for the actual commands.

### Step 5: Write CLAUDE.md for that project
Use `CLAUDE-TEMPLATE.md`. 30-45 minutes. Most important file in the whole system.

### Step 6: Run one workflow end-to-end
Pick a real Linear issue. In Claude Code:
> "Follow the issue-to-pr workflow for PROJ-123"

Watch what happens. Note friction. That's what you'll improve.

### Step 7: Tune from real use
After that first run, the skill or rule that caused friction is what you edit. Don't pre-plan. Iterate from real sessions.

---

## Files in this package, ranked by importance

| File | Read it? | Why |
|---|---|---|
| `START-HERE.md` | Yes, now | You're reading it |
| `MASTER-GUIDE.md` | Yes, today | The actual learning |
| `CLAUDE-TEMPLATE.md` | Yes, when installing | The entry point you write per project |
| `INSTALLATION.md` | Yes, when installing | Setup commands |
| `CHEATSHEET.md` | Skim, bookmark | Daily reference |
| `PERSONAL-PREFERENCES.md` | Skim, edit | Your defaults |
| `docs/context-hygiene.md` | Read once | The "smart zone" — critical for session quality |
| `docs/superpowers-setup.md` | Read when installing | Plugin integration |
| `docs/hooks-guide.md` | Skim once | How enforcement works |
| `ROUTER.md` | Skim | Human-readable routing reference |
| `PERMISSION-MODEL.md` | Skim | Approval tiers and safety boundaries |
| `rules/*.md` | Don't read upfront | Reference files; relevant skills point to them |
| `skills/*/SKILL.md` | Don't read upfront | Active skill files. Read individually when relevant. |
| `agents/*.md` | Skim once | 4 focused subagents |

---

## When to throw things out

After 2 weeks of real use, audit:
- Which skills did you actually invoke? (Probably 5-8)
- Where did you correct the agent more than twice? → update the relevant SKILL.md
- What did you keep re-explaining? → add to CLAUDE.md
- Which rules got violated despite being in CLAUDE.md? → convert to a hook

A 10-skill system you use beats a 33-skill system you don't. Delete what's not helping.

Now go read MASTER-GUIDE.md.
