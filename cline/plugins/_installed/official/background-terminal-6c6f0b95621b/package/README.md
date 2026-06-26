# background-terminal

Runs long-lived shell commands in the background.

## What It Does

Registers `start_background_command`, `get_background_command`, and `delete_background_command`. Jobs write metadata and logs under the Cline data directory so an agent can start work, poll output, and clean up later.

## Install

```bash
cline plugin install background-terminal
```

For local development from this repository:

```bash
cline plugin install ./plugins/background-terminal --cwd .
```

## Example Usage

After installation, ask Cline:

```text
Run npm test in the background, keep working while it runs, and check the result before you finish.
```

Cline can use `start_background_command` to launch the process, `get_background_command` to poll logs, and `delete_background_command` to clean up stored job metadata.

## Requirements

- A shell environment.
- Optional `CLINE_DATA_DIR` to control where job metadata is stored.

## Security Notes

This plugin runs shell commands. Review requested commands carefully and use host tool approval policies in sensitive workspaces.
