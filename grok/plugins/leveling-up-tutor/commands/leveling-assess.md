---
description: "Assess the latest learning turn and award XP + skill gains"
argument-hint: "[optional notes about what the learner did]"
---

# /leveling-assess

Score the learner's recent work and award XP.

## Arguments

$ARGUMENTS

## Rubric (0.0–1.0 each)

| Signal | Meaning |
|--------|---------|
| quality | Correctness, clarity, idiomatic style |
| depth | Non-superficial reasoning |
| design | API/system/data design quality |
| reading | Codebase/PR/paper reading skill shown |
| debugging | Systematic fault isolation |
| testing | Tests, oracles, edge cases |
| ml-eng | Pipelines, eval, serving, MLOps |
| research | Hypotheses, ablations, literature, math |
| independence | How little spoiling they needed |
| explanation | Ability to teach it back |

Also estimate `lines` = lines of code **the learner** authored this turn (0 if none).

## Steps

1. Infer scores from the conversation and any files you **read** (do not write).
2. Award:

```bash
python3 "${GROK_PLUGIN_ROOT:-$HOME/.grok/plugins/leveling-up-tutor}/scripts/progress.py" award \
  --compute \
  --lines <N> \
  --quality <0-1> \
  --depth <0-1> \
  --design <0-1> \
  --reading <0-1> \
  --debugging <0-1> \
  --testing <0-1> \
  --ml-eng <0-1> \
  --research <0-1> \
  --independence <0-1> \
  --explanation <0-1> \
  --skill <id>:<xp> \
  --reason "..." \
  --journal "..."
```

3. Show the JSON result and a short human summary (level-ups, skill gains, next focus).
4. Notes from user: $ARGUMENTS
