# Cursor Team Kit plugin (Grok port)

Internal-style workflows for CI, code review, shipping, and test reliability. Ported from [cursor/plugins/cursor-team-kit](https://github.com/cursor/plugins/tree/main/cursor-team-kit) for Grok. Designed to be plug-and-play without third-party service integrations beyond `git`/`gh` and local tooling.

Upstream commit reference: `11ecc12a3ffc037b4ef3b64de2be449668e8afc7`.

## Installation

From this repo (user plugins path):

```bash
grok plugin install ./plugins/cursor-team-kit --trust
grok plugin enable cursor-team-kit
```

Or add the path and enable in `~/.grok/config.toml`:

```toml
[plugins]
paths = ["~/ghq/github.com/frinfo702/dotfiles/grok/plugins"]
enabled = ["cursor-team-kit"]
```

Then run `/plugins` and press `r` to reload, or restart Grok.

## Grok adaptations

| Cursor | Grok |
|--------|------|
| `.cursor-plugin/plugin.json` | `.grok-plugin/plugin.json` |
| Agent `model: fast`, `is_background` | `model: inherit`, standard Grok agent frontmatter |
| Task tool / `subagent_type: "shell"` | `spawn_subagent` / `general-purpose` + `explore` |
| Plugin `rules/*.mdc` (`alwaysApply`) | `rules/*.md` for reference + skill wrappers (plugins do not auto-inject rules) |
| Cursor chat mining | Grok `~/.grok/sessions/` + other transcript sources |
| In-app browser for PR canvas | Local HTTP server + browser MCP / open URL |

Skills are mostly unchanged and work as slash commands (`/loop-on-ci`, `/review-and-ship`, …).

## Components

### Skills

| Skill | Description |
| ----- | ----------- |
| `loop-on-ci` | Watch CI runs and iterate on failures until checks pass |
| `review-and-ship` | Run a structured review, commit changes, and open a PR |
| `pr-review-canvas` | Generate an interactive HTML PR walkthrough |
| `verify-this` | Prove or disprove claims with baseline/treatment artifacts |
| `control-cli` | Local harness for interactive CLIs/TUIs |
| `control-ui` | Local browser/CDP harness for web or Electron UIs |
| `make-pr-easy-to-review` | Clean PR history, descriptions, reviewer guidance |
| `run-smoke-tests` | Run Playwright smoke tests and triage failures |
| `fix-ci` | Find failing CI jobs, inspect logs, apply fixes |
| `new-branch-and-pr` | Fresh branch, complete work, open a PR |
| `get-pr-comments` | Fetch and summarize PR review comments |
| `check-compiler-errors` | Compile/type-check and report failures |
| `what-did-i-get-done` | Summarize authored commits over a period |
| `weekly-review` | Weekly recap of shipped work |
| `fix-merge-conflicts` | Resolve conflicts, validate build/tests |
| `deslop` | Remove AI-generated code slop |
| `workflow-from-chats` | Extract durable prefs from sessions into skills/rules |
| `thermo-nuclear-code-quality-review` | Strict maintainability review rubric |
| `no-inline-imports` | Keep imports at module top-level |
| `typescript-exhaustive-switch` | Exhaustive switch handling for unions/enums |

### Agents

| Agent | Description |
| ----- | ----------- |
| `ci-watcher` | Monitor GitHub Actions / PR checks and summarize |
| `thermo-nuclear-code-quality-review` | Subagent that runs the thermo-nuclear rubric against a diff |

### Rules (reference)

Grok plugins do not auto-load `rules/`. For always-on project rules, copy into the project:

```bash
mkdir -p .grok/rules
cp plugins/cursor-team-kit/rules/*.md .grok/rules/
```

Or rely on the matching skills (`no-inline-imports`, `typescript-exhaustive-switch`), which the model can invoke automatically.

| Rule | Description |
| ---- | ----------- |
| `typescript-exhaustive-switch` | Exhaustive switch handling for unions/enums |
| `no-inline-imports` | Imports at module top-level |

## License

MIT (Copyright Cursor; port packaging for Grok)
