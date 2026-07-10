---
name: session-handoff
description: >-
  Update docs/STATE.md with current session state. Use whenever the user says "wrap up", "handoff",
  "end session", "save state", "update state", or signals they are stopping work — even mid-task.
---

# session-handoff

Maintains `docs/STATE.md`, the 40-line rolling dashboard a fresh session reads before anything else. It is a dashboard, not a journal — history lives in git, not here.

## Process

1. Read `docs/STATE.md`. If missing, create it from the template below.
2. Update ONLY the sections that changed this session. Newest entries first.
3. Enforce every cap by deleting the oldest or stale entries: Now ≤5, Blocked ≤3, Recent decisions ≤8, Don't touch ≤4, whole file ≤40 lines. Never exceed a cap to "keep something important" — if it's durable, it belongs in an ADR or the code, not here.
4. One-line bullets only. No paragraphs, no code blocks, no transcripts.
5. Every "Now" bullet MUST name a file path or issue ID plus the next step, so the next session can act without searching.
6. Finish by printing the diff (`git diff docs/STATE.md`, or full content if new) and ask the user to confirm before treating the handoff as done.

## Template (for a missing STATE.md)

```markdown
# Project State
> Rolling state file. Hard cap 40 lines. Newest first. Prune on every update.

## Now (max 5 bullets — in-flight work, one line each: what + where + next step)

## Blocked (max 3 bullets — what's stuck and on what)

## Recent decisions (max 8 bullets — decision + one-clause rationale, newest first, delete oldest when full)

## Don't touch (max 4 bullets — fragile areas and why)
```

## Hard rules

- Never let STATE.md exceed 40 lines — it is read at the start of every session and must stay cheap
- Never write history or explanations into it — prune, don't accumulate
