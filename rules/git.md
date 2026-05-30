# Git conventions

These rules apply when working with git, branches, commits, and PRs.

## Branches
- Name: `[ISSUE-KEY]-[short-slug]` (e.g., `PROJ-42-dashboard-cards`)
- Always branch from up-to-date main: `git pull origin main` before creating
- Never commit directly to main

## Commits
- Prefix with Linear issue key: `PROJ-42: add dashboard card component`
- One clear purpose per commit
- Group by intent, not by file
- Keep under ~300 lines per commit when possible

## PRs
- Link to Linear issue in description
- Include: summary, acceptance criteria status, changes, testing, preview URL, risks, follow-ups
- Never merge without passing checks
- Never merge without human approval (Tier 4)

## Force push
- Only on your own unmerged branches
- Always use `--force-with-lease`
- Never on shared branches
- Requires explicit approval

## Worktrees (for parallel work)
- Create under `.worktrees/`: `git worktree add .worktrees/PROJ-42-feature`
- Run `pnpm install` and verify clean baseline in each worktree
- Clean up merged worktrees: `git worktree remove .worktrees/PROJ-42-feature`
