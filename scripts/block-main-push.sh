#!/usr/bin/env bash
# Block direct or bulk git pushes to main/master. Uses structured JSON output with
# exit 0 per the Claude Code hook contract: JSON is processed only on exit 0.
set -euo pipefail

if ! command -v jq >/dev/null 2>&1; then
  echo "Ravie warning: jq is not installed; skipping main-push protection hook." >&2
  exit 0
fi

INPUT=$(cat)
COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || true)
[ -z "$COMMAND" ] && exit 0

# Inspect normal `git push ...` and global-option forms such as
# `git -C repo push ...`. The hook is intentionally conservative for pushes.
if [[ ! "$COMMAND" =~ (^|[[:space:];&|])git[[:space:]]+push([[:space:]]|$) ]] && \
   [[ ! "$COMMAND" =~ (^|[[:space:];&|])git[[:space:]]+(-C[[:space:]]+[^[:space:]]+[[:space:]]+)+push([[:space:]]|$) ]]; then
  exit 0
fi

REASON=""

if [[ "$COMMAND" =~ (^|[[:space:]])--mirror([[:space:]=]|$) ]]; then
  REASON="Blocked git push --mirror. Mirror pushes can overwrite protected branches and remote refs. Push a feature branch and open a PR instead."
elif [[ "$COMMAND" =~ (^|[[:space:]])--all([[:space:]=]|$) ]]; then
  REASON="Blocked git push --all. Bulk pushes can publish protected branches unexpectedly. Push a single feature branch and open a PR instead."
elif [[ "$COMMAND" =~ (^|[[:space:]])\+?(main|master)([[:space:]]|$) ]] || \
     [[ "$COMMAND" =~ (^|[[:space:]:])\+?refs/heads/(main|master)([[:space:]:]|$) ]] || \
     [[ "$COMMAND" =~ (^|[[:space:]])\+?HEAD:(main|master)([[:space:]]|$) ]] || \
     [[ "$COMMAND" =~ (^|[[:space:]])[^[:space:]:]+:(main|master)([[:space:]]|$) ]]; then
  REASON="Blocked direct push to main/master. Create a branch, push the branch, open a PR, and merge after review."
fi

if [ -n "$REASON" ]; then
  jq -n --arg reason "$REASON" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$reason}}'
  exit 0
fi

exit 0
