## What this PR does
<!-- One sentence summary -->

## Why
<!-- What problem does this solve? Link to issue if applicable -->

## Changes
<!-- List the files changed and why -->

## How to verify
<!-- How can a reviewer check that this works? -->

## Checklist
- [ ] Skill follows the structure in CONTRIBUTING.md
- [ ] "When to use this" section has specific triggers
- [ ] "Hard rules" section uses mandatory language (MUST, NEVER)
- [ ] Added to SKILL-INDEX.md (if new skill)
- [ ] No personal data or client-specific content
- [ ] If touching `scripts/`: hook scripts pass `bash -n`
- [ ] If touching `scripts/`: tested with sample JSON payloads (block + allow cases)
- [ ] If touching `hooks/hooks.json or settings.example.json`: file is valid JSON (verified with `jq empty`)
