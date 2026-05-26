# Output Patterns

Use output patterns to make a skill easier to route into and easier to consume after it runs.
The most useful patterns cover both ends:

- How the skill advertises itself in `description`
- How the skill returns results after execution

## Description Pattern

Treat the frontmatter `description` as a routing rule, not marketing copy.

A strong description answers three questions:

1. Use when should this skill trigger
2. Do not use when should this skill stay out
3. Success output what artifact or outcome should this skill produce

### Description Template

```yaml
description: Use when [concrete request, inputs, and environment]. Do not use when [nearby but out-of-scope cases]. Produces [artifact or outcome].
```

Example:

```yaml
description: Use when a bug has reproduction steps and the repository can be tested locally. Do not use for architecture brainstorming, vague debugging advice, or documentation-only requests. Produces a validated code fix and verification result.
```

## Use / Do Not Use Pattern

When the boundary is important, spell it out with explicit trigger language:

```markdown
Use when:
- The user wants a narrowly defined code migration in an existing TypeScript repo
- The target framework and destination are already known

Do not use when:
- The user is still choosing between frameworks
- The request is only for a design discussion or tradeoff analysis
- The repository cannot be inspected or modified
```

This reduces accidental triggering on adjacent tasks.

## Positive and Negative Examples

Do not stop at positive examples. Add negative examples to reduce misfires.

```markdown
Positive examples:
- "Migrate this Express route to Fastify in the current repo"
- "Replace axios with fetch in this package and run the affected tests"

Negative examples:
- "Should we migrate from Express to Fastify?"
- "Review this README and suggest improvements"
- "Explain what Fastify is"
```

Negative examples are especially useful when nearby requests share keywords but require a
different skill.

## Output Contract Pattern

Constrain the final response format when downstream handling matters.

```markdown
Return:
- `summary`: one or two sentences describing the result
- `changed_files`: exact files touched
- `verification_result`: commands run and pass/fail/blocked status
- `open_questions`: unresolved items or explicit `none`
```

This is more reliable than asking for a "helpful summary."

## Strict vs Flexible Templates

Use strict templates when consistency matters across runs:

```markdown
Return exactly:

- `summary`
- `changed_files`
- `verification_result`
- `open_questions`
```

Use flexible templates when the task shape varies, but still anchor the required fields:

```markdown
Default response structure:

- `summary`
- `changed_files`
- `verification_result`
- Additional sections only if they add necessary context
```

## Examples Pattern

When style or level of detail matters, show input/output examples:

```markdown
Example 1
Input: Fix import sorting in the modified package
Output:
- `summary`: Standardized import order in the parser package.
- `changed_files`: `parser/index.ts`
- `verification_result`: `pnpm test parser` passed
- `open_questions`: none
```

Examples are often cheaper and clearer than long prose.

## Avoid These Patterns

Do not write descriptions or outputs like this:

- "Powerful all-in-one skill for development tasks"
- "Use for any GitHub-related request"
- "Return a clear and useful response"

These are too broad to guide routing or execution.
