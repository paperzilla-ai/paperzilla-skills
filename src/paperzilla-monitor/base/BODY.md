# Paperzilla Research Monitor

Monitor and triage papers from Paperzilla projects using the Paperzilla access method provided by the current profile.

## Scope

Use this skill when the user asks to:
- check what is new in a project feed
- triage papers by relevance to current focus
- fetch full markdown for a specific paper
- produce a concise digest and optionally deliver it externally

## Prerequisites

- Use the Paperzilla transport required by the current profile.
- For CLI profiles, `pz` must be installed and authenticated (`pz login`).
- For MCP profiles, the Paperzilla MCP must be available to the agent.

## Access method

This workflow skill builds on top of the same Paperzilla data access as the core `paperzilla` skill.

- Some profiles use the `pz` CLI.
- Some profiles use Paperzilla MCP.

Read and follow any `AGENT.md` or other profile-specific files packaged with the current profile.

## CLI reference

When the current profile uses `pz`, these are the core commands.

### List projects
```bash
pz project list
```

### Project details
```bash
pz project <project_id>
```

### Feed
```bash
pz feed <project_id> --limit 20
pz feed <project_id> --limit 20 --json
```

### Paper details
```bash
pz paper <paper_id_or_short_id>
pz paper <paper_id_or_short_id> --json
pz paper <paper_id_or_short_id> --markdown
```

If markdown is still processing, wait and retry.

## Workflow

### 1) Identify project

1. Run `pz project list`.
2. If user named a project, use that project.
3. Otherwise ask once.

### 2) Establish current relevance context

Combine:
- project focus from name/details
- current conversation goals
- user include/exclude constraints

If context is unclear, ask one focused question.

### 3) Fetch feed

Use JSON for triage:
```bash
pz feed <project_id> --limit 20 --json
```

### 4) Triage

Classify each item:
- 🟢 Relevant — directly useful now
- 🟡 Tangential — related but not core
- 🔴 Irrelevant — off current focus

Use title + abstract as primary evidence. Treat ranking score as prior only.

### 5) Present digest

Format for scanability:
- group by 🟢 / 🟡 / 🔴
- one-liner reason for 🟢 and 🟡
- titles only for 🔴

### 6) Deep-dive on demand

For selected paper:
1. fetch markdown
2. summarize: contribution, method, results, limitations, relevance to user context
3. avoid dumping full markdown unless explicitly requested

## Edge cases

- **No new papers:** confirm project active and report no fresh additions.
- **Large feeds:** increase `--limit` or split in chunks.
- **Markdown delay:** retry once after waiting; then report processing state.

## Agent-specific delivery rules

Read and follow `AGENT.md` in this skill root for channel/tool behavior and external reporting rules for the current agent target.
