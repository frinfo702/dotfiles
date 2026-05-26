# Workflow Patterns

Use workflow guidance to narrow behavior after a skill is selected. Good workflows do not just
list steps. They define preconditions, exact actions, verification, and the final handoff format.

## Recommended Structure

Prefer this order in `SKILL.md`:

1. Preconditions
2. Execution steps
3. Verification steps
4. Output format

This keeps the skill focused on a single job and makes the agent's behavior easier to predict.

## Preconditions First

State the conditions that must be true before execution starts. This avoids the skill wandering
into planning, unrelated analysis, or unsafe writes.

```markdown
Before starting:

1. Read `package.json` and identify the test command.
2. Confirm the bug is reproducible locally.
3. If reproduction is not possible, stop and report the blocker.
```

Use preconditions to encode scope:

- What inputs must exist
- What environment or repository type is expected
- What should cause the workflow to stop early

## Sequential Workflows

For deterministic tasks, write imperative steps with concrete actions:

```markdown
Fixing a locally reproducible Python bug:

1. Read `pyproject.toml` and the failing module.
2. Run the narrowest command that reproduces the bug.
3. Edit only the files required for the fix.
4. Re-run the narrowest reproducer.
5. Run the smallest relevant test subset.
6. Report the root cause, changed files, and verification result.
```

Write commands and files explicitly when possible. "Investigate as needed" is too loose for a
skill instruction.

## Conditional Workflows

For branching tasks, put the decision point first and keep each branch narrow:

```markdown
1. Determine the request type:
   - New skill: follow the creation workflow
   - Existing skill update: follow the iteration workflow
   - Packaging only: follow the packaging workflow

2. Creation workflow:
   1. Gather concrete trigger examples.
   2. List reusable scripts, references, and assets.
   3. Run the initializer.
   4. Implement and validate resources.

3. Iteration workflow:
   1. Read the existing `SKILL.md`.
   2. Identify trigger or output failures.
   3. Patch the smallest set of files.
   4. Re-test the affected path.
```

Branch on observable conditions, not vague intent.

## Approval Gates

Skills that can write, publish, or mutate external systems should say exactly when approval is
required.

```markdown
Before any high-impact write:

1. Summarize the planned change.
2. Request explicit approval for external writes or destructive actions.
3. Continue only after approval is granted.
```

Use this for:

- Creating or deleting tickets, comments, pull requests, or documents
- Running destructive commands
- Making irreversible or user-visible changes

## Verification Is Required

Verification should be part of the workflow, not an optional note at the end.

```markdown
After making changes:

1. Run the narrowest relevant verification command.
2. Capture whether verification passed, failed, or was blocked.
3. If blocked, report the reason and the next required action.
```

Prefer the smallest verification step that proves the skill's job was completed.

## Output Handoff

End with a fixed output contract so higher-level agents can reliably consume the result.

```markdown
Finish with:

- `summary`: what changed
- `changed_files`: files created or modified
- `verification_result`: commands run and outcome
- `open_questions`: blockers, risks, or follow-ups
```

Skills are more composable when the final output shape is predictable.

## Long-Running Workflows

If the task may span many turns, include state handoff guidance instead of trying to keep every
detail in active context.

```markdown
When context grows large:

1. Preserve only the current goal, constraints, changed files, and next pending step.
2. Re-read source files or references instead of relying on long conversational memory.
3. Resume from the last verified checkpoint.
```

This keeps the skill robust after compaction or partial restarts.
