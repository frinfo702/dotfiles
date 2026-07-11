---
description: "Build a new Grok plugin scaffold with the right files and metadata"
argument-hint: "[plugin-name] [purpose...]"
---

# Create plugin

Scaffold a new Grok plugin using the `create-plugin-scaffold` skill.

## Arguments

$ARGUMENTS

## Instructions

1. Parse the user arguments for:
   - Plugin name (lowercase kebab-case)
   - Purpose / target users
   - Optional component types (`rules`, `skills`, `agents`, `commands`, `hooks`, `mcpServers`)
2. If required inputs are missing, ask briefly for them.
3. Follow the **create-plugin-scaffold** skill end-to-end:
   - Default output: `~/.grok/plugins/<plugin-name>/`
   - Create `.grok-plugin/plugin.json`, `README.md`, `LICENSE`, and requested components
4. After scaffolding, give a short validation report and how to enable the plugin:

```toml
[plugins]
enabled = ["<plugin-name>"]
```

Or: `grok plugin enable <plugin-name>`
