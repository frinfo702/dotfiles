import type { Plugin } from "@opencode-ai/plugin";

const DEV_PORTS = [3000, 3001, 4200, 5173, 8080, 8000, 5000, 8787, 3002];

const DEV_PATTERNS = [
  /\b(npm|yarn|pnpm|bun)\s+(run\s+)?dev\b/,
  /\bcargo\s+run\b/,
  /\bgo\s+run\b/,
  /\bpython.*\b(manage\.py|app\.py|main\.py|flask\s+run|fastapi\s+run|uvicorn|gunicorn)\b/,
  /\bnpx\s+\S*(dev|serve|start)\b/,
  /\bnext\s+dev\b/,
  /\bvite\b/,
  /\bwrangler\s+dev\b/,
];

async function killDevServers($: any, directory: string) {
  const ports = DEV_PORTS.map((p) => `:${p}`).join(",");
  try {
    const proc = await $`lsof -ti ${ports}`.nothrow();
    const pids = proc.stdout
      .toString()
      .trim()
      .split("\n")
      .filter(Boolean);
    if (pids.length > 0) {
      await $`kill ${pids.join(" ")}`.nothrow();
    }
  } catch {}
}

export const DevServerCleanup: Plugin = async ({ client, directory, $ }) => {
  await client.app.log({
    body: {
      service: "dev-server-cleanup",
      level: "info",
      message: "dev-server-cleanup plugin initialized",
    },
  });

  return {
    "tool.execute.after": async (input, output) => {
      if (input.tool !== "bash") return;

      const cmd: string = (input as any)?.args?.command ?? "";
      const matched = DEV_PATTERNS.some((p) => p.test(cmd));
      if (!matched) return;

      await client.app.log({
        body: {
          service: "dev-server-cleanup",
          level: "info",
          message: `dev server detected: ${cmd.substring(0, 200)}`,
        },
      });
    },

    event: async ({ event }) => {
      if (event.type === "session.deleted") {
        await client.app.log({
          body: {
            service: "dev-server-cleanup",
            level: "info",
            message: `session deleted, cleaning up dev servers on ports: ${DEV_PORTS.join(", ")}`,
          },
        });
        await killDevServers($, directory);
      }
    },
  };
};
