# Supabase conventions

- **Migrations:** every schema change gets a migration file tracked in GitHub (`supabase migration new [name]`); regenerate types after (`pnpm gen:types`). Destructive production migrations need explicit Tier 4 approval.
- **RLS:** every user-facing table MUST have RLS enabled; review select/insert/update/delete policies separately; test with real user roles, not service-role bypass. Never weaken RLS to fix a frontend bug — fix the frontend.
- **Auth:** Supabase Auth only (not custom, not Better Auth). Check auth server-side for protected routes — client-side checks are UX, not security. Never expose service-role keys to client code.
- **Service role:** bypasses RLS — server-side code only, never imported in client bundles; audit usage quarterly.
- **Types:** use generated types, regenerate after every migration; if types don't match runtime data, the migration is wrong — fix the migration.
- **Environments:** preview and production are different Supabase projects — never interchangeable, never use the production connection string locally.
