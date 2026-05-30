#!/usr/bin/env bash
# Block Bash commands that can read, write, search for, or stage secrets.
# Read()/Write() permission denies do not cover Bash, so this hook denies secret
# path references by default and allows only sanitized example env files.
set -euo pipefail

if ! command -v jq >/dev/null 2>&1; then
  echo "Ravie warning: jq is not installed; skipping Bash secrets protection hook." >&2
  exit 0
fi

INPUT=$(cat)
COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || true)
[ -z "$COMMAND" ] && exit 0

LC=$(printf '%s' "$COMMAND" | LC_ALL=C tr '[:upper:]' '[:lower:]')

# Allow documentation/example env files, but leave real .env paths detectable.
SANITIZED=$(printf '%s' "$LC" | sed -E \
  -e 's#(^|[^[:alnum:]_.-])\.env\.local\.example([^[:alnum:]_.-]|$)#\1__allowed_env_example__\2#g' \
  -e 's#(^|[^[:alnum:]_.-])\.env\.(example|sample|template)([^[:alnum:]_.-]|$)#\1__allowed_env_example__\3#g')

REASON=""
has_secret_reference=false

env_re='(^|[^[:alnum:]_.-])\.env($|[^[:alnum:]_.-]|\.[a-z0-9_-]+)'
pem_re='\.pem($|[^[:alnum:]_])'

if [[ "$SANITIZED" =~ $env_re ]] || \
   [[ "$LC" == *"secrets/"* ]] || \
   [[ "$LC" == *"credentials.json"* ]] || \
   [[ "$LC" == *"id_rsa"* ]] || \
   [[ "$LC" == *"id_ed25519"* ]] || \
   [[ "$LC" =~ $pem_re ]]; then
  has_secret_reference=true
fi

recursive_grep_long_re='(^|[[:space:];&|])grep[[:space:]][^;&|]*--recursive'
recursive_grep_flag_re='(^|[[:space:];&|])grep[[:space:]][^;&|]*-[a-z]*r[a-z]*[[:space:]][^;&|]*(^|[[:space:]])\.?/?($|[[:space:];&|])'
rg_re='(^|[[:space:];&|])rg([[:space:]]|$)'
repo_root_target_re='(^|[[:space:]])\.?/?($|[[:space:];&|])'
find_repo_re='(^|[[:space:];&|])find[[:space:]]+\./?([[:space:]]|$)'

if $has_secret_reference; then
  REASON="Blocked Bash command that references secrets: $COMMAND. Secrets in .env files, secrets/, credentials.json, *.pem, id_rsa, and id_ed25519 are off-limits via shell. Sanitized examples such as .env.example are allowed."
elif [[ "$LC" =~ $recursive_grep_long_re ]] || [[ "$LC" =~ $recursive_grep_flag_re ]]; then
  REASON="Blocked recursive grep over the repository. Recursive secret discovery must be done manually outside the agent session."
elif [[ "$LC" =~ $rg_re ]] && [[ "$LC" =~ $repo_root_target_re ]]; then
  REASON="Blocked ripgrep over the repository. Recursive secret discovery must be done manually outside the agent session."
elif [[ "$LC" =~ $find_repo_re ]] && [[ "$LC" == *" -exec "* ]]; then
  REASON="Blocked find -exec over the repository. Recursive secret discovery must be done manually outside the agent session."
fi

if [ -n "$REASON" ]; then
  jq -n --arg reason "$REASON" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$reason}}'
  exit 0
fi

exit 0
