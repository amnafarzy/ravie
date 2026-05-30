# Hooks guide

CLAUDE.md is advisory. Hooks are deterministic guardrails for the tool calls they cover. Use hooks for anything that MUST be blocked or checked by the local Claude Code runtime.

---

## What hooks are

Hooks are scripts that run automatically at specific points in Claude Code's workflow. They're defined in `hooks/hooks.json` (plugin) or `.claude/settings.json` (direct copy) and fire on events like file edits, command execution, and session stops.

Unlike CLAUDE.md rules, which Claude interprets and may occasionally skip, hooks are executed by the runtime. Claude cannot choose to ignore a hook that is configured and available.

## When to use hooks vs rules vs CLAUDE.md

| Enforcement need | Where to put it |
|---|---|
| Must be enforced for covered Claude Code tool calls: formatting, blocking `.env` writes, blocking Bash secret access, protected branch pushes | **Hook** |
| Domain-specific guidance that skills or CLAUDE.md should explicitly reference when needed: Supabase patterns, Git conventions, UI rules | **Rule reference** (`.claude/rules/`) |
| Project-wide context: stack, commands, priorities | **CLAUDE.md** |
| Personal preferences: code style, communication | **CLAUDE.local.md** or `~/.claude/CLAUDE.md` |

## The hooks included in Ravie

### 1. Auto-format on file edit

`auto-format.sh` runs Prettier after any file Claude writes or edits, if `npx` and Prettier are available. It fails open when formatting is unavailable so it does not block work.

### 2. Block `.env` writes

`block-env-writes.sh` prevents Claude from writing to real `.env` files. It allows sanitized examples such as `.env.example`, `.env.sample`, `.env.template`, and `.env.local.example` so documentation and onboarding files can still be maintained.

### 3. Block Bash secret reads/writes/searches

`block-bash-secrets.sh` closes the gap where Bash commands can read or stage files that `Read()` and `Write()` permission rules would otherwise protect. It blocks commands that reference real `.env` files, `secrets/`, `credentials.json`, `*.pem`, `id_rsa`, or `id_ed25519`; it also blocks recursive repository searches such as `grep -R ... .`, `rg ... .`, and `find . -exec ...` that can sweep secrets without naming a secret file directly.

Sanitized example files are intentionally allowed. This is a design choice: `.env.example`, `.env.sample`, `.env.template`, and `.env.local.example` should be readable and writable when they contain placeholders only.

### 4. Block protected branch pushes

`block-main-push.sh` prevents direct, forced, mirrored, or bulk pushes that could affect `main` or `master`. It blocks forms such as `git push origin main`, `git push origin HEAD:main`, `git push --mirror`, `git push --all origin`, and plus-refspecs like `git push origin +main`.

## Configuration

Hooks live in `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"${CLAUDE_PROJECT_DIR:-.}/.claude/scripts/auto-format.sh\""
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"${CLAUDE_PROJECT_DIR:-.}/.claude/scripts/block-env-writes.sh\""
          }
        ]
      },
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"${CLAUDE_PROJECT_DIR:-.}/.claude/scripts/block-main-push.sh\""
          },
          {
            "type": "command",
            "command": "bash \"${CLAUDE_PROJECT_DIR:-.}/.claude/scripts/block-bash-secrets.sh\""
          }
        ]
      }
    ]
  }
}
```

## Writing your own hooks

When you notice a rule in CLAUDE.md that Claude keeps violating, convert it to a hook:

1. Write a shell script in `.claude/scripts/`.
2. The script receives tool input via stdin as JSON.
3. Parse the input with `jq`; do not parse JSON with grep or sed.
4. To block with structured feedback, print JSON to stdout with `hookSpecificOutput.permissionDecision: "deny"`, then `exit 0`.
5. Add the hook to `.claude/settings.json`.
6. Test by piping sample JSON payloads to the script. Include both block and allow cases.

**Important hook signaling.** Claude Code parses JSON from stdout only when the hook exits with code 0. Exit 2 blocks the tool but ignores stdout. Use exit 0 + structured JSON for rich blocking, or exit 2 + stderr for simple blocking. Do not mix exit 2 with JSON on stdout.

Example — blocking writes to a protected directory:

```bash
#!/usr/bin/env bash
set -euo pipefail

if ! command -v jq >/dev/null 2>&1; then
  echo "warning: jq not installed; hook is not enforcing" >&2
  exit 0
fi

INPUT=$(cat)
FILE_PATH=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null || true)
[ -z "$FILE_PATH" ] && exit 0

if [[ "$FILE_PATH" == *"protected/"* ]]; then
  jq -n --arg reason "Cannot write to protected/. These files are managed manually." \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$reason}}'
  exit 0
fi

exit 0
```

## Hook events available

- **PreToolUse** — fires before a tool runs. Can block the action.
- **PostToolUse** — fires after a tool runs. Can provide feedback and side effects such as formatting.
- **Stop** — fires when Claude finishes a response. Can nudge it to continue or verify.
