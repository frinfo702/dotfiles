import type { Plugin } from "@opencode-ai/plugin";

export const EnvProtection: Plugin = async ({ client }) => {
  await client.app.log({
    body: {
      service: "env-protection",
      level: "info",
      message: "env-protection plugin initialized",
    },
  });

  return {
    "tool.execute.before": async (input, output) => {
      if (input.tool === "read" && output.args?.filePath?.includes(".env")) {
        throw new Error("🚫 Cannot read .env files");
      }
    },
  };
};
