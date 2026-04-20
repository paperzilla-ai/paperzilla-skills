# Paperzilla MCP plugin

`paperzilla-mcp` is a Codex plugin that bundles the Paperzilla MCP endpoint declaration and a Codex skill for Paperzilla research workflows.

The customer-facing MCP setup should use Codex **Settings** > **Integrations & MCP**, not this local plugin installer. In Codex settings, users can add Paperzilla as a custom MCP server with this URL:

```txt
https://paperzilla.ai/api/mcp/?key=pzmcp_...
```

Replace `pzmcp_...` with a real **Paperzilla MCP API key** from the Paperzilla dashboard.

Important current limitation: Codex plugin install does not prompt for API keys for non-OAuth MCP servers. Paperzilla uses an **MCP API key**, so this plugin is not the best customer setup path today. Keep the plugin for local testing and for a future OpenAI public Plugin Directory release.

## What this plugin includes

- [`.mcp.json`](./.mcp.json) declares the `paperzilla` MCP server endpoint.
- [`skills/paperzilla-mcp/SKILL.md`](./skills/paperzilla-mcp/SKILL.md) teaches Codex the Paperzilla MCP tool flow.
- [`../../.agents/plugins/marketplace.json`](../../.agents/plugins/marketplace.json) makes the plugin discoverable for this repo workspace.

## Current customer UX

The current Paperzilla customer flow is:

1. Open Codex **Settings**.
2. Open **Integrations & MCP**.
3. Add a custom MCP server.
4. Use `paperzilla` as the server name.
5. Select **Streamable HTTP**.
6. Paste `https://paperzilla.ai/api/mcp/?key=pzmcp_...` as the MCP server URL.
7. Click **Save**.
8. Start a new thread and ask Codex to use Paperzilla.

No `pz` install, no shell script, and no local plugin install are required.

## Local plugin testing

Codex does not currently document direct plugin install from a GitHub URL.

There is no Paperzilla API-key prompt in the current Codex plugin install flow. If Codex does show an auth flow for a plugin MCP server, that is for OAuth-style MCP auth, not the Paperzilla MCP API key.

## Install for this workspace

Use this path when you want the plugin available only inside this repo workspace.

1. Open `paperzilla-skills` as the workspace in Codex.
2. Restart Codex if the workspace marketplace does not appear immediately.
3. Open **Plugins** in Codex.
4. Select the **Paperzilla** marketplace.
5. Install `paperzilla-mcp`.
6. Add this block to `~/.codex/config.toml` or a trusted project `.codex/config.toml`:

```toml
[mcp_servers.paperzilla]
url = "https://paperzilla.ai/api/mcp"
http_headers = { Authorization = "Bearer pzmcp_..." }
```

7. Replace `pzmcp_...` with your real **Paperzilla MCP API key** from the Paperzilla dashboard.
8. Restart Codex and start a new thread.

## Install for your user account

Use this path only for local testing or internal team packaging when you want the plugin available across workspaces without keeping the repo open as the active workspace.

1. Run the installer script from this plugin directory and enter your **Paperzilla MCP API key** when prompted:

```bash
./scripts/install-personal.sh
```

Or point it at another local copy of the plugin:

```bash
./scripts/install-personal.sh /absolute/path/to/paperzilla-skills/plugins/paperzilla-mcp
```

For non-interactive testing, pass the key explicitly:

```bash
./scripts/install-personal.sh --api-key pzmcp_...
```

The script:

- symlinks the plugin into `~/.codex/plugins/paperzilla-mcp`
- creates or updates `~/.agents/plugins/marketplace.json`
- writes the `paperzilla` MCP server config into `~/.codex/config.toml` when you provide a key
- backs up an existing `~/.codex/config.toml` before changing it
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
        "path": "./.codex/plugins/paperzilla-mcp"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_USE"
      },
      "category": "Productivity"
    }
  ]
}
```

The MCP config block it writes looks like this:

```toml
[mcp_servers.paperzilla]
url = "https://paperzilla.ai/api/mcp"
http_headers = { Authorization = "Bearer pzmcp_..." }
```

2. Restart Codex.
3. Open **Plugins**, select **Paperzilla**, and install `paperzilla-mcp`.
4. Start a new thread and ask Codex to use Paperzilla.

## Use after install

Start a new thread and use prompts such as:

- `Use the paperzilla MCP server. Do not use pz.`
- `List my Paperzilla projects.`
- `Search this Paperzilla project for papers about retrieval evaluation.`
- `Fetch this Paperzilla paper as markdown and summarize it.`

## Troubleshooting

- If Codex starts talking about "connector methods" or uses unrelated tools, Paperzilla MCP is not actually available yet.
- If the plugin is installed but `paperzilla` does not appear in `/mcp`, add Paperzilla through Codex **Settings** > **Integrations & MCP** or check `~/.codex/config.toml` for the `paperzilla` MCP block above.
- If `/mcp paperzilla` shows `Auth unsupported` and `Enabled`, that can be normal for static API-key auth. Codex uses that label for unsupported interactive OAuth login, not as proof that the key is missing.
- If `paperzilla` appears but auth fails, regenerate your **Paperzilla MCP API key** in the dashboard and update the custom MCP URL in Codex **Integrations & MCP**. For local plugin testing, you can also rerun `./scripts/install-personal.sh`.
- If you installed only from the repo marketplace, remember that repo marketplace install gives Codex the plugin and skill, but it does not write your Paperzilla API key into Codex MCP config.

## Docs and keys

- Codex guide: `https://docs.paperzilla.ai/guides/codex`
- MCP guide: `https://docs.paperzilla.ai/guides/mcp`
- Dashboard key panel: `https://paperzilla.ai/dashboard`

## Current publishing status

This plugin is ready for local and team marketplace testing today.

Official public Plugin Directory publishing for Codex is still gated by OpenAI's self-serve plugin publishing rollout, so this repo ships the local marketplace path first.
