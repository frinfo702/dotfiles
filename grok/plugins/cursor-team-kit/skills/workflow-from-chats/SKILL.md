---
name: workflow-from-chats
description: >
  Extract durable working preferences from recent Grok sessions (or other agent
  chats) and convert them into skills, rules, or workflow docs. Use when asked to
  learn preferences, mine feedback, personalize workflows, or generate
  team/person-specific agent guidance.
---

# Workflow From Chats

Infer durable working preferences from recent sessions. Do not summarize chats; extract reusable workflow guidance.

## Scope

- Default to the last 7 days unless the user asks for a different window.
- Prefer parent/session transcripts; use subagent content as evidence, but cite only parent conversations.
- Grok session data typically lives under `~/.grok/sessions/` (project-keyed directories with transcript JSONL). Also consider user-provided exports or other harness transcripts when the user points to them.
- Do not expose local transcript paths, secrets, customer data, private chat content, or credentials.

## Workflow

1. State the target workflow or preference surface in one paragraph.
2. Build an internal transcript inventory: title/topic, parent conversation ID, approximate date, completion state, relevant subagents, and why it may contain preference evidence.
3. Scan for explicit preferences, corrections, and workflow markers such as "I prefer", "always", "never", "not what I asked", "stop", "review", "PR", "CI", "logs", and "skill".
4. Extract preference atoms: trigger, workflow step, decision rule, quality bar, stop condition, evidence, and confidence.
5. Rate confidence as strong, medium, weak, or contradicted.
6. Cluster by workflow shape rather than transcript: shipping, review, simplification, debugging, capture, communication, delegation, or validation.
7. Choose the artifact: new skill, skill edit, rule (`AGENTS.md` / `.grok/rules/*.md`), workflow doc, or no artifact.
8. Draft only the reusable guidance. Filter anecdotes that will not help future tasks.

## Confidence

- Strong: explicit user preference, workflow-changing correction, repeated parent-chat pattern, or direct request to encode behavior.
- Medium: accepted workflow, repeated tool/model/validation preference, or subagent consensus that the parent used successfully.
- Weak: agent-chosen behavior with no user feedback, one ambiguous transcript, or a likely task-specific correction.
- Contradicted: evidence points in incompatible directions; ask the user before writing files.

## Artifact Choice

- Skill (`SKILL.md` under `.grok/skills/` or a plugin): recurring multi-step workflow with clear triggers.
- Rule (`AGENTS.md` or `.grok/rules/*.md`): general behavior that should apply broadly.
- Workflow doc: useful context that is not reliably triggerable.
- No artifact: situational, stale, or low-confidence observation.

## Output

Return a concise synthesis first:

- Target workflow.
- Evidence corpus with parent conversation citations only.
- Preference profile.
- Adopt, consider, dismissed.
- Proposed artifacts.
- Open questions only if they block writing.
