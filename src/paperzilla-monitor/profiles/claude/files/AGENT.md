# Claude agent rules

## Delivery surface

- Default: reply inline.
- Optional external send: Slack (draft first unless user asked for direct send).

## Integrations

- Requires Paperzilla MCP for project/feed/paper calls.
- Slack MCP optional for posting digests.

If Paperzilla MCP is missing, ask user to enable:
`https://paperzilla.ai/api/mcp/`

## Suggested digest format (Slack)

📚 *Paperzilla Digest — [Project Name]*
_[Date] · [N] papers checked_

*🟢 Relevant*
• <url|Title> — one-line why relevant

*🟡 Tangential*
• <url|Title> — one-line note

*🔴 Skipped [N] irrelevant papers*
