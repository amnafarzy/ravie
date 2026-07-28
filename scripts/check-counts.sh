#!/bin/bash
# Verify the component counts claimed in README.md and .claude-plugin/plugin.json
# match what actually exists in the repo, so the docs can never silently drift
# from reality. Run from anywhere: /bin/bash scripts/check-counts.sh
set -u

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT" || exit 1

if ! command -v jq >/dev/null 2>&1; then
  echo "ERROR: jq is required to parse .claude-plugin/plugin.json." >&2
  exit 1
fi

FAIL=0

# --- Actual counts -----------------------------------------------------------
ACTUAL_SKILLS=$(find skills -mindepth 2 -maxdepth 2 -name SKILL.md | wc -l | tr -d ' ')
ACTUAL_AGENTS=$(find agents -maxdepth 1 -name '*.md' | wc -l | tr -d ' ')
ACTUAL_RULES=$(find rules -maxdepth 1 -name '*.md' | wc -l | tr -d ' ')
ACTUAL_BLOCKS=$(find scripts -maxdepth 1 -name 'block-*.sh' | wc -l | tr -d ' ')

# "Hook scripts" as claimed by the docs = the distinct scripts actually wired
# into hooks/hooks.json (the 3 block-*.sh guards plus auto-format.sh).
ACTUAL_HOOKS=$(jq -r '.hooks[][].hooks[].command' hooks/hooks.json \
  | grep -oE '[A-Za-z0-9_-]+\.sh' | sort -u | wc -l | tr -d ' ')

# Every block-*.sh guard must be wired into hooks.json, and every wired script
# must exist on disk — otherwise the hook count is fiction.
WIRED=$(jq -r '.hooks[][].hooks[].command' hooks/hooks.json | grep -oE '[A-Za-z0-9_-]+\.sh' | sort -u)
for f in scripts/block-*.sh; do
  name=$(basename "$f")
  if ! printf '%s\n' "$WIRED" | grep -qx "$name"; then
    echo "FAIL: $f exists but is not wired into hooks/hooks.json"
    FAIL=1
  fi
done
for name in $WIRED; do
  if [ ! -f "scripts/$name" ]; then
    echo "FAIL: hooks/hooks.json references scripts/$name which does not exist"
    FAIL=1
  fi
done

# --- Claimed counts ----------------------------------------------------------
# README claims live on the intro line ("N active skills, N rule reference
# files, N subagents, and N hook scripts"). Locate it by content rather than a
# hard-coded line number so badges/headers can't silently break this check.
README_LINE=$(grep -m1 'active skills' README.md)
if [ -z "$README_LINE" ]; then
  echo "FAIL: could not find the 'active skills' claim line in README.md"
  exit 1
fi
README_SKILLS=$(printf '%s' "$README_LINE" | grep -oE '[0-9]+ active skills' | grep -oE '[0-9]+')
README_RULES=$(printf '%s' "$README_LINE" | grep -oE '[0-9]+ rule reference files' | grep -oE '[0-9]+')
README_AGENTS=$(printf '%s' "$README_LINE" | grep -oE '[0-9]+ subagents' | grep -oE '[0-9]+')
README_HOOKS=$(printf '%s' "$README_LINE" | grep -oE '[0-9]+ hook scripts' | grep -oE '[0-9]+')

PLUGIN_DESC=$(jq -r '.description' .claude-plugin/plugin.json)
PLUGIN_SKILLS=$(printf '%s' "$PLUGIN_DESC" | grep -oE '[0-9]+ skills' | grep -oE '[0-9]+')
PLUGIN_RULES=$(printf '%s' "$PLUGIN_DESC" | grep -oE '[0-9]+ rule reference files' | grep -oE '[0-9]+')
PLUGIN_AGENTS=$(printf '%s' "$PLUGIN_DESC" | grep -oE '[0-9]+ subagents' | grep -oE '[0-9]+')
PLUGIN_HOOKS=$(printf '%s' "$PLUGIN_DESC" | grep -oE '[0-9]+ deterministic hooks' | grep -oE '[0-9]+')

# --- Compare -----------------------------------------------------------------
check() {
  local label="$1" actual="$2" claimed="$3" source="$4"
  if [ -z "$claimed" ]; then
    echo "FAIL: $source does not claim a count for $label"
    FAIL=1
  elif [ "$actual" != "$claimed" ]; then
    echo "FAIL: $label — $source claims $claimed, repo has $actual"
    FAIL=1
  else
    echo "ok:   $label — $source claims $claimed, repo has $actual"
  fi
}

check "skills (skills/*/SKILL.md)"      "$ACTUAL_SKILLS" "$README_SKILLS" "README.md"
check "rules (rules/*.md)"              "$ACTUAL_RULES"  "$README_RULES"  "README.md"
check "subagents (agents/*.md)"         "$ACTUAL_AGENTS" "$README_AGENTS" "README.md"
check "hook scripts (wired in hooks.json)" "$ACTUAL_HOOKS" "$README_HOOKS" "README.md"

check "skills (skills/*/SKILL.md)"      "$ACTUAL_SKILLS" "$PLUGIN_SKILLS" "plugin.json"
check "rules (rules/*.md)"              "$ACTUAL_RULES"  "$PLUGIN_RULES"  "plugin.json"
check "subagents (agents/*.md)"         "$ACTUAL_AGENTS" "$PLUGIN_AGENTS" "plugin.json"
check "hooks (wired in hooks.json)"     "$ACTUAL_HOOKS"  "$PLUGIN_HOOKS"  "plugin.json"

echo ""
echo "counts: block guards=$ACTUAL_BLOCKS, wired hook scripts=$ACTUAL_HOOKS, skills=$ACTUAL_SKILLS, agents=$ACTUAL_AGENTS, rules=$ACTUAL_RULES"
exit "$FAIL"
