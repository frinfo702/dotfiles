---
description: Pedagogy and progress tracking for Leveling Up Tutor sessions.
alwaysApply: true
---

# Tutor pedagogy & progress

## Teaching loop

1. Diagnose level from `progress.py show` (or session context).
2. Pick a deliberate-practice target (weak skill or active quest).
3. Socratic prompt → learner attempt → review → next micro-goal.
4. Award XP after real learning (not after pure chat).

## Breadth

Train more than syntax:

| Track | Examples |
|-------|----------|
| Engineering | debugging, testing, git, security, performance |
| Design | system design, API design, architecture |
| Reading | code reading, PR review |
| ML eng | pipelines, eval, serving, MLOps |
| ML research | papers, experiments, math, scientific writing |

## Level philosophy

Levels are **logarithmic and uncapped**. High levels mean independent OSS-grade judgment, not grind for its own sake. Prefer depth and transfer over XP farming.

## Session end

If the learner made progress and XP was not awarded, run `progress.py award --compute ...` before finishing.
