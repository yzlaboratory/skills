# Engineering

Skills I use daily for code work.

- **[create-alignment-and-refine-docs](./create-alignment-and-refine-docs/SKILL.md)** — Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates `CONTEXT.md`, ADRs, specs, and OOS inline.
- **[create-prd-after-alignment](./create-prd-after-alignment/SKILL.md)** — Synthesise a PRD from the just-completed alignment session, the ADRs you confirmed, and the specs you authored.
- **[diagnose](./diagnose/SKILL.md)** — Disciplined diagnosis loop for hard bugs and performance regressions: reproduce → minimise → hypothesise → instrument → fix → regression-test.
- **[implement-issues](./implement-issues/SKILL.md)** — Orchestrate parallel implementation of every issue in a directory: spawns one `/tdd` subagent per issue per wave, each in its own worktree, respecting `Blocked by` dependencies until the whole backlog is done. Invoking the skill is the approval; waves spawn automatically as blockers clear.
- **[improve-codebase-architecture](./improve-codebase-architecture/SKILL.md)** — Find deepening opportunities in a codebase, informed by the domain language in `CONTEXT.md` and the decisions in `docs/adr/`.
- **[setup-kira-skills-in-project](./setup-kira-skills-in-project/SKILL.md)** — Scaffold the per-repo config (local-markdown issue tracker under `docs/ephemeral/`, single-context domain docs, strict-Gherkin spec template and README under `docs/specs/`, `docs/prd/` for PRDs) that the other engineering skills consume.
- **[tdd](./tdd/SKILL.md)** — Test-driven development with a red-green-refactor loop. Builds features or fixes bugs one vertical slice at a time.
- **[to-issues](./to-issues/SKILL.md)** — Break a PRD into independently-grabbable issues using vertical slices. Requires a PRD file as an argument; reads `docs/specs/`, `docs/adr/`, `docs/OOS.md`, and `CONTEXT.md` as supporting inputs.
- **[zoom-out](./zoom-out/SKILL.md)** — Tell the agent to zoom out and give broader context or a higher-level perspective on an unfamiliar section of code.
