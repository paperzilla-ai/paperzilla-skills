---
name: paperzilla-mcp
description: Use Paperzilla through the bundled `paperzilla` MCP server. Prefer this plugin MCP path over `pz` when the user wants live projects, feeds, paper metadata, or paper markdown from Paperzilla.
---

# Paperzilla MCP

Use this skill when you need live Paperzilla data in Codex through the bundled `paperzilla` MCP server.

## Setup assumptions

- The user installs the `paperzilla-mcp` plugin from Codex Plugins.
- The plugin bundles the Paperzilla MCP endpoint at `https://paperzilla.ai/api/mcp`.
- During install or plugin setup, the user should provide a **Paperzilla MCP API key** from the Paperzilla dashboard.
- If the plugin is installed but auth is missing or invalid, tell the user to reopen the plugin settings or reinstall the plugin with a fresh key.
- Setup docs:
  - `https://docs.paperzilla.ai/guides/codex`
  - `https://docs.paperzilla.ai/guides/mcp`
  - `https://paperzilla.ai/dashboard`

## Default behavior

- Before doing any Paperzilla task, use only the bundled `paperzilla` MCP server.
- Prefer the `paperzilla` MCP server over the `pz` CLI.
- Do not fall back to `pz` unless the user explicitly asks for the CLI path.
- Never substitute other connectors or apps for Paperzilla. Do not use Stripe, Gmail, GitHub, or any other unrelated tool to answer a Paperzilla request.
- Keep both the project feed item ID and the canonical `paper.id` when feed results include both.

## Authentication and availability

- If the `paperzilla` tools are unavailable, unauthenticated, or return an auth/startup error, stop and tell the user that Paperzilla MCP is not ready.
- In that case, do not keep searching for "connector methods" or explore unrelated tools.
- Tell the user to check the `paperzilla-mcp` plugin install state and complete Codex auth or MCP setup with a valid **Paperzilla MCP API key**.
- If the plugin appears installed but Paperzilla tools still do not work, tell the user to reopen the plugin or MCP settings and re-enter the key.
- Once Paperzilla MCP is available, resume the normal tool flow below.

## Tool flow

1. Start with `projects_list` when you need to identify a project.
2. Use `projects_get` when the user asks for project settings or project details.
3. Use `feed_get` for browse-style feed retrieval.
4. Use `feed_search` for title, author, abstract, or summary search across the full project feed.
5. Use `paper_get` when you need standalone paper metadata or need to resolve an identifier.
6. Use `paper_markdown` with the canonical `paper.id` when the user wants the paper body as markdown.

## Paper and feed rules

- `feed_get` and `feed_search` already return nested paper metadata, so skip `paper_get` unless it adds something.
- `paper_markdown` returns structured statuses such as `ready`, `queued`, and `unavailable`.
- Treat `queued` and `unavailable` as normal outcomes. Explain the status and retry or suggest retrying later instead of inventing missing content.
- When the user asks for "some papers", browse or search the feed first instead of going straight to `paper_markdown`.

## Example requests

- `List my Paperzilla projects and show the newest feed items from one.`
- `Search this Paperzilla project for papers about retrieval evaluation.`
- `Get the metadata for this Paperzilla paper, then fetch the markdown.`
- `Summarize this Paperzilla paper from markdown.`
