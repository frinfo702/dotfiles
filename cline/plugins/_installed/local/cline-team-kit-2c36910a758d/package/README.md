# Cline Team Kit plugin

A [Cline](https://cline.bot) plugin ported from the Cursor **Team Kit**. Internal-style workflows for CI, code review, shipping, and test reliability. The kit is designed to be plug and play without requiring third-party service integrations.

This is a **skills-only** plugin: it ships no runtime tools, only bundled skills that Cline discovers automatically.

> **Source:** Ported from [`cursor/plugins` → `cursor-team-kit`](https://github.com/cursor/plugins/tree/11ecc12a3ffc037b4ef3b64de2be449668e8afc7/cursor-team-kit) (commit `11ecc12a`), reformatted to the [Cline plugin format](https://docs.cline.bot/sdk/guides/writing-plugins).

## Installation

### From a local path

```bash
cline plugin install /path/to/cline-team-kit
```

### From git

```bash
cline plugin install https://github.com/cursor/plugins.git
```

> The original repo contains multiple Cursor plugins. To install just this directory, point the CLI at this folder or copy it into its own repository first.

### Load directly via `pluginPaths`

```ts
import { ClineCore } from "@cline/sdk"

const cline = await ClineCore.create({ clientName: "my-app" })
await cline.start({
	config: {
		systemPrompt: "Use the Cline Team Kit skills.",
		pluginPaths: ["/absolute/path/to/cline-team-kit/index.ts"],
	},
})
```

## How the port maps

The Cursor plugin shipped three kinds of content. Cline plugins can only bundle **skills** (plus TypeScript tools/hooks), so everything was normalized to skills:

| Cursor concept | Cursor location | Cline location | Notes |
|:---------------|:----------------|:---------------|:------|
| Skills (18) | `skills/*/SKILL.md` | `skills/*/SKILL.md` | Ported verbatim. The `SKILL.md` frontmatter (`name`, `description`) is identical between Cursor and Cline. |
| Agents (2) | `agents/*.md` | `skills/*/SKILL.md` | Converted to skills. In Cline, use them as the system prompt for a sub-agent (`spawn_agent`) or invoke inline. |
| Rules (2) | `rules/*.mdc` | `skills/*/SKILL.md` | Converted to skills. Cursor rules were `alwaysApply: true`; to make them always-on in Cline, copy the rule text into your project's `.clinerules` file. |

## Components

### Skills (ported from Cursor skills)

| Skill | Description |
|:------|:------------|
| `loop-on-ci` | Watch CI runs and iterate on failures until checks pass |
| `review-and-ship` | Run a structured review, commit changes, and open a PR |
| `pr-review-canvas` | Generate an interactive HTML PR walkthrough with annotated, categorized diffs |
| `verify-this` | Prove or disprove claims with baseline/treatment artifacts and a clear verdict |
| `control-cli` | Build or adapt a local harness to drive and profile interactive CLIs or TUIs |
| `control-ui` | Build or adapt a local browser/CDP harness for web or Electron UIs |
| `make-pr-easy-to-review` | Clean noisy PR history, improve descriptions, and add reviewer guidance |
| `run-smoke-tests` | Run Playwright smoke tests and triage failures |
| `fix-ci` | Find failing CI jobs, inspect logs, and apply focused fixes |
| `new-branch-and-pr` | Create a fresh branch, complete work, and open a pull request |
| `get-pr-comments` | Fetch and summarize review comments from the active pull request |
| `check-compiler-errors` | Run compile and type-check commands and report failures |
| `what-did-i-get-done` | Summarize authored commits over a given time period into a concise status update |
| `weekly-review` | Generate a weekly recap of shipped work with bugfix/tech-debt/net-new highlights |
| `fix-merge-conflicts` | Resolve merge conflicts, validate build/tests, and summarize decisions |
| `deslop` | Remove AI-generated code slop and clean up code style |
| `workflow-from-chats` | Extract durable working preferences from chats into skills, rules, or docs |
| `thermo-nuclear-code-quality-review` | Run an unusually strict maintainability review (code-judo, 1k-line rule, spaghetti, boundaries) |

### Skills (converted from Cursor agents)

| Skill | Description |
|:------|:------------|
| `ci-watcher` | Monitor GitHub Actions runs and return concise pass/fail summaries |
| `thermo-nuclear-code-quality-review` | Doubles as the sub-agent prompt for a thermo-nuclear code quality audit (see the "Sub-agent Usage" section in its `SKILL.md`) |

### Skills (converted from Cursor rules)

| Skill | Description |
|:------|:------------|
| `typescript-exhaustive-switch` | Require exhaustive switch handling for unions/enums |
| `no-inline-imports` | Keep imports at module top-level for readability and consistency |

## License

MIT — see [LICENSE](./LICENSE). Original copyright Cursor.
