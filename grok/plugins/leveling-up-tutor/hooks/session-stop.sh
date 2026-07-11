#!/usr/bin/env bash
# Stop: remind agent to award XP if this turn looked like real learning.
# Passive on Grok (no block); still logs and emits systemMessage when possible.
set -euo pipefail

INPUT=$(cat || true)
ROOT="${GROK_PLUGIN_ROOT:-${CLAUDE_PLUGIN_ROOT:-}}"
if [[ -z "$ROOT" ]]; then
  ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fi
export GROK_PLUGIN_ROOT="$ROOT"
DATA="${GROK_PLUGIN_DATA:-${CLAUDE_PLUGIN_DATA:-$HOME/.grok/plugin-data/leveling-up-tutor}}"
export GROK_PLUGIN_DATA="$DATA"
mkdir -p "$DATA"

# Extract last assistant / user signals when present
LAST_MSG=""
SESSION_ID="${GROK_SESSION_ID:-}"
if command -v jq >/dev/null 2>&1; then
  LAST_MSG=$(echo "$INPUT" | jq -r '.last_assistant_message // .lastAssistantMessage // empty' 2>/dev/null || true)
  SESSION_ID=$(echo "$INPUT" | jq -r '.sessionId // .session_id // empty' 2>/dev/null || true)
  [[ -z "$SESSION_ID" ]] && SESSION_ID="${GROK_SESSION_ID:-}"
fi

# Detect if this turn already awarded XP (history mtime / last_session recency)
AWARDED_RECENTLY=0
if [[ -f "$DATA/progress.json" ]]; then
  if python3 - <<PY
import json, time
from pathlib import Path
p = Path("$DATA/progress.json")
try:
    d = json.loads(p.read_text())
except Exception:
    raise SystemExit(1)
last = (d.get("last_session") or {}).get("at")
if not last:
    raise SystemExit(1)
# treat awards in last 90s as this turn
from datetime import datetime, timezone
try:
    ts = datetime.fromisoformat(last.replace("Z", "+00:00")).timestamp()
except Exception:
    raise SystemExit(1)
raise SystemExit(0 if time.time() - ts < 90 else 1)
PY
  then
    AWARDED_RECENTLY=1
  fi
fi

# Heuristic: learning signal in last message
LEARNING=0
if printf '%s' "$LAST_MSG" | grep -Eiq '```|exercise|try this|hint|level|xp|quest|design|review|read the|socratic|what do you think|write a test|paper|ablation|loss|gradient'; then
  LEARNING=1
fi

STAMP_FILE="$DATA/.last_stop_nudge"
NUDGE=0
if [[ "$AWARDED_RECENTLY" -eq 0 && "$LEARNING" -eq 1 ]]; then
  # Rate-limit nudges to once per 3 minutes
  if [[ ! -f "$STAMP_FILE" ]] || [[ $(( $(date +%s) - $(stat -f %m "$STAMP_FILE" 2>/dev/null || stat -c %Y "$STAMP_FILE") )) -gt 180 ]]; then
    NUDGE=1
    date +%s >"$STAMP_FILE" 2>/dev/null || true
  fi
fi

# Append lightweight stop log
printf '%s\n' "{\"at\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"type\":\"stop\",\"session_id\":$(python3 -c 'import json,sys; print(json.dumps(sys.argv[1]))' "${SESSION_ID:-}"),\"awarded_recently\":$AWARDED_RECENTLY,\"learning_signal\":$LEARNING,\"nudge\":$NUDGE}" >>"$DATA/stop-events.jsonl" 2>/dev/null || true

if [[ "$NUDGE" -eq 1 ]]; then
  MSG="Leveling Up Tutor: this turn looked educational but no XP was recorded. Before ending, run: python3 \"\$GROK_PLUGIN_ROOT/scripts/progress.py\" award --compute --lines <learner_lines> --quality 0-1 --depth 0-1 --design 0-1 --reading 0-1 --debugging 0-1 --testing 0-1 --ml-eng 0-1 --research 0-1 --reason '...' --skill go:10 (etc). Never write code for the learner."
  # Emit compatible fields; Grok may ignore some, Claude/Cursor may use them
  python3 - <<PY
import json
msg = """$MSG"""
print(json.dumps({
  "systemMessage": msg,
  "additionalContext": msg,
  "hookSpecificOutput": {
    "hookEventName": "Stop",
    "additionalContext": msg,
  },
}, ensure_ascii=False))
PY
else
  # Still surface a tiny status for UIs that show systemMessage
  LVL=$(python3 "$ROOT/scripts/progress.py" show --json 2>/dev/null | python3 -c 'import json,sys,math; d=json.load(sys.stdin); xp=float(d.get("total_xp") or 0); print(int(math.floor(14*math.log1p(xp/120)))+1)' 2>/dev/null || echo "?")
  python3 -c 'import json,sys; print(json.dumps({"systemMessage": f"Leveling Up Tutor · learner L{sys.argv[1]}"}))' "$LVL"
fi

exit 0
