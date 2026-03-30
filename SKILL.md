---
name: paperzilla
description: Chat with your agent about projects and papers in Paperzilla. Use when users ask for recent papers from a project, want a paper as markdown, need a summary, want relevance to their research, inspect feeds, export JSON, or get Atom feed URLs.
version: 0.2.1
metadata:
  openclaw:
    requires:
      bins:
        - pz
    homepage: https://docs.paperzilla.ai/guides/cli
---

# Paperzilla

Use this skill when you want to chat with your agent about projects and papers in Paperzilla.

## What you can ask

- "Give me the latest papers from project X."
- "Fetch paper Y as markdown and summarize it."
- "Tell me how this paper is relevant to my research."
- "Show me the feed for project X."
- "Export this paper or feed as JSON."

This is the core Paperzilla skill. It gives your agent direct access to Paperzilla data, but it does not impose a workflow or external delivery integration.

## Access method

Most current profiles in this repo use the `pz` CLI.

If the current profile ships extra agent-specific instructions, follow those as well.

## Install

### macOS
```bash
brew install paperzilla-ai/tap/pz
```

### Windows (Scoop)
```bash
scoop bucket add paperzilla-ai https://github.com/paperzilla-ai/scoop-bucket
scoop install pz
```

### Linux
```bash
curl -sL https://github.com/paperzilla-ai/pz/releases/latest/download/pz_linux_amd64.tar.gz | tar xz
sudo mv pz /usr/local/bin/
```

### Build from source (Go 1.23+)
```bash
git clone https://github.com/paperzilla-ai/pz.git
cd pz
go build -o pz .
mv pz /usr/local/bin/
```

## Update

### macOS
```bash
brew update
brew upgrade pz
```

### Windows
```bash
scoop update pz
```

### Linux / Releases
```bash
curl -sL https://github.com/paperzilla-ai/pz/releases/latest/download/pz_linux_amd64.tar.gz | tar xz
sudo mv pz /usr/local/bin/
```

### Source install
```bash
git pull
go build -o pz .
sudo mv pz /usr/local/bin/
```

## Authentication

```bash
pz login
```

## CLI reference

If the current profile uses `pz`, these are the core commands.

### List projects
```bash
pz project list
```

### Show one project
```bash
pz project <project-id>
```

### Browse project feed
```bash
pz feed <project-id>
```

Useful flags:
- `--must-read`
- `--since YYYY-MM-DD`
- `--limit N`
- `--json`
- `--atom`

Examples:
```bash
pz feed <project-id> --must-read --since 2026-03-01 --limit 5
pz feed <project-id> --json
pz feed <project-id> --atom
```

### Inspect one paper/feed item
```bash
pz paper <paper-or-feed-id>
pz paper <paper-or-feed-id> --json
pz paper <paper-or-feed-id> --markdown
```

## Output and automation

- Prefer `--json` for machine parsing.
- `--atom` returns a personal feed URL for feed readers.

## Configuration

```bash
export PZ_API_URL="https://paperzilla.ai"
```

## References

- Docs: https://docs.paperzilla.ai/guides/cli
- Quickstart: https://docs.paperzilla.ai/guides/cli-getting-started
- Repo: https://github.com/paperzilla-ai/pz
