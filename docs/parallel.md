# Parallel sessions with worktrees (this repo)

## Start one

New terminal tab → `claude -w <task-name>`. The worktree appears at `.claude/worktrees/<task-name>/` on branch `worktree-<task-name>` (both gitignored). Repeat with different names for more parallel sessions.

## What carries over, and why

- **All tracked files**: CLAUDE.md, `rules/`, `hooks/` + `scripts/`, skill sources — a worktree is a full checkout.
- **Ravie's skills and agents** — but only because the plugin is installed at **USER scope** on this machine (see STATE.md decisions / README Quick start). The failure mode: a project-scope install is recorded against the literal repo path, so worktrees (different paths) silently load **zero** skills — verified on CLI 2.1.206 (0 skills at project scope vs all of them at user scope — 24 at test time, 25 now), even though the docs say v2.1.200+ should load project-scope plugins in same-repo worktrees. Trust the check, not the assumption: if `/context` in a worktree shows no `Plugin (ravie)` entries, run `claude plugin install ravie@ravie --scope user`.
- **Gitignored files matched by `.worktreeinclude`**: `.claude/settings.local.json` only. Copy mechanism verified 2026-07-10; `.worktreeinclude` is read from the main checkout at creation time. On a fresh clone that file doesn't exist yet (it's gitignored) — Claude Code creates it as permission approvals accrue, and worktrees made before then simply have nothing to copy, which is harmless.

## Plugin freshness

Sessions load a cached snapshot pinned to a commit SHA, refreshed at startup (`autoUpdate: true` in `.claude/settings.json`). Skill edits mid-session need `/reload-plugins`; edits land in other sessions at their next startup. The repo is the source of truth; the running copy is a snapshot. The plugin cache is machine-global — a marketplace update from one session affects all sessions at their next startup.

## What does NOT carry over

- Untracked files not matched by `.worktreeinclude`.
- Installed dependencies — **not applicable here**: this repo has no package.json, lockfile, Makefile, or containers (verified 2026-07-10). A fresh worktree needs **no install step**; it is ready immediately.

## Shared-resource collisions

**None found.** This repo runs no dev server, binds no ports, and has no local database — there is nothing for two parallel sessions to fight over (checked: no package.json / docker-compose / Makefile / env files). The only shared mutable state is `docs/STATE.md` and the machine-global plugin cache, both covered by the rules below. (Because no collision risks exist, CLAUDE.md carries no pointer to this file — by design.)

## Cleanup

- Exit with no changes → worktree auto-removed (named sessions get a prompt).
- Exit with changes → Claude asks keep-or-remove.
- `claude -p --worktree` runs are **never** auto-cleaned and stay locked — `git worktree unlock <path>` then `git worktree remove <path>`.
- Weekly: `git worktree list`; remove strays with `git worktree remove <path>` (add `--force` if dirty).

## Hard rules

1. **`docs/STATE.md` is only edited from the main checkout, never a worktree** — parallel edits to a 40-line file guarantee conflicts, and worktree branches merge later (or never).
2. **No parallel worktree use until `claude/ravie-context-audit-vlfzjp` is merged to main.** `claude --worktree` branches from `origin/HEAD` — verified: a test worktree today started at `b8af7fd`, the pre-upgrade baseline, with no CLAUDE.md and none of the current config. This dependency lives in STATE.md's Now section; remove it there when the merge lands.
