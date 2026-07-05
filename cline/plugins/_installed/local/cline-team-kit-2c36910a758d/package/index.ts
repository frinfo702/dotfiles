import type { AgentPlugin } from "@cline/sdk"

/**
 * Cline Team Kit — a skills-only plugin ported from the Cursor Team Kit.
 *
 * This plugin ships no runtime tools. All capabilities are bundled as skills
 * under `./skills/`, which Cline discovers automatically when the plugin is
 * loaded via `pluginPaths` or installed through the CLI.
 */
const plugin: AgentPlugin = {
	name: "cline-team-kit",
	manifest: {
		capabilities: ["skills"],
	},
}

export default plugin
