# Fixes applied — Ravie v1.0 → v1.1

This is the change log for the v1.1 review pass. Every entry is a **confirmed** finding
(cited to a file/line or backed by test output). Findings that could not be confirmed
broken are listed at the end as **flags for the maintainer**, not changes.

Severity key: 🔴 Critical · 🟡 Important · 🟢 Nice-to-have

Hooks were tested by piping the exact `TESTING.md` payloads to the scripts via stdin
and reading `hookSpecificOutput.permissionDecision`. `[deny]` = blocked; `[ALLOW]` =
no stdout, exit 0. `jq` 1.7 was installed in the test environment.

---

## 1. Direct-copy hook path inconsistency 🟡

**Finding.** The plugin install path in `hooks/hooks.json` is correct
(`${CLAUDE_PLUGIN_ROOT}/scripts/...`), but the **direct-copy** install pointed at
`.claude/hooks/` in six files, while the repo's scripts actually live in `scripts/`.
A user following `TESTING.md` against a fresh clone would run
`bash .claude/hooks/*.sh`, which does not exist.

Confirmed occurrences (v1.0 line numbers):
- `settings.example.json:102,113,122,126` — hook command paths.
- `TESTING.md` — 33 occurrences across the syntax check and all payload examples.
- `INSTALLATION.md:73` (`cp -r ~/code/ravie/scripts .claude/hooks`) and `:123` (test command).
- `SECURITY.md:25` — "(`scripts/` … or `.claude/hooks/` (direct copy))".
- `docs/hooks-guide.md:55,66,75,79,92`.
- `CONTRIBUTING.md:87` — "Create a script in `.claude/hooks/`".

**Fix.** Standardized the direct-copy path to `.claude/scripts/` in all six files so it
matches the repo's `scripts/` directory and the `cp` target. `hooks/hooks.json` was
**not** changed (the plugin path was already correct).

**Evidence (after fix).** Simulated the corrected direct-copy layout and ran the
documented commands:

```
$ cp -r scripts /tmp/dc/.claude/scripts
$ bash -n .claude/scripts/*.sh            # all OK
$ stat -c '%a %n' .claude/scripts/*.sh    # 755 on all four
$ echo '{"tool_input":{"command":"cat .env"}}' | bash .claude/scripts/block-bash-secrets.sh
[deny]
$ echo '{"tool_input":{"command":"cat README.md"}}' | bash .claude/scripts/block-bash-secrets.sh
(no output)
```

A repo-wide sweep confirms `.claude/hooks` no longer appears anywhere.

---

## 2. Inaccurate hook test count in CHANGELOG 🟡

**Finding.** `CHANGELOG.md:32` (v1.0) claimed: "All 16 hook test cases (10 block, 6
allow) pass." `TESTING.md` actually documents **30 payload cases — 16 block, 14 allow**
(env-writes 2/3, main-push 5/5, bash-secrets 9/6). The stated figure is wrong and
internally inconsistent with the test doc.

**Fix.** Corrected the [1.0.0] note to "All 30 documented hook payload cases (16 block,
14 allow) pass, plus syntax, fail-open, and permission checks."

**Evidence.** Counted directly from `TESTING.md`: 2+5+9 = 16 block, 3+5+6 = 14 allow.

---

## 3. Hook behavior verification (no code change) ✅

All four scripts were re-tested after every edit. **Scripts were not modified** in this
release; the path fixes were in config/docs only. All 30 documented cases pass:

```
block-env-writes.sh   2/2 block, 3/3 allow
block-main-push.sh    5/5 block, 5/5 allow
block-bash-secrets.sh 9/9 block, 6/6 allow
```

Specific probes requested in the review brief:

| Payload | Result | Verdict |
|---|---|---|
| `git push origin feature-main` → `block-main-push.sh` | `[ALLOW]` | ✅ no false positive ("main" in branch name) |
| `cat .env` → `block-bash-secrets.sh` | `[deny]` | ✅ defense-in-depth covers the Bash path |
| `cat .env.local` → `block-bash-secrets.sh` | `[deny]` | ✅ |
| `git stash show -p` → `block-bash-secrets.sh` | `[ALLOW]` | see finding 4 |
| `python3 -c "...os.environ['API_KEY']..."`, `printenv`, `echo $VAR` | `[ALLOW]` | see finding 5 |

`set -euo pipefail` robustness: piping malformed JSON, empty input, and
`{"tool_input":{"command":null}}` to all three guard scripts returns exit 0 with no
output — the `|| true` guards and `2>/dev/null` on `jq` prevent false failures. The
`jq`-missing fail-open path also behaves as documented (stderr warning, exit 0).

---

## 4. `git stash show -p` edge case — documented as an intentional allow 🟢

**Finding.** `echo '{"tool_input":{"command":"git stash show -p"}}' | bash
scripts/block-bash-secrets.sh` → `[ALLOW]`. It was not covered in `TESTING.md`.

**Decision & fix.** Keep allowing it, and document why. A bare `git stash show -p`
prints the diff of stashed *tracked* changes and is a routine review command; blocking
it would be a false positive. A normal-project `.env` is gitignored and is not stashed
unless forced. The moment the command names the secret path (`-- .env`), the existing
path matcher denies it. Added both cases to `TESTING.md` under "Documented edge case:
`git stash show -p`".

**Evidence.**
```
[ALLOW] git stash show -p
[deny]  git stash show -p stash@{0} -- .env
```

---

## 5. Env-var reads — documented as an accepted limitation 🟢

**Finding.** Reading environment *variables* already loaded into the process
(`printenv API_KEY`, `echo $DATABASE_URL`, `python3 -c "...os.environ..."`,
`node -e "process.env..."`) all return `[ALLOW]`.

**Decision & fix.** This is in-scope behavior, not a bug. The hook is **path-based**: it
blocks shell references to secret *files* and recursive secret discovery. Blocking
in-process env-var reads would false-positive on routine commands like `echo $HOME` or
`echo $PATH`. Documented this explicitly in `TESTING.md` under "Accepted limitation:
reading environment variables (not files)" so the boundary is intentional and visible.

**Evidence.** All four env-var payloads → `[ALLOW]`, verified.

---

## 6. Codex content removed from the shipping surface and preserved 🟡

**Finding.** v1.0 interleaved Claude Code and Codex instructions across 16 files and
shipped two Codex `AGENTS.md` templates, implying Codex support that does not exist.
Additionally, two Codex facts were stale: `docs/hooks-guide.md:133` and
`docs/agents-template-full-reference.md:219` described Codex hooks as gated behind the
`codex_hooks` feature flag. Per OpenAI's current Codex docs (Hooks, Config Reference,
early 2026), Codex hooks are now **stable** and the canonical key is `hooks`
(`codex_hooks` is a deprecated alias).

**Fix.**
- Created **`docs/codex-roadmap.md`** with a top note ("Codex support is planned for
  v1.2. This document tracks the planned port.") containing: the planned port structure
  (`.codex/hooks/`, `.agents/skills/`, `.codex/agents/*.toml`), the corrected Codex hook
  facts, the AGENTS.md instruction-file behavior, and the verbatim content of the three
  deleted files plus every extracted section.
- Deleted `AGENTS-TEMPLATE.md`, `quickstart/AGENTS.md`, and
  `docs/agents-template-full-reference.md` (content preserved in the roadmap).
- Stripped Codex from `README.md` (roadmap line removed), `CHANGELOG.md:30` (now "planned
  for a future release. See docs/codex-roadmap.md"), `INSTALLATION.md:5` (callout
  removed), `START-HERE.md` (Codex section + two "or Codex" mentions removed),
  `ROUTER.md:5,21,116`, `SKILL-INDEX.md:8`, `MASTER-GUIDE.md:298`,
  `docs/superpowers-setup.md:17-21`, `docs/hooks-guide.md` (Codex section removed),
  `docs/context-hygiene.md:36`, `skills/project-control-plane/SKILL.md` (description,
  purpose, when-to-use, step 7, output line), `skills/code-review/SKILL.md:42`
  (parenthetical removed, fallback guidance kept), and
  `.github/ISSUE_TEMPLATE/bug-report.md:23`.

**Evidence.** `grep -rin "codex" .` now returns only `docs/codex-roadmap.md` and the
single `CHANGELOG.md:30` pointer. No dangling links to the deleted files remain (the
only references are "Source:" provenance notes inside the roadmap).

**Codex claims verified accurate (preserved as-is in the roadmap):** `.agents/skills/`
discovery, the shared `SKILL.md` format, `.codex/agents/*.toml` custom agents, the 32 KiB
`project_doc_max_bytes` default, root-down precedence of nested `AGENTS.md`, and the
Superpowers-on-Codex `/plugins` install flow (matches the official `obra/superpowers`
README).

---

## 7. Thin skills brought up to the repo's own bar 🟢

**Finding.** `CONTRIBUTING.md:13-14` requires every skill to have "a real output
template" and "at least three specific failure modes." Seven skills were under 90 lines;
six of them fell short of that bar:

| Skill | v1.0 lines | Output template | Failure modes |
|---|---|---|---|
| `responsive-ui` | 75 | thin | 2 |
| `threejs-motion-performance` | 75 | missing | 2 |
| `ui-copy` | 77 | missing | 2 |
| `design-system-ui` | 78 | present | 2 |
| `animation-motion` | 80 | missing | 2 |
| `system-of-record-governance` | 84 | examples only | 2 |
| `decision-log-adr` | 87 | present (ADR) | 3 — **already compliant** |

**Fix.** Added a concrete output template where missing and a third concrete failure
mode where there were two — concrete content (real CSS/commands/templates), not filler.
All seven now have ≥3 failure modes and an output-format section. `decision-log-adr` was
left **unchanged** (confirmed identical to v1.0 by diff).

**Evidence.** Post-edit counts: every one of the seven reports 3 failure modes + 1
output-format section.

---

## 8. Version bumps 🟢

Bumped to `1.1.0` in `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`,
and `CITATION.cff` (with `date-released: "2026-05-29"`). All JSON revalidated with
`jq empty`. Added the `[1.1.0]` entry to `CHANGELOG.md`.

---

## Review findings that did NOT result in a code change

### skill-creator self-compliance ✅ (no change)
`skills/skill-creator/SKILL.md` contains all four required elements: the exact YAML
frontmatter template (lines 36–41 and 60–63), a finished output example (the full
SKILL.md structure block at 59–103 and the skill-package output block at 119–146), a
"Common failure modes" section (4 modes), and a "Connects to" section. It eats its own
cooking. Left unchanged.

### README accuracy ✅ (counts verified)
Verified against the repo: **33** `skills/*/SKILL.md`, **5** `rules/*.md`, **4**
`agents/*.md`, **4** `scripts/*.sh`. The four-layer architecture diagram matches the
implementation (Layer 2 = `rules/` + `scripts/` via `hooks/hooks.json`; Layer 4 =
`skills/` + `agents/`). No change needed.

### LICENSE / CITATION / CODE_OF_CONDUCT ✅ (verified)
- `LICENSE`: MIT, "Copyright (c) 2026 Ravie Contributors" — valid placeholder author.
- `CITATION.cff`: metadata matches the repo URL and (now) version 1.1.0.
- `CODE_OF_CONDUCT.md`: standard Contributor Covenant v2.1, correctly attributed.
- `.github/ISSUE_TEMPLATE/`: bug-report and new-skill templates are tailored to this
  project (not generic); PR template references `scripts/` correctly.

---

## Flags for the maintainer (could not confirm; not changed)

### 🟡 GitHub install URLs do not resolve
`README.md` (`/plugin marketplace add amnafarzy/ravie`, `curl .../amnafarzy/ravie/...`),
`plugin.json`, `marketplace.json`, `CITATION.cff`, `SECURITY.md`, and `CONTRIBUTING.md`
all use the `amnafarzy/ravie` owner/repo. As of this review:

```
https://github.com/amnafarzy/ravie                         → 404
https://raw.githubusercontent.com/amnafarzy/ravie/main/... → 404
```

This is left **unchanged** because the correct final owner/repo cannot be inferred
without guessing. Before publishing, confirm the GitHub owner and update these
references; the quick-start curl in step 2 of the README will not work until the repo is
public at that path.

### HN "embarrassment test" — opinionated notes (no change unless flagged above)
- **Unverifiable/fluffy claims:** "four-layer operating system" is marketing framing, but
  the README defines each layer concretely, so it survives scrutiny. The one hard claim
  that was actually wrong — the hook test count — is fixed (finding 2).
- **Layer 1 clarity:** "Superpowers + Karpathy Guidelines" still assumes the reader knows
  both. The README does link Superpowers and explain the split lower down, and
  `rules/karpathy-guidelines.md` exists, so a motivated reader can follow it — but a
  one-line gloss at first mention would help. Left as an editorial suggestion, not a fix.
- **Quick start end-to-end:** the only real gap is the unresolved repo URL above (step 2
  curl). The rest of the flow is internally consistent.
- **AI-generated feel:** the prose is dense and list-heavy in places, but the content is
  specific and not boilerplate. No change made.
