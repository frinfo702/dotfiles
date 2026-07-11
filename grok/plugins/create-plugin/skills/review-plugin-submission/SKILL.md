---
name: review-plugin-submission
description: Audit a Grok plugin for marketplace readiness. Use when validating manifests, component metadata, discovery paths, and submission quality before publishing.
---

# Review plugin submission

## Trigger

A plugin is implemented and needs a final quality check before submission or release.

## Workflow

1. Verify manifest validity:
   - `.grok-plugin/plugin.json` exists (or root `plugin.json` if that is the repo convention)
   - `name` is valid lowercase kebab-case
   - metadata fields are coherent (`description`, `version`, `author`, `license`)
2. Verify component discoverability:
   - Skills in `skills/*/SKILL.md`
   - Rules in `rules/` as markdown
   - Agents in `agents/` markdown files
   - Commands in `commands/` markdown or text files
   - Hooks in `hooks/hooks.json`
   - MCP config in `.mcp.json` (or `mcpServers` override)
3. Verify component metadata:
   - Skills include `name` and `description` frontmatter
   - Rules include valid frontmatter and clear guidance
   - Agents and commands include `name` and/or `description`
4. Verify repository integration:
   - For multi-plugin marketplaces, the plugin is listed and `source` resolves uniquely
   - Enablement documented (`enabled` in config, or install instructions)
5. Verify documentation quality:
   - `README.md` states purpose, installation, and component coverage
   - optional logo path is valid and repository-hosted
6. Optionally run `grok plugin validate <path>` and report the result.

## Checklist

- Manifest exists and parses as valid JSON
- All declared paths exist and are relative
- No broken file references
- No missing frontmatter on skills/rules/agents/commands
- Plugin scope is clear and focused
- Marketplace / config registration complete (if multi-plugin repo)

## Output

- Pass/fail report by section
- Prioritized fix list
- Final submission recommendation
