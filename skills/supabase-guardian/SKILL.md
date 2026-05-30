---
name: supabase-guardian
description: >-
  Use this skill when creating or altering Supabase tables, columns, indexes, migrations, RLS policies, auth flows, storage bucket policies, edge functions, or service-role usage. Do not use for non-database UI work, read-only product planning, or deployment actions that do not touch Supabase.
---


# supabase-guardian

Review every database, auth, and RLS change before it ships. The skill that prevents "it works in dev" from becoming "users can see each other's data in prod."

## Purpose

Gate all Supabase changes — schema, RLS, auth, storage, edge functions — through a structured review. No DB change ships without passing this.

## When to use this

**You MUST use this skill when:**
- Creating or altering tables, columns, or indexes
- Adding, changing, or removing RLS policies
- Modifying auth configuration or flows
- Changing storage bucket policies
- Writing or editing edge functions
- Changing service-role usage patterns

## When NOT to use this

- Do not use for non-database UI work, read-only product planning, or deployment actions that do not touch Supabase.

## Process

### 0. Read the Supabase rule reference first
Before reviewing or changing anything, read `rules/supabase.md`. If the change also touches UI or Git operations, read `rules/ui.md` or `rules/git.md` as appropriate.

### 1. Review the migration file
```bash
cat supabase/migrations/[timestamp]_[name].sql
```
List every table, column, index, function, trigger, policy, and storage bucket touched. Flag destructive operations (`DROP`, `TRUNCATE`, broad `UPDATE`/`DELETE`) before running anything.

### 2. Apply from a clean local database
Run migrations from scratch before trusting an incremental local state:

```bash
supabase db reset
```

If reset is too destructive for the current machine, stop and state that the migration was not fully verified from a clean baseline.

### 3. Verify RLS is enabled per public table
Check the actual database state, not only the migration text:

```sql
SELECT relname, relrowsecurity
FROM pg_class
WHERE relkind = 'r'
  AND relnamespace = 'public'::regnamespace
ORDER BY relname;
```

Every user-facing table must have `relrowsecurity = true`. Internal lookup tables may be exempt only when the reason is documented.

### 4. Inspect policies per changed table
For every changed table, inspect policies directly:

```sql
SELECT *
FROM pg_policies
WHERE tablename = '[table]'
ORDER BY policyname;
```

Check SELECT, INSERT, UPDATE, and DELETE separately. Verify owner scoping uses `auth.uid()` or an equivalent tenant/user boundary.

Example review:
```sql
-- GOOD: scoped to authenticated user's own data
CREATE POLICY "Users can read own data" ON profiles
  FOR SELECT USING (auth.uid() = user_id);

-- BAD: allows reading all rows
CREATE POLICY "Users can read" ON profiles
  FOR SELECT USING (true);
```

### 5. Service-role audit
Find service-role usage before approving:

```bash
grep -rn "SUPABASE_SERVICE_ROLE_KEY\|createClient.*service" src/
```

Rules:
- Service-role clients must stay in server-only code paths.
- They must not be imported in files with a `'use client'` directive.
- They must not be imported by modules that client components can transitively reach.
- `src/app/api/`, server actions, and server components may use service-role clients when the code path is server-only and the key is not exposed as `NEXT_PUBLIC_`.

### 6. Regenerate and inspect types
After any schema migration, regenerate types and confirm the diff matches the migration:

```bash
pnpm gen:types
# or
supabase gen types typescript > src/types/supabase.ts
```

### 7. Test with actual user context
Do not test RLS with service-role. Use an anon key plus a JWT for a real test user. Attempt the operations the policy should allow and the operations it should block. The review is blocked until denied operations actually fail.

Test pattern:
1. Sign in as user A and create/read/update only user A data.
2. Attempt to read or mutate user B data and confirm it fails.
3. Attempt unauthenticated access where relevant and confirm it fails.
4. Repeat for each changed table and storage bucket policy.

## Output format

```markdown
# Supabase review — [migration name]

## Schema changes
- [Table]: [what changed]

## RLS status
| Table | RLS enabled | SELECT | INSERT | UPDATE | DELETE |
|---|---|---|---|---|---|
| [name] | yes/no | [policy] | [policy] | [policy] | [policy] |

## Service-role usage: [SAFE / CONCERN — details]
## Types regenerated: [yes/no]
## Tested as user: [yes/no]
## Verdict: [PASS / BLOCKED — reasons]
```

## Hard rules

- Never ship a user-facing table without RLS enabled
- Never weaken RLS to fix a frontend bug — fix the frontend
- Never import service-role client in client-side code
- Never test RLS with service-role bypass only
- Always regenerate types after migration

## Connects to

- `issue-to-pr` — invoked during implementation when DB is touched
- `current-docs-guard` — verify Supabase API patterns are current
- `deploy-ready` — complementary pre-deploy check
- `security-auditor` agent — for deeper auth/access review

## Common failure modes

**RLS "works" because you tested with service-role** — Service-role bypasses all RLS. You must test as an actual authenticated user.

**Frontend workaround for RLS** — "The query doesn't return data, so I'll disable RLS on that table." No. Fix the policy or the query.

**Forgetting to regenerate types** — Schema changed but TypeScript types are stale. Runtime works, types lie. Always regenerate.
