---
name: assess-and-award-xp
description: >
  Score a tutoring turn and award global XP/skills for Leveling Up Tutor.
  Use at end of learning turns, on /leveling-assess, or when Stop hook nudges.
---

# Assess and award XP

## Goal

Convert demonstrated learning into honest XP without farming.

## Inputs to estimate

- Lines of code the **learner** wrote (not you)
- Dimensions 0–1: quality, depth, design, reading, debugging, testing, ml-eng, research, independence, explanation
- Which skill ids moved (see skill tree)

## Command

```bash
python3 "${GROK_PLUGIN_ROOT:-$HOME/.grok/plugins/leveling-up-tutor}/scripts/progress.py" award \
  --compute \
  --lines N \
  --quality Q --depth D --design DES --reading R \
  --debugging DBG --testing T --ml-eng M --research RES \
  --independence I --explanation E \
  --skill go:12 \
  --reason "one-line cause" \
  --journal "optional"
```

`--compute` builds the main XP from the scorer; extra `--skill id:xp` assigns skill XP (and can replace computed skill split if you pass skills explicitly — prefer adding skills that match the work).

## Honesty guide

| Independence | Meaning |
|--------------|---------|
| 0.2 | heavy spoilers / you almost solved it |
| 0.5 | normal coaching |
| 0.8 | light hints only |
| 1.0 | essentially solo after goal set |

| Quality | Meaning |
|---------|---------|
| 0.3 | works barely / many smells |
| 0.6 | acceptable |
| 0.85 | clean, tested, thoughtful |
| 1.0 | production/research grade for the level |

## After award

- Surface level-ups and milestones
- Name 1–2 skills that grew
- Propose the next deliberate practice micro-goal
- Never edit project files as part of assessment
