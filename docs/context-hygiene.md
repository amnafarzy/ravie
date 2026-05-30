# Context hygiene

The single most impactful practice for AI-assisted development. If you read one doc beyond START-HERE, make it this one.

---

## The problem

AI agents have context windows — a fixed amount of text they can "see" at once. As a session fills with file reads, tool outputs, plans, code, and conversation, reasoning quality degrades *before* the hard limit. The agent doesn't tell you it's getting dumber. It just starts making worse decisions, subtly.

## The smart zone

Treat **60% of the context window as your practical ceiling**. Not the hard limit — 60%.

- **0-40%**: Sharp zone. Agent reasons well, follows instructions, catches nuance.
- **40-60%**: Still usable. Good for targeted fixes in an existing session.
- **60-80%**: Degrading. Instructions from earlier in the session start getting lost. New implementation should not start here.
- **80%+**: Dumb zone. Auto-compaction fires around 83%. Quality is poor. Agent may ignore rules, miss obvious bugs, or produce overbuilt code.

**A fresh session with 20k tokens of system prompt + CLAUDE.md starts at ~10%.** You have roughly 50% of useful runway before quality drops.

## The rules

### 1. Clear after each committed phase
Don't compact. Clear. The difference:
- `/compact` — lossy compression. Creates "sediment" where compressed layers of prior context accumulate. Details get lost. Repeated compaction makes this worse.
- `/clear` — clean slate. The code you committed is durable in git. The plan/PRD is a file on disk. Start fresh with only what's needed.

**The pattern:** Plan → Execute → Review → Fix → Commit → **Clear** → Next phase.

### 2. Never start major implementation above 40%
If you're at 45% context and want to start a new feature, don't. Clear first, then reference the plan file.

Check your context usage:
- Claude Code: `/context` or watch the status line

### 3. Externalize durable intent into files
Plans, PRDs, design decisions — these should be **files on disk**, not things you said in chat. When you clear context, chat history vanishes. Files survive.

Good session bridge pattern:
```
# End of session:
1. Commit all code
2. Write current state to docs/plans/[feature]-progress.md
3. /clear

# Start of next session:
"Read CLAUDE.md, then read docs/plans/feature-progress.md. Continue from phase 3."
```

### 4. Use subagents for exploration
When you need to read 15 files to understand a system, don't do it in the main context. Delegate:
> "Use a subagent to investigate how our auth system works. Report back a summary of the key patterns and files."

The subagent explores in its own context window. Main context gets a clean summary. This is the single most effective way to preserve context budget.

### 5. Prefer /clear over /compact
Use compaction **at most once** in a difficult long-running task. Never compact repeatedly as a habit. If you've compacted twice in one session, you should have cleared and restarted instead.

### 6. Keep CLAUDE.md under 100 lines
Every line of CLAUDE.md costs tokens on every single message. 200 lines of CLAUDE.md means ~3,000 tokens consumed before you type anything, every turn. Prune ruthlessly. Move domain-specific rules to `.claude/rules/` and have relevant skills or CLAUDE.md explicitly reference them when needed.

### 7. Reference files, don't paste content
Bad: pasting a 500-line Notion PRD into chat.
Good: `"Read docs/plans/dashboard-prd.md and implement phase 2."`

The file reference is ~20 tokens. Claude reads the file separately and the content enters context more efficiently.

## When to clear vs when to continue

| Situation | Action |
|---|---|
| Finished a coherent unit of work, committed | Clear |
| Hit a bug during implementation, context still healthy (<40%) | Continue, fix in place |
| Debugging ate 30% of context with false trails | Clear, start fresh with the bug description only |
| About to start a new feature | Clear |
| Mid-implementation, < 30% used | Continue |
| Mid-implementation, > 50% used | Commit what works, clear, continue from the committed state |
| Context auto-compacted | Session is compromised. Commit immediately, clear, restart |

## Compaction survival instructions

If you must compact (or auto-compaction fires), add this to your CLAUDE.md:

```markdown
## Compaction instructions
When summarizing this conversation:
- Preserve the full list of modified files
- Preserve all test commands and their results
- Preserve any migration decisions and rationale
- Preserve the current plan phase and next steps
- Summarize exploration attempts briefly, keeping conclusions
```

This tells Claude what to preserve during compaction. It won't save everything, but it protects the most critical details.

## The session bridge pattern (for multi-session work)

Large features span multiple sessions. The bridge:

1. **End of session N:** Write progress to a markdown file
   ```
   Commit code. Then write a session handoff note to docs/plans/[feature]-session-N.md including:
   - What was completed
   - What's next
   - Current blockers
   - Key decisions made
   - Files changed
   ```

2. **Start of session N+1:** 
   ```
   Read CLAUDE.md and docs/plans/[feature]-session-N.md. 
   We're continuing from where that left off. 
   Start with phase [X].
   ```

This is better than compaction because you control exactly what survives. The file is inspectable, editable, and version-controlled.
