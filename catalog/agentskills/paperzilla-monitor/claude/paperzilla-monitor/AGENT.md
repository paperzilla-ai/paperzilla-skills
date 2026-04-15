# Claude profile rules

Use this profile for:

- live paper discussion in Claude in Slack
- weekday research briefs scheduled in Cowork

## Surfaces

- On-demand discussion surface: Slack
- Weekday brief scheduler: Cowork
- Weekday brief delivery surface: Slack

## Required integrations

- Paperzilla MCP for project, feed, metadata, and markdown access
- Slack access in Claude for draft or send actions
- Cowork for scheduled weekday runs

If Paperzilla MCP is missing, ask the user to enable the Paperzilla connector in Claude with:

`https://paperzilla.ai/api/mcp/`

If Slack delivery actions are unavailable, return a Slack-ready draft inline instead of failing.

## Tooling rules

Use Paperzilla MCP directly.

Preferred tool sequence:

1. `projects_list` when the project is missing or ambiguous
2. `feed_get` for the latest papers from one project
3. `paper_get` for one paper's metadata
4. `paper_markdown` for markdown-backed analysis

Handle `paper_markdown` statuses correctly:

- `ready`: analyze the markdown
- `queued`: say markdown is still being prepared and suggest retrying shortly
- `unavailable`: say markdown is not currently available

Always keep the project and "our work" context stable across the conversation. If "our work" is missing, ask once for a one-sentence description and then reuse it.

## Mode: on-demand discussion

Use Slack as the live chat surface.

Default behavior:

- reply in the current Slack DM, channel, or thread
- keep replies concise and discussion-friendly
- separate metadata from interpretation
- explain why the paper matters for our work

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

If the user is in a shared Slack thread, prefer a Slack-friendly reply that can be reviewed before broader posting when that surface supports drafts.

## Mode: weekday brief

Use Cowork for recurring weekday runs and Slack for delivery.

Default behavior:

- produce one concise weekday brief for one project
- draft the Slack post first unless the user explicitly asked for direct send
- reuse the same project and "our work" context on every run
- keep a persistent per-project history of the exact Paperzilla IDs already proposed in earlier weekday briefs
- exclude previously proposed papers from later weekday briefs unless the user explicitly asked to revisit them
- after drafting or sending the brief, update that history with the exact Paperzilla IDs included in the brief

Persist that proposed-paper history in Cowork or another scheduler-owned state that survives to the next scheduled run.

The weekday brief must include:

- project name
- date
- how many new papers were checked
- for each selected paper:
  - title
  - one short summary
  - one sentence on why it is relevant to our work
- `No new papers today.` when nothing new qualifies

Suggested Slack format:

📚 *Paperzilla brief — [Project Name]*
_[Date] · [N] new papers checked_

• *[Title]* — short summary
  Why it matters: one sentence tied to our work

If no new papers qualify:

📚 *Paperzilla brief — [Project Name]*
_[Date]_

No new papers today.
