#!/usr/bin/env bash
# Format files after Write/Edit/MultiEdit using the hook JSON payload.
# Fails open if jq is unavailable or if prettier is not installed.

set -u

if ! command -v jq >/dev/null 2>&1; then
  echo "Ravie warning: jq not installed; skipping auto-format hook." >&2
  exit 0
fi

INPUT=$(cat)
FILE_PATH=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

if [[ -z "$FILE_PATH" || ! -f "$FILE_PATH" ]]; then
  exit 0
fi

case "$FILE_PATH" in
  *.js|*.jsx|*.ts|*.tsx|*.json|*.css|*.scss|*.md|*.mdx|*.yml|*.yaml)
    if command -v npx >/dev/null 2>&1; then
      npx prettier --write "$FILE_PATH" >/dev/null 2>&1 || true
    fi
    ;;
esac

exit 0
