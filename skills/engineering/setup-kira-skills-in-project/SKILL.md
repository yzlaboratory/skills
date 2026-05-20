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

- `CLAUDE.md` at the repo root **and** `~/.claude/CLAUDE.md` — do they exist? Is there already an `## Agent skills` section in either? (The destination is mode-dependent; see step 3.)
- `.claude/settings.json` — does it exist? Does it already set `worktree.baseRef`?
- `CONTEXT.md` and `docs/adr/` — the in-repo domain docs (don't create them; they're created lazily by other skills).

### 2. Gather the mode details

- **GitHub** — confirm `gh` is installed and authenticated (`gh auth status`). Determine the `owner/repo` from `git remote get-url origin`.
- **Jira** — confirm the Atlassian MCP is available. Ask the user for the Jira **project key** (e.g. `PROJ`).

### 3. Confirm and write

Show the user the `## Agent skills` block you're about to write (the matching variant below, with placeholders filled in). Let them edit it before writing.

The destination depends on tracker mode:

- **GitHub mode** — write to the project's `CLAUDE.md` at the repo root (create it if it doesn't exist). The block is repo-specific (it names `owner/repo`) and belongs alongside the code.
- **Jira mode** — write to the user's global `~/.claude/CLAUDE.md` (create it if it doesn't exist). Do not touch the project's `CLAUDE.md`. Jira/Bitbucket setups are typically org-wide rather than per-repo, and the block is the same across every repo the user works in for that org.

This skill set targets Claude Code only; `AGENTS.md` is not used. If an `## Agent skills` block already exists in the destination file, replace its contents in-place rather than appending a duplicate. Don't overwrite user edits to surrounding sections.

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

A feature branch names the ticket it implements: `<issue-number>-<slug>` (e.g. `42-checkout-flow`). All commits for that feature — including every sub-issue's work — land on this single branch. Sub-issues do not get their own named branches; subagents implement them in worktrees that branch off the feature branch and merge back into it. Skills derive the current ticket from the feature branch name; worktrees inherit it.

### Domain docs (in-repo)

Before exploring the codebase, read `CONTEXT.md` (domain glossary) and the ADRs under `docs/adr/` that touch the area you're working in. These are the only planning docs committed to the repo. If they don't exist yet, proceed silently — they're created lazily by `/create-alignment-and-refine-docs`. Use the glossary's vocabulary in all output; flag any output that contradicts an ADR.
</github-block>

<jira-block>
## Agent skills

Kira's engineering skills are used across the Jira/Bitbucket projects on this machine. Specs, PRDs, and implementation issues are kept **out of the source tree** — they live in the tracker below. Only `CONTEXT.md` and `docs/adr/` are committed to each repo.

### Tracker — Jira

Specs, PRDs, and issues live in Jira, project `<KEY>`.

- **Feature ticket** — a Jira Story, created by a human and passed to `/create-alignment-and-refine-docs`. **Leave the Story's own description untouched.** The feature's planning docs are written as **comments** on the Story — a separate comment each for `## PRD`, `## Spec` (strict Gherkin), and `## Out of scope`. To update one, edit its existing comment (matched by the heading); create the comment if it doesn't exist yet.
- **Issue** — a Jira Subtask of that Story. One tracer-bullet vertical slice, produced by `/to-issues`.
- Use the Atlassian MCP for all tracker reads and writes.
- The code itself lives on **Bitbucket** — pull requests are Bitbucket PRs, not GitHub. Tracker (Jira) and code host (Bitbucket) are separate systems; skills that open or read a PR target Bitbucket.
- Nothing is closed automatically. Once a feature's PR merges to `main`, its Story and Subtasks are simply stale — ignore them.

### Branch naming

A feature branch names the Story it implements with a Git Flow prefix:

- `feature/<STORY-KEY>-<slug>` — default, for normal work (e.g. `feature/PROJ-42-checkout-flow`).
- `hotfix/<STORY-KEY>-<slug>` — for urgent fixes; use when the Story is a Bug or the user explicitly calls it a hotfix (e.g. `hotfix/PROJ-99-payment-double-charge`).

All commits for that Story — including every Subtask's work — land on this single feature branch. Subtasks do not get their own named branches; subagents implement them in worktrees that branch off the feature branch and merge back into it.

Skills derive the current Story from the feature branch name by stripping the leading `feature/` or `hotfix/` segment, then parsing `<STORY-KEY>-<slug>`. Worktrees inherit the branch and thus the prefix.

### Commit messages

Every commit message starts with the Jira key of the ticket it implements, followed by a single space: `<STORY-KEY> <message>` (e.g. `PROJ-43 add webhook signature verification`). This is the Bitbucket Smart Commit convention — it links each commit to the right Subtask or Story automatically. On alignment commits (ADRs, `CONTEXT.md`) made on the feature branch directly, use the feature Story's key.

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

Tell the user setup is complete, where the `## Agent skills` block was written (project `CLAUDE.md` for GitHub mode, `~/.claude/CLAUDE.md` for Jira mode), and which engineering skills now read this block.
