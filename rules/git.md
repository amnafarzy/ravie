# Git conventions

- **Branches:** `[ISSUE-KEY]-[short-slug]` (e.g. `PROJ-42-dashboard-cards`), created from up-to-date main (`git pull origin main` first).
- **Commits:** prefix with the Linear key (`PROJ-42: add dashboard card`), one purpose per commit, grouped by intent not by file, ~300 lines max when possible.
- **PRs:** link the Linear issue; include summary, acceptance-criteria status, changes, testing, preview URL, risks, follow-ups. Never merge without passing checks and human approval (Tier 4).
- **Force push:** own unmerged branches only, always `--force-with-lease`, never shared branches, explicit approval required.
- **Worktrees:** manual ones go under `.worktrees/` (`git worktree add .worktrees/PROJ-42-feature`); run the project's install step in each, if it has one, and verify a clean baseline; remove after merge. `claude -w` worktrees are separate — Claude Code manages them under `.claude/worktrees/` (see `docs/parallel.md` in the Ravie repo).

Pushes to main/master (direct, forced, mirrored, or bulk) are blocked by the `block-main-push` hook.
