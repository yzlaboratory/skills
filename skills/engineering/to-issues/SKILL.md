---
name: to-issues
description: Break a feature ticket's PRD into independently-grabbable implementation issues on the project tracker using tracer-bullet vertical slices. Reads the PRD, spec, and out-of-scope list from the feature ticket, plus `docs/adr/` and `CONTEXT.md` from the repo. Publishes the slices as sub-issues (GitHub) or Subtasks (Jira) of the feature ticket. Use when user wants to convert an aligned feature ticket into implementation tickets.
---

# To Issues

Break a feature ticket's PRD into independently-grabbable implementation issues using vertical slices (tracer bullets). Each issue is published as a child of the feature ticket — a GitHub sub-issue or a Jira Subtask.

## The feature ticket

Read the tracker mode from the `## Agent skills` block in `CLAUDE.md`. If that block is absent, stop and ask the user to run `/setup-kira-skills-in-project` first.

Identify the feature ticket: use the argument if one was passed (issue number, Story key, or URL); otherwise derive it from the current branch name (`<ticket>-<slug>`).

If you can identify no feature ticket, **stop immediately** and reply:

> This skill needs a feature ticket — pass its issue number / Story key, or run it on a feature branch. The ticket must already hold a PRD; if it doesn't, run `/create-prd-after-alignment` first.

Do not guess. Do not synthesise a PRD on the fly — that's `/create-prd-after-alignment`.

## Process

### 1. Gather context

Fetch the feature ticket from the tracker and read it **in full**. It is the source of truth for:

- The `## PRD` section — what user stories are in scope, what implementation and testing decisions are made
- The `## Spec` section — the Gherkin scenarios that define the behavioral surface
- The `## Out of scope` section — what **not** to slice

If the ticket has no `## PRD` section, stop and tell the user to run `/create-prd-after-alignment` first.

**Also read the in-repo documentation set:**

- `CONTEXT.md` — the domain glossary; issue titles and descriptions must use this vocabulary
- `docs/adr/*.md` — architectural decisions; slices must not contradict any ADR. The PRD references the ADRs it depends on by repo path — read those.

If the PRD references ADRs that don't exist on disk, stop and surface the broken references — the alignment that produced this PRD has drifted.

A Gherkin scenario tells you which behaviors exist; CONTEXT.md tells you what to call things; ADRs tell you which technical paths are chosen; the out-of-scope list tells you what NOT to slice; the PRD tells you which of the above are in scope for this feature.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code. Issue titles and descriptions should use the project's domain glossary vocabulary, and respect ADRs in the area you're touching.

### 3. Draft vertical slices

Break the plan into **tracer bullet** issues. Each issue is a thin vertical slice that cuts through ALL integration layers end-to-end, NOT a horizontal slice of one layer.

Slices may be 'HITL' or 'AFK'. HITL slices require human interaction, such as an architectural decision or a design review. AFK slices can be implemented and merged without human interaction. Prefer AFK over HITL where possible.

<vertical-slice-rules>
- Each slice delivers a narrow but COMPLETE path through every layer (schema, API, UI, tests)
- A completed slice is demoable or verifiable on its own
- Prefer many thin slices over few thick ones
- **Start with infrastructure tracer bullets.** The first few slices each take a single, simple scenario from the source material end-to-end — schema → integration adapter → API → minimal UI → tests — even when most of those layers are stubs. This establishes the foundations subsequent feature slices will rely on. Do not draft a backlog where every slice silently assumes that auth, persistence, external integrations, and the UI shell already exist; they don't until a tracer bullet has put them there.
- After the infrastructure tracer bullets, bundle related behavioral scenarios into feature slices. A single Gherkin Scenario is usually too fine to be its own slice; group the scenarios that together demonstrate one capability into one slice.
</vertical-slice-rules>

### 4. Quiz the user

Present the proposed breakdown as a numbered list. For each slice, show:

- **Title**: short descriptive name
- **Type**: HITL / AFK
- **Blocked by**: which other slices (if any) must complete first
- **User stories covered**: which user stories this addresses (if the source material has them)

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the dependency relationships correct?
- Should any slices be merged or split further?
- Are the correct slices marked as HITL and AFK?

Iterate until the user approves the breakdown.

### 5. Publish the issues to the tracker

For each approved slice, create a child of the feature ticket:

- **GitHub** — `gh issue create`, then link it with `gh issue edit <feature-ticket> --add-sub-issue <new-issue>`.
- **Jira** — create a Subtask of the Story via the Atlassian MCP.

Use the issue body template below. Publish in dependency order (blockers first) so you can reference real issue identifiers in the "Blocked by" field.

<issue-template>
## What to build

A concise description of this vertical slice. Describe the end-to-end behavior, not layer-by-layer implementation.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Blocked by

- A reference to the blocking issue (if any)

Or "None - can start immediately" if no blockers.
</issue-template>

Do NOT close or modify the feature ticket itself — only create children under it.
