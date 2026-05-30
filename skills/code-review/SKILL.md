---
name: code-review
description: >-
  Use this skill when AI or a developer changed more than a trivial amount of code, touched module boundaries, created components/services/API routes, or modified auth, permissions, database, or RLS logic. Do not use for typo fixes, documentation-only edits, single-line config changes, or changes already reviewed through an equivalent code-review workflow.
---


# code-review

Review AI-generated code before it ships. Catches the failure modes that passing checks doesn't: wrong abstractions, magic strings, leaky component boundaries, unnecessary complexity, poor prop shapes.

## Purpose

Structured review of code changes — whether from AI generation or manual edits — before committing or opening a PR. This is the quality gate between "checks pass" and "code is actually good."

## When to use this

**You MUST use this skill when:**
- AI generated more than 50 lines of new code
- Changes touch multiple files or module boundaries
- New components, services, or API routes were created
- Database schema or RLS policies changed
- Auth or permission logic was modified

**Skip for:**
- Typo fixes, single-line changes, config tweaks
- Documentation-only changes
- Changes already reviewed by Superpowers' two-stage review

## When NOT to use this

- Do not use for typo fixes, documentation-only edits, single-line config changes, or changes already reviewed through an equivalent code-review workflow.

## Process

### 0. Read relevant rule references first
Before reviewing, read `rules/karpathy-guidelines.md`. Also read `rules/git.md` for Git/PR changes, `rules/supabase.md` for database/auth/RLS changes, and `rules/ui.md` for UI changes.

### 1. Spawn a code-reviewer subagent
This review should happen in a separate context to avoid confirmation bias. The main session that wrote the code should not also review it.

If subagents aren't available, do the review in the main session but explicitly switch mode: "Now review the changes as if you're seeing them for the first time."

### 2. Review against 8 dimensions

**Correctness**
- Does it satisfy the acceptance criteria from the Linear issue?
- Edge cases: empty data, null values, error states, concurrent access
- Does the happy path AND the unhappy path work?

**Abstractions**
- Are component/module boundaries in the right place?
- Is logic that belongs together split across files unnecessarily?
- Is logic that should be separate crammed into one place?
- Are there passing too many props (prop drilling) when a simpler pattern exists?
- Are domain objects passed as objects, not destructured into 5 individual fields?

**Simplicity**
- Could 200 lines be 50? If yes, it should be 50.
- Are there abstractions built for "flexibility" that only has one use case?
- Are there config objects or factory patterns where a simple function would do?
- Would a senior engineer say "this is overcomplicated"?

**Consistency**
- Does it match existing patterns in the repo?
- Naming conventions followed? (check CLAUDE.md conventions)
- Import style matches? (destructured, barrel files, etc.)
- Same patterns as similar existing features?

**Magic values**
- Hardcoded strings that should be constants?
- Hardcoded URLs or paths?
- Numbers without explanation (magic numbers)?
- Status strings that should be enums or shared constants?

**Security**
- Inputs validated (Zod or equivalent)?
- Auth/authorization checked on the server, not just client?
- No secrets in code or comments?
- RLS policies reviewed if Supabase tables touched?
- No `dangerouslySetInnerHTML` without sanitization?

**Testing**
- Are there tests for non-trivial logic?
- Do tests test behavior, not implementation details?
- Are edge cases covered?
- Can the test fail for the right reason? (not just "it renders")

**AI-specific antipatterns**
- Unnecessary try/catch wrapping that hides real errors
- Over-defensive null checks (`?.?.?.`) masking broken data flow
- Generated comments that restate the code ("// increment counter" above `counter++`)
- Overly generic variable names (`data`, `result`, `item`, `temp`)
- Imports or dependencies that aren't used
- Dead code left behind from a prior approach

### 3. Classify findings

- **Critical** — blocks merge. Security issue, data loss risk, logic error.
- **High** — should fix before merge. Wrong abstraction, missing validation, no error handling.
- **Medium** — fix soon. Inconsistent naming, suboptimal pattern, missing edge case test.
- **Low** — note for later. Style nit, minor naming preference, optional optimization.

### 4. Fix critical and high issues
Fix them now, in the current session. Don't defer critical issues.

For medium/low: create follow-up Linear issues if the fix would expand scope.

## Output format

```markdown
# Code review — [feature/PR]

## Summary
[1-2 sentences: overall quality assessment]

## Findings

### Critical
- [Finding]: [file:line] — [what's wrong and why it matters]

### High
- [Finding]: [file:line] — [what's wrong and suggested fix]

### Medium
- [Finding]: [file:line] — [what's wrong]

### Low
- [Finding]: [file:line] — [note]

## Verdict
[PASS / PASS WITH FIXES / BLOCK]

## Follow-ups
- [Linear issue for deferred items]
```

## Hard rules

- Never skip review because "checks pass" — checks catch syntax, not design
- Never review your own code in the same context that wrote it — use a subagent or fresh session
- Never let critical findings slide because "we'll fix it later"
- Never expand scope during review — create follow-up issues instead
- Never add complexity to fix a review finding when simplification is the real answer

## Connects to

- `issue-to-pr` — invoke between step 11 (full checks) and step 15 (open PR)
- `debug-root-cause` — when review reveals a bug
- `supabase-guardian` — when review reveals DB/RLS issues
- `pattern-learner` — feed recurring review findings into pattern library

## Common failure modes

**Reviewing in the same context that wrote the code** — Claude rationalizes its own choices instead of finding flaws. Always spawn the `code-reviewer` subagent or run review in a separate session with fresh context.

**Treating passing checks as sufficient** — typecheck/lint/test passing is necessary but not sufficient. The 8 review dimensions catch issues that automated checks can't: bad abstractions, security holes, AI antipatterns, magic values.

**Fixing medium findings by expanding scope** — review identifies a problem, "fix" introduces three more files. Keep fixes scoped to the original change. Add follow-up issues for adjacent improvements.

**Accepting "I'll fix it later" comments** — TODO/FIXME comments accumulate. If the review finds something worth fixing, fix it now or open a Linear issue with concrete acceptance criteria. Don't leave comments in code.
