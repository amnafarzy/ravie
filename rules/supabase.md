# Supabase conventions

These rules apply when working with Supabase: database, auth, RLS, storage, edge functions.

## Migrations
- Every schema change needs a migration file tracked in GitHub
- Never apply destructive migrations to production without explicit Tier 4 approval
- Run `supabase migration new [name]` for new migrations
- Regenerate types after migration: `pnpm gen:types`

## RLS (Row Level Security)
- Every user-facing table MUST have RLS enabled
- Review select/insert/update/delete policies separately
- Never weaken RLS to fix a frontend bug — fix the frontend
- Test RLS with actual user roles, not service-role bypass

## Auth
- Always use Supabase Auth — not custom auth, not Better Auth
- Never expose service-role keys to client code
- Check auth state server-side for protected routes
- Client-side auth checks are UX, not security

## Service role
- Service role bypasses RLS — use only in server-side code
- Never import service-role client in client-side bundles
- Audit service-role usage quarterly

## Types
- Use generated types from `supabase gen types` — not manually typed
- Regenerate after every migration
- If types don't match runtime data, the migration is wrong — fix the migration

## Environment separation
- Preview and production are different Supabase projects
- Never treat them as interchangeable
- Never use production connection string for local development
