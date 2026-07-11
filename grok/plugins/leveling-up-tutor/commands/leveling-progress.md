---
description: "Show global level, XP bar, and skill levels (Go Lv2, System Design Lv3, …)"
---

# /leveling-progress

Display the learner's **global** Leveling Up Tutor progress card.

## Steps

1. Resolve plugin root (hooks set `GROK_PLUGIN_ROOT`; otherwise the installed plugin path under `~/.grok/plugins/leveling-up-tutor`).
2. Run:

```bash
python3 "${GROK_PLUGIN_ROOT:-$HOME/.grok/plugins/leveling-up-tutor}/scripts/progress.py" show
```

3. Present the script output to the user **verbatim** (it is already formatted).
4. Optionally add 2–3 sentences of coaching: what to train next based on weak skills and active quests.
5. Do **not** edit any project files.

If the progress file is missing, run `init` first, then `show`.
