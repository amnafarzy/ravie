#!/bin/bash
# Run every payload test case documented in TESTING.md against the hook
# scripts at their repo location scripts/. Used by CI (hooks-ci.yml) and
# runnable locally from anywhere: /bin/bash scripts/run-hook-tests.sh
#
# CRITICAL: never modify PATH in this script and always invoke the hooks via
# absolute-path /bin/bash. A previous CI run set PATH=/tmp to simulate a
# missing jq and broke every subsequent command with exit 127. The
# missing-jq fail-open behavior in TESTING.md is therefore NOT exercised
# here; verify it manually if you change that code path.
set -u

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCRIPTS_DIR="$REPO_ROOT/scripts"

if ! command -v jq >/dev/null 2>&1; then
  echo "ERROR: jq is required to run the hook tests (the hooks fail open without it)." >&2
  exit 1
fi

PASS=0
FAIL=0

# expect_deny <script> <payload>: the hook must emit permissionDecision "deny".
expect_deny() {
  local script="$1" payload="$2" out rc
  out=$(printf '%s' "$payload" | /bin/bash "$SCRIPTS_DIR/$script" 2>/dev/null)
  rc=$?
  if [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q '"permissionDecision": "deny"'; then
    PASS=$((PASS + 1))
  else
    FAIL=$((FAIL + 1))
    echo "FAIL [deny]  $script <- $payload"
    echo "       exit=$rc stdout=${out:-<empty>}"
  fi
}

# expect_allow <script> <payload>: the hook must print nothing and exit 0.
expect_allow() {
  local script="$1" payload="$2" out rc
  out=$(printf '%s' "$payload" | /bin/bash "$SCRIPTS_DIR/$script" 2>/dev/null)
  rc=$?
  if [ "$rc" -eq 0 ] && [ -z "$out" ]; then
    PASS=$((PASS + 1))
  else
    FAIL=$((FAIL + 1))
    echo "FAIL [allow] $script <- $payload"
    echo "       exit=$rc stdout=${out:-<empty>}"
  fi
}

# --- block-env-writes.sh -----------------------------------------------------
expect_deny  block-env-writes.sh '{"tool_input":{"file_path":"/project/.env"}}'
expect_deny  block-env-writes.sh '{"tool_input":{"file_path":"/project/.env.local"}}'
expect_allow block-env-writes.sh '{"tool_input":{"file_path":"/project/.env.example"}}'
expect_allow block-env-writes.sh '{"tool_input":{"file_path":"/project/src/utils/client.env.ts"}}'
expect_allow block-env-writes.sh '{"tool_input":{}}'

# --- block-main-push.sh ------------------------------------------------------
expect_deny  block-main-push.sh '{"tool_input":{"command":"git push --mirror"}}'
expect_deny  block-main-push.sh '{"tool_input":{"command":"git push --all origin"}}'
expect_deny  block-main-push.sh '{"tool_input":{"command":"git push origin +main"}}'
expect_deny  block-main-push.sh '{"tool_input":{"command":"git push -f origin +master"}}'
expect_deny  block-main-push.sh '{"tool_input":{"command":"git -C repo push origin main"}}'
expect_allow block-main-push.sh '{"tool_input":{"command":"git push origin feature-branch"}}'
expect_allow block-main-push.sh '{"tool_input":{"command":"git push origin feature-main"}}'
expect_allow block-main-push.sh '{"tool_input":{"command":"git status"}}'
expect_allow block-main-push.sh '{"tool_input":{"command":"npx something push main"}}'
expect_allow block-main-push.sh '{"tool_input":{}}'

# --- block-bash-secrets.sh ---------------------------------------------------
expect_deny  block-bash-secrets.sh '{"tool_input":{"command":"cat .env"}}'
expect_deny  block-bash-secrets.sh '{"tool_input":{"command":"grep -R API_KEY ."}}'
expect_deny  block-bash-secrets.sh '{"tool_input":{"command":"rg API_KEY ."}}'
expect_deny  block-bash-secrets.sh '{"tool_input":{"command":"python3 -c \"open(.env).read()\""}}'
expect_deny  block-bash-secrets.sh '{"tool_input":{"command":"git log -p .env"}}'
expect_deny  block-bash-secrets.sh '{"tool_input":{"command":"git show HEAD:.env"}}'
expect_deny  block-bash-secrets.sh '{"tool_input":{"command":"git add .env"}}'
expect_deny  block-bash-secrets.sh '{"tool_input":{"command":"git add -f .env"}}'
expect_deny  block-bash-secrets.sh '{"tool_input":{"command":"cat keys/server.pem"}}'
expect_allow block-bash-secrets.sh '{"tool_input":{"command":"cat .env.example"}}'
expect_allow block-bash-secrets.sh '{"tool_input":{"command":"cat .env.sample"}}'
expect_allow block-bash-secrets.sh '{"tool_input":{"command":"grep NEXT_PUBLIC_ src/"}}'
expect_allow block-bash-secrets.sh '{"tool_input":{"command":"npm run env:check"}}'
expect_allow block-bash-secrets.sh '{"tool_input":{"command":"cat README.md"}}'
expect_allow block-bash-secrets.sh '{"tool_input":{}}'

# Documented edge case: bare `git stash show -p` allows, naming .env denies.
expect_allow block-bash-secrets.sh '{"tool_input":{"command":"git stash show -p"}}'
expect_deny  block-bash-secrets.sh '{"tool_input":{"command":"git stash show -p stash@{0} -- .env"}}'

# Accepted limitation: env-var reads (not files) are out of scope and allow.
expect_allow block-bash-secrets.sh '{"tool_input":{"command":"printenv API_KEY"}}'
# shellcheck disable=SC2016  # the payload must contain a literal $DATABASE_URL
expect_allow block-bash-secrets.sh '{"tool_input":{"command":"echo $DATABASE_URL"}}'
expect_allow block-bash-secrets.sh '{"tool_input":{"command":"python3 -c \"import os; print(os.environ['"'"'API_KEY'"'"'])\""}}'
expect_allow block-bash-secrets.sh '{"tool_input":{"command":"node -e \"console.log(process.env.SECRET)\""}}'

echo ""
echo "hook tests: $PASS passed, $FAIL failed, $((PASS + FAIL)) total"
[ "$FAIL" -eq 0 ] || exit 1
exit 0
