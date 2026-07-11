# UI/UX Pro Max (Grok plugin)

Design intelligence for professional UI/UX across web and mobile stacks. Ported from [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) for Grok.

Upstream commit reference: `3da52ff1cab1be91848072ec1be5f493d730fd5f` (v2.6.2).

## Installation

From this repo (user plugins path):

```bash
cd ~/ghq/github.com/frinfo702/dotfiles/grok
grok plugin install ./plugins/ui-ux-pro-max --trust
grok plugin enable ui-ux-pro-max
```

Or add the plugins path and enable in `~/.grok/config.toml`:

```toml
[plugins]
paths = ["~/ghq/github.com/frinfo702/dotfiles/grok/plugins"]
enabled = ["ui-ux-pro-max"]
```

Then run `/plugins` and press `r` to reload, or restart Grok.

Validate the manifest anytime:

```bash
grok plugin validate ./plugins/ui-ux-pro-max
```

## Prerequisites

Python 3.x is required for the search / design-system scripts (standard library only — no packages, no network).

```bash
python3 --version
```

## Grok adaptations

| Upstream (Claude) | Grok |
|-------------------|------|
| `.claude-plugin/plugin.json` | `.grok-plugin/plugin.json` |
| `.claude/skills/*` | `skills/*` |
| `python3 skills/ui-ux-pro-max/scripts/...` | `python3 scripts/search.py` (relative to skill root) |
| Claude marketplace install | `grok plugin install` / local path |

Main skill data is taken from upstream `src/ui-ux-pro-max` (full stack CSVs including desktop platforms). Companion skills match the official Claude plugin packaging under `.claude/skills/`.

## Components

### Skills

| Skill | Description |
| ----- | ----------- |
| `ui-ux-pro-max` | Core design intelligence: BM25 search over styles, colors, typography, UX rules, stacks; `--design-system` generator |
| `design` | Unified design skill (brand, tokens, logo, CIP, banners, icons, social) |
| `design-system` | Token architecture, component specs, slide generation |
| `ui-styling` | shadcn/ui + Tailwind + canvas visual design |
| `brand` | Brand voice, visual identity, messaging |
| `banner-design` | Multi-format banner design |
| `slides` | Strategic HTML presentations |

### Core CLI (ui-ux-pro-max)

```bash
# From skills/ui-ux-pro-max/
python3 scripts/search.py "beauty spa wellness" --design-system -p "Serenity Spa"
python3 scripts/search.py "glassmorphism" --domain style
python3 scripts/search.py "form validation" --stack react
python3 scripts/search.py "SaaS dashboard" --design-system --persist -p "MyApp"
```

## License

MIT (Copyright Next Level Builder; Grok packaging in this repo).
