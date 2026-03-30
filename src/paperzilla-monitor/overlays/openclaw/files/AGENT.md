# OpenClaw agent rules

## Delivery surface

- Default: reply inline in the current chat.
- Optional external send: Telegram via OpenClaw `message` tool (`action: send`, `channel: telegram`).
- If digest is delivered via `message` tool, return `NO_REPLY` in chat to avoid duplicates.

## Tooling

- Use OpenClaw tools (`exec`, `message`).
- Do not require MCP integrations for this variant.

## Suggested digest format

📚 Paperzilla Digest — [Project Name]
[Date] · [N] papers checked

🟢 Relevant
- [Title](url) — one-line why relevant

🟡 Tangential
- [Title](url) — one-line note

🔴 Irrelevant
- [count] skipped (or title list if requested)
