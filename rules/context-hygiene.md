# Context hygiene

Rules for managing the context window to maintain agent quality.

## Thresholds
- Sharp zone: 0-40% context used
- Usable zone: 40-60%
- Degrading zone: 60-80% — do NOT start new major implementation here
- Dumb zone: 80%+ — commit immediately and clear

## Session discipline
- Clear context after each committed phase (don't compact)
- Use /clear, not /compact, as the default session boundary
- Compact at most once per session, and only for difficult in-flight work
- If auto-compaction fires, the session is compromised — commit and clear immediately

## Context preservation
- Externalize durable intent into files (plans, PRDs, session notes) not chat
- Reference files by path instead of pasting content into chat
- Use subagents for heavy exploration — keeps main context clean

## Session bridging (for multi-session work)
At end of session: write progress to `docs/plans/[feature]-progress.md`
At start of next session: "Read CLAUDE.md, then read docs/plans/[feature]-progress.md. Continue from phase [X]."

## Compaction survival
If compaction is unavoidable, preserve: modified file list, test commands, migration decisions, current plan phase, next steps.
