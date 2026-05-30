---
name: current-docs-guard
description: >-
  Use this skill when implementing or changing version-sensitive APIs, SDKs, frameworks, package upgrades, Supabase, Next.js, Vercel, MCP, auth systems, Three.js, browser APIs, deployment tooling, or any API not verified in the current session. Do not use for pure business logic, copy edits, or styling changes with no external API dependency.
---


# current-docs-guard

Verify current official documentation before changing version-sensitive APIs. Prevents the #1 AI failure mode: confidently writing code from outdated training data.

## Purpose

Before any implementation that touches version-sensitive tools (Supabase, Next.js, Vercel, Three.js, MCP, auth systems), check the current official docs. Not blogs, not courses, not memory — the actual docs at the actual URL.

## When to use this

**You MUST use this skill when:**
- Changing Supabase API calls, auth flows, or RLS patterns
- Updating Next.js routing, server components, or API routes
- Configuring Vercel deployment settings or edge functions
- Installing or updating MCP servers
- Touching Three.js rendering, loaders, or shaders
- Updating any package more than one major version
- Using an API you haven't verified in this session

**Skip for:**
- Pure business logic with no external API dependencies
- CSS/styling changes
- Copy changes

## When NOT to use this

- Do not use for pure business logic, copy edits, or styling changes with no external API dependency.

## Process

### 0. Read relevant rule references first
Before long investigations, read `rules/context-hygiene.md` to keep the docs check scoped and avoid context bloat. Before version-sensitive work, read the relevant `rules/*.md` file for the domain, if one exists.

### 1. Identify what's version-sensitive
Before writing any code, list: which external APIs, SDKs, or tools does this change touch?

### 2. Check the repo's current versions
```bash
cat package.json | grep "[library-name]"
# or
cat pnpm-lock.yaml | grep "[library-name]" | head -5
```

### 3. Read the actual docs
Go to the official documentation URL. Not a blog post, not a Stack Overflow answer, not your training data. The docs.

Common doc URLs:
- Supabase: https://supabase.com/docs
- Next.js: https://nextjs.org/docs
- Vercel: https://vercel.com/docs
- Three.js: https://threejs.org/docs

### 4. Compare docs against current code
Look for:
- Deprecated methods the codebase still uses
- New patterns that replace what's currently implemented
- Breaking changes between installed version and latest
- Auth patterns that have changed (very common with Supabase)

### 5. Document what you found
```markdown
## Docs check — [library/API]

**Installed version:** [x.y.z]
**Current docs version:** [a.b.c]
**Breaking changes:** [yes/no — list if yes]
**Deprecated patterns found:** [list]
**Recommended approach:** [what the current docs say to do]
**Migration needed:** [yes/no — scope if yes]
**Confidence:** [HIGH — docs verified / MEDIUM — docs partially checked / LOW — unable to verify]
```

### 6. Flag uncertainty explicitly
If you can't verify something from docs, say so. "I believe this API works this way based on training data, but I could not verify it from current docs" is vastly better than silently guessing.

## Output format

```markdown
# Docs guard report — [what was checked]

## Components checked
- [Library]: v[installed] → docs say v[current]
- [API]: [method checked] — [current/deprecated/changed]

## Stale assumptions avoided
- [Pattern that would have been wrong without checking]

## Recommendation
[What to implement based on current docs]

## Risks
- [Migration risk if upgrading]
- [Compatibility concern]

## Confidence: [HIGH/MEDIUM/LOW]
```

## Hard rules

- Never rely on training data for version-sensitive API behavior — always verify
- Never silently upgrade packages without checking migration guides
- Never use deprecated patterns when docs show the current replacement
- Never bury uncertainty — flag it explicitly with confidence level
- Prefer official docs over courses, blogs, summaries, or Stack Overflow

## Connects to

- `issue-to-pr` — invoked during implementation for version-sensitive work
- `supabase-guardian` — complementary: docs-guard checks the API, supabase-guardian checks the schema/RLS
- `decision-log-adr` — log decisions to upgrade or stay on current version

## Common failure modes

**Confidently wrong** — AI generates Supabase auth code from 6 months ago. The API changed. Code compiles but auth silently breaks in edge cases. Always verify.

**Checking blogs instead of docs** — A Medium post from 2024 is not current documentation. Go to the official URL.

**Skipping the version check** — Docs for v3 look different from v2. If you're on v2, read v2 docs, not latest.

**"I'm pretty sure this is right"** — If you're "pretty sure" about an API method without checking, flag it as MEDIUM confidence. Let the human decide whether to verify.
