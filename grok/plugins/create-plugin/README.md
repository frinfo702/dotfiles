# Create plugin (Grok port)

Meta workflows for creating Grok plugins that are marketplace-ready. Ported from [cursor/plugins/create-plugin](https://github.com/cursor/plugins/tree/main/create-plugin).

Upstream commit reference: `11ecc12a3ffc037b4ef3b64de2be449668e8afc7`.

## Installation

Already available under `~/.grok/plugins/create-plugin` when this dotfiles tree is linked. Enable in `config.toml`:

```toml
[plugins]
enabled = ["create-plugin"]
```

Or install / enable via the TUI (`/plugins`) or CLI:

```bash
grok plugin enable create-plugin
```

## Components

### Skills

| Skill | Description |
|:------|:------------|
| `create-plugin-scaffold` | Scaffold a new plugin directory with manifest, components, and repository wiring |
| `review-plugin-submission` | Run a pre-submission quality check against marketplace expectations |

### Rules

| Rule | Description |
|:-----|:------------|
| `plugin-quality-gates` | Keep plugin manifests, component metadata, and paths valid and consistent |

### Agents

| Agent | Description |
|:------|:------------|
| `plugin-architect` | Design plugin structure and component mix based on a concrete use case |

### Commands

| Command | Description |
|:--------|:------------|
| `create-plugin` | Build a new plugin scaffold with the right files and metadata |

## Typical flow

1. Use `/create-plugin` with a plugin name, purpose, and target component types.
2. Generate or update `plugin.json` under `.grok-plugin/`, then add rules/skills/agents/commands as needed.
3. Run `review-plugin-submission` before publishing or marketplace submission.

## Default output location

New plugins default to:

```
~/.grok/plugins/<plugin-name>/
```

## License

MIT
