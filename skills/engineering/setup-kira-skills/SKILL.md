---
name: setup-kira-skills
description: Sets up an `## Agent skills` block in CLAUDE.md and `docs/agents/` so the engineering skills know this repo's issue tracker location (always local markdown under `docs/ephemeral/`) and domain doc layout (always single-context). Also adds `docs/ephemeral` to `.gitignore`. Run before first use of `to-issues`, `to-prd`, `diagnose`, `tdd`, `improve-codebase-architecture`, or `zoom-out` — or if those skills appear to be missing context about the issue tracker or domain docs.
disable-model-invocation: true
---

# Setup Kira's Skills

Scaffold the per-repo configuration that the engineering skills assume:

- **Issue tracker** — always local markdown under `docs/ephemeral/` (gitignored)
- **Domain docs** — always single-context (`CONTEXT.md` + `docs/adr/`)

This is a deterministic skill: there are no choices to present. Explore, confirm with the user, then write.

## Process

### 1. Explore

Look at the current repo to understand its starting state. Read whatever exists; don't assume:

- `CLAUDE.md` at the repo root — does it exist? Is there already an `## Agent skills` section in it?
- `CONTEXT.md` at the repo root
- `docs/adr/` directory
- `docs/agents/` — does this skill's prior output already exist?
- `docs/ephemeral/` — does the issue directory already exist?
- `.gitignore` — does it already exclude `docs/ephemeral`?

### 2. Confirm and edit

Show the user a draft of:

- The `## Agent skills` block to add to `CLAUDE.md`
- The contents of `docs/agents/issue-tracker.md` and `docs/agents/domain.md`
- The `.gitignore` line to add (`docs/ephemeral/`)

Let them edit before writing.

### 3. Write

Edit `CLAUDE.md` (create it if it doesn't exist). This skill set targets Claude Code only; `AGENTS.md` is not used.

If an `## Agent skills` block already exists, update its contents in-place rather than appending a duplicate. Don't overwrite user edits to surrounding sections.

The block:

```markdown
## Agent skills

### Issue tracker

Issues live as local markdown under `docs/ephemeral/` (gitignored). See `docs/agents/issue-tracker.md`.

### Domain docs

Single-context layout (`CONTEXT.md` + `docs/adr/` at repo root). See `docs/agents/domain.md`.
```

Then write the two docs files using the seed templates in this skill folder as a starting point:

- [issue-tracker.md](./issue-tracker.md) — local-markdown issue tracker (under `docs/ephemeral/`)
- [domain.md](./domain.md) — domain doc consumer rules + single-context layout

**Update `.gitignore`:**

- If `.gitignore` doesn't exist, create it with `docs/ephemeral/` as the only line.
- If it exists and doesn't already exclude `docs/ephemeral` (or `docs/ephemeral/`), append the line.
- If it already excludes that path, leave it alone.

**Create the `docs/ephemeral/` directory** if it doesn't exist (so issues have a home on first use).

### 4. Done

Tell the user the setup is complete and which engineering skills will now read from these files. Mention they can edit `docs/agents/*.md` directly later — re-running this skill is only necessary if they want to restart from scratch.
