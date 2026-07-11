#!/usr/bin/env bash
# SessionStart: init progress store and inject learner level/skills into context.
set -euo pipefail

# Drain stdin (session payload)
cat >/dev/null 2>&1 || true

ROOT="${GROK_PLUGIN_ROOT:-${CLAUDE_PLUGIN_ROOT:-}}"
if [[ -z "$ROOT" ]]; then
  ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fi
export GROK_PLUGIN_ROOT="$ROOT"

# Ensure data dir
DATA="${GROK_PLUGIN_DATA:-${CLAUDE_PLUGIN_DATA:-$HOME/.grok/plugin-data/leveling-up-tutor}}"
export GROK_PLUGIN_DATA="$DATA"
mkdir -p "$DATA"

SESSION_ID="${GROK_SESSION_ID:-}"

python3 "$ROOT/scripts/progress.py" init >/dev/null 2>&1 || true
python3 "$ROOT/scripts/progress.py" session-start ${SESSION_ID:+--session-id "$SESSION_ID"}
exit 0
