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

In any project where you want to use these skills, run `/setup-kira-skills`. It will:

- Configure the issue tracker as local markdown under `docs/ephemeral/` (gitignored)
- Set up single-context domain docs (`CONTEXT.md` + `docs/adr/`)
- Add the relevant pointers to your `CLAUDE.md`

You're ready to go.

## What each skill solves

### Misalignment between you and the agent

Agents guess at what you want. The fix is a structured grilling session that interviews you until each branch of the design tree is resolved.

- [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md) — grilling session that also updates `CONTEXT.md` and ADRs inline as decisions crystallise

### Verbose, jargon-blind agents

Agents drop into a project and use 20 words where 1 will do. A shared domain language fixes that — and makes the codebase easier for them to navigate, with consistently named identifiers and fewer thinking tokens spent.

This is built into [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md): every resolved term goes into `CONTEXT.md` immediately. Hard-to-reverse architectural decisions get an ADR under `docs/adr/`.

### Code that doesn't work

When you and the agent are aligned but the code still breaks, you need feedback loops: types, browser access, automated tests.

- [`/tdd`](./skills/engineering/tdd/SKILL.md) — red-green-refactor loop with guidance on good vs bad tests
- [`/diagnose`](./skills/engineering/diagnose/SKILL.md) — disciplined diagnosis: reproduce → minimise → hypothesise → instrument → fix → regression-test

### Architectural drift

Agents accelerate software entropy. The counterweight is investing in design every day.

- [`/to-prd`](./skills/engineering/to-prd/SKILL.md) — quizzes you about which modules you're touching before writing the PRD
- [`/zoom-out`](./skills/engineering/zoom-out/SKILL.md) — tells the agent to explain code in the context of the whole system
- [`/improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md) — rescue a codebase that's become a ball of mud (run every few days)

## Reference

### Engineering

- **[diagnose](./skills/engineering/diagnose/SKILL.md)** — Disciplined diagnosis loop for hard bugs and performance regressions: reproduce → minimise → hypothesise → instrument → fix → regression-test.
- **[grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md)** — Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates `CONTEXT.md` and ADRs inline.
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)** — Find deepening opportunities in a codebase, informed by the domain language in `CONTEXT.md` and the decisions in `docs/adr/`.
- **[setup-kira-skills](./skills/engineering/setup-kira-skills/SKILL.md)** — Scaffold the per-repo config (local-markdown issue tracker under `docs/ephemeral/`, single-context domain docs) that the other engineering skills consume. Run once per repo before using `to-issues`, `to-prd`, `diagnose`, `tdd`, `improve-codebase-architecture`, or `zoom-out`.
- **[tdd](./skills/engineering/tdd/SKILL.md)** — Test-driven development with a red-green-refactor loop. Builds features or fixes bugs one vertical slice at a time.
- **[to-issues](./skills/engineering/to-issues/SKILL.md)** — Break any plan, spec, or PRD into independently-grabbable issues using vertical slices.
- **[to-prd](./skills/engineering/to-prd/SKILL.md)** — Turn the current conversation context into a PRD and publish it to the issue tracker. No interview — just synthesizes what you've already discussed.
- **[to-spec](./skills/engineering/to-spec/SKILL.md)** — Convert loose thoughts into a strict-Gherkin-in-markdown spec under `spec/`. Batches clarifying questions for actor, motivation, preconditions, observable outcomes, unhappy path, and edge cases until the spec is unambiguous, then writes it.
- **[zoom-out](./skills/engineering/zoom-out/SKILL.md)** — Tell the agent to zoom out and give broader context or a higher-level perspective on an unfamiliar section of code.
