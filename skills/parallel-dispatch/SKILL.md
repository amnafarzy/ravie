---
name: parallel-dispatch
description: >-
  Plan and split work into parallel worktree sessions. Use whenever the user wants to work on
  multiple tasks at once, mentions parallel sessions, worktrees, "split this up", "dispatch", or
  lists several independent tasks for one work session.
---

# parallel-dispatch

Plan-then-spawn discipline: turn a task list into at most 3 scoped worktree sessions, each launched by the human with a tight dispatch brief. Mechanics of worktrees themselves (what carries over, cleanup, hard rules) live in `docs/parallel.md` — read it before dispatching; do not restate it here or to the user.

## Purpose

Parallel sessions are only faster when they never touch the same files and never have to rediscover their scope. This skill front-loads that thinking into one dispatcher session, then hands each worktree a brief so it starts working instead of exploring — that's the token-efficiency core.

## Process

### 1. Collect the task list

From the user's message, `docs/STATE.md` "Now" section, or Linear (if connected). Confirm the list with the user before splitting.

### 2. Dependency check — the gate

For each pair of tasks, identify which files/modules each will touch (search now, in this session). Tasks with overlapping file surface MUST be serialized into the same session, never parallelized — overlapping worktrees produce merge conflicts, not speed. When unsure whether surfaces overlap, treat them as overlapping.

### 3. Cap parallelism

At most 3 parallel sessions (4 absolute max, only with explicit user push). More cannot be supervised, and unsupervised output is not high-end output. Extra tasks queue for the next round.

### 4. Emit one DISPATCH BRIEF per parallel task

The user pastes it as the first message in that worktree session. Max 12 lines:

```markdown
# Dispatch brief — [kebab-task-name]

Task: [one sentence]
Scope: [exact files/directories in play]
Do not touch: [every file another parallel session owns, plus docs/STATE.md]
Definition of done: [tests/checks that must pass]; deliverable = a PR
Linear: [issue ID, or "none"]
Your scope is this brief plus what loads at startup; don't explore beyond it.
```

### 5. Print launch commands

One per task, with its brief:

```bash
claude -w <kebab-task-name>   # new terminal tab; paste the matching brief as the first message
```

Remind the user to spot-check `/context` in the first worktree session for `Plugin (ravie)` entries — the missing-skills failure mode and its fix are in `docs/parallel.md`.

### 6. Dispatcher responsibilities

This session (main checkout) owns `docs/STATE.md` updates and final merges. Merge the returning PRs sequentially, re-running checks after each merge — never batch-merge.

## Output format

Task table (task → session assignment → file surface), then the briefs, then the launch commands. Nothing else.

## Hard rules

- NEVER spawn sessions, run `claude -w`, or create worktrees yourself — this skill plans and emits briefs; the human launches terminals
- Never parallelize tasks with overlapping file surface; when unsure, serialize
- Never exceed 4 sessions; default cap is 3
- Every brief's "do not touch" list must include every file another parallel session owns
- STATE.md is edited only from this dispatcher session (see `docs/parallel.md` hard rules)

## Connects to

- `docs/parallel.md` — worktree mechanics, plugin-scope failure mode, cleanup, merge-first dependency
- `issue-to-pr` — each worktree session typically runs it against its brief
- `github-operator` — sequential merges of the returning PRs

## Common failure modes

**Optimistic splitting** — two tasks "probably" touch different files; nobody checked; both edit the same component and the merge burns the saved time. Do the dependency check with actual searches.

**Scope-free sessions** — a worktree session launched with just "fix the dashboard" spends its first 20k tokens rediscovering context the dispatcher already had. Always paste the brief.

**Fan-out pride** — six parallel sessions, zero supervision, six mediocre PRs. Three supervised beats six abandoned.
