# Testing Ravie hooks

Run these from the repo root. Hooks read Claude Code tool payloads from stdin and emit structured JSON with `hookSpecificOutput.permissionDecision: "deny"` when they block. Allow cases should print no stdout and exit 0.

Requirements:

```bash
command -v bash
command -v jq
```

## Syntax and settings checks

```bash
bash -n .claude/scripts/*.sh
jq empty .claude/settings.json
stat -c '%a %n' .claude/scripts/*.sh
```

Expected:
- `bash -n` prints nothing and exits 0.
- `jq empty` prints nothing and exits 0.
- Hook scripts are executable, typically mode `755`.

## `block-env-writes.sh`

Block real env files:

```bash
echo '{"tool_input":{"file_path":"/project/.env"}}' | bash .claude/scripts/block-env-writes.sh
echo '{"tool_input":{"file_path":"/project/.env.local"}}' | bash .claude/scripts/block-env-writes.sh
```

Expected: JSON containing `"permissionDecision": "deny"`.

Allow sanitized examples and unrelated files:

```bash
echo '{"tool_input":{"file_path":"/project/.env.example"}}' | bash .claude/scripts/block-env-writes.sh
echo '{"tool_input":{"file_path":"/project/src/utils/client.env.ts"}}' | bash .claude/scripts/block-env-writes.sh
echo '{"tool_input":{}}' | bash .claude/scripts/block-env-writes.sh
```

Expected: no stdout, exit 0.

## `block-main-push.sh`

These bypass cases must all block:

```bash
echo '{"tool_input":{"command":"git push --mirror"}}' | bash .claude/scripts/block-main-push.sh
echo '{"tool_input":{"command":"git push --all origin"}}' | bash .claude/scripts/block-main-push.sh
echo '{"tool_input":{"command":"git push origin +main"}}' | bash .claude/scripts/block-main-push.sh
echo '{"tool_input":{"command":"git push -f origin +master"}}' | bash .claude/scripts/block-main-push.sh
echo '{"tool_input":{"command":"git -C repo push origin main"}}' | bash .claude/scripts/block-main-push.sh
```

Expected: JSON containing `"permissionDecision": "deny"`.

These cases must allow:

```bash
echo '{"tool_input":{"command":"git push origin feature-branch"}}' | bash .claude/scripts/block-main-push.sh
echo '{"tool_input":{"command":"git push origin feature-main"}}' | bash .claude/scripts/block-main-push.sh
echo '{"tool_input":{"command":"git status"}}' | bash .claude/scripts/block-main-push.sh
echo '{"tool_input":{"command":"npx something push main"}}' | bash .claude/scripts/block-main-push.sh
echo '{"tool_input":{}}' | bash .claude/scripts/block-main-push.sh
```

Expected: no stdout, exit 0.

## `block-bash-secrets.sh`

These secret access and bypass cases must all block:

```bash
echo '{"tool_input":{"command":"cat .env"}}' | bash .claude/scripts/block-bash-secrets.sh
echo '{"tool_input":{"command":"grep -R API_KEY ."}}' | bash .claude/scripts/block-bash-secrets.sh
echo '{"tool_input":{"command":"rg API_KEY ."}}' | bash .claude/scripts/block-bash-secrets.sh
echo '{"tool_input":{"command":"python3 -c \"open(.env).read()\""}}' | bash .claude/scripts/block-bash-secrets.sh
echo '{"tool_input":{"command":"git log -p .env"}}' | bash .claude/scripts/block-bash-secrets.sh
echo '{"tool_input":{"command":"git show HEAD:.env"}}' | bash .claude/scripts/block-bash-secrets.sh
echo '{"tool_input":{"command":"git add .env"}}' | bash .claude/scripts/block-bash-secrets.sh
echo '{"tool_input":{"command":"git add -f .env"}}' | bash .claude/scripts/block-bash-secrets.sh
echo '{"tool_input":{"command":"cat keys/server.pem"}}' | bash .claude/scripts/block-bash-secrets.sh
```

Expected: JSON containing `"permissionDecision": "deny"`.

These documentation and normal-work cases must allow:

```bash
echo '{"tool_input":{"command":"cat .env.example"}}' | bash .claude/scripts/block-bash-secrets.sh
echo '{"tool_input":{"command":"cat .env.sample"}}' | bash .claude/scripts/block-bash-secrets.sh
echo '{"tool_input":{"command":"grep NEXT_PUBLIC_ src/"}}' | bash .claude/scripts/block-bash-secrets.sh
echo '{"tool_input":{"command":"npm run env:check"}}' | bash .claude/scripts/block-bash-secrets.sh
echo '{"tool_input":{"command":"cat README.md"}}' | bash .claude/scripts/block-bash-secrets.sh
echo '{"tool_input":{}}' | bash .claude/scripts/block-bash-secrets.sh
```

Expected: no stdout, exit 0.

### Documented edge case: `git stash show -p`

```bash
echo '{"tool_input":{"command":"git stash show -p"}}' | bash .claude/scripts/block-bash-secrets.sh
echo '{"tool_input":{"command":"git stash show -p stash@{0} -- .env"}}' | bash .claude/scripts/block-bash-secrets.sh
```

Expected: the first **allows** (no stdout, exit 0); the second **blocks** (`permissionDecision: "deny"`).

`git stash show -p` on its own prints the diff of stashed *tracked* changes and is a routine review command, so it is intentionally allowed — blocking it would be a false positive for normal work. A `.env` is gitignored in a normal project and is not stashed unless you force it, so a bare `git stash show -p` does not leak it. The moment the command names a secret path explicitly (`-- .env`), the existing path matcher denies it, as the second case shows.

### Accepted limitation: reading environment *variables* (not files)

```bash
echo '{"tool_input":{"command":"printenv API_KEY"}}' | bash .claude/scripts/block-bash-secrets.sh
echo '{"tool_input":{"command":"echo $DATABASE_URL"}}' | bash .claude/scripts/block-bash-secrets.sh
echo '{"tool_input":{"command":"python3 -c \"import os; print(os.environ['"'"'API_KEY'"'"'])\""}}' | bash .claude/scripts/block-bash-secrets.sh
echo '{"tool_input":{"command":"node -e \"console.log(process.env.SECRET)\""}}' | bash .claude/scripts/block-bash-secrets.sh
```

Expected: all **allow** (no stdout, exit 0).

This hook is **path-based**: it blocks shell references to secret *files* (`.env`, `secrets/`, `*.pem`, `id_rsa`, `id_ed25519`, `credentials.json`) and recursive secret discovery. It does **not** inspect reads of environment variables already loaded into the process (`printenv`, `echo $VAR`, `os.environ`, `process.env`). Blocking those would false-positive on routine commands such as `echo $HOME` or `echo $PATH`. Treat in-process env-var access as out of scope for this hook; the deny list in `settings.json` plus not committing real `.env` files is the control there.

## Missing `jq` behavior

Hooks fail open when `jq` is unavailable so they do not break Claude Code on machines that have not installed dependencies yet:

```bash
echo '{"tool_input":{"command":"cat .env"}}' | env PATH=/tmp /bin/bash .claude/scripts/block-bash-secrets.sh
```

Expected: stderr warning about `jq` and exit 0. Reinstall `jq` before relying on hooks for enforcement.

## Adding new bypass tests

When you find a bypass, add both a block case and a nearby allow case. For example, if a new command can expose `.env`, add the exact payload that must block and an adjacent benign command that should still allow. Keep the test payloads copy-pasteable so reviewers can verify hook behavior without running Claude Code.
