---
name: github-operator
description: >-
  Use this skill when working with GitHub branches, commits, PRs, remotes, CI failures, releases, repo docs, Linear links, or source-of-truth code operations. Do not use for product requirements, Notion knowledge, Linear issue planning, or direct pushes to main/master.
---


# github-operator

Manage GitHub as the source of truth for code. Branches, commits, PRs, repo docs, releases — all governed by the same conventions.

## Purpose

Treat GitHub as authoritative for code, migrations, repo documentation, and automation source. Maintain clean Git hygiene. Connect PRs to Linear issues. Resist treating chat as more authoritative than committed files.

## When to use this

- Creating branches and naming them by Linear issue
- Reviewing repo state before changes
- Committing in coherent chunks
- Pushing branches and managing remotes
- Opening PRs with proper descriptions
- Linking PRs to Linear issues
- Reviewing PRs (yours or others')
- Triaging failed CI checks
- Maintaining repo docs (README, ADRs, runbooks)
- Generating release notes
- Cleaning stale branches

## When NOT to use this

- Do not use for product requirements, Notion knowledge, Linear issue planning, or direct pushes to main/master.

## Stack integration

**Reads from:**
- GitHub: repo state, branches, PRs, commits, checks, comments
- Local Git: working tree, staged/unstaged changes, branch state
- Linear: issues to link
- Notion: PRDs and decisions to reference
- Vercel: deployment status for previews
- Supabase: migrations and types files
- `CLAUDE.md`: branch naming, commit conventions, PR template

**Writes to:**
- Branches (locally and remotely)
- Commits
- PR descriptions and comments
- Repo docs (README, ADRs, .env.example, etc.)
- Release notes
- Local draft changes only until pushed

## Inputs required

- Repo (path or URL)
- Branch / issue key
- Work completed or to be completed
- Check status
- Linked Linear issue
- Linked Notion doc (if relevant)
- Write approval level

## Process

### 0. Read the Git rule reference first
Before branch, commit, push, PR, or release work, read `rules/git.md` and follow its branch, commit, and merge discipline.

### Inspecting state

Always start with current Git state:
```bash
git status
git branch --show-current
git log --oneline -10
git fetch
```

For PR work, also check:
- What's the base branch state?
- Have there been recent merges that might conflict?
- Is CI passing on `main`?

### Branch naming

Default: `[ISSUE-KEY]-[short-slug]`
- `PROJ-42-dashboard-cards`
- `SOR-89-fix-auth-redirect`

Override per `CLAUDE.md` if project specifies different.

For non-issue work:
- `chore/[what]`
- `docs/[what]`
- `spike/[what]`

### Branch creation

```bash
git checkout main
git pull origin main
git checkout -b PROJ-42-dashboard-cards
```

Never create branches off stale main. Always pull first.

### Commit conventions

Default: prefix with Linear issue key.
```
PROJ-42: tracer bullet for dashboard cards
PROJ-42: wire up Supabase query
PROJ-42: handle empty state
```

For multi-issue or non-issue work:
- Conventional commits: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`
- Group commits by intent, not by file

### Coherent commits

Each commit should:
- Have one clear purpose
- Compile and pass checks (or be marked WIP)
- Have a message that explains *why*, not just *what*
- Stay under ~300 lines of changes when possible

Bad: "Updates" / "WIP" / "Fix stuff"
Good: "PROJ-42: extract StatCard variants from prototype" / "Fix race condition in checkout submit by awaiting promise resolution"

### Pre-push checks

Always run before pushing:
```bash
pnpm typecheck
pnpm lint
pnpm test
pnpm build  # if quick
```

If any fail: fix them, don't ignore. Don't `--no-verify` your way past hooks.

### Pushing

```bash
git push -u origin PROJ-42-dashboard-cards
```

For first push, set upstream. After that, just `git push`.

### Force-pushing

Avoid. Only acceptable on:
- Your own unmerged branch (not shared)
- After explicit approval
- Never on shared/main branches

```bash
git push --force-with-lease  # safer than --force
```

### Pull request creation

PR description template (override per `CLAUDE.md`):
```markdown
## Linear: [PROJ-42](https://linear.app/...)

## Summary
[1-2 sentences on what shipped]

## Acceptance criteria (from Linear)
- [x] Criterion 1
- [x] Criterion 2
- [ ] Criterion 3 — see follow-up notes

## Changes
- [Bullet list of meaningful changes]

## Testing
- [What tests were added or run]
- [Manual verification done]

## Preview
- URL: [Vercel preview link]
- Tested on: [browsers/devices]

## Risks
- [Anything reviewer should pay attention to]

## Follow-ups
- [Linear keys for any deferred items]
```

### PR review (your own or others')

Checklist:
- [ ] Summary matches what code actually does
- [ ] Acceptance criteria match Linear issue
- [ ] All checks pass
- [ ] Preview deploys cleanly (run `vercel-preview-qa`)
- [ ] No commented-out code, console.logs, or debug artifacts
- [ ] No commits with secrets / API keys / credentials
- [ ] No `// TODO` without a Linear issue linked
- [ ] Tests added for non-trivial logic
- [ ] No new dependencies without justification
- [ ] Migrations reviewed via `supabase-guardian` if DB touched
- [ ] Repo docs updated if commands/behavior changed

### Merging

This is **always** Tier 4 — explicit approval each time, naming the exact PR.

When approved:
- Use squash merge by default (clean history)
- Use merge commit for major features (preserved history)
- Use rebase only for small chains (advanced)

Default per `CLAUDE.md`. Don't decide unilaterally.

### Repo docs

Update when behavior changes:
- `README.md` — setup commands, getting started, deployment
- `.env.example` — new env vars (without values)
- `docs/adr/[date]-[title].md` — architectural decisions
- `CHANGELOG.md` — if maintained

Don't duplicate Notion content in repo docs. Repo docs are technical / setup. Product context lives in Notion.

### Release notes

When tagging a release:
```bash
gh release create v1.2.0 --generate-notes
```

Then edit to:
- Group by feature / fix / chore
- Link Linear issues
- Highlight breaking changes
- Note migration steps if any

### Stale branch cleanup

Weekly check:
- List branches with no PR, >14 days old
- List merged branches that weren't deleted
- Delete merged branches (locally and remotely):
  ```bash
  git fetch -p
  git branch -vv | grep ': gone' | awk '{print $1}' | xargs git branch -D
  ```
- Comment on stale unmerged branches asking if still active

## Output format

```markdown
# GitHub operation — [action]

## Repo state
- Branch: [name]
- Base: [main]
- Behind/ahead: [counts]
- Working tree: [clean / dirty]

## Changes (if applicable)
- Files changed: [count]
- Lines added/removed: [+/-]
- Commits: [count]

## Checks
- typecheck: [status]
- lint: [status]
- tests: [status]
- build: [status]

## Action taken or proposed
[What this skill did or wants to do]

## PR (if applicable)
- Title: [...]
- Body: [Notion-ready markdown]
- Linked: Linear [LIN-XX], Notion [if relevant]
- Preview: [Vercel URL]

## Approvals needed
- [ ] Push branch
- [ ] Open PR
- [ ] Specific approval list
```

## Approval gates

**Tier 1 (read-only)** — inspecting repos, branches, PRs, checks: always allowed.

**Tier 2 (draft)** — local edits, drafts, plan files: always allowed.

**Tier 3 — needs approval:**
- Pushing branches
- Opening PRs
- Updating PR comments and body
- Updating repo docs
- Creating tags

**Tier 4 — needs explicit approval naming exact target:**
- Merging PRs
- Force-pushing (any branch)
- Deleting branches
- Changing branch protection
- Creating / modifying GitHub Actions secrets
- Publishing packages
- Creating releases
- History rewrites (rebase, amend, filter-branch)

**Tier 5 — always blocked:**
- Committing secrets
- Falsifying check status
- Bypassing pre-commit hooks
- Pushing directly to main (use PRs)

## Hard rules

- Never commit secrets or `.env` files
- Never merge with failing checks
- Never force-push without approval (and never on shared branches)
- Never make huge mixed commits — split by intent
- Never leave issue-based PRs unlinked from Linear
- Never treat chat conclusions as authoritative over what's in the repo
- Never skip pre-push checks
- Never bypass hooks with `--no-verify`
- Never push to main directly
- Never delete branches without confirming they're merged

## Connects to

- `issue-to-pr` — the daily driver that calls this for branch / PR work
- `linear-operator` — for issue linking and status updates
- `current-docs-guard` — invoked before changing version-sensitive code
- `supabase-guardian` — invoked when migrations are part of the PR
- `vercel-preview-qa` — invoked after push, before PR finalized
- `deploy-ready` — invoked before merging
- `permission-guardian` — for tier escalation requests
- `decision-log-adr` — when decisions get committed as ADRs

## Common failure modes

**Pushing without baseline checks** — CI fails, you scramble to fix in public. Always run checks locally first.

**Mixed commits** — One commit with a bug fix, a refactor, and a typo correction. Reviewer can't tell what's what. Split intent.

**Stale main** — Branch from week-old main, conflicts everywhere. Always `git pull origin main` before branching.

**Bypassing hooks** — `--no-verify` to skip pre-commit. Don't. Hooks exist to catch issues before push.

**Lost work via force-push** — Force-pushing over teammate's commits = deleted work. Use `--force-with-lease` and only on your own branches.

**Untracked branch sprawl** — 30 branches, half abandoned. Weekly cleanup. Delete merged branches.

**PR body is empty** — "see commits" is not a PR description. Reviewers need context, summary, risks, testing notes.

**Linear/PR drift** — PR merged but Linear still In Progress. Update Linear immediately, not after lunch.
