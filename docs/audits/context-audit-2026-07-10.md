# Ravie Context Efficiency Audit — 2026-07-10

> **ACCEPTED BASELINE (going forward, 25 skills): 2,603 tokens always-loaded — measured 2026-07-10 after parallel-dispatch (+~90) was added; verification passes within +10% (≤ ~2,863). See docs/audits/verification-2026-07-10.md.**
> Prior 24-skill baseline: ~2,100–2,513 (self-measured 2,513 via claude -p; user-confirmed via interactive /context showing Skills 2.1k + Memory 35, no rules category, archived skills absent).

Measurement + triage only; no behavior changed. Token estimates use ~4 chars/token (scaffolding only — superseded by the /context measurement above). **Evidence caveat:** git history had 2 commits at audit time, so triage rests on overlap analysis, redundancy with native ability, and the repo's own docs — not commit frequency.

## 1. Inventory

**Skills** (frontmatter = ALWAYS LOADED; body = ON TRIGGER). Tokens shown as FM / body.

| Skill                       | Purpose                                          | FM tok | Body tok | Triage      |
| --------------------------- | ------------------------------------------------ | ------ | -------- | ----------- |
| issue-to-pr                 | Implement approved Linear issue end-to-end to PR | 79     | 2,213    | CORE        |
| debug-root-cause            | Diagnose failures before fixing                  | 80     | 2,157    | CORE        |
| code-review                 | Review AI/dev code changes before commit         | 98     | 1,613    | CORE        |
| requirements-griller        | Clarify vague requests into scope + criteria     | 105    | 2,842    | CORE        |
| supabase-guardian           | Safe Supabase schema/RLS/auth changes            | 84     | 1,310    | CORE        |
| linear-operator             | Create/triage/update Linear issues               | 83     | 2,181    | CORE        |
| github-operator             | Branch/commit/PR/CI conventions                  | 77     | 2,409    | CORE\*      |
| accessibility-ui            | Semantic HTML, keyboard, ARIA, contrast          | 101    | 753      | SITUATIONAL |
| animation-motion            | UI transition/animation polish                   | 86     | 850      | SITUATIONAL |
| automation-sre              | Cron/scheduled-job lifecycle and health          | 92     | 2,623    | SITUATIONAL |
| current-docs-guard          | Verify version-sensitive APIs before use         | 97     | 1,154    | SITUATIONAL |
| daily-brief                 | Cross-system morning status summary              | 87     | 1,862    | SITUATIONAL |
| decision-log-adr            | Record durable decisions as ADRs                 | 75     | 703      | SITUATIONAL |
| deploy-ready                | Pre-merge/production release checklist           | 94     | 1,221    | SITUATIONAL |
| design-system-ui            | Tokens, spacing, component variants              | 84     | 761      | SITUATIONAL |
| figma-lovable-handoff       | Figma/Lovable → implementation plan              | 84     | 2,522    | SITUATIONAL |
| growth-launch-pack          | Positioning, SEO, launch artifacts               | 85     | 2,109    | SITUATIONAL |
| idea-to-prd-tracer          | Idea → PRD → issues → tracer bullet              | 92     | 2,472    | SITUATIONAL |
| notion-brain                | Curate Notion as durable knowledge               | 77     | 2,321    | SITUATIONAL |
| observability-incident-loop | Production incident response loop                | 94     | 1,037    | SITUATIONAL |
| project-control-plane       | Onboard a repo to Claude Code/Ravie              | 67     | 870      | SITUATIONAL |
| responsive-ui               | Breakpoints, mobile-first layout bugs            | 82     | 686      | SITUATIONAL |
| skill-creator               | Author/improve a Ravie skill                     | 74     | 1,541    | SITUATIONAL |
| threejs-motion-performance  | Three.js/WebGL performance + fallbacks           | 77     | 796      | SITUATIONAL |
| ui-copy                     | Microcopy: buttons, errors, empty states         | 83     | 808      | SITUATIONAL |
| vercel-preview-qa           | Browser QA on Vercel preview URLs                | 96     | 807      | SITUATIONAL |
| router                      | Meta: pick which Ravie skill applies             | 71     | 1,336    | SPECULATIVE |
| permission-guardian         | Classify action risk tiers before acting         | 81     | 949      | SPECULATIVE |
| pattern-learner             | Mine sessions for reusable patterns              | 81     | 982      | SPECULATIVE |
| workflow-evaluator          | Audit whether Ravie itself is working            | 80     | 855      | SPECULATIVE |
| memory-import-sanitizer     | Sanitize ChatGPT/Notion exports for import       | 90     | 821      | SPECULATIVE |
| system-of-record-governance | Resolve Notion/Linear/GitHub conflicts           | 80     | 1,010    | SPECULATIVE |
| client-boundary-guard       | Prevent cross-client data/pattern leaks          | 80     | 886      | SPECULATIVE |

\*github-operator is used constantly but ~80% duplicates native git ability + `rules/git.md` + issue-to-pr steps.

**Subagents** (description ALWAYS LOADED; body ON TRIGGER): `agents/code-reviewer.md` (55/263 tok, duplicates code-review skill),
`research-scout.md` (52/176, duplicates built-in Explore agent), `security-auditor.md` (58/310), `ux-checker.md` (51/295).

**Rules** (empirically confirmed 2026-07-10: NOT auto-loaded — /context shows no rules category and only CLAUDE.md under Memory Files; read on demand as the repo docs claimed):
`context-hygiene.md` (~299 tok), `git.md` (~274), `karpathy-guidelines.md` (~365), `supabase.md` (~355), `ui.md` (~353). Total ~1,645.

**CLAUDE.md files**: `CLAUDE-TEMPLATE.md` installable portion ~1,263 tok (full file 2,093 incl. meta notes);
`quickstart/CLAUDE.md` ~496 tok (alternative minimal install).

**Hooks/scripts — ZERO TOKEN** (deterministic, never enter context): `hooks/hooks.json` (block env writes,
block main push, block secret reads, auto-format), `scripts/block-env-writes.sh`, `block-main-push.sh`,
`block-bash-secrets.sh`, `auto-format.sh`. ~7.4 KB on disk, 0 context cost. This is the right place for policy.

## 2. Fixed tax (ALWAYS LOADED)

| Component                              | Tokens     |
| -------------------------------------- | ---------- |
| 33 skill name+description frontmatters | ~2,793     |
| 4 subagent descriptions                | ~216       |
| 5 rule files                           | ~1,645     |
| CLAUDE.md (filled template)            | ~1,263     |
| **Total**                              | **~5,917** |

SETTLED: /context confirmed rules never auto-load, so the correct pre-cleanup baseline is the
**rules-excluded ~4,270 tokens (2.1% of 200k)**; the 5,917 with-rules figure was wrong accounting.
Skill frontmatter is the largest and least visible line item: descriptions average ~85 tokens each —
2–3× the length needed to trigger correctly.

## 3. Overlap flags (mis-trigger risk)

1. **router skill vs ROUTER.md vs SKILL-INDEX.md** — the same routing map maintained in 3 places; the skill itself is redundant with Claude's native description-based skill selection.
2. **code-review skill vs code-reviewer agent** — same job, two entries; either can fire.
3. **debug-root-cause vs observability-incident-loop** — both "something failed"; the local/production boundary is stated only in prose.
4. **requirements-griller vs idea-to-prd-tracer** — both catch new product ideas; "vague vs defined" boundary is judgment-based and each description references the other.
5. **github-operator vs issue-to-pr vs rules/git.md** — branch/commit/PR conventions live in all three.
6. **deploy-ready vs vercel-preview-qa** — both pre-release verification; distinguished only by preview-URL presence.
7. **accessibility-ui / responsive-ui / design-system-ui / ui-copy / animation-motion** — five skills that co-fire on any nontrivial UI task (~285 tok of always-loaded descriptions; each description name-drops the others).
8. **animation-motion vs threejs-motion-performance** — "motion" keyword collides; exclusion is prose-only.
9. **notion-brain vs memory-import-sanitizer vs system-of-record-governance** — knowledge-governance cluster with fuzzy boundaries.
10. **pattern-learner vs skill-creator vs workflow-evaluator** — three meta-skills for improving Ravie itself; a single pipeline split across three triggers.
11. **research-scout agent vs built-in Explore agent** — identical purpose.

## 4. Recommended actions (not executed)

**Archive (7 skills, saves ~563 always-loaded tok + removes mis-trigger surface):**

- `router` — native description-based routing already does this; keep ROUTER.md as human doc only.
- `permission-guardian` — convert to a short rule + rely on existing hooks (hooks already enforce the hard cases at zero token cost).
- `pattern-learner`, `workflow-evaluator` — merge salvageable steps into `skill-creator`; no usage evidence.
- `memory-import-sanitizer` — one-time migration task, not a recurring skill.
- `system-of-record-governance` — fold its one table (what lives where) into CLAUDE.md template.
- `client-boundary-guard` — speculative; no multi-client evidence in repo.

**Merge:**

- `accessibility-ui` + `responsive-ui` + `design-system-ui` + `ui-copy` → one `ui-quality` skill with sections (saves ~270 FM tok, ends the five-way trigger collision).
- `code-reviewer` agent → delete; keep the `code-review` skill. Delete `research-scout` (built-in Explore covers it).
- `github-operator` → demote to `rules/git.md` content; `issue-to-pr` already sequences the workflow.

**Rewrite descriptions (all 33, target ≤40 tok each, saves ~1,500 tok/session):** drop the
"Do not use for…" clauses (move to body's first line); disambiguate pairs 3, 4, 6, 8 above with
one objective trigger each (e.g. "production/main-branch failures only" on observability-incident-loop).

**CLAUDE.md template relocations:** cut "Available skills" section (duplicates frontmatter already in
context); move "Decisions Claude should respect" to decision-log-adr output; move "Current state and
known issues" to Linear (it churns); keep filling-out notes (lines 138+) out of installed copies —
already the design, worth an explicit warning. Collapse SKILL-INDEX.md into ROUTER.md (single human-facing index).

**Projected post-cleanup tax:** ~3,100 tokens (1.6% of 200k) — roughly half.

---

## 5. Execution results (2026-07-10, same day)

The recommendations above were executed on this branch. Measured with the same method (~4 chars/token):

| ALWAYS LOADED component          | Before                 | After                  | How                                                                                                                      |
| -------------------------------- | ---------------------- | ---------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| Skill frontmatter                | ~2,793 tok (33 skills) | ~1,817 tok (23 skills) | 7 speculative archived; 4 UI skills merged into `ui-quality`; every description rewritten as a ≤60-word trigger contract |
| Subagent descriptions            | ~216 tok (4 agents)    | ~109 tok (2 agents)    | code-reviewer + research-scout archived (duplicated code-review skill / built-in Explore)                                |
| Rule files                       | ~1,645 tok             | ~1,137 tok             | Compressed to bullet density; hook-enforced lines removed; ui.md deduped against ui-quality                              |
| CLAUDE.md (installable template) | ~1,263 tok             | ~398 tok               | Churning state → STATE.md pointer; skills section cut; conventions → rules; enforcement → hooks                          |
| **Total**                        | **~5,917 tok (3.0%)**  | **~3,462 tok (1.7%)**  | **−41.5%**                                                                                                               |

Verification notes:

- **Zero capability loss:** every archived skill/agent is restorable with one `git mv` (`archive/README.md`); merged UI content lives complete in `ui-quality`; all cross-references updated (no dangling skill names).
- **Archive is outside the scan path:** the CLI's discovery glob is `skills/*/SKILL.md` (one level, verified against the claude 2.1.206 bundle), which the original nested archive location did not match; the archive has since been relocated to repo-root `archive/`, outside skills/ and agents/ entirely, so no discovery mechanism, current or future, can load it.
- **Hooks byte-identical** to the pre-audit baseline (`git diff b8af7fd..HEAD -- hooks/ scripts/` is empty).
- **All 23 descriptions ≤60 words; all bodies ≤365 lines** (cap 500). SKILL-INDEX.md collapsed into ROUTER.md.

## 6. Empirical confirmation (2026-07-10, `claude --plugin-dir . -p "/context"`, CLI 2.1.206, model claude-sonnet-5)

/context settles the rules question: **rules never auto-load** (no rules category; Memory Files lists only CLAUDE.md, 35 tok). Measured Ravie footprint: 24 skill descriptions ~2,330 + agents 148 + CLAUDE.md 35 = **2,513 tok** — 1.26% of a 200k window, and a 41.1% reduction against the corrected ~4,270 rules-excluded baseline. Hooks confirmed at zero context cost.

Measured 2,513 differs from the projected ~3,554 by −29% (>15%), explained by two offsetting errors, not unaccounted loading:

- The projection wrongly counted 1,137 tok of rule files that /context proves never load (−1,137).
- The ~4 chars/token scaffold underestimates real tokenization by ~25-30%: measured descriptions average ~97 tok vs ~79 estimated (skills ~2,330 vs 1,817; agents 148 vs 109; CLAUDE.md 35 vs 22) (+~565).

Out of Ravie's control (not counted in the baseline): harness system prompt + tools ~41k tok, built-in/user skills ~2.0k, deferred tools ~17k. The 200k-window percentages are conventions — the measured session ran on a 967k window.
