---
name: setup-kira-skills
description: Sets up the per-repo conventions the engineering skills assume — `## Agent skills` block in CLAUDE.md, `docs/agents/` for issue tracker and domain doc rules, and `docs/specs/` with the strict-Gherkin spec template and README. Also adds `docs/ephemeral` to `.gitignore`. Run before first use of `to-spec`, `grill-with-docs`, `to-issues`, `to-prd`, `diagnose`, `tdd`, `improve-codebase-architecture`, or `zoom-out` — or if those skills appear to be missing context about the issue tracker, domain docs, or spec convention.
disable-model-invocation: true
---

# Setup Kira's Skills

Scaffold the per-repo configuration that the engineering skills assume:

- **Issue tracker** — always local markdown under `docs/ephemeral/` (gitignored)
- **Domain docs** — always single-context (`CONTEXT.md` + `docs/adr/`)
- **Specs** — strict Gherkin in markdown under `docs/specs/`, governed by `_template.md` + `README.md`

This is a deterministic skill: there are no choices to present. Explore, confirm with the user, then write.

## Process

### 1. Explore

Look at the current repo to understand its starting state. Read whatever exists; don't assume:

- `CLAUDE.md` at the repo root — does it exist? Is there already an `## Agent skills` section in it?
- `CONTEXT.md` at the repo root
- `docs/adr/` directory
- `docs/agents/` — does this skill's prior output already exist?
- `docs/ephemeral/` — does the issue directory already exist?
- `docs/specs/_template.md` and `docs/specs/README.md` — does the spec convention already exist?
- `.gitignore` — does it already exclude `docs/ephemeral`?

### 2. Confirm and edit

Show the user a draft of:

- The `## Agent skills` block to add to `CLAUDE.md`
- The contents of `docs/agents/issue-tracker.md` and `docs/agents/domain.md`
- The `.gitignore` line to add (`docs/ephemeral/`)

Let them edit before writing.

The spec-convention files (`docs/specs/_template.md` and `docs/specs/README.md`) are copied verbatim from this skill's bundled defaults — they're a single canonical scaffold that `to-spec` and `grill-with-docs` rely on, so we don't draft them. Mention to the user that they'll be written and can be edited later.

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

### Specs

Strict Gherkin in markdown under `docs/specs/`. The convention is `docs/specs/README.md`; new specs start from `docs/specs/_template.md`.
```

Then write the two docs files using the seed templates in this skill folder as a starting point:

- [issue-tracker.md](./issue-tracker.md) — local-markdown issue tracker (under `docs/ephemeral/`)
- [domain.md](./domain.md) — domain doc consumer rules + single-context layout

**Scaffold `docs/specs/`** — copy verbatim from this skill's bundled defaults, but only when the destination file does not already exist (the user may have customised theirs):

- [spec-defaults/_template.md](./spec-defaults/_template.md) → `docs/specs/_template.md`
- [spec-defaults/README.md](./spec-defaults/README.md) → `docs/specs/README.md`

**Update `.gitignore`:**

- If `.gitignore` doesn't exist, create it with `docs/ephemeral/` as the only line.
- If it exists and doesn't already exclude `docs/ephemeral` (or `docs/ephemeral/`), append the line.
- If it already excludes that path, leave it alone.

**Create the `docs/ephemeral/` directory** if it doesn't exist (so issues have a home on first use).

### 4. Done

Tell the user the setup is complete and which engineering skills will now read from these files. Mention they can edit `docs/agents/*.md` and `docs/specs/*.md` directly later — re-running this skill is only necessary if they want to restart from scratch.
