---
description: "Propose or register a deliberate-practice quest tailored to weak skills"
argument-hint: "[optional focus, e.g. go concurrency | paper reading | system design]"
---

# /leveling-quest

Create a growth quest for the learner.

## Arguments

$ARGUMENTS

## Steps

1. Load progress:

```bash
python3 "${GROK_PLUGIN_ROOT:-$HOME/.grok/plugins/leveling-up-tutor}/scripts/progress.py" show
```

2. Based on level, weak skills, and optional focus `$ARGUMENTS`, design **one** quest that is:
   - Specific and finishable in 1–3 sessions
   - Hard enough to stretch, not crush
   - Measurable (what “done” looks like)
   - Mapped to 1–3 skill ids (e.g. `go`, `testing`, `paper-reading`)

3. Register it:

```bash
python3 "${GROK_PLUGIN_ROOT:-$HOME/.grok/plugins/leveling-up-tutor}/scripts/progress.py" quest-add \
  --title "..." \
  --detail "..." \
  --skill go \
  --skill testing
```

4. Tell the learner the quest, success criteria, and first 15-minute action.
5. Do **not** write code for them. Guide only.
