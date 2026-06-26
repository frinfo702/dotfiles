# web-search

Adds Exa-backed web search as a Cline tool.

## What It Does

Registers `web_search`, which searches public web results through Exa and returns normalized result metadata. Use it to discover relevant URLs before fetching page content with normal Cline tools.

## Install

```bash
cline plugin install web-search
```

For local development from this repository:

```bash
cline plugin install ./plugins/web-search --cwd .
```

## Example Usage

After installation, ask Cline:

```text
Search the web for current Cline plugin package manifest examples and summarize the most relevant results.
```

Cline can call `web_search` to retrieve Exa-backed web results before deciding which public pages to inspect.

## Requirements

- `EXA_API_KEY`

## Security Notes

Queries are sent to Exa. Do not include private code, secrets, customer data, or other confidential text in search queries.
