---
name: paperzilla
description: Use the Paperzilla CLI (pz) to browse research projects/feeds, inspect papers, export JSON, and generate Atom feed URLs. Trigger when users ask to check Paperzilla feeds, list projects, inspect paper details, or automate feed workflows.
version: 1.1.0
metadata:
  openclaw:
    requires:
      bins:
        - pz
    homepage: https://docs.paperzilla.ai/guides/cli
---

# Paperzilla CLI (`pz`) 🦖

Use `pz` to work with Paperzilla projects and paper feeds from the terminal.

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

## Core commands

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
