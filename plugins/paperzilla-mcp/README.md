# Paperzilla MCP plugin

`paperzilla-mcp` is a Codex plugin that bundles the Paperzilla MCP endpoint and a Codex skill for Paperzilla research workflows.

Today, the customer-facing install path is repo-based, not public-directory-based. A customer can clone or download this repo, then install the plugin from a repo or personal marketplace inside Codex.

## What this plugin includes

- [`.mcp.json`](./.mcp.json) registers the `paperzilla` MCP server.
- [`skills/paperzilla-mcp/SKILL.md`](./skills/paperzilla-mcp/SKILL.md) teaches Codex the Paperzilla MCP tool flow.
- [`../../.agents/plugins/marketplace.json`](../../.agents/plugins/marketplace.json) makes the plugin discoverable for this repo workspace.

## Current customer UX

Codex does not currently document direct plugin install from a GitHub URL.

The current Paperzilla customer flow is:

1. Clone or download this repo.
2. Either:
   - open the repo in Codex and install from the repo marketplace, or
   - run the personal installer script below to make the plugin available across workspaces
3. Open **Plugins** in Codex.
4. Select the **Paperzilla** marketplace.
5. Install `paperzilla-mcp`.
6. Complete any Codex auth or setup prompt with your **Paperzilla MCP API key**.
7. Start a new thread and ask Codex to use Paperzilla.

This is the current GitHub-backed flow. It still depends on local files after clone or download.

## Install for this workspace

Use this path when you want the plugin available only inside this repo workspace.

1. Open `paperzilla-skills` as the workspace in Codex.
2. Restart Codex if the workspace marketplace does not appear immediately.
3. Open **Plugins** in Codex.
4. Select the **Paperzilla** marketplace.
5. Install `paperzilla-mcp`.
6. Complete any Codex auth or setup prompt with your **Paperzilla MCP API key**.
7. Start a new thread and ask Codex to use Paperzilla.

## Install for your user account

Use this path when you want the plugin available across workspaces without keeping the repo open as the active workspace.

1. Run the installer script from this plugin directory:

```bash
./scripts/install-personal.sh
```

Or point it at another local copy of the plugin:

```bash
./scripts/install-personal.sh /absolute/path/to/paperzilla-skills/plugins/paperzilla-mcp
```

The script:

- symlinks the plugin into `~/.codex/plugins/paperzilla-mcp`
- creates or updates `~/.agents/plugins/marketplace.json`
- preserves any existing marketplace metadata and other plugin entries

The marketplace entry it writes looks like this:

```json
{
  "name": "paperzilla",
  "interface": {
    "displayName": "Paperzilla"
  },
  "plugins": [
    {
      "name": "paperzilla-mcp",
      "source": {
        "source": "local",
        "path": "./plugins/paperzilla-mcp"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Productivity"
    }
  ]
}
```

2. Restart Codex.
3. Open **Plugins**, select **Paperzilla**, and install `paperzilla-mcp`.
4. Complete any Codex auth or setup prompt with your **Paperzilla MCP API key**.

## Use after install

Start a new thread and use prompts such as:

- `Use the paperzilla MCP server. Do not use pz.`
- `List my Paperzilla projects.`
- `Search this Paperzilla project for papers about retrieval evaluation.`
- `Fetch this Paperzilla paper as markdown and summarize it.`

## Docs and keys

- Codex guide: `https://docs.paperzilla.ai/guides/codex`
- MCP guide: `https://docs.paperzilla.ai/guides/mcp`
- Dashboard key panel: `https://paperzilla.ai/dashboard`

## Current publishing status

This plugin is ready for local and team marketplaces today.

Official public Plugin Directory publishing for Codex is still gated by OpenAI's self-serve plugin publishing rollout, so this repo ships the local marketplace path first.
