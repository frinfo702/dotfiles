---
name: continual-learning
description: Incremental transcript-driven memory updates for AGENTS.md using high-signal bullet points only. Run when the user asks to mine prior chats, update AGENTS.md, or when suggested by the continual-learning plugin.
---

# Continual Learning

Keep `AGENTS.md` current by mining new or changed transcript content and writing only high-signal findings.

## Trigger

- The user asks to mine prior chats, maintain `AGENTS.md`, or run continual learning.
- Suggested after a session with significant learning (new preferences, patterns, decisions).

## Workflow

1. Read existing `AGENTS.md` and note the current `## Learned User Preferences` and `## Learned Workspace Facts` sections.
2. Scan recent transcripts for new or changed information that belongs in `AGENTS.md`.
3. Write only plain bullet points under the appropriate section. No evidence or confidence metadata.
4. Keep bullets actionable: a new reader should understand the preference or fact without reading transcripts.

## Output Format

```markdown
## Learned User Preferences

- Prefer <X> over <Y> when <context>.
- Always <action> before <other action>.

## Learned Workspace Facts

- <subsystem> uses <pattern> for <purpose>.
- <file> is the source of truth for <thing>.
```

## Guardrails

- Process only new or changed data since the last run.
- Update matching bullets in place rather than appending duplicates.
- Do not include transcript paths, secrets, or private chat content.
- Keep bullets concise and de-duplicated.
- Only write when there is genuinely new information.
