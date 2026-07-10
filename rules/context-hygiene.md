# Context hygiene

- **Zones:** 0-40% context = sharp; 40-60% usable; 60-80% degrading — do NOT start major implementation; 80%+ — commit immediately and clear.
- **Session discipline:** clear (don't compact) after each committed phase; `/clear` is the default boundary; compact at most once per session, only for difficult in-flight work. If auto-compaction fires, the session is compromised — commit and clear.
- **Preservation:** externalize durable intent into files (plans, PRDs, session notes), reference files by path instead of pasting, use subagents for heavy exploration.
- **Session bridging:** at session end write progress to `docs/plans/[feature]-progress.md`; next session starts "Read CLAUDE.md, then docs/plans/[feature]-progress.md. Continue from phase [X]."
- **Compaction survival:** preserve the modified-file list, test commands, migration decisions, current plan phase, next steps.
