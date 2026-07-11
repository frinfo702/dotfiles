#!/usr/bin/env bash
# PreToolUse: deny file-writing tools and shell commands that write code/files.
# Allows: reads, tests, git read ops, and the progress.py award/show CLI.
set -euo pipefail

INPUT=$(cat || true)

# Prefer jq; fall back to python for portability
extract() {
  local expr="$1"
  if command -v jq >/dev/null 2>&1; then
    echo "$INPUT" | jq -r "$expr // empty" 2>/dev/null || true
  else
    python3 -c "
import json,sys
try:
    d=json.load(sys.stdin)
except Exception:
    sys.exit(0)
parts='$expr'.replace('.', ' ').split()
# only support simple .toolName and .toolInput.command
" <<<"$INPUT" 2>/dev/null || true
  fi
}

if command -v jq >/dev/null 2>&1; then
  TOOL=$(echo "$INPUT" | jq -r '.toolName // .tool_name // empty')
  CMD=$(echo "$INPUT" | jq -r '.toolInput.command // .tool_input.command // empty')
else
  read -r TOOL CMD < <(python3 - <<'PY' "$INPUT"
import json,sys
raw=sys.argv[1] if len(sys.argv)>1 else sys.stdin.read()
try:
    d=json.loads(raw)
except Exception:
    print(" ","")
    raise SystemExit
tool=d.get("toolName") or d.get("tool_name") or ""
ti=d.get("toolInput") or d.get("tool_input") or {}
cmd=ti.get("command") or "" if isinstance(ti, dict) else ""
print(tool, cmd)
PY
)
fi

TOOL=${TOOL:-}
CMD=${CMD:-}

deny() {
  local reason="$1"
  printf '%s\n' "{\"decision\":\"deny\",\"reason\":$(python3 -c 'import json,sys; print(json.dumps(sys.argv[1]))' "$reason")}"
  exit 2
}

allow() {
  printf '%s\n' '{"decision":"allow"}'
  exit 0
}

# Normalize tool name
TOOL_LC=$(printf '%s' "$TOOL" | tr '[:upper:]' '[:lower:]')

# Hard-deny write/edit tools
case "$TOOL_LC" in
  search_replace|write|edit|multiedit|strreplace|create|delete|notebookedit)
    deny "Leveling Up Tutor: code writing is disabled. Guide the learner to edit files themselves. Use explanations, reviews, and Socratic questions only."
    ;;
esac

# Non-shell tools that reached here with other matchers: allow
case "$TOOL_LC" in
  bash|run_terminal_command|shell) ;;
  *)
    allow
    ;;
esac

# Empty command
if [[ -z "${CMD// /}" ]]; then
  allow
fi

# Always allow the progress engine (writes only to plugin data dir)
if printf '%s' "$CMD" | grep -Eq 'progress\.py[[:space:]]+(show|award|init|path|session-start|quest-add|quest-complete)'; then
  allow
fi
if printf '%s' "$CMD" | grep -Eq 'leveling-up-tutor/scripts/progress\.py'; then
  allow
fi

# Allow common read-only / verify commands (learner runs edits; tutor may verify)
# Still block if they also contain write redirects.
READ_OK=0
if printf '%s' "$CMD" | grep -Eq '^(cd[[:space:]]+[^;|&]+[[:space:]]*(;|&&)[[:space:]]*)?(ls|pwd|cat|head|tail|wc|sort|uniq|tr|cut|date|whoami|hostname|uptime|ps|file|stat|tree|rg|grep|find|fd|which|type|echo|printf|env|printenv|jq|python3? -m (pytest|unittest|py_compile)|pytest|go test|go vet|go build|cargo check|cargo test|cargo clippy|npm test|npm run (test|lint|typecheck)|pnpm (test|lint)|yarn test|bun test|tsc --noEmit|ruff check|mypy|eslint|git (status|diff|log|show|branch|rev-parse|ls-files|blame|stash list)|jj (status|diff|log|show|st)|gh (pr view|pr checks|issue view|repo view)|man|help)([[:space:]]|$)'; then
  READ_OK=1
fi

# Write patterns in shell
WRITE_PAT='(^|[[:space:];|&])(tee|install|cp|mv|rm|mkdir|touch|chmod|chown|ln|dd|truncate)([[:space:]]|$)|>>?[[:space:]]*/|>>?[[:space:]]*[^|&;[:space:]]|<<[^=]|sed[[:space:]]+(-i|--[[:alnum:]-]*in-place)|perl[[:space:]]+-i|ruby[[:space:]]+-i|awk[[:space:]].*>[[:space:]]|/dev/sd|mkfs|dd[[:space:]]+if='

# Redirection to /dev/null is fine
CMD_CHECK=$(printf '%s' "$CMD" | sed 's|>[[:space:]]*/dev/null||g; s|>>[[:space:]]*/dev/null||g')

if printf '%s' "$CMD_CHECK" | grep -Eq "$WRITE_PAT"; then
  # Exception: writing only under plugin data paths
  if printf '%s' "$CMD" | grep -Eq 'plugin-data/leveling-up-tutor|GROK_PLUGIN_DATA|CLAUDE_PLUGIN_DATA'; then
    allow
  fi
  deny "Leveling Up Tutor: shell must not write project files (no redirects, tee, sed -i, cp/mv into tree, etc.). The learner writes the code. You may run read-only checks and tests. To award XP: python3 \"\$GROK_PLUGIN_ROOT/scripts/progress.py\" award ..."
fi

# Block "echo/printf/cat code into file" even if pattern missed
if printf '%s' "$CMD_CHECK" | grep -Eq '(echo|printf|cat|curl|wget).*(>|>>)|python3?[[:space:]]+-c[[:space:]]+.*(open\(|write\(|Path\(.*\)\.write)'; then
  if ! printf '%s' "$CMD" | grep -Eq 'plugin-data/leveling-up-tutor|GROK_PLUGIN_DATA|progress\.py'; then
    deny "Leveling Up Tutor: writing file contents via shell is forbidden. Coach the learner to type the code themselves."
  fi
fi

allow
