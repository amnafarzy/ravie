# Installation

Ravie ships as a Claude Code plugin. Pick the install method that fits your workflow.

---

## Option A: Plugin marketplace (recommended)

The standard install. Use the plugin marketplace for versioned installs and updates.

**Prerequisite:** Claude Code installed. See https://docs.claude.com.

In Claude Code, run:
```
/plugin marketplace add amnafarzy/ravie
/plugin install ravie@ravie
```

Then in any project:
```bash
cd /path/to/your/project
curl -O https://raw.githubusercontent.com/amnafarzy/ravie/main/quickstart/CLAUDE.md
# Edit CLAUDE.md — fill in your stack and commands
```

Reload plugins:
```
/reload-plugins
```

Test with:
```
> "Read CLAUDE.md and tell me what you understand about this project."
```

**Updating:** `/plugin update ravie`  
**Uninstalling:** `/plugin uninstall ravie`

---

## Option B: Local plugin directory (for plugin development)

If you want to modify the plugin itself or test changes before they hit the marketplace, clone the repo and add it as a local marketplace:

```bash
git clone https://github.com/amnafarzy/ravie.git ~/code/ravie
```

In Claude Code, add the local checkout as a marketplace and install from it:
```
/plugin marketplace add ~/code/ravie
/plugin install ravie@ravie
```

After editing plugin files, run `/reload-plugins` to pick up changes.

---

## Option C: Direct file copy (no plugin system)

If you don't want to use the Claude Code plugin system and prefer to copy files directly into your project:

```bash
git clone https://github.com/amnafarzy/ravie.git ~/code/ravie
cd /path/to/your/project

# Copy components into the local .claude/ directory
mkdir -p .claude
cp -r ~/code/ravie/skills .claude/skills
cp -r ~/code/ravie/agents .claude/agents
cp -r ~/code/ravie/scripts .claude/scripts
cp -r ~/code/ravie/rules .claude/rules
cp ~/code/ravie/settings.example.json .claude/settings.json

# Reference docs at root
cp ~/code/ravie/ROUTER.md .
cp ~/code/ravie/PERMISSION-MODEL.md .

# Project entry point
cp ~/code/ravie/CLAUDE-TEMPLATE.md ./CLAUDE.md
# Edit CLAUDE.md and fill it in

git add .claude ROUTER.md PERMISSION-MODEL.md CLAUDE.md
git commit -m "Install Ravie"
```

**Important note:** when using direct file copy, hook commands in `.claude/settings.json` use `${CLAUDE_PROJECT_DIR}` instead of `${CLAUDE_PLUGIN_ROOT}`. The `settings.example.json` shipped with this repo already uses `${CLAUDE_PROJECT_DIR}` so it works out of the box for direct-copy installs.

**Pros:** Self-contained. Works offline. No plugin dependency.  
**Cons:** No automatic updates. Skills don't sync across projects without manual re-copy.

---

## Verifying the install

In your project root:

```
> "Read CLAUDE.md and tell me back what you understand about this project's stack and conventions."
```

Then test that skills are accessible:

```
> "Read the issue-to-pr skill and tell me when to use it."
```

For plugin installs, the agent should find the bundled `skills/issue-to-pr/SKILL.md`. For direct-copy installs, Claude reads it from `.claude/skills/issue-to-pr/SKILL.md`.

Then test a hook directly from a plugin checkout:

```bash
cd /path/to/ravie
echo '{"tool_input":{"command":"git push origin main"}}' | bash scripts/block-main-push.sh
# Should output JSON with "permissionDecision": "deny"
```

For direct-copy installs, test the copied hook path instead:

```bash
echo '{"tool_input":{"command":"git push origin main"}}' | bash .claude/scripts/block-main-push.sh
```

---

## Companion plugins (recommended)

Ravie layers cleanly with two other plugins. Install both for the full stack:

```
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace

/plugin marketplace add forrestchang/andrej-karpathy-skills
/plugin install andrej-karpathy-skills@karpathy-skills
```

**Superpowers** handles workflow methodology (planning, TDD, debugging, code review process).  
**Karpathy Guidelines** handles behavioral rules (the LLM-as-junior-developer rules).  
**Ravie** handles project context, skills, hooks, and subagents.

These are complementary, not redundant. See `START-HERE.md` for the layering rationale.

---

## MCP connectors (optional)

Skills work without connectors — Claude can do most work from code reading and pasted context. Add MCP connectors after 2 weeks of real use, only for integrations you keep needing.

For the default stack, the relevant official MCP servers are:
- Linear (issues)
- Notion (knowledge base)
- GitHub (PRs, repos)
- Supabase (database — evaluate carefully; community servers exist with write access)

Each connector should respect the permission model in `PERMISSION-MODEL.md`. Default to read-only scopes.

---

## Updating

**Plugin install:** `/plugin update ravie`

**Local plugin dir:** `cd ~/code/ravie && git pull`, then `/reload-plugins`.

**Direct copy:** Re-run the copy commands from Option C, or write a small sync script.

---

## Uninstalling

**Plugin install:** `/plugin uninstall ravie`

**Direct copy:**
```bash
cd /path/to/project
rm -rf .claude ROUTER.md PERMISSION-MODEL.md CLAUDE.md
```
