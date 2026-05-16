# Engineering

Skills I use daily for code work.

- **[create-alignment-and-refine-docs](./create-alignment-and-refine-docs/SKILL.md)** — Grilling session that challenges your plan against the existing domain model, sharpens terminology, writes the spec into the feature ticket, and updates `CONTEXT.md` and ADRs inline.
- **[create-prd-after-alignment](./create-prd-after-alignment/SKILL.md)** — Synthesise a PRD from the just-completed alignment session and write it into the feature ticket, alongside the spec and out-of-scope list.
- **[diagnose](./diagnose/SKILL.md)** — Disciplined diagnosis loop for hard bugs and performance regressions: reproduce → minimise → hypothesise → instrument → fix → regression-test.
- **[implement-issues](./implement-issues/SKILL.md)** — Orchestrate parallel implementation of every child issue under a feature ticket: spawns one subagent per issue per wave, each in its own worktree, respecting `Blocked by` dependencies until the whole backlog is done. Asks once how subagents should implement (TDD, test-after, direct, kira-style-coding, or custom); waves then spawn automatically as blockers clear.
- **[improve-codebase-architecture](./improve-codebase-architecture/SKILL.md)** — Find deepening opportunities in a codebase, informed by the domain language in `CONTEXT.md` and the decisions in `docs/adr/`.
- **[kira-style-coding](./kira-style-coding/SKILL.md)** — Implement code in Kira's personal style: KISS, clean code, and names that tell the reader both the what and the why. Offered as an implementation approach by `/implement-issues`.
- **[setup-kira-skills-in-project](./setup-kira-skills-in-project/SKILL.md)** — Pick the project's tracker mode (Jira or GitHub Issues) and write the `## Agent skills` block into `CLAUDE.md` that the other engineering skills consume.
- **[tdd](./tdd/SKILL.md)** — Test-driven development with a red-green-refactor loop. Builds features or fixes bugs one vertical slice at a time.
- **[to-issues](./to-issues/SKILL.md)** — Break a feature ticket's PRD into independently-grabbable issues using vertical slices, published as child issues of the feature ticket.
- **[zoom-out](./zoom-out/SKILL.md)** — Tell the agent to zoom out and give broader context or a higher-level perspective on an unfamiliar section of code.
