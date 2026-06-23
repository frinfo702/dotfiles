import type { Plugin } from "@opencode-ai/plugin";

const _STATE_DIR = ".opencode/state/continual-learning";

interface CadenceState {
  lastRun: number;
  turnCount: number;
  trialExpiresAt: number;
}

function now(): number {
  return Date.now();
}

function getDefaultCadence(state: CadenceState) {
  const isTrial = state.trialExpiresAt > 0 && now() < state.trialExpiresAt;
  return {
    minTurns: isTrial
      ? parseInt(
          process.env.CONTINUAL_LEARNING_TRIAL_MIN_TURNS ||
            process.env.CONTINUOUS_LEARNING_TRIAL_MIN_TURNS ||
            "3",
          10,
        )
      : parseInt(
          process.env.CONTINUAL_LEARNING_MIN_TURNS ||
            process.env.CONTINUOUS_LEARNING_MIN_TURNS ||
            "10",
          10,
        ),
    minMinutes: isTrial
      ? parseInt(
          process.env.CONTINUAL_LEARNING_TRIAL_MIN_MINUTES ||
            process.env.CONTINUOUS_LEARNING_TRIAL_MIN_MINUTES ||
            "15",
          10,
        )
      : parseInt(
          process.env.CONTINUAL_LEARNING_MIN_MINUTES ||
            process.env.CONTINUOUS_LEARNING_MIN_MINUTES ||
            "120",
          10,
        ),
    trialDurationMinutes: parseInt(
      process.env.CONTINUAL_LEARNING_TRIAL_DURATION_MINUTES ||
        process.env.CONTINUOUS_LEARNING_TRIAL_DURATION_MINUTES ||
        "1440",
      10,
    ),
  };
}

export const ContinualLearningPlugin: Plugin = async ({
  client,
  directory: _directory,
}) => {
  await client.app.log({
    body: {
      service: "continual-learning",
      level: "info",
      message: "continual-learning plugin initialized",
    },
  });

  return {
    event: async ({ event }) => {
      if (event.type === "session.created") {
        const cadence = getDefaultCadence({
          lastRun: 0,
          turnCount: 0,
          trialExpiresAt: now() + 24 * 60 * 60 * 1000,
        });

        await client.app.log({
          body: {
            service: "continual-learning",
            level: "debug",
            message: `new primary session, cadence: ${cadence.minTurns} turns, ${cadence.minMinutes} min`,
          },
        });
      }

      if (event.type === "session.idle") {
        await client.app.log({
          body: {
            service: "continual-learning",
            level: "info",
            message:
              "primary session idle, consider running continual-learning skill",
          },
        });
      }
    },
  };
};
