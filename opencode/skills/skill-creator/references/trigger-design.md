# Trigger Design Patterns

Trigger quality determines whether a skill is useful. Most failures come from the skill being
selected at the wrong time, not from the body being poorly written.

Design around two goals:

1. Make it obvious when the skill should trigger
2. Keep the behavior narrow after it triggers

## One Skill, One Job

Prefer one skill for one reusable job.

Good split:

- One skill to summarize a GitHub issue
- Another skill to implement a fix and open a pull request

Bad split:

- One skill that reads issues, plans work, edits code, writes docs, and opens a PR

If a skill is trying to cover multiple distinct outcomes, split it.

## Write Description as a Routing Boundary

The frontmatter `description` should describe the decision boundary, not advertise features.

Include:

- The concrete request shape
- The expected inputs or environment
- The nearby cases that are out of scope
- The expected result

Template:

```yaml
description: Use when [specific request and context]. Do not use when [adjacent but different requests]. Produces [artifact or result].
```

Example:

```yaml
description: Use when a Python repository has a locally reproducible bug and the user wants the fix implemented and verified. Do not use for high-level debugging advice, architecture discussions, or documentation-only edits. Produces a code change plus verification result.
```

## Add Negative Examples

Negative examples reduce accidental triggering better than more adjectives.

```markdown
Use when:
- "Fix this failing pytest in the current repo"
- "Update the migration and run the targeted tests"

Do not use when:
- "Why might this test be flaky?"
- "Review this code and tell me what you think"
- "Help me decide whether to migrate"
```

Add negative examples when:

- Neighboring tasks share the same vocabulary
- The skill can make writes or destructive changes
- The task is often confused with advice, review, or planning

## Keep Post-Trigger Behavior Narrow

Once triggered, the skill should not improvise into adjacent jobs.

Specify:

- What files or systems to inspect first
- What actions are allowed
- What actions require explicit approval
- What verification is required
- What the final output must contain

If the skill can branch into different outcomes, that is a sign the boundary is still too broad.

## Prefer Instructions Over Scripts Unless Determinism Matters

Use scripts when:

- The same code would otherwise be rewritten repeatedly
- The operation is fragile or exactness matters
- A deterministic transformation is more reliable than prose guidance

Use instructions when:

- The work requires judgment inside a narrow scope
- The same workflow applies across many contexts
- The benefit comes from routing and procedure, not automation

## Build Trigger Evals

Test the trigger before optimizing the body.

Recommended loop:

1. Write the success conditions
2. Create a small set of positive and negative prompts
3. Manually check whether the skill should trigger on each prompt
4. Adjust the description or examples
5. Re-test until the boundary is stable

Track two outcomes:

- Trigger precision: does it fire only when it should
- Task quality: after firing, does it produce the right artifact

## Include Safety Boundaries

If a triggered skill can write to external systems, encode that explicitly:

```markdown
Before creating comments, tickets, PRs, or external documents:

1. Summarize the intended write
2. Request explicit approval
3. Proceed only after approval
```

Do not rely on generic system safeguards when the skill itself can make the boundary clearer.

## Design for Long Conversations

Do not overload the skill with conversation state. Instead, make preconditions and checkpoints
explicit so the workflow can resume after context compaction.

Useful checkpoints:

- Current goal
- Inputs confirmed
- Files or systems already inspected
- Latest verified result
- Next pending action
