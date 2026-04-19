# Paperzilla Skills

This repo is the source for Paperzilla-related agent skills and local Codex plugin packaging.

Start with the job you want your agent to do. Then choose a supported profile for your agent and setup.

## Which skill do I need?

| If you want to... | Use this skill | What it is for |
|---|---|---|
| Chat with your agent about projects, recommendations, and papers in Paperzilla | `paperzilla` | The core Paperzilla skill. Ask for recent recommendations from a project, fetch a canonical paper as markdown, inspect a recommendation, leave recommendation feedback, export JSON, or get Atom feed URLs. This is the default starting point for most users. |
| Run an opinionated research brief workflow | `paperzilla-monitor` | A higher-level workflow skill built on top of Paperzilla access. It is for on-demand paper discussion plus recurring weekday briefs in supported Slack or Telegram setups. |

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
| `paperzilla-monitor` | Workflow | Users who want on-demand paper discussion plus weekday briefs | An opinionated workflow built on top of Paperzilla access |

## Profiles available today

| Skill | Profile | Agent | Transport | Availability |
|---|---|---|---|---|
| `paperzilla` | `generic` | Generic | CLI (`pz`) | [Latest ZIP](https://github.com/paperzilla-ai/paperzilla-skills/releases/latest/download/paperzilla-generic.zip) |
| `paperzilla` | `claude` | Claude | CLI (`pz`) | [Latest ZIP](https://github.com/paperzilla-ai/paperzilla-skills/releases/latest/download/paperzilla-claude.zip) |
| `paperzilla` | `codex` | Codex | CLI (`pz`) | [Latest ZIP](https://github.com/paperzilla-ai/paperzilla-skills/releases/latest/download/paperzilla-codex.zip) |
| `paperzilla` | `openclaw` | OpenClaw | CLI (`pz`) | [ClawHub](https://clawhub.ai/pors/paperzilla) |
| `paperzilla-monitor` | `claude` | Claude | MCP | [Latest ZIP](https://github.com/paperzilla-ai/paperzilla-skills/releases/latest/download/paperzilla-monitor-claude-mcp.zip) |
| `paperzilla-monitor` | `openclaw` | OpenClaw | CLI (`pz`) | [ClawHub](https://clawhub.ai/pors/paperzilla-research-monitor) |

## Codex plugin

This repo also includes a local Codex plugin for the Paperzilla MCP path:

- [`plugins/paperzilla-mcp`](./plugins/paperzilla-mcp)

It bundles the Paperzilla MCP endpoint plus a Codex skill so users can install one plugin instead of setting up Codex MCP and skill files separately.

For the current repo-clone and personal-install flows, see [`plugins/paperzilla-mcp/README.md`](./plugins/paperzilla-mcp/README.md).

## Install

### OpenClaw

If you want the core `paperzilla` skill on OpenClaw, install it from ClawHub:

```bash
clawhub install paperzilla
```

Skill page: https://clawhub.ai/pors/paperzilla

Paperzilla Monitor page: https://clawhub.ai/pors/paperzilla-research-monitor

ClawHub is an install channel, not a separate skill type. The source of truth still lives in this repo.

### Other agents

Download packaged assets from the latest GitHub release:

- https://github.com/paperzilla-ai/paperzilla-skills/releases/latest

Release assets are built automatically and uploaded when a `v*` tag is pushed.

Detailed agent-specific setup and transport documentation should live in the docs repo rather than this README.

For the local Codex plugin install flow, see [`plugins/paperzilla-mcp/README.md`](./plugins/paperzilla-mcp/README.md).

## GitHub import path

If you use an ecosystem that imports skills from GitHub and expects a repo-root `skills/` folder, use this repo URL directly:

- Repo URL: `https://github.com/paperzilla-ai/paperzilla-skills`
- Root import folder: [`skills`](./skills)
- Core canonical export: [`skills/paperzilla`](./skills/paperzilla)
- Workflow canonical export: [`skills/paperzilla-monitor`](./skills/paperzilla-monitor)

This is the path most GitHub-importing skill registries look for. It is generated by the build and contains one canonical profile per skill.

## Agent Skills profile exports

If you need the unpacked per-profile exports, use `catalog/agentskills`:

- Core generic export: [`catalog/agentskills/paperzilla/generic/paperzilla`](./catalog/agentskills/paperzilla/generic/paperzilla)
- Monitor Claude export: [`catalog/agentskills/paperzilla-monitor/claude/paperzilla-monitor`](./catalog/agentskills/paperzilla-monitor/claude/paperzilla-monitor)

These directories match the packaged release assets and are intended to stay compatible with the Agent Skills specification.

## Reference links

- Paperzilla CLI docs: https://docs.paperzilla.ai/guides/cli
- CLI quickstart: https://docs.paperzilla.ai/guides/cli-getting-started
- CLI repo: https://github.com/paperzilla-ai/pz
- Maintainer repo model: [REPO_MODEL.md](./REPO_MODEL.md)

## Security

Only install skills from trusted sources and review packaged files before using them in sensitive environments.
