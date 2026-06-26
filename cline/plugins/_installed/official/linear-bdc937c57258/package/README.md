# linear

Bundle the Linear SDK scripting skill as an installable Cline plugin.

## What It Does

Installs the `linear-sdk-scripting` skill. The skill guides agents through Linear work from the terminal by writing small Node scripts against the official `@linear/sdk`, including reading, creating, updating, closing, and commenting on issues.

## Install

```bash
cline plugin install linear
```

For local development from this repository:

```bash
cline plugin install ./plugins/linear --cwd .
```

## Example Usage

After installation, ask Cline:

```text
Find my open Linear issues, summarize the blockers, and add a comment to the highest-priority issue with the next step.
```

Cline automatically uses the `linear-sdk-scripting` skill to write and run small Node scripts against `@linear/sdk`, then returns the Linear result in the conversation.

## Requirements

- Node 18 or newer for the scripts the skill creates.
- A Linear personal API key in `LINEAR_API_KEY` when executing Linear actions.
- The skill handles installing `@linear/sdk` into a cache working directory when needed.

## Security Notes

Linear API keys are secrets. The bundled skill tells agents not to print, commit, or persist keys without explicit user approval.
