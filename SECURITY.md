# Security policy

## Reporting a vulnerability

If you discover a security issue in Ravie, please report it responsibly.

**Do not open a public issue.** Instead, use GitHub's private security advisory feature:

1. Go to the repository's **Security** tab
2. Click **Report a vulnerability**
3. Fill in the details

Include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if you have one)

You'll receive acknowledgment within 48 hours and a more detailed response within 7 days.

## Scope

Ravie is a set of markdown files, shell scripts, and JSON configuration. The main security concerns are:

- **Hook scripts** (`scripts/` (in the plugin) or `.claude/scripts/` (direct copy)) — these execute on your machine. Review them before use.
- **Settings.json** — defines what commands are allowed/denied. Review the permission list and adjust for your environment.
- **Skill content** — skills instruct the agent. Malicious skill content could instruct the agent to take harmful actions.

## Best practices when using Ravie

- Review hook scripts before enabling them
- Never commit `.env` files (the block-env-writes hook helps enforce this, but treat it as defense-in-depth, not a primary control)
- Review the `settings.json` allow/deny lists for your project
- When accepting community-contributed skills via PR, review the skill content for instructions that could harm your project
- Default to Tier 2 (draft only) approval mode unless you've reviewed what the agent will do
- Keep `jq` installed — hooks fail open without it (warning to stderr) rather than silently breaking
