# Master guide

The principles behind the architecture, structured so you understand *why* the system works the way it does — not just what files do what.

Read this once, properly. ~20 minutes. After this, the rest of the package will make sense and you'll know what to keep, change, or throw out.

---

## Table of contents

1. [The core insight](#the-core-insight)
2. [The 6 principles worth keeping](#the-6-principles-worth-keeping)
3. [What most approaches get wrong](#what-most-approaches-get-wrong)
4. [How this applies to your stack specifically](#how-this-applies-to-your-stack-specifically)
5. [The architecture: why these specific files](#the-architecture-why-these-specific-files)
6. [Tiered usage: what to use now, later, never](#tiered-usage)
7. [The 3 workflows to build first](#the-3-workflows-to-build-first)
8. [Gaps most approaches don't cover](#gaps-most-approaches-dont-cover)
9. [Discard list (and reasoning)](#discard-list)

---

## The core insight

The same insight appears across every serious AI-assisted development approach:

> **The win is not "better prompts" — it's giving AI a persistent operating context so you stop re-explaining yourself.**

Every approach is a different attempt to solve the same problem: AI is powerful per-session, but useless across sessions because it forgets everything. Each approach's "system" is just a way to externalize context so the next session inherits it.

- Engineering-focused approaches externalize engineering context (tracer bullets, current docs, planning before coding)
- Design-focused approaches externalize UI/design conventions (tokens, components, accessibility, motion)
- Knowledge management approaches externalize knowledge (memory, decisions, project state)
- Role-based approaches externalize role-specific instructions (specialists per business function)

Once you see this, you stop following any one approach and instead build your own version that uses *your* tools (Notion/Linear/GitHub) instead of theirs (local files / Obsidian / generic agents).

That's what this package is.

---

## The 6 principles worth keeping

### 1. The systems-of-record triangle

Every approach either struggles with or ignores this question: when AI generates output, where does it live?

The answer is the same regardless of approach: pick three durable systems, let AI write to them, never let AI create a fourth.

**Default stack mapping:**
- **Notion** = durable knowledge (PRDs, decisions, runbooks, briefs)
- **Linear** = execution (tasks, status, blockers, acceptance criteria)
- **GitHub** = source truth (code, migrations, repo docs, ADRs)

Plus the runtime layers: Supabase (data), Vercel (deploys), VPS/automation server (automation).

The common mistake across all approaches: building a parallel system. Some want local memory files, others want planning docs in the repo, others push personas over system rules. None of these scale because they create a 4th source of truth that competes with the real ones.

**Rule:** if AI generates something, it goes in Notion, Linear, or GitHub — or it gets thrown away. No exceptions.

### 2. Tracer bullets > big plans

A principle that appears across all serious AI-assisted development approaches.

Don't ask AI to build the whole feature. Ask it to build the smallest end-to-end vertical slice that proves the design works:

```
Idea → smallest path through schema → API → UI → preview → review → expand
```

Why this matters: AI can produce 500 lines of plausible code that compiles and looks right but doesn't actually work end-to-end. A tracer bullet finds the broken assumption in 50 lines instead of 500.

This becomes the `idea-to-prd-tracer` and `issue-to-pr` skills.

### 3. Current docs guard

The simplest, highest-leverage rule in the entire package.

**Rule:** before AI changes anything version-sensitive (Supabase API, Next.js, auth flows, package versions, MCP servers), it checks the current official docs first.

This rule prevents a common failure mode: AI confidently writing broken code from outdated training data. The skill is `current-docs-guard`. Claude should select `current-docs-guard` from its YAML description whenever a request touches version-sensitive systems.

### 4. Approval gates per risk tier

A principle formalized in the permission model.

The principle: AI should freely read, freely draft, but only write to external systems with explicit approval — and the approval level depends on what's at stake.

- Reading anything → fine
- Drafting code, issues, PRs locally → fine
- Pushing branches, creating Linear issues, updating Notion → approve once per session
- Merging PRs, deploying prod, changing secrets → approve every single time, naming the exact target

This is what `PERMISSION-MODEL.md` formalizes. Without it, AI eventually does something destructive you didn't sanction. With it, you have a clear contract on what's autonomous vs gated.

### 5. Skills > prompts > chats

A principle from skill-based development approaches.

When you find yourself typing the same kind of prompt twice, it should become a skill. When you find yourself building skills that overlap, they should merge or one should call the other.

Three signs something should become a skill:
- You've explained the same thing 3+ times across sessions
- The output has a consistent structure you want enforced
- Multiple steps need to happen in a specific order

Things that should NOT become skills:
- One-time exploration
- Anything specific to a single project (put it in CLAUDE.md instead)
- Vague "be better at X" requests (sharpen the request, not the skill)

### 6. Pattern-learner: the system improves itself

The knowledge compounding principle, refined from research into AI memory systems.

After each completed feature/bug/incident, run a quick review:
- What worked?
- What did Claude need re-correcting on?
- What context was missing?
- What should change in CLAUDE.md or a skill?

This becomes the `pattern-learner` skill. Run it weekly. Apply changes to skills/CLAUDE.md. The system gets smarter without any pre-planning.

---

## What most approaches get wrong

So you don't repeat their mistakes:

### "Install everything to start"
Every approach tries to give you a complete system on day one. Don't. Install the minimum, use it for a week, then expand based on actual friction. A 5-skill system you use beats a 33-skill system you don't.

### "Memory should be local files"
A common flaw in knowledge management approaches. Local Markdown for memory has zero retrieval, zero search, zero collaboration, and dies on machine swap. Notion is right for this.

### "Personas / specialists"
Some approaches push the "you are X persona" pattern. This is anti-engineering. Skills should describe processes, not characters. The persona pattern is what makes large specialist collections feel like useless prompts.

### "More agents = better"
Some approaches lean on agent swarms or multi-agent orchestration. Skip this for solo work. One Claude Code session with 5 well-defined skills outperforms 5 agents arguing with each other.

### "Local is enough"
Some approaches treat the local repo as sufficient. It's not — the work eventually needs to go into Linear and Notion. The package fixes this by making system-of-record the default routing rule.

### "Generic 'do this better' prompts"
Some design-focused approaches lean on this. "Make it look better." "Improve the UX." This produces nothing useful. The fix is having specific skills (`design-system-ui`, `accessibility-ui`, `responsive-ui`, `ui-copy`) that have actual checklists.

### "Stack defaults that don't match yours"
Many guides and templates default to Prisma, Better Auth, SendGrid, Railway, Render. None of these are wrong individually but they're wrong for *you*. The defaults are Supabase + Vercel + GitHub + Linear + Notion. The package strips all the alt-stack assumptions.

---

## How this applies to your stack specifically

Ravie is for solo founders or designer-developers who often move between product, design, implementation, and operations. Those modes need slightly different treatment:

**Solo founder mode:**
- Focus on speed of iteration
- Tracer bullets > big plans (because pivot risk is high)
- Daily brief is genuinely useful (you have to context-switch)
- Decision log matters because future-you will second-guess past-you
- Pattern-learner weekly is critical because you're the only QA

**Designer-developer mode:**
- `figma-lovable-handoff` is the most-used skill
- `design-system-ui`, `accessibility-ui`, `responsive-ui`, `animation-motion`, `threejs-motion-performance` matter more than for non-designers
- Visual QA via `vercel-preview-qa` matters more (most engineers skip the visual layer)

**Client-work mode:**
- `client-boundary-guard` is critical — never let client work pollute reusable skills
- Per-client CLAUDE.md, never shared
- `memory-import-sanitizer` matters when migrating old client conversations
- Strict permission gates on anything customer-facing

**Across all modes:**
- your automation server or VPS is your background runtime — `automation-sre` governs it
- Three.js or WebGL work on product or marketing surfaces → `threejs-motion-performance` covers performance, fallbacks, and reduced motion
- Lovable for rapid prototyping → never gets copied to production unprocessed; `figma-lovable-handoff` enforces this

---

## The architecture: why these specific files

Once you understand the layers, the file structure stops being arbitrary.

```
ravie/
├── START-HERE.md         ← onboarding (you, once)
├── MASTER-GUIDE.md       ← the learning (you, once)
├── CHEATSHEET.md         ← daily reference (you, recurring)
├── INSTALLATION.md       ← setup (you, when installing)
├── CLAUDE-TEMPLATE.md    ← per-project entry point (you, per project)
│
├── ROUTER.md             ← classification logic (Claude reads)
├── PERMISSION-MODEL.md   ← safety contract (Claude reads)
├── WORKFLOWS.md          ← multi-step runbooks (Claude reads)
│
├── SKILL-INDEX.md        ← catalog (you reference, Claude can read)
├── DISCARD-LIST.md       ← what was stripped and why (you, occasional)
│
└── skills/
    ├── [orchestration skills — router, project-control-plane, governance]
    ├── [planning skills — requirements-griller, idea-to-prd-tracer, decision-log-adr]
    ├── [implementation skills — issue-to-pr, debug-root-cause, deploy-ready]
    ├── [stack-specific guards — supabase-guardian, vercel-preview-qa, current-docs-guard]
    ├── [system operators — linear-operator, github-operator, notion-brain]
    ├── [UI/design skills — design-system-ui, accessibility-ui, responsive-ui, animation-motion, ui-copy, figma-lovable-handoff, threejs-motion-performance]
    ├── [ops skills — automation-sre, daily-brief, observability-incident-loop, permission-guardian]
    └── [meta skills — pattern-learner, workflow-evaluator, memory-import-sanitizer, client-boundary-guard]
```

You don't memorize this. You understand the categories so when you need a skill, you know roughly where to look.

---

## Tiered usage

### Tier 1 — use immediately

**Files:**
- `START-HERE.md`, `MASTER-GUIDE.md`, `CHEATSHEET.md` (you)
- `CLAUDE.md` (template + your filled-in version per project)
- `ROUTER.md`, `PERMISSION-MODEL.md`

**Skills:**
- `issue-to-pr` (your daily driver)
- `debug-root-cause` (when things break)
- `requirements-griller` (when ideas are vague)
- `idea-to-prd-tracer` (when starting features)
- `decision-log-adr` (when making durable choices)
- `daily-brief` (Monday mornings)

**Workflows:**
- `idea → execution`
- `issue → pr`
- `weekly review`

### Tier 2 — use when the situation calls for it

**Skills:**
- All the UI/design skills — used during frontend work
- `supabase-guardian`, `vercel-preview-qa`, `deploy-ready`, `current-docs-guard` — guard skills Claude should select when relevant
- `figma-lovable-handoff` — every time you start from a design or prototype
- `automation-sre` — when working on the VPS
- `notion-brain`, `linear-operator`, `github-operator` — when explicitly working with those systems
- `pattern-learner` — weekly review
- `system-of-record-governance` — when you find duplicate info

### Tier 3 — situational, may stay unused

**Skills:**
- `threejs-motion-performance` — only when doing WebGL work
- `client-boundary-guard` — only when in agency mode
- `memory-import-sanitizer` — only when importing old conversations
- `workflow-evaluator` — only when auditing the system itself
- `observability-incident-loop` — only when production incidents start happening
- `ui-copy` — only when polish phase

These exist for completeness. Don't force usage. They activate when the situation arises.

---

## The 3 workflows to build first

Don't try to build all 13 workflows in WORKFLOWS.md. Build these three first, get them working, then expand.

### 1. Idea → Execution
**Use case:** You have an idea, vague spec, or rough Figma. Output: PRD in Notion, Linear issues, GitHub plan, first tracer bullet.

**Skills involved:** `requirements-griller` → `idea-to-prd-tracer` → `figma-lovable-handoff` (if applicable) → `linear-operator` → `github-operator`

**Why first:** Without this, every project starts from scratch. With this, every project starts with structured plans and acceptance criteria.

### 2. Issue → PR (the daily driver)
**Use case:** A Linear issue is approved. Output: a merged PR.

**Skills involved:** `issue-to-pr` orchestrates → `current-docs-guard` (if needed) → `supabase-guardian` (if DB changes) → `vercel-preview-qa` → `github-operator` → `linear-operator`

**Why first:** This is what you'll do hundreds of times. Everything else is supporting infrastructure for this.

### 3. Weekly review
**Use case:** End of week. Output: what shipped, what stalled, what to improve, updates to skills.

**Skills involved:** `pattern-learner` orchestrates → `linear-operator` (closed issues) → `github-operator` (merged PRs) → `notion-brain` (decisions)

**Why first:** This is what makes the system improve. Without it, skills stay the same forever and you don't notice friction patterns.

The other 10 workflows in WORKFLOWS.md are reference material. Build them when you actually need them.

---

## Gaps most approaches don't cover

These exist as skills in this package because most approaches don't address them:

- **VPS/automation operations** — `automation-sre`. Most approaches don't cover VPS automation.
- **Notion ↔ Linear ↔ GitHub governance** — `system-of-record-governance`. Courses pick one and ignore the others.
- **Multi-model routing (Claude Code vs ChatGPT)** — partially addressed in ROUTER.md.
- **Permission tiers per system** — `permission-guardian` + PERMISSION-MODEL.md. Courses are vague about safety.
- **Lovable to production handoff** — `figma-lovable-handoff` covers this. Lovable is newer and most guides predate it.
- **Three.js production discipline** — `threejs-motion-performance`. Courses treat this as exotic.
- **Agency client boundaries** — `client-boundary-guard`. Most approaches ignore this.
- **Workflow evaluation** — `workflow-evaluator`. Courses don't teach how to know if a skill is working.
- **Memory privacy on import** — `memory-import-sanitizer`. Important if you ever migrate old conversations into Notion.

---

## Discard list

What was stripped from common approaches, and why:

| Stripped | Source | Reason |
|---|---|---|
| Beginner setup walkthroughs | Common | You're past this |
| Toy projects (LinkPreview, ColorDrop, etc.) | Common | Salvage patterns only |
| Local file Kanban / JSON task board | Common | Linear is the system |
| Local memory folder as primary brain | Common | Notion is durable knowledge |
| Wholesale agent kit install | Common | Sprawl; salvage gates only |
| Persona-style agents (70 specialists) | Common | Workflow-oriented skills replace these |
| All-Opus / expensive-model defaults | Common | Model choice should be explicit |
| Broad write permissions | Multiple | Violates permission model |
| API keys in prompts | Multiple | Unsafe; use env vars |
| Generated demo media | Common | Not operational |
| Mac metadata, build artifacts | All ZIPs | Noise |
| Old install recipes / hardcoded API claims | Multiple | Version-sensitive; current-docs-guard handles |
| Unverified MCP install instructions | Multiple | Permission-sensitive |
| MCP enthusiasm | Multiple | MCP is access, not intelligence |
| Duplicate debug/deploy/design prompts | Multiple | Collapsed into specific skills |
| Growth kit as daily OS | Common | Belongs in launch mode only |
| Course-branded naming (specialist names, etc.) | All | Renamed to neutral skills |
| Anything that creates a 4th source of truth | All | Use Notion/Linear/GitHub or discard |
| Promotional content (bootcamp upsells, links) | Common | Trash |

---

## How to know this is working (after 2 weeks)

Signs the system is helping:
- You stop re-explaining your stack at the start of sessions
- Claude generates code that matches your conventions without correction
- Linear tickets, GitHub PRs, and Notion docs stay in sync without manual reconciliation
- You catch bugs in tracer bullets instead of after 500 lines

Signs you need to tune:
- You correct Claude on the same thing repeatedly → update CLAUDE.md
- A skill produces output that's slightly off every time → edit that SKILL.md
- You skip the system entirely for fast tasks → skill activation is too heavy, simplify
- You install the system and never look at it → start over with just CLAUDE.md and 5 skills

The goal is leverage, not completeness. If after 2 weeks you've used 10 skills heavily and never touched the other 20, that's success — those 10 are now optimized for your work.
