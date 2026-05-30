# Cheatsheet

Daily reference. Bookmark this. Don't memorize.

---

## What to say to Claude for common tasks

### Starting work
> "Pull my Linear queue and tell me what to focus on today"
*(should route to daily-brief)*

> "What's the state of [project name]?"
*(should route to notion-brain + linear-operator + github-operator)*

### Building something
> "Convert this idea into a PRD and Linear issues: [paste idea]"
*(should route to idea-to-prd-tracer)*

> "I'm not sure what I want yet. Help me think through [thing]"
*(should route to requirements-griller)*

> "Build [Linear issue key] from start to PR"
*(should route to issue-to-pr — full workflow)*

> "Convert this Figma frame to code: [link]"
*(should route to figma-lovable-handoff)*

### Debugging
> "Something's broken. Help me find the root cause"
*(should route to debug-root-cause)*

> "Vercel preview is failing — investigate"
*(should route to debug-root-cause, then vercel-preview-qa when a preview URL is available)*

### Before merging
> "Run preview QA on this PR"
*(should route to vercel-preview-qa)*

> "This touches Supabase — review before I deploy"
*(should route to supabase-guardian)*

> "Run deploy-readiness check"
*(should route to deploy-ready)*

### Documenting decisions
> "Log this as a decision: [what you decided + why]"
*(should route to decision-log-adr)*

### Cleanup
> "Run weekly review"
*(should route to pattern-learner across the week's work)*

> "There's duplicate info between Notion and Linear — clean it up"
*(should route to system-of-record-governance)*

### Permissions check
> "I want to do [risky thing] — what tier is this?"
*(should route to permission-guardian)*

---

## Permission tiers, quick reference

| Tier | Examples | Default? |
|---|---|---|
| **1 — Read-only** | Read code, read Linear, summarize | Always allowed |
| **2 — Draft** | Draft code, draft issues, draft PRs (no push) | Default working mode |
| **3 — Controlled write** | Push branch, open PR, create Linear issue, update Notion | Approved per session or task |
| **4 — High-risk** | Merge PR, prod migration, secret rotation, deploy prod | Approved each time, with exact target |
| **5 — Critical** | Delete prod data, expose secrets, force-push shared branch | Always blocked |

Default for daily work: **Tier 2**. Upgrade to Tier 3 with "approved" or "go ahead." Tier 4 needs explicit "approved: [exact action] on [exact target]."

---

## What lives where (system of record)

| Artifact | Goes in |
|---|---|
| Product requirements (PRD) | Notion |
| Decisions and rationale | Notion (with link from GitHub if technical) |
| Active tasks and status | Linear |
| Code, migrations, schema | GitHub |
| Repo-specific docs (README, ADRs) | GitHub |
| Operating runbooks | Notion (linked from GitHub if automation) |
| Daily brief / weekly review | Notion |
| Decision logs | Notion |
| Automation source | GitHub |
| Automation schedules/logs | VPS / automation server |
| Database/auth state | Supabase |
| Frontend deploys | Vercel |

Rule: if you're not sure where it goes, ask `system-of-record-governance` skill.

---

## Workflow shortcuts

The 4 most-used workflows. Reference the skill name in your prompt and Claude should route to the matching SKILL.md.

**`idea-to-prd-tracer`** — Idea → PRD in Notion → Linear issues → GitHub plan → first tracer bullet
**`issue-to-pr`** — Linear issue → branch → tracer → preview → PR (the daily driver)
**`pattern-learner`** — Pull all the week's work → identify patterns → propose skill/rule improvements
**`daily-brief`** — Morning summary across all systems

---

## Skill index by problem

**"I have a vague idea"** → `requirements-griller`
**"I want to build a feature"** → `idea-to-prd-tracer` then `issue-to-pr`
**"I have a Figma file"** → `figma-lovable-handoff`
**"I have a Lovable prototype"** → `figma-lovable-handoff` (same skill)
**"Something broke"** → `debug-root-cause`
**"I touched the database"** → `supabase-guardian`
**"My preview looks weird"** → `vercel-preview-qa`
**"UI feels inconsistent"** → `design-system-ui`
**"Mobile is broken"** → `responsive-ui`
**"Keyboard nav doesn't work"** → `accessibility-ui`
**"Animations stutter"** → `animation-motion` or `threejs-motion-performance`
**"Copy is generic"** → `ui-copy`
**"I'm about to deploy"** → `deploy-ready`
**"I made an architectural decision"** → `decision-log-adr`
**"My VPS automation is failing"** → `automation-sre`
**"Repeated incidents — what's the pattern"** → `observability-incident-loop`
**"I want to install old AI conversation memory"** → `memory-import-sanitizer`
**"Working on client work, want to reuse a pattern"** → `client-boundary-guard`
**"Should this skill even exist?"** → `workflow-evaluator`
**"Notion and Linear disagree"** → `system-of-record-governance`
**"Onboarding new repo to Claude"** → `project-control-plane`

---

## Anti-patterns to avoid

- ❌ Asking Claude to "do everything" without a skill in mind → reference ROUTER.md
- ❌ Approving high-risk actions vaguely ("looks good" / "go ahead") → name the exact target
- ❌ Letting Claude create a parallel task tracker in Markdown → Linear is the system
- ❌ Letting Claude write durable docs in chat → push to Notion explicitly
- ❌ Starting implementation without acceptance criteria → run `requirements-griller` first
- ❌ Editing skills based on what *might* be useful → only edit based on actual friction
- ❌ Trying to install all 33 skills before using any → install, use one, then expand

---

## Common session opener templates

For maximum context with minimal explaining, start a session with one of these:

**For new feature work:**
> "I want to build [thing]. Use idea-to-prd-tracer. The repo is [name]. Active project context is in CLAUDE.md."

**For bug work:**
> "Bug: [describe]. Steps to reproduce: [steps]. Use debug-root-cause."

**For preview QA:**
> "PR [number] is up. Preview at [url]. Run vercel-preview-qa against acceptance criteria from [Linear key]."

**For end-of-day:**
> "Run pattern-learner for this week. Output to chat, don't write anything yet."

**For Monday:**
> "Run daily-brief. Active project is [name]. Output to chat."

---

## When the system feels wrong

After 2 weeks of real use, audit. Check:

1. Which skills did you actually invoke? (Probably 5-8)
2. Which skills did Claude Code select from their YAML descriptions?
3. Which skills did you never touch?
4. Where did you correct Claude mid-session more than twice?
5. What did you keep re-explaining?

The skills you never touched aren't useless — they're just not used yet. Leave them.
The corrections become updates to the relevant SKILL.md.
The re-explained things become updates to your project's CLAUDE.md.

Iterate the system from real use. Not from theory.
