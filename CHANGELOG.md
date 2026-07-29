# Changelog

All notable changes to Ravie are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [1.1.1] - 2026-07-29

Maintenance release: CI, verification tooling, and repo hygiene — plus the context-efficiency overhaul merged on 2026-07-10 (PR #1), documented under Notes below. Within the maintenance pass itself, no skill, agent, or hook behavior changed, and the four hook scripts and `hooks/hooks.json` remain byte-identical to v1.1.0 across the entire release.

### Added

- **CI workflow** (`.github/workflows/hooks-ci.yml`) with six jobs: bash syntax (`bash -n` on every script), shellcheck, JSON validation (`jq empty` on `hooks/hooks.json`, `.claude/settings.json`, `settings.example.json`, and both `.claude-plugin/` manifests), the 36-case hook payload suite, docs-vs-reality count verification, and markdown link integrity.
- **`scripts/run-hook-tests.sh`** — runs all 36 `TESTING.md` payload cases (17 block, 19 allow) with pass/fail counts and a non-zero exit on failure. The missing-`jq` fail-open case is deliberately excluded: a `PATH=/tmp` variant previously broke CI with exit 127 (see the comment in the script).
- **`scripts/check-counts.sh`** — fails CI if the component counts claimed in `README.md` and `.claude-plugin/plugin.json` drift from what exists in the repo. "Hook scripts" are counted from what `hooks/hooks.json` actually wires, and every `block-*.sh` guard must be registered there.
- **`scripts/check-links.sh`** — verifies every relative markdown link outside `archive/` and dot-directories resolves to an existing file; sixth CI job.
- **CI status badge** at the top of `README.md`.

### Changed

- **`FIXES-APPLIED.md` → `docs/audits/fixes-v1.0-to-v1.1.md`** — it is an audit log and now lives with the other audit docs.
- **`PERSONAL-PREFERENCES.md` → `quickstart/PERSONAL-PREFERENCES.md`** — it is a fill-in user template, like `quickstart/CLAUDE.md`.
- **`TESTING.md` restructured** into "Testing in this repo" (repo layout: `scripts/`, with `scripts/run-hook-tests.sh` as the canonical runner) and "Testing a direct-copy install" (the existing payload documentation with its `.claude/scripts/` paths). Payloads and expected outputs are unchanged.
- **`docs/STATE.md` byte-identical guarantee** scoped to `hooks/hooks.json` and the four hook scripts; the test/check scripts in `scripts/` are not covered and may evolve.
- **`actions/checkout` bumped v4 → v5** in CI (GitHub's Node 20 deprecation).

### Removed

- **`DISCARD-LIST.md`** — editorial residue from the original source-material distillation; no entry explained why any archived component was archived. That rationale lives in `docs/audits/context-audit-2026-07-10.md`, and `MASTER-GUIDE.md` retains its own discard summary table.

### Fixed

- **Hook payload-case count corrected to 36 (17 block, 19 allow).** The "30 payload cases (16 block, 14 allow)" figure in the v1.1.0 entry below undercounted by omitting the `git stash show -p` edge case (1 block, 1 allow) and the env-var limitation section (4 allow); see the correction note in `docs/audits/fixes-v1.0-to-v1.1.md` §2. `TESTING.md` now states the full count and `scripts/run-hook-tests.sh` enforces it in CI.

### Notes

- **This release also ships the context-efficiency overhaul** merged on 2026-07-10 (PR #1), previously absent from this changelog: skills 33 → 25 (eleven skills archived — seven speculative plus the four-skill UI cluster, which merged into the new `ui-quality`; `parallel-dispatch` and `session-handoff` added), agents 4 → 2 (`code-reviewer` and `research-scout` archived), all skill descriptions rewritten as trigger contracts, rule files compressed, worktree support (`.worktreeinclude`, `docs/parallel.md`), cross-session memory (`docs/STATE.md` + `session-handoff`), and a plugin auto-load fix. Full record: `docs/audits/context-audit-2026-07-10.md`. Archived components are restorable with a one-line `git mv`; see `archive/README.md`.

[1.1.1]: https://github.com/amnafarzy/ravie/releases/tag/v1.1.1

## [1.1.0] - 2026-05-29

Maintenance and accuracy release. Claude Code only; Codex content extracted to a roadmap doc. No skill, agent, or hook behavior changed.

### Fixed

- **Direct-copy hook path** — `settings.example.json`, `TESTING.md`, `INSTALLATION.md`, `SECURITY.md`, `docs/hooks-guide.md`, and `CONTRIBUTING.md` referenced `.claude/hooks/` for the direct-copy install, but the repo's scripts live in `scripts/`. Standardized the direct-copy path to `.claude/scripts/` everywhere. `hooks/hooks.json` (plugin install, `${CLAUDE_PLUGIN_ROOT}/scripts/`) was already correct and is unchanged.
- **Inaccurate hook test count** — `CHANGELOG.md` claimed "16 hook test cases (10 block, 6 allow)"; `TESTING.md` actually documents 30 payload cases (16 block, 14 allow). Corrected.

### Changed

- **Codex support removed from the shipping surface** and consolidated into `docs/codex-roadmap.md` (planned for a future release). Stripped Codex references from README, CHANGELOG, INSTALLATION, START-HERE, ROUTER, SKILL-INDEX, MASTER-GUIDE, `docs/hooks-guide.md`, `docs/context-hygiene.md`, `docs/superpowers-setup.md`, `skills/project-control-plane`, `skills/code-review`, and the bug-report template. Removed `AGENTS-TEMPLATE.md`, `quickstart/AGENTS.md`, and `docs/agents-template-full-reference.md` (their content is preserved verbatim in the roadmap doc).
- **Codex hook facts corrected** (now in the roadmap doc): Codex hooks are stable and the canonical feature key is `hooks` (`codex_hooks` is a deprecated alias), per OpenAI's current Codex documentation.

### Added

- **`docs/codex-roadmap.md`** — all extracted Codex content: planned `.codex/hooks/`, `.agents/skills/`, `.codex/agents/*.toml` port structure; the full AGENTS.md templates (compact, quickstart, expanded reference); and the Superpowers-for-Codex install steps.
- **TESTING.md edge cases** — documented `git stash show -p` (allowed; the secret-path form `-- .env` blocks) and an "accepted limitation" note that the Bash secrets hook is path-based and does not inspect in-process env-var reads (`printenv`, `echo $VAR`, `os.environ`, `process.env`).
- **Thin-skill upgrades** — brought seven skills up to the repo's own `CONTRIBUTING.md` bar (output template + at least three concrete failure modes): `responsive-ui`, `threejs-motion-performance`, `ui-copy`, `design-system-ui`, `animation-motion`, and `system-of-record-governance`. `decision-log-adr` already met the bar and was left unchanged.

### Notes

- All 30 documented hook payload cases (16 block, 14 allow) plus the two new edge cases pass; scripts were not modified in this release.

[1.1.0]: https://github.com/amnafarzy/ravie/releases/tag/v1.1.0

## [1.0.0] - 2026-05-25

First public release. Ravie ships as a Claude Code plugin.

### Added

- **Four-layer architecture** — companion plugins, rules + hooks, project entry file, skills + agents.
- **33 skills** at `skills/*/SKILL.md`, selected by Claude Code from YAML descriptions. Covers the full lifecycle: ideation, requirements, PRD, implementation, review, deploy, and launch.
- **5 rule reference files** at `rules/*.md` — git, Supabase, UI, context hygiene, and Karpathy behavioral guidelines. Skills and the project entry file instruct the agent to read the relevant file when working in that domain.
- **4 subagents** at `agents/*.md` — `code-reviewer`, `research-scout`, `security-auditor`, `ux-checker`. Run in isolated context to avoid confirmation bias.
- **4 hook scripts** at `scripts/*.sh`, registered via `hooks/hooks.json`:
  - `block-env-writes.sh` — blocks writes to real `.env` files, allows sanitized examples.
  - `block-bash-secrets.sh` — blocks Bash reads, searches, and staging of `.env`, keys, `secrets/`, and credential files; blocks recursive repository secret searches.
  - `block-main-push.sh` — blocks direct, forced, mirrored, bulk, and refspec-form pushes to `main`/`master`.
  - `auto-format.sh` — runs Prettier after Write/Edit/MultiEdit when available.
- **Plugin manifest** at `.claude-plugin/plugin.json` and marketplace catalog at `.claude-plugin/marketplace.json`.
- **Direct-copy install** — `settings.example.json` provides equivalent configuration for users who prefer copying files over installing the plugin. Uses `${CLAUDE_PROJECT_DIR}` for portability.
- **Templates** — `CLAUDE-TEMPLATE.md` and a ready-to-use `quickstart/CLAUDE.md`.
- **Documentation** — START-HERE, MASTER-GUIDE, CHEATSHEET, INSTALLATION, SKILL-INDEX, context-hygiene guide, Superpowers integration guide, and hooks authoring guide.

### Notes

- This release targets Claude Code. Codex support is planned for a future release. See docs/codex-roadmap.md.
- Hooks use `exit 0` with structured `hookSpecificOutput` JSON, matching the current Claude Code hook specification.
- All 30 documented hook payload cases (16 block, 14 allow) pass, plus syntax, fail-open, and permission checks. See `TESTING.md` for reproducible payloads.

[1.0.0]: https://github.com/amnafarzy/ravie/releases/tag/v1.0.0
