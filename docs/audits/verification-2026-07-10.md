# Integration verification — 2026-07-10 (context diet + handoff + install + worktrees + parallel-dispatch)

| #   | Check                      | Result                                                                                                                                                                                                                                                                                                                                                                          |
| --- | -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | Token math (plugin loaded) | **PASS** — 2,603 tok = 25 skills ~2,420 + 2 agents 148 + CLAUDE.md 35, via `claude --plugin-dir . -p "/context"`. Within accepted range adjusted for parallel-dispatch (~90 measured): 2,190–2,603, +10% ceiling ~2,863.                                                                                                                                                        |
| 2   | Trigger test (dry)         | **PASS** — 9/9 messages match exactly one skill (below).                                                                                                                                                                                                                                                                                                                        |
| 3   | Continuity                 | **PASS** — CLAUDE.md is exactly 1 pointer line (no collision line was ever warranted); STATE.md 30/40 lines; every Now bullet names a branch or path; merge-before-worktrees dependency present.                                                                                                                                                                                |
| 4   | Parallel readiness         | **FAIL → FIXED** — .worktreeinclude patterns matched zero real files: `CLAUDE.local.md` removed (never existed in this repo — was a guess), `.claude/settings.local.json` seeded empty (Claude Code materializes it as permission approvals accrue; verified gitignored). docs/parallel.md: user-scope failure mode ✓, /reload-plugins ✓, collisions explicitly "None found" ✓. |
| 5   | Install                    | **PASS** — `.claude/settings.json` committed (registers directory marketplace + enables ravie@ravie); README Quick start carries the one-time `--scope user` command.                                                                                                                                                                                                           |
| 6   | Consistency                | **PASS** — worktree mechanics live only in docs/parallel.md (skills reference it by pointer); zero lingering "24 skills" counts outside historical docs.                                                                                                                                                                                                                        |

## Trigger test detail (message → only matching skill)

- "ok let's wrap up for today" → session-handoff
- "I've got three features to build, split them up" → parallel-dispatch (several tasks + "split"; issue-to-pr needs ONE named approved issue — boundary holds)
- "start on the auth issue from Linear" → issue-to-pr (implementation; linear-operator explicitly excludes it)
- "the build is failing and I don't know why" → debug-root-cause (pre-ship; observability-incident-loop is production-only)
- "I think it's done, review it before I commit" → code-review
- "can we add some kind of sharing feature?" → requirements-griller (vague, no criteria; idea-to-prd-tracer requires a validated idea)
- "add a last_login column to the users table" → supabase-guardian
- "make a ticket for that bug we just found" → linear-operator
- "clean up stale branches and check why CI failed on the release PR" → github-operator (standalone ops, no issue named)

## Going-forward baseline

**2,603 tokens always-loaded at 25 skills** (measured 2026-07-10, CLI 2.1.206). Recorded in the ACCEPTED BASELINE line of context-audit-2026-07-10.md.

## Monthly smoke test

Launch `claude` at the repo root, run `/context`, confirm: 25 `Plugin (ravie)` skill entries, 2 `ravie:` agents, Memory files ≈ 35 tok (CLAUDE.md only — no rules category, no archived skills).
