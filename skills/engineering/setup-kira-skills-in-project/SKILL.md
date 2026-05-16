---
name: setup-kira-skills-in-project
description: Sets up the per-repo conventions the engineering skills assume — picks the project's tracker mode (Jira or GitHub Issues) and writes the `## Agent skills` block into CLAUDE.md describing the tracker, the branch-naming convention, and the in-repo domain docs. Run before first use of `create-alignment-and-refine-docs`, `create-prd-after-alignment`, `to-issues`, `implement-issues`, `diagnose`, `tdd`, `improve-codebase-architecture`, or `zoom-out` — or if those skills appear to be missing context about the tracker or domain docs.
disable-model-invocation: true
---

# Setup Kira's Skills

The engineering skills keep ephemeral planning docs — specs, PRDs, and implementation issues — **out of the source tree**. They live in an external tracker instead. Only two artifacts stay committed to the repo: the domain glossary (`CONTEXT.md`) and the architectural decision records (`docs/adr/`).

This skill records, in `CLAUDE.md`, which tracker the project uses so every other skill can find specs, PRDs, and issues.

## The one choice: tracker mode

Ask the user which mode this project uses:

- **GitHub** — specs, PRDs, and issues live in **GitHub Issues** on the repo's `origin` remote. A feature ticket is a GitHub issue; implementation issues are its sub-issues. Tracker access is the `gh` CLI.
- **Jira** — specs, PRDs, and issues live in **Jira**. A feature ticket is a Jira Story; implementation issues are its Subtasks. Tracker access is the Atlassian MCP.

There are no other choices to present. Everything else is deterministic.

## Process

### 1. Explore

Look at the current repo to understand its starting state. Read whatever exists; don't assume:

- `CLAUDE.md` at the repo root — does it exist? Is there already an `## Agent skills` section in it?
- `.claude/settings.json` — does it exist? Does it already set `worktree.baseRef`?
- `CONTEXT.md` and `docs/adr/` — the in-repo domain docs (don't create them; they're created lazily by other skills).
- Stale artifacts from an older setup — `docs/specs/`, `docs/prd/`, `docs/ephemeral/`, `docs/agents/`. These directories are no longer used. If any exist, note them for the final step.

### 2. Gather the mode details

- **GitHub** — confirm `gh` is installed and authenticated (`gh auth status`). Determine the `owner/repo` from `git remote get-url origin`.
- **Jira** — confirm the Atlassian MCP is available. Ask the user for the Jira **project key** (e.g. `PROJ`).

### 3. Confirm and write

Show the user the `## Agent skills` block you're about to write (the matching variant below, with placeholders filled in). Let them edit it before writing.

Then edit `CLAUDE.md` (create it if it doesn't exist). This skill set targets Claude Code only; `AGENTS.md` is not used. If an `## Agent skills` block already exists, replace its contents in-place rather than appending a duplicate. Don't overwrite user edits to surrounding sections.

<github-block>
## Agent skills

This repo uses Kira's engineering skills. Specs, PRDs, and implementation issues are kept **out of the source tree** — they live in the tracker below. Only `CONTEXT.md` and `docs/adr/` are committed.

### Tracker — GitHub Issues

Specs, PRDs, and issues live in GitHub Issues on `<owner>/<repo>`.

- **Feature ticket** — a GitHub issue. Its **body** holds, for one feature, three sections in order: `## PRD`, `## Spec` (strict Gherkin), and `## Out of scope`. Created by `/create-alignment-and-refine-docs` (or passed to it if one already exists).
- **Issue** — a GitHub sub-issue of a feature ticket. One tracer-bullet vertical slice, produced by `/to-issues`.
- Use the `gh` CLI for all tracker reads and writes. Link a child to its feature ticket with `gh issue edit <feature-ticket> --add-sub-issue <child>`.
- Nothing is closed automatically. Once a feature's PR merges to `main`, its feature ticket and issues are simply stale — ignore them.

### Branch naming

A feature branch names the ticket it implements: `<issue-number>-<slug>` (e.g. `42-checkout-flow`). Implementation branches name their issue the same way. Skills derive the current ticket from the branch name; worktrees inherit it.

### Domain docs (in-repo)

Before exploring the codebase, read `CONTEXT.md` (domain glossary) and the ADRs under `docs/adr/` that touch the area you're working in. These are the only planning docs committed to the repo. If they don't exist yet, proceed silently — they're created lazily by `/create-alignment-and-refine-docs`. Use the glossary's vocabulary in all output; flag any output that contradicts an ADR.
</github-block>

<jira-block>
## Agent skills

This repo uses Kira's engineering skills. Specs, PRDs, and implementation issues are kept **out of the source tree** — they live in the tracker below. Only `CONTEXT.md` and `docs/adr/` are committed.

### Tracker — Jira

Specs, PRDs, and issues live in Jira, project `<KEY>`.

- **Feature ticket** — a Jira Story, created by a human and passed to `/create-alignment-and-refine-docs`. **Leave the Story's own description untouched.** The feature's planning docs are written as **comments** on the Story — a separate comment each for `## PRD`, `## Spec` (strict Gherkin), and `## Out of scope`. To update one, edit its existing comment (matched by the heading); create the comment if it doesn't exist yet.
- **Issue** — a Jira Subtask of that Story. One tracer-bullet vertical slice, produced by `/to-issues`.
- Use the Atlassian MCP for all tracker reads and writes.
- The code itself lives on **Bitbucket** — pull requests are Bitbucket PRs, not GitHub. Tracker (Jira) and code host (Bitbucket) are separate systems; skills that open or read a PR target Bitbucket.
- Nothing is closed automatically. Once a feature's PR merges to `main`, its Story and Subtasks are simply stale — ignore them.

### Branch naming

A feature branch names the Story it implements: `<STORY-KEY>-<slug>` (e.g. `PROJ-42-checkout-flow`). Implementation branches name their Subtask the same way. Skills derive the current ticket from the branch name; worktrees inherit it.

### Domain docs (in-repo)

Before exploring the codebase, read `CONTEXT.md` (domain glossary) and the ADRs under `docs/adr/` that touch the area you're working in. These are the only planning docs committed to the repo. If they don't exist yet, proceed silently — they're created lazily by `/create-alignment-and-refine-docs`. Use the glossary's vocabulary in all output; flag any output that contradicts an ADR.
</jira-block>

### 4. Set the worktree base ref

`/implement-issues` fans work out to subagents that each run in a git worktree. Those worktrees must branch from the **feature branch** — which carries the alignment ADRs and `CONTEXT.md` — not from `origin/main`. Set this in `.claude/settings.json` (merge into the existing JSON; create the file if absent):

```json
{
  "worktree": { "baseRef": "head" }
}
```

With `head`, a worktree branches from the orchestrator's current HEAD. `/implement-issues` runs on the feature branch, so its subagents inherit it. If `worktree.baseRef` is already set to something else, surface the conflict to the user rather than overwriting it.

### 5. Done

Tell the user setup is complete and which engineering skills now read this block. If you found stale `docs/specs/`, `docs/prd/`, `docs/ephemeral/`, or `docs/agents/` directories in step 1, point them out: they were used by the previous local-docs setup and can be deleted — say so, but do **not** delete them yourself. Likewise, any `docs/ephemeral/` line in `.gitignore` is now harmless but unused.
