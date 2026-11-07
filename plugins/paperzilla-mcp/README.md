# Paperzilla MCP migration

The local Paperzilla MCP bundle and its API-key setup have been retired. Paperzilla MCP now uses OAuth.

1. If you configured Paperzilla with an API key, remove that old MCP entry from your client.
2. In your client's MCP settings, add `https://paperzilla.ai/api/mcp` as a Streamable HTTP server. For Codex, follow the [Codex setup guide](https://docs.paperzilla.ai/guides/codex). For other clients, see the [MCP setup guide](https://docs.paperzilla.ai/guides/mcp).
3. Sign in to Paperzilla and review the requested permissions. After connecting, ask your client to find public Paperzilla digests about machine learning.

A Paperzilla account is required. You can browse public digests and papers before creating a project.

For command-line workflows, see the separate [Paperzilla CLI guide](https://docs.paperzilla.ai/guides/cli).
