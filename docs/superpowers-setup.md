# Superpowers plugin setup

How to install and use the Superpowers plugin alongside Ravie. Superpowers handles **workflow discipline** (brainstorm → plan → TDD → review). Ravie handles **project context** (your stack, systems, conventions). They complement each other.

---

## Install

In Claude Code:
```
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```

Restart Claude Code. You should see a session-start hook mentioning Superpowers.

## What Superpowers does automatically

Once installed, Superpowers activates skills automatically based on what you're doing:

1. **brainstorming** — Before writing code, it asks you questions to refine the idea. Presents the design in 200-300 word sections for sign-off. Saves a design doc.
2. **using-git-worktrees** — After design approval, creates an isolated workspace on a new branch.
3. **writing-plans** — Breaks work into bite-sized tasks (2-5 min each) with exact file paths, code context, and verification steps. Written for "an enthusiastic junior engineer with zero context and questionable taste."
4. **test-driven-development** — Enforces RED-GREEN-REFACTOR: write failing test → watch it fail → write minimal code → watch it pass → commit. Will delete code written before tests.
5. **subagent-driven-development** — Dispatches fresh subagent per task with two-stage review (spec compliance, then code quality).
6. **requesting-code-review** — Reviews against plan, reports by severity. Critical issues block.
7. **finishing-a-development-branch** — Verifies tests, offers merge/PR/keep/discard options.

## How Superpowers and Ravie interact

Superpowers owns the **process layer**:
- When to brainstorm vs implement
- How to write plans
- TDD discipline
- Subagent dispatch pattern
- Code review gates

Ravie owns the **context layer**:
- Your stack (Supabase, Vercel, Linear, etc.)
- Your system-of-record rules (Notion for knowledge, Linear for execution, GitHub for code)
- Your permission tiers
- Your stack-specific guards (supabase-guardian, vercel-preview-qa, etc.)
- Your design workflow (figma-lovable-handoff)

**They don't overlap.** Superpowers says "brainstorm before building." Ravie says "when building, check supabase-guardian for DB changes." Both run simultaneously.

## What to put in CLAUDE.md about Superpowers

Add this to your per-project CLAUDE.md:

```markdown
## Workflow discipline
Superpowers plugin is installed. It handles:
- Brainstorming and design refinement (don't skip this)
- Implementation planning (plans for zero-context engineers)
- TDD discipline (RED-GREEN-REFACTOR)
- Subagent dispatch for execution
- Code review gates

Do NOT re-implement these workflows in skills. Use Superpowers for process, Ravie skills for stack-specific context.
```

## What Superpowers doesn't cover (Ravie fills these)

- Stack-specific safety (supabase-guardian, vercel-preview-qa, deploy-ready)
- System-of-record governance (what goes in Notion vs Linear vs GitHub)
- Permission tiers beyond code review
- Design/UI workflow (figma-lovable-handoff, design-system-ui, etc.)
- Daily operations (daily-brief, automation-sre, observability)
- Growth/launch workflows
- Client boundary management

## Git worktrees (from Superpowers)

Superpowers auto-creates git worktrees for parallel work. This is especially useful for you running multiple projects in parallel. The manual pattern if you want to use it outside Superpowers:

```bash
cd your-project
mkdir -p .worktrees
git worktree add .worktrees/PROJ-42-dashboard
cd .worktrees/PROJ-42-dashboard
pnpm install
pnpm typecheck && pnpm test  # verify clean baseline
claude  # start session in the worktree
```

Each worktree is an isolated branch. Changes don't affect each other. When done, Superpowers' finishing skill handles merge/PR/cleanup.
