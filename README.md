# Paperzilla Skills

Single source-of-truth repo for Paperzilla agent skills.

Goals:
- **DRY for maintainers**: one canonical skill body, thin per-agent overlays
- **Easy for users**: direct ZIP downloads per target where needed

## Repository layout

```text
src/
  <skill-name>/
    base/
      BODY.md                 # canonical skill instructions (shared)
      references/             # optional shared docs
      scripts/                # optional shared scripts
      assets/                 # optional shared assets
    overlays/
      generic/frontmatter.yml
      claude/frontmatter.yml
      codex/frontmatter.yml
      openclaw/frontmatter.yml
      <target>/files/...      # optional target-specific files

tools/
  build-distributions.sh      # generates SKILL.md + ZIP artifacts

dist/                         # generated artifacts
catalog/
  downloads.md                # generated install/download index
```

## Build distributions

```bash
./tools/build-distributions.sh
```

This generates:
- `dist/<skill>-<target>.zip` for non-OpenClaw targets
- `dist/<skill>/<target>/<skill>/SKILL.md` assembled from frontmatter + shared body
- `catalog/downloads.md` index

## OpenClaw distribution

For OpenClaw, prefer **ClawHub install** over ZIP download:

```bash
clawhub install paperzilla
```

Published skill page:
- https://clawhub.ai/pors/paperzilla

## Current skills

- `paperzilla-cli`
