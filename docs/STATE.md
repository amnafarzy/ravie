# Project State
> Rolling state file. Hard cap 40 lines. Newest first. Prune on every update.

## Now (max 5 bullets — in-flight work, one line each: what + where + next step)
- Context-efficiency overhaul done on branch `claude/ravie-context-audit-vlfzjp` (8 commits) — next: open PR and merge to main
- Cross-session memory (docs/STATE.md + skills/session-handoff/ + root CLAUDE.md pointer) just added — next: include in the same PR

## Blocked (max 3 bullets — what's stuck and on what)
- (none)

## Recent decisions (max 8 bullets — decision + one-clause rationale, newest first, delete oldest when full)
- Accepted baseline = 2,513 tok always-loaded, measured via /context — rules confirmed on-demand, 4-chars/token retired
- Archive relocated to repo-root archive/ — outside skills/ and agents/, immune to any future discovery glob
- Continuity system = docs/STATE.md (≤40 lines) + one CLAUDE.md pointer line; skill body loads on demand
- Rule files compressed to bullets; enforcement lives in hooks, never restated in prose (rules/*.md)
- CLAUDE.md templates carry every-session content only; churning state lives here, not there
- SKILL-INDEX.md collapsed into ROUTER.md — one human-facing routing doc
- Skill descriptions are ≤60-word trigger contracts; no when-to-use content in bodies (skill-creator enforces)
- accessibility-ui/responsive-ui/design-system-ui/ui-copy merged into ui-quality — they co-fired on any UI task

## Don't touch (max 4 bullets — fragile areas and why)
- hooks/ and scripts/ — byte-identical to v1.1.0 baseline is a verified guarantee; change only deliberately
- Skill frontmatter wrapping — hyphen-breaking is disabled so skill names never split across lines
- CHANGELOG.md and FIXES-APPLIED.md — historical records; old counts in them are intentional
