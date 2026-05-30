---
name: deploy-ready
description: >-
  Use this skill when a PR or branch is close to merge or production deploy, especially for public-facing features, new env vars, external services, metadata, performance, secrets, or release-readiness checks. Do not use for early development, preview-only QA handled by vercel-preview-qa, or production actions without explicit approval.
---


# deploy-ready

Pre-deployment checklist. Run this before merging or deploying to catch what tests don't: missing env vars, exposed secrets, broken error states, metadata gaps, and performance regressions.

## Purpose

Verify a PR or branch is actually ready for production — not just "checks pass" but "nothing will break when real users hit it."

## When to use this

- PR is about to merge to main
- Preparing a Vercel production deployment
- Adding new env vars or external services
- Shipping a public-facing feature

## When NOT to use this

- Do not use for early development, preview-only QA handled by vercel-preview-qa, or production actions without explicit approval.

## Process

### 0. Read relevant rule references first
Before deploy readiness review, read `rules/git.md` and `rules/context-hygiene.md`. If the release touches Supabase, read `rules/supabase.md`; if it touches UI, read `rules/ui.md`.

### 1. Environment check

Compare what the deployment needs against what's documented in `.env.example`.

**Portable approach (works on macOS BSD grep and Linux GNU grep):**
```bash
# Extract keys declared in .env.example
declared=$(awk -F= '/^[A-Z_]+=/{print $1}' .env.example | sort -u)

# Extract process.env.X references across common file types and locations
# Adjust the find -path patterns for your project structure
used=$(find . \
  \( -path ./node_modules -prune -o -path ./.next -prune -o -path ./dist -prune \) -o \
  \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" -o -name "*.mjs" -o -name "*.cjs" \) -print 2>/dev/null \
  | xargs grep -hoE 'process\.env\.[A-Z_]+' 2>/dev/null \
  | sed 's/process\.env\.//' \
  | sort -u)

# Show keys used in code but missing from .env.example
echo "Used in code but missing from .env.example:"
comm -23 <(echo "$used") <(echo "$declared")

# Show keys declared but never referenced
echo ""
echo "Declared in .env.example but unused in code:"
comm -13 <(echo "$used") <(echo "$declared")
```

If you have `ripgrep` (`rg`), this is faster and cleaner:
```bash
rg -No 'process\.env\.[A-Z_]+' --type ts --type tsx --type js --type jsx \
  | sed 's/.*process\.env\.//' | sort -u > /tmp/used.txt
awk -F= '/^[A-Z_]+=/{print $1}' .env.example | sort -u > /tmp/declared.txt
diff /tmp/used.txt /tmp/declared.txt
```

Verify:
- Every `process.env.X` in code has a matching entry in `.env.example`
- No secrets in code, comments, or commit history (run `git log -p | grep -i 'api[_-]key\|secret\|token'`)
- Preview and production env vars are configured separately in your hosting provider
- Server-only secrets are not exposed via `NEXT_PUBLIC_` or equivalent client prefix

### 2. Build verification
```bash
pnpm build  # must succeed cleanly, not just locally
```

### 3. Error and loading states
- Every data-fetching component has a loading state
- Every data-fetching component has an error state
- Error messages are user-friendly (not raw stack traces)
- 404 page exists and is styled
- 500 fallback exists

### 4. Metadata and SEO
- Page titles set for new routes
- Open Graph tags for shareable pages
- Favicon present
- robots.txt and sitemap configured (if public)

### 5. Performance basics
- No unoptimized images (use next/image or equivalent)
- No massive bundle imports (check with `pnpm build` output)
- API calls don't block initial render unnecessarily

### 6. Security quick check
- No `dangerouslySetInnerHTML` without sanitization
- Auth checked server-side on protected routes
- RLS enabled on user-facing Supabase tables

## Output format

```markdown
# Deploy readiness — [feature/PR]

## Environment: [PASS/FAIL]
- .env.example complete: [yes/no]
- Secret boundary respected: [yes/no]
- Preview/prod separation: [yes/no]

## Build: [PASS/FAIL]

## States: [PASS/FAIL]
- Loading states: [complete/missing in X]
- Error states: [complete/missing in X]
- 404/500 pages: [present/missing]

## Metadata: [PASS/FAIL]

## Performance: [PASS/FAIL]

## Security: [PASS/FAIL]

## Verdict: [READY / BLOCKED — reasons]
```

## Hard rules

- Never deploy with unknown env var requirements
- Never expose server-only keys to client bundles
- Never skip error state review for user-facing changes
- Never treat "it works locally" as deploy-ready

## Connects to

- `vercel-preview-qa` — complementary: deploy-ready is the checklist, preview-qa is the visual verification
- `supabase-guardian` — for DB/auth security review
- `permission-guardian` — production deploy requires Tier 4 approval

## Common failure modes

**Missing env var in production** — App works locally (env vars set), breaks in prod (env var missing). The diff check catches this.

**Error states forgotten** — Happy path is polished, error state shows a raw JSON error. Always check.

**Secret in commit history** — Even if you removed it from the latest commit, `git log` still has it. Rotate the secret.
