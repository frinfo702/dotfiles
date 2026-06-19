#!/bin/bash

# Ralph Loop stop hook (adapted for Factory Droid).
# When the agent finishes a turn, this hook decides whether to feed the
# same prompt back for another iteration or let the session end.
#
# Factory Droid Stop hook API:
#   Input:  JSON via stdin with session_id, transcript_path, cwd, etc.
#   Output: { "decision": "block", "reason": "<text>" } to continue, or exit 0 to stop

set -euo pipefail

HOOK_INPUT=$(cat)

PROJECT_DIR="${FACTORY_PROJECT_DIR:-.}"
STATE_FILE="$PROJECT_DIR/.factory/ralph/scratchpad.md"
DONE_FLAG="$PROJECT_DIR/.factory/ralph/done"

# No active loop. Let the session end.
if [[ ! -f "$STATE_FILE" ]]; then
  exit 0
fi

# Parse state file frontmatter
FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$STATE_FILE")
ITERATION=$(echo "$FRONTMATTER" | grep '^iteration:' | sed 's/iteration: *//')
MAX_ITERATIONS=$(echo "$FRONTMATTER" | grep '^max_iterations:' | sed 's/max_iterations: *//')
COMPLETION_PROMISE=$(echo "$FRONTMATTER" | grep '^completion_promise:' | sed 's/completion_promise: *//' | sed 's/^"\(.*\)"$/\1/')

# Validate iteration is numeric
if [[ ! "$ITERATION" =~ ^[0-9]+$ ]]; then
  echo "Ralph loop: state file corrupted (iteration: '$ITERATION'). Stopping." >&2
  rm -f "$STATE_FILE" "$DONE_FLAG"
  exit 0
fi

if [[ ! "$MAX_ITERATIONS" =~ ^[0-9]+$ ]]; then
  echo "Ralph loop: state file corrupted (max_iterations: '$MAX_ITERATIONS'). Stopping." >&2
  rm -f "$STATE_FILE" "$DONE_FLAG"
  exit 0
fi

# Check if completion promise was detected by the afterAgentResponse hook
if [[ -f "$DONE_FLAG" ]]; then
  echo "Ralph loop: completion promise fulfilled at iteration $ITERATION." >&2
  rm -f "$STATE_FILE" "$DONE_FLAG"
  exit 0
fi

# Check max iterations
if [[ $MAX_ITERATIONS -gt 0 ]] && [[ $ITERATION -ge $MAX_ITERATIONS ]]; then
  echo "Ralph loop: max iterations ($MAX_ITERATIONS) reached." >&2
  rm -f "$STATE_FILE" "$DONE_FLAG"
  exit 0
fi

# Extract prompt text (everything after the closing --- in frontmatter)
PROMPT_TEXT=$(awk '/^---$/{i++; next} i>=2' "$STATE_FILE")

if [[ -z "$PROMPT_TEXT" ]]; then
  echo "Ralph loop: no prompt text found in state file. Stopping." >&2
  rm -f "$STATE_FILE" "$DONE_FLAG"
  exit 0
fi

# Increment iteration
NEXT_ITERATION=$((ITERATION + 1))
TEMP_FILE="${STATE_FILE}.tmp.$$"
sed "s/^iteration: .*/iteration: $NEXT_ITERATION/" "$STATE_FILE" > "$TEMP_FILE"
mv "$TEMP_FILE" "$STATE_FILE"

# Build the followup message: iteration context + original prompt
if [[ "$COMPLETION_PROMISE" != "null" ]] && [[ -n "$COMPLETION_PROMISE" ]]; then
  HEADER="[Ralph loop iteration $NEXT_ITERATION. To complete: output <promise>$COMPLETION_PROMISE</promise> ONLY when genuinely true.]"
else
  HEADER="[Ralph loop iteration $NEXT_ITERATION.]"
fi

FOLLOWUP="$HEADER

$PROMPT_TEXT"

# Output decision to block stop and continue the loop (Factory Droid format)
jq -n --arg msg "$FOLLOWUP" '{"decision": "block", "reason": $msg}'

exit 0
