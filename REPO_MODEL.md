# Repo Model

This document describes the target structure for `paperzilla-skills`.

The goal is to keep the repo understandable for users and maintainable for us without turning every dimension into a separate top-level product.

## User Model

Users should choose a skill by function, not by implementation details.

The recommended decision flow is:

1. What do you want your agent to do?
2. Choose the skill that matches that job.
3. Choose one supported profile for your agent and setup.

The two primary skill categories are:

- `core`: conversational access to Paperzilla
- `workflow`: opinionated flows built on top of that access

## Product Taxonomy

### Core skill

`paperzilla`

This is the default Paperzilla skill. It is not "just browsing." It should support the full conversational experience around Paperzilla data, including:

- getting the latest papers from a project
- fetching paper details or markdown
- summarizing a paper
- assessing relevance to the user's research
- comparing papers
- exporting structured output when needed

The core skill should avoid workflow-specific automation and external delivery logic.

### Workflow skills

Example: `paperzilla-monitor`

Workflow skills should be treated as opinionated examples or packaged solutions for repeated tasks. They do not expose fundamentally different Paperzilla capabilities. They encode:

- a repeated workflow
- an output format
- optional external delivery or integrations

Examples:

- feed triage with relevance buckets
- digest generation
- posting to Slack or Telegram

## Profiles

A profile is a supported combination of:

- agent runtime
- Paperzilla transport
- optional integrations

Examples:

- `generic`
- `claude`
- `codex`
- `openclaw`

Profiles are support commitments, not a full compatibility matrix. We should only ship profiles we are prepared to maintain.

When one agent needs multiple materially different variants, the profile id can include the transport or integration. Until then, prefer short ids and keep transport in metadata.

Rules:

- Every `core` skill should have a `generic` profile.
- The `generic` profile should work in most environments and avoid agent-specific behavior.
- Agent-specific profiles exist only when packaging, prompts, or tooling differ in meaningful ways.
- Workflow skills can support a narrower set of profiles.

## Source Layout

Target layout:

```text
src/
  paperzilla/
    skill.yml
    base/
      BODY.md
    profiles/
      generic/
        profile.yml
      claude/
        profile.yml
        files/
      codex/
        profile.yml
        files/
      openclaw/
        profile.yml
        files/

  paperzilla-monitor/
    skill.yml
    base/
      BODY.md
    profiles/
      claude/
        profile.yml
        files/
      openclaw/
        profile.yml
        files/
```

Notes:

- `base/BODY.md` contains the shared skill instructions for that skill.
- `profiles/<id>/profile.yml` contains metadata for one supported profile.
- `profiles/<id>/files/` contains profile-specific files such as agent manifests or install helpers.

## Manifest Schema

### `skill.yml`

`skill.yml` is the source of truth for the user-facing skill.

Example:

```yaml
id: paperzilla
name: Paperzilla
package_root: paperzilla
category: core
summary: Chat with your agent about projects and papers in Paperzilla.
frontmatter_name: paperzilla
frontmatter_description: Chat with your agent about projects and papers in Paperzilla.
recommended_profile: generic
profiles:
  - generic
  - claude
  - codex
  - openclaw
```

Suggested fields:

- `id`
- `name`
- `package_root`
- `category`: `core` or `workflow`
- `summary`
- `frontmatter_name`
- `frontmatter_description`
- `recommended_profile`
- `profiles`

### `profile.yml`

`profile.yml` is the source of truth for one supported profile.

Example:

```yaml
id: codex
agent: codex
transport: cli
package_type: zip
artifact_name: paperzilla-codex
version: 0.2.1
```

Suggested fields:

- `id`
- `agent`
- `transport`: `mcp`, `cli`, or another supported backend path
- `package_type`: `zip`, `openclaw`, or `source`
- `artifact_name`
- `version`
- `install_command`
- `requires_bins`
- `homepage`
- `source_note`
- `sync_repo_root_skill`

## Distribution Channels

Distribution channels should not be top-level product concepts.

- ClawHub is an install path for supported OpenClaw profiles.
- GitHub release ZIPs are a delivery mechanism for packaged profiles.
- Some profiles can remain source-only.

The current outlier is the core `paperzilla` OpenClaw profile, which is published on ClawHub. That should be visible in install docs, but it should not change the skill taxonomy.

The repo root [`SKILL.md`](./SKILL.md) can remain synced to that core OpenClaw profile so ClawHub users still get the simplest install path.

## README Strategy

The README should stay short and user-centric.

Recommended structure:

1. What is this repo?
2. Which skill do I need?
3. Brief explanation of core skills versus workflow skills
4. Short profile/compatibility table
5. Links to docs

The README should not be the place for:

- full CLI install instructions
- MCP setup walkthroughs
- agent-specific packaging details
- deep workflow behavior docs

Those should live in the docs repo.

## Build Strategy

The build should move from "build every overlay directory" to "build declared profiles from manifests."

Target behavior:

1. Discover all `src/*/skill.yml` files.
2. For each skill, read its declared profiles.
3. For each profile:
   - merge `base/BODY.md` with profile metadata
   - copy profile-specific files
   - emit the correct package shape for that profile
4. Regenerate `catalog/downloads.md`
5. Optionally generate a machine-readable catalog for docs or release automation
6. Optionally sync the repo-root `SKILL.md` for the published OpenClaw profile
7. On tag push, publish packaged ZIP assets to a GitHub release

Important policy:

- Do not infer supported profiles from directory names alone.
- Build only what is declared in manifests.
- Keep generated filenames decoupled from internal folder names.

## Migration Path

Recommended sequence:

1. Treat `paperzilla` as the canonical name of the core skill.
2. Move the current `paperzilla-cli` source tree to `src/paperzilla/`.
3. Introduce `skill.yml` and `profile.yml` manifests.
4. Rework the build script to use manifests.
5. Align release artifact names with the canonical skill names.

## Decision Summary

The repo should present skills by job-to-be-done.

- Function is the top-level product concept.
- Agent and transport are profile details.
- The base Paperzilla skill is a conversational research tool, not a thin wrapper around low-level commands.
- Workflow skills are examples or packaged automations built on top of the base skill.
