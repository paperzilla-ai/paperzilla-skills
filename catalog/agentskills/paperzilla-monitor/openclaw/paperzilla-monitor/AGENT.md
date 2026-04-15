# OpenClaw profile rules

Use this profile for:

- live paper discussion in Telegram or another OpenClaw chat surface
- weekday research briefs delivered to Telegram

## Surfaces

- On-demand discussion surface: the current chat, preferably Telegram when available
- Weekday brief delivery surface: Telegram

## Tooling

- Use OpenClaw `exec` for Paperzilla CLI calls
- Use OpenClaw `message` for Telegram delivery when you need to send externally
- Do not require MCP integrations for this profile

Use the Paperzilla CLI directly:

```bash
pz project list
pz project <project-id>
pz feed <project-id> --limit 20 --json
pz paper <paper-id-or-feed-id> --json
pz paper <paper-id-or-feed-id> --markdown
```

If "our work" is missing, ask once for one sentence and then reuse it.

## Mode: on-demand discussion

Keep the discussion in the current chat. If the current chat is Telegram, that is the default live surface.

Default behavior:

- show the latest papers from one project
- let the user pick one paper
- return metadata first
- then fetch markdown and explain why it matters for our work
- keep the discussion going in chat

When discussing one paper, include:

- title
- authors
- publication date
- source
- URL
- exact Paperzilla ID used
- contribution
- method
- results
- limits
- why it matters for our work

If markdown is still being prepared, say so and suggest retrying shortly.

## Mode: weekday brief

Use Telegram as the default delivery surface for the recurring brief.

Default behavior:

- produce one concise weekday brief for one project
- if the current run is a scheduled or external-send run, send the brief through the `message` tool to Telegram
- if the brief is sent externally and no chat reply is needed, return `NO_REPLY`
- if this is a user-initiated interactive run, keep the response in chat unless the user explicitly asked to send it elsewhere
- keep a persistent per-project history of the exact Paperzilla IDs already proposed in earlier weekday briefs
- exclude previously proposed papers from later weekday briefs unless the user explicitly asked to revisit them
- after sending or drafting the brief, update that history with the exact Paperzilla IDs included in the brief

Persist that proposed-paper history in the scheduling job state or another profile-owned memory surface that survives to the next run.

The weekday brief must include:

- project name
- date
- how many new papers were checked
- for each selected paper:
  - title
  - one short summary
  - one sentence on why it is relevant to our work
- `No new papers today.` when nothing new qualifies

Suggested Telegram-friendly format:

📚 Paperzilla brief — [Project Name]
[Date] · [N] new papers checked

- [Title](url) — short summary
  Why it matters: one sentence tied to our work

If no new papers qualify:

📚 Paperzilla brief — [Project Name]
[Date]

No new papers today.
