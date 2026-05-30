---
name: debug-root-cause
description: >-
  Use this skill when tests, builds, previews, UI behavior, data flows, RLS, deployment, or automation jobs fail and the root cause is not yet known. Do not use for already-diagnosed fixes, feature implementation, or vague product questions that need requirements-griller first.
---


# debug-root-cause

Find the actual cause of a bug instead of patching symptoms. The skill that prevents the failure mode where AI keeps adding `try/catch` until the error message goes away.

## Purpose

Debug methodically: reproduce, gather evidence, isolate, hypothesize, test, fix at the smallest scope, verify, document.

## When to use this

- Tests fail
- Build fails
- Vercel preview is broken
- UI behavior is wrong
- Data is wrong or missing
- Supabase RLS blocks something it shouldn't (or allows what it shouldn't)
- VPS/automation server automation fails
- You catch yourself making 3+ random patches without understanding the cause

## When NOT to use this

- Do not use for already-diagnosed fixes, feature implementation, or vague product questions that need requirements-griller first.

## Stack integration

**Reads from:**
- GitHub: code, recent diffs, blame
- Linear: the bug issue, related context
- Vercel: build logs, runtime logs, deployment history
- Supabase: query logs, auth logs, RLS policy state, recent migrations
- Browser: console errors, network tab, source maps
- VPS/automation server: job logs, retry history
- Notion: any related runbook or prior incident notes

**Writes to:**
- The fix itself (in code)
- Regression test or check (if practical)
- PR notes describing root cause + fix
- Linear comments
- Notion runbook entry (only if the bug is durable / will recur)

## Inputs required

- **Expected behavior**: what should happen
- **Actual behavior**: what is happening
- **Reproduction steps**: minimal sequence to trigger
- **Error messages and logs**: actual text, not paraphrased
- **Recent changes**: what merged/deployed recently
- **Environment**: local / preview / production
- **Linear issue or PR** if one exists

## Process

### 0. Read context hygiene first
Before debugging, read `rules/context-hygiene.md` so the session stays evidence-based and does not drift into speculative patches.

### 1. Restate the problem precisely
"It's broken" is not a problem statement. Force precision:
- Expected: [exact expected behavior]
- Actual: [exact observed behavior]
- Frequency: [always / sometimes / once]
- When started: [if known]

If the user can't describe it precisely yet, the first job is to extract that — not to fix.

### 2. Reproduce it
You can't fix what you can't reproduce.
- Get the exact steps
- Run them in the same environment if possible (or document why you can't)
- If it's environment-specific (only prod), document conditions clearly

If you can't reproduce: stop guessing. Either gather more data or escalate to "needs more info" status.

### 3. Capture exact evidence
Don't paraphrase errors. Copy them verbatim:
- Full error message
- Stack trace
- Console output
- Network request/response
- Database query and response
- Relevant log lines with timestamps

### 4. Check what changed recently
Most bugs come from recent changes:
```bash
git log --since="3 days ago" --oneline
git diff [last-known-good-commit]..HEAD -- [suspect-area]
```
Also check:
- Recent Vercel deployments
- Recent Supabase migrations
- Recent package updates
- Recent CLAUDE.md changes (rare but possible)

### 5. Find the smallest failing path
Bisect:
- If it broke between commits, find the bad commit
- If it's a UI bug, find the component that's actually wrong (not just the visible symptom)
- If it's a data bug, trace from input → mutation → output and find where it diverges

### 6. Form a hypothesis
A hypothesis is "X causes Y because Z." Not "maybe it's the auth thing."

If you can't form a specific hypothesis, you don't have enough evidence yet. Go back to step 3.

### 7. Test the hypothesis
The cheapest test that would prove it right or wrong. Examples:
- Add a `console.log` and check what value flows through
- Run a SQL query directly against Supabase
- Comment out a line and see if behavior changes
- Revert the suspect commit and see if the bug disappears

### 8. Apply the smallest possible fix
Once you know the cause:
- Fix at the source, not downstream
- Don't refactor adjacent code
- Don't "improve" things while you're there
- Don't fix multiple bugs in one change

### 9. Verify the fix
- Run the original reproduction steps
- Run the full check suite (typecheck, lint, test, build)
- Test edge cases related to the bug
- If the bug was data-related, verify with actual data not mock

### 10. Add regression coverage
If practical:
- Write a test that fails before your fix and passes after
- Add a runtime assertion if a test isn't possible
- Document the failure mode in a code comment

If the bug was environmental (only happens in prod), document the trigger conditions in the runbook.

### 11. Document the root cause
In the PR or Linear comment:
- What the symptom was
- What the actual cause was
- Why the original code was wrong
- What the fix does
- What edge cases were considered

This is for future-you. The minute the fix lands, you'll forget why.

## Output format

```markdown
# Debug report — [issue]

## Expected vs actual
- Expected: [precise]
- Actual: [precise]
- Reproduces: [always / sometimes / specific conditions]

## Evidence
- Errors: [verbatim]
- Logs: [relevant lines with timestamps]
- Repro steps: [minimal sequence]

## Recent changes investigated
- [commit a] — not the cause, ruled out by [test]
- [commit b] — partial cause, see fix

## Root cause
[1-2 paragraphs explaining what's actually wrong and why]

## Fix
[What was changed, in plain language]

## Verification
- Reproduction steps no longer trigger the bug
- typecheck/lint/test/build: pass
- Edge cases tested: [list]

## Regression coverage
- Test added: [path/test-name]
- (or: runbook entry added at [link])

## Risks
[Anything that could break in adjacent areas]

## Follow-ups
- [Linear keys for any deferred related work]
```

## Approval gates

**Tier 1-2** — investigating, drafting fix, running checks: no approval needed.

**Tier 3** — pushing fix branch, opening PR, updating Linear: standard PR approval.

**Tier 4 — needs explicit approval each time:**
- Production hotfix (not the normal PR cycle)
- Rollback to previous version
- Production data repair (UPDATE/DELETE on real data)
- Disabling tests (almost never the right call)
- Changing secrets or permissions

**Tier 5 — always blocked:**
- Mutating production data without explicit approval naming exact rows/effects
- Suppressing errors with try/catch to make symptoms disappear
- Deleting tests to bypass them

## Hard rules

- Never patch randomly — every change should follow from a hypothesis
- Never suppress errors without understanding them
- Never delete tests to make checks pass
- Never mutate production data without explicit approval
- Never claim a fix works without verifying with the original reproduction
- Never close a Linear bug without the root cause documented
- Never trust "it's working now" without reproducing the original failure first

## Connects to

- `current-docs-guard` — invoke if the bug might be from outdated API usage
- `supabase-guardian` — invoke if the bug involves DB / RLS / auth
- `vercel-preview-qa` — invoke if the bug is preview-environment-specific
- `automation-sre` — invoke if the bug is in an VPS/automation server job
- `observability-incident-loop` — invoke if this is a production incident
- `issue-to-pr` — the fix flows through normal PR cycle unless it's a hotfix
- `decision-log-adr` — if the fix changes architecture, log it
- `pattern-learner` — if the bug class is recurring, surface it for skill updates

## Common failure modes

**Patching symptoms** — The most common AI failure. Adding `?.` everywhere, wrapping things in `try/catch`, defaulting to empty objects. These hide the bug. Always ask: *why* is this value undefined? Then fix the cause.

**Skipping reproduction** — Reading the error message and immediately writing a fix. Don't. Reproduce first, even if you "know" what's wrong.

**Fixing too much** — While in the suspect file, also "improving" adjacent code. Don't. Fix the bug. Open follow-up issues for everything else.

**Stopping at first plausible cause** — There might be two bugs interacting. If your fix doesn't reproduce-pass-cleanly, keep investigating.

**Not capturing the root cause in writing** — In 3 weeks you'll see this bug pattern again and have no record of why it happened. Always write the post-mortem in PR/Linear.

**Treating "it's intermittent" as unfixable** — Intermittent bugs almost always have a real cause (race condition, state leak, timing). They're not random. They're a clue you haven't found the actual trigger yet.
