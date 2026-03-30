# Paperzilla Skills

Official skill packages for using **Paperzilla** from AI agents.

These skills let agents use the `pz` CLI to:
- list projects
- browse project feeds
- inspect paper/feed-item details
- export JSON output
- generate Atom feed URLs

## Get the latest skills

### OpenClaw (recommended install path)
Install from ClawHub (not ZIP):

- Skill page: https://clawhub.ai/pors/paperzilla
- Install command:

```bash
clawhub install paperzilla
```

### Other agents (ZIP packages)
Download from the latest GitHub release assets:

- https://github.com/paperzilla-ai/paperzilla-skills/releases/latest

## Skill matrix

| Skill type | OpenClaw | Claude | Codex | Generic |
|---|---|---|---|---|
| `paperzilla-cli` | ClawHub package: `paperzilla` | ZIP: `paperzilla-cli-claude.zip` | ZIP: `paperzilla-cli-codex.zip` | ZIP: `paperzilla-cli-generic-vX.Y.Z.zip` |
| `paperzilla-monitor` | OpenClaw source variant in repo (can be packaged) | ZIP: `paperzilla-monitor-claude.zip` | — | — |

**Versioning:** the Generic ZIP version matches the OpenClaw skill version (example: `0.2.0`).

## Prerequisites

- Install `pz`: https://docs.paperzilla.ai/guides/cli
- Authenticate once:

```bash
pz login
```

## Reference links

- Paperzilla CLI docs: https://docs.paperzilla.ai/guides/cli
- CLI quickstart: https://docs.paperzilla.ai/guides/cli-getting-started
- CLI repo: https://github.com/paperzilla-ai/pz

## Security

Only install skills from trusted sources and review packaged files before using them in sensitive environments.
