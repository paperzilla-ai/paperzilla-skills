# Paperzilla Skills

This repo is the source for all Paperzilla-related agent skills.

Start with the job you want your agent to do. Then choose a supported profile for your agent and setup.

## Which skill do I need?

| If you want to... | Use this skill | What it is for |
|---|---|---|
| Chat with your agent about projects and papers in Paperzilla | `paperzilla` | The core Paperzilla skill. Ask for recent papers from a project, fetch a paper as markdown, get summaries, compare relevance to your research, inspect project feeds, export JSON, or get Atom feed URLs. This is the default starting point for most users. |
| Run an opinionated monitoring workflow | `paperzilla-monitor` | A higher-level workflow skill built on top of Paperzilla access. It is for repeated feed triage, digest generation, and optional delivery to tools like Slack or Telegram in supported profiles. |

## How to think about skills in this repo

There are two kinds of skills:

- `paperzilla` is a core access skill. It helps you talk to your agent about Paperzilla data.
- `paperzilla-monitor` and similar skills are workflow skills. They do not unlock more Paperzilla data; they package a specific repeated task and, sometimes, external delivery.

The important distinction is not "simple browsing" versus "advanced analysis." The core `paperzilla` skill already supports conversational tasks such as:

- "Give me the latest papers from project X."
- "Fetch paper Y as markdown and summarize it."
- "Tell me how this paper is relevant to my research."

Workflow skills matter when you want that access wrapped in a specific flow, format, or integration.

## Profiles, not a full matrix

Each skill can have one or more supported profiles.

A profile is one maintained combination of:

- agent runtime: Claude, OpenClaw, Codex, generic, and so on
- Paperzilla backend transport: MCP or CLI (`pz`)
- optional integrations: Slack, Telegram, or none

We do not want to support every possible combination. Instead, each skill declares the profiles we actually maintain.

Rules of thumb:

- Every core skill should have a `generic` profile that works in most environments.
- Agent-specific profiles exist only when packaging or behavior needs to differ.
- Workflow skills can support a narrower set of profiles.

## Skills available today

| Skill | Category | Recommended for | Notes |
|---|---|---|---|
| `paperzilla` | Core access | Almost everyone | The default Paperzilla skill |
| `paperzilla-monitor` | Workflow | Users who specifically want feed triage and digest delivery | An opinionated workflow built on top of Paperzilla access |

## Profiles available today

| Skill | Profile | Agent | Transport | Availability |
|---|---|---|---|---|
| `paperzilla` | `generic` | Generic | CLI (`pz`) | [Latest ZIP](https://github.com/paperzilla-ai/paperzilla-skills/releases/latest/download/paperzilla-generic.zip) |
| `paperzilla` | `claude` | Claude | CLI (`pz`) | [Latest ZIP](https://github.com/paperzilla-ai/paperzilla-skills/releases/latest/download/paperzilla-claude.zip) |
| `paperzilla` | `codex` | Codex | CLI (`pz`) | [Latest ZIP](https://github.com/paperzilla-ai/paperzilla-skills/releases/latest/download/paperzilla-codex.zip) |
| `paperzilla` | `openclaw` | OpenClaw | CLI (`pz`) | [ClawHub](https://clawhub.ai/pors/paperzilla) |
| `paperzilla-monitor` | `claude` | Claude | MCP | [Latest ZIP](https://github.com/paperzilla-ai/paperzilla-skills/releases/latest/download/paperzilla-monitor-claude-mcp.zip) |
| `paperzilla-monitor` | `openclaw` | OpenClaw | CLI (`pz`) | [Latest source bundle](https://github.com/paperzilla-ai/paperzilla-skills/releases/latest/download/paperzilla-monitor-openclaw-source.tar.gz) |

## Install

### OpenClaw

If you want the core `paperzilla` skill on OpenClaw, install it from ClawHub:

```bash
clawhub install paperzilla
```

Skill page: https://clawhub.ai/pors/paperzilla

ClawHub is an install channel, not a separate skill type. The source of truth still lives in this repo.

### Other agents

Download packaged assets from the latest GitHub release:

- https://github.com/paperzilla-ai/paperzilla-skills/releases/latest

Release assets are built automatically and uploaded when a `v*` tag is pushed.

Detailed agent-specific setup and transport documentation should live in the docs repo rather than this README.

## Reference links

- Paperzilla CLI docs: https://docs.paperzilla.ai/guides/cli
- CLI quickstart: https://docs.paperzilla.ai/guides/cli-getting-started
- CLI repo: https://github.com/paperzilla-ai/pz
- Maintainer repo model: [REPO_MODEL.md](./REPO_MODEL.md)

## Security

Only install skills from trusted sources and review packaged files before using them in sensitive environments.
