# Project State

> Rolling state file. Hard cap 40 lines. Newest first. Prune on every update.

## Now (max 5 bullets — in-flight work, one line each: what + where + next step)

- Merge `claude/ravie-context-audit-vlfzjp` → main before any worktree use — claude --worktree branches from origin/HEAD, so unmerged worktrees run the pre-upgrade config
- Context-efficiency overhaul done on branch `claude/ravie-context-audit-vlfzjp` (13 commits) — next: open PR and merge to main
- Cross-session memory (docs/STATE.md + skills/session-handoff/ + root CLAUDE.md pointer) added — next: include in the same PR

## Blocked (max 3 bullets — what's stuck and on what)

- (none)

## Recent decisions (max 8 bullets — decision + one-clause rationale, newest first, delete oldest when full)

- Ravie installs user-scope from the repo's own directory marketplace (.claude/settings.json) — project scope is path-keyed and silently skips worktrees
- Accepted ~92-token always-loaded cost for continuity system (CLAUDE.md pointer + session-handoff frontmatter); final baseline recorded in audit doc
- Accepted baseline = ~2,100–2,513 tok always-loaded, twice-measured via /context — rules confirmed on-demand, 4-chars/token retired
- Archive relocated to repo-root archive/ to remove CLI-version dependency
- Continuity system = docs/STATE.md (≤40 lines) + one CLAUDE.md pointer line; skill body loads on demand
- Rule files compressed to bullets; enforcement lives in hooks, never restated in prose (rules/\*.md)
- CLAUDE.md templates carry every-session content only; churning state lives here, not there
- SKILL-INDEX.md collapsed into ROUTER.md — one human-facing routing doc

## Don't touch (max 4 bullets — fragile areas and why)

- hooks/ and scripts/ — byte-identical to v1.1.0 baseline is a verified guarantee; change only deliberately
- Skill frontmatter wrapping — hyphen-breaking is disabled so skill names never split across lines
- CHANGELOG.md and FIXES-APPLIED.md — historical records; old counts in them are intentional
