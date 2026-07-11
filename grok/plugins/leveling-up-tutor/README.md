# Leveling Up Tutor

Educational Grok plugin that **raises the learner’s coding ability** (and design, reading, ML engineering, ML research) **without writing code for them**.

Writes are blocked by hooks. Progress (levels, skills, quests) is **global**, stored outside any single project.

## Features

- **No ghostwriting** — edit tools denied; shell file writes denied; illustrative snippets only
- **Logarithmic, uncapped levels** — L70 ≈ solo substantial OSS; L100 ≈ world-class rare
- **Skill tree** — languages (e.g. Go Lv2), engineering, design, reading, ML eng, ML research
- **Hooks**
  - `PreToolUse` — block writes
  - `SessionStart` — inject level/skills context
  - `Stop` — nudge XP award after educational turns
- **Commands**
  - `/leveling-progress` — level, XP bar, skills
  - `/leveling-quest` — deliberate-practice quest
  - `/leveling-assess` — score turn + award XP
- **Agent** — `leveling-tutor` (readonly coaching persona)

## Install / enable

Source lives at:

```text
~/.grok/plugins/leveling-up-tutor/
```

Install (registers into Grok’s plugin registry) and enable:

```bash
grok plugin install ~/.grok/plugins/leveling-up-tutor --trust
grok plugin enable leveling-up-tutor
```

Or list it under `~/.grok/config.toml`:

```toml
[plugins]
enabled = ["leveling-up-tutor"]
```

After editing the plugin source, re-run `grok plugin install ~/.grok/plugins/leveling-up-tutor --trust` so the installed copy stays in sync. Reload plugins (`r` in the Plugins tab) or start a new session.

## Global progress data

Not in the plugin source tree (so it stays global and uncommitted with projects):

| Path | Purpose |
|------|---------|
| `$GROK_PLUGIN_DATA/progress.json` | Canonical state (hooks set this) |
| `~/.grok/plugin-data/leveling-up-tutor/progress.json` | Fallback when env unset |
| `history.jsonl` | Append-only XP events |

Inspect:

```bash
python3 ~/.grok/plugins/leveling-up-tutor/scripts/progress.py path
python3 ~/.grok/plugins/leveling-up-tutor/scripts/progress.py show
```

## Level curve

```text
level = floor(14 * ln(1 + total_xp / 120)) + 1
```

No maximum. Skill levels use a slightly faster curve (`SCALE=10`, `BASE=40`).

## Award XP (tutor / agent)

```bash
python3 "$GROK_PLUGIN_ROOT/scripts/progress.py" award \
  --compute \
  --lines 40 \
  --quality 0.75 --depth 0.7 --design 0.4 \
  --debugging 0.6 --testing 0.5 \
  --skill go:15 --skill testing:10 \
  --reason "implemented retry with tests"
```

## Layout

```text
leveling-up-tutor/
├── .grok-plugin/plugin.json
├── agents/leveling-tutor.md
├── commands/
│   ├── leveling-progress.md
│   ├── leveling-quest.md
│   └── leveling-assess.md
├── hooks/
│   ├── hooks.json
│   ├── block-writes.sh
│   ├── session-start.sh
│   └── session-stop.sh
├── rules/
│   ├── never-write-code.md
│   └── tutor-pedagogy.md
├── skills/
│   ├── leveling-up-tutor/
│   └── assess-and-award-xp/
└── scripts/progress.py
```

## Philosophy

The tutor optimizes for **independence**: Socratic questions, progressive hints, design-before-code, code reading, experiment design, and honest XP. High levels mean judgment under ambiguity—not autocomplete dependency.

## License

MIT
