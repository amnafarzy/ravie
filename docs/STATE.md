# Project State

> Rolling state file. Hard cap 40 lines. Newest first. Prune on every update.

## Now (max 5 bullets — in-flight work, one line each: what + where + next step)

- v1.1.1 maintenance pass — CI suite (.github/workflows/hooks-ci.yml, scripts/run-hook-tests.sh, scripts/check-counts.sh) landed and green; next: root file reorganization, TESTING.md path fix, attribution, then cut v1.1.1 release
- Grant application to Anthropic's Claude for OSS program — submitting week of 2026-07-27

## Blocked (max 3 bullets — what's stuck and on what)

- (none)

## Recent decisions (max 8 bullets — decision + one-clause rationale, newest first, delete oldest when full)

- CI defines "hook scripts" as scripts wired in hooks/hooks.json, not a filename glob — the registry is ground truth
- check-counts.sh locates the README claim sentence by content, not line number — header/badge edits can't silently break the check
- jq-missing/PATH test case deliberately excluded from CI — PATH=/tmp caused exit-127 breakage; see comment in run-hook-tests.sh
- Ravie installs user-scope from the repo's own directory marketplace (.claude/settings.json) — project scope is path-keyed and silently skips worktrees
- Accepted ~92-token always-loaded cost for continuity system (CLAUDE.md pointer + session-handoff frontmatter); final baseline recorded in audit doc
- Accepted baseline = ~2,100–2,513 tok always-loaded, twice-measured via /context — rules confirmed on-demand, 4-chars/token retired
- Archive relocated to repo-root archive/ to remove CLI-version dependency
- Continuity system = docs/STATE.md (≤40 lines) + one CLAUDE.md pointer line; skill body loads on demand

## Don't touch (max 4 bullets — fragile areas and why)

- hooks/hooks.json and the four hook scripts (block-env-writes, block-bash-secrets, block-main-push, auto-format) — byte-identical to v1.1.0 baseline is a verified guarantee; test/check scripts in scripts/ are not covered and may evolve
- Skill frontmatter wrapping — hyphen-breaking is disabled so skill names never split across lines
- CHANGELOG.md and FIXES-APPLIED.md — historical records; old counts in them are intentional
