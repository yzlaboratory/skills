# Kira's Skills

Agent skills for real engineering work — small, composable slash commands and behaviours loaded by Claude Code.

These skills are adapted from [mattpocock/skills](https://github.com/mattpocock/skills), pruned and reshaped for solo local use:

- Issues live as local markdown under `docs/ephemeral/` (gitignored), not GitHub
- Domain docs are always single-context (`CONTEXT.md` + `docs/adr/`)
- No triage / label state machine

## Install

Pick one of the two install paths below — don't run both, or you'll end up with
duplicates of every skill loaded into Claude Code.

### Option A — Plugin (easiest, no clone)

Inside Claude Code:

```text
/plugin marketplace add yzlaboratory/skills
/plugin install kira-skills@kira-skills
```

Skills land in `~/.claude/plugins/cache/` and update via `/plugin marketplace update`.

### Option B — Copy from a clone

1. Clone the repo somewhere on your machine:

   ```sh
   git clone git@github.com:yzlaboratory/skills.git ~/Workspace/skills
   ```

2. Copy the skills into `~/.claude/skills/`:

   ```sh
   bash ~/Workspace/skills/scripts/install-skills.sh
   ```

   Re-run after pulling new changes — the install copies snapshots, not live links.

   > **Heads up — collisions are destructive.** For each skill in this repo, the
   > script removes any same-named entry already in `~/.claude/skills/` (file,
   > directory, or symlink) and replaces it with a fresh copy. If you already
   > have a `tdd/`, `to-prd/`, `to-issues/`, `zoom-out/`, or
   > `improve-codebase-architecture/` skill there, back them up first — the
   > script will not prompt before deleting them. Unrelated skills are left
   > alone.

## First-run setup (per project)

In any project where you want to use these skills, run `/setup-kira-skills-in-project`. It will:

- Configure the issue tracker as local markdown under `docs/ephemeral/` (gitignored)
- Set up single-context domain docs (`CONTEXT.md` + `docs/adr/`)
- Scaffold `docs/specs/` with the strict-Gherkin spec template and README
- Add the relevant pointers to your `CLAUDE.md`

You're ready to go.

## How the skills compose — end-to-end flow

The engineering skills are designed to chain. A typical flow from "I have an idea" to "the whole backlog is shipped":

```mermaid
flowchart TD
    A["One-time install"] --> B["/setup-kira-skills-in-project"]
    B --> C["/create-alignment-and-refine-docs"]
    C --> D{"Need a PRD?"}
    D -->|optional| E["/to-prd"]
    D -->|skip| F
    E --> F["/to-issues"]
    F --> G{"How to implement?"}
    G -->|one issue at a time<br/>in this conversation| H["/tdd"]
    G -->|whole backlog in parallel| I["/implement-issues"]
```

**The shape of the chain:**

1. **Install once** — plugin or `install-skills.sh`. Repo-independent.
2. **`/setup-kira-skills-in-project`** — run once per repo. Creates the conventions every other skill reads from.
3. **`/create-alignment-and-refine-docs`** — interview-style grilling that aligns you and the agent on terminology and scope, while writing decisions straight into `CONTEXT.md`, `docs/adr/`, `docs/specs/`, and `docs/OOS.md`.
4. **`/to-prd`** *(optional)* — if a PRD will help carry context across sessions or stakeholders, generate one from the conversation and the docs.
5. **`/to-issues`** — slice the PRD/specs/plan into tracer-bullet issues. Reads ADRs, specs, OOS, and CONTEXT as default inputs.
6. **Implement** — pick one:
   - **`/tdd`** in this same conversation, one issue at a time.
   - **`/implement-issues`** to fan the whole backlog out to parallel `/tdd` subagents, each working in its own git worktree. Invoking the skill is the approval — waves spawn automatically as blockers clear, with no per-wave gate.

## What each skill solves

### Misalignment between you and the agent

Agents guess at what you want. The fix is a structured grilling session that interviews you until each branch of the design tree is resolved.

- [`/create-alignment-and-refine-docs`](./skills/engineering/create-alignment-and-refine-docs/SKILL.md) — grilling session that also updates `CONTEXT.md`, ADRs, specs, and OOS inline as decisions crystallise

### Verbose, jargon-blind agents

Agents drop into a project and use 20 words where 1 will do. A shared domain language fixes that — and makes the codebase easier for them to navigate, with consistently named identifiers and fewer thinking tokens spent.

This is built into [`/create-alignment-and-refine-docs`](./skills/engineering/create-alignment-and-refine-docs/SKILL.md): every resolved term goes into `CONTEXT.md` immediately. Hard-to-reverse architectural decisions get an ADR under `docs/adr/`.

### Code that doesn't work

When you and the agent are aligned but the code still breaks, you need feedback loops: types, browser access, automated tests.

- [`/tdd`](./skills/engineering/tdd/SKILL.md) — red-green-refactor loop with guidance on good vs bad tests
- [`/diagnose`](./skills/engineering/diagnose/SKILL.md) — disciplined diagnosis: reproduce → minimise → hypothesise → instrument → fix → regression-test

### A whole backlog to burn down

When you have a directory of issues (typically produced by `/to-issues`) and want them all implemented without babysitting each one.

- [`/implement-issues`](./skills/engineering/implement-issues/SKILL.md) — orchestrates parallel `/tdd` subagents, one per issue per wave, each in its own worktree. Invoking the skill is the approval; waves spawn automatically as blockers clear, with no per-wave gate.

### Architectural drift

Agents accelerate software entropy. The counterweight is investing in design every day.

- [`/to-prd`](./skills/engineering/to-prd/SKILL.md) — quizzes you about which modules you're touching before writing the PRD
- [`/zoom-out`](./skills/engineering/zoom-out/SKILL.md) — tells the agent to explain code in the context of the whole system
- [`/improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md) — rescue a codebase that's become a ball of mud (run every few days)

## Reference

### Engineering

- **[create-alignment-and-refine-docs](./skills/engineering/create-alignment-and-refine-docs/SKILL.md)** — Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates `CONTEXT.md`, ADRs, specs, and OOS inline.
- **[diagnose](./skills/engineering/diagnose/SKILL.md)** — Disciplined diagnosis loop for hard bugs and performance regressions: reproduce → minimise → hypothesise → instrument → fix → regression-test.
- **[implement-issues](./skills/engineering/implement-issues/SKILL.md)** — Orchestrate parallel implementation of every issue in a directory: spawns one `/tdd` subagent per issue per wave, each in its own worktree, respecting `Blocked by` dependencies until the whole backlog is done. Invoking the skill is the approval — waves spawn automatically as blockers clear, with no per-wave gate. Requires the issues directory path as an argument.
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)** — Find deepening opportunities in a codebase, informed by the domain language in `CONTEXT.md` and the decisions in `docs/adr/`.
- **[setup-kira-skills-in-project](./skills/engineering/setup-kira-skills-in-project/SKILL.md)** — Scaffold the per-repo config (local-markdown issue tracker under `docs/ephemeral/`, single-context domain docs, strict-Gherkin spec template and README under `docs/specs/`) that the other engineering skills consume. Run once per repo before using `to-spec`, `create-alignment-and-refine-docs`, `to-issues`, `to-prd`, `diagnose`, `tdd`, `improve-codebase-architecture`, or `zoom-out`.
- **[tdd](./skills/engineering/tdd/SKILL.md)** — Test-driven development with a red-green-refactor loop. Builds features or fixes bugs one vertical slice at a time.
- **[to-issues](./skills/engineering/to-issues/SKILL.md)** — Break any plan, spec, or PRD into independently-grabbable issues using vertical slices. Reads `docs/specs/`, `docs/adr/`, `docs/OOS.md`, and `CONTEXT.md` as default inputs.
- **[to-prd](./skills/engineering/to-prd/SKILL.md)** — Turn the current conversation context into a PRD and publish it to the issue tracker. No interview — just synthesizes what you've already discussed.
- **[zoom-out](./skills/engineering/zoom-out/SKILL.md)** — Tell the agent to zoom out and give broader context or a higher-level perspective on an unfamiliar section of code.
