#!/usr/bin/env bash
# Block writes to .env-style files. Uses structured JSON output with exit 0
# per current Claude Code hook contract: JSON is only processed on exit 0.
set -euo pipefail

if ! command -v jq >/dev/null 2>&1; then
  echo "Ravie warning: jq is not installed; skipping .env write protection hook." >&2
  exit 0
fi

INPUT=$(cat)
FILE_PATH=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null || true)
[ -z "$FILE_PATH" ] && exit 0

BASE_NAME=$(basename "$FILE_PATH")

case "$BASE_NAME" in
  .env.example|.env.local.example|.env.sample|.env.template)
    exit 0
    ;;
  .env|.env.*|*.env)
    jq -n --arg reason "Blocked write to $FILE_PATH. Secrets must be managed manually. You may write sanitized examples to .env.example or .env.local.example." \
      '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$reason}}'
    exit 0
    ;;
  *)
    exit 0
    ;;
esac
