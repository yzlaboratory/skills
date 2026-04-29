# Issues live as local markdown under `docs/ephemeral/`

Issues, PRDs, and slices for projects consumed by these skills are written as gitignored markdown files under `docs/ephemeral/<feature-slug>/` rather than published to a remote tracker (GitHub Issues, Linear, Jira). The skill set targets a solo, single-machine workflow where agents read and write issues directly with file tools — no API auth, no rate limits, no fetch round-trip, instant iteration.

The trade-off is no multi-machine sync, no PR auto-linking, and no label state machine. All acceptable because that's not the workflow this skill set is for; if any of those matter, this is the wrong tool.
