import type { AgentPlugin } from "@cline/sdk"

const plugin: AgentPlugin = {
	name: "linear",
	manifest: {
		capabilities: ["skills"],
	},
}

export default plugin
