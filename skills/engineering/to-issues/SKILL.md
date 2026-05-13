---
name: to-issues
description: Break a PRD into independently-grabbable issues on the project issue tracker using tracer-bullet vertical slices. Requires a PRD file under `docs/prd/` as an argument — the PRD is the source of truth for what to slice. Reads `docs/specs/` (behavioral specs), `docs/adr/` (architectural decisions), `docs/OOS.md` (non-goals), and `CONTEXT.md` (domain glossary) as supporting inputs alongside the PRD. Use when user wants to convert an approved PRD into implementation tickets.
---

# To Issues

Break a PRD into independently-grabbable issues using vertical slices (tracer bullets).

The issue tracker location and `docs/prd/` should already exist — run `/setup-kira-skills-in-project` if not.

## Required argument

A path to a PRD file under `docs/prd/` (e.g. `docs/prd/checkout-flow.md`).

If no path is provided, **stop immediately** and reply:

> This skill requires a PRD file as an argument (e.g. `docs/prd/<feature>.md`). If you don't have a PRD yet, run `/create-prd-after-alignment` first. Re-run with the PRD path as an argument.

Do not guess. Do not pick "the most recent file under `docs/prd/`". Do not synthesise a PRD on the fly — that's `/create-prd-after-alignment`. Refuse and ask.

If the path does not exist, is not a file, or is not under `docs/prd/`, stop and tell the user.

## Process

### 1. Gather context

Read the PRD file passed as the argument **in full**. It is the source of truth for:

- What user stories are in scope
- Which specs (`docs/specs/*.md`) define the behavioral surface — follow every link in the PRD's "Specs covered" section
- Which ADRs (`docs/adr/*.md`) constrain implementation — follow every link in the PRD's "Architectural decisions" section
- What's explicitly out of scope (the PRD's "Out of scope" section, and the OOS entries it references)
- What implementation and testing decisions have already been made

**Also read the supporting documentation set** even if not linked from the PRD — these are the canonical references for vocabulary and constraints:

- `CONTEXT.md` — the domain glossary; issue titles and descriptions must use this vocabulary
- `docs/specs/*.md` — behavioral specs the PRD links to (and any others that touch the same area)
- `docs/adr/*.md` — architectural decisions; slices must not contradict any ADR
- `docs/OOS.md` — explicit non-goals; do **not** draft slices for anything listed here

If the PRD links to specs or ADRs that don't exist on disk, stop and surface the broken links — the alignment that produced this PRD has drifted from the artifacts it references.

Use the union of all available sources, anchored by the PRD. A Gherkin spec tells you which scenarios exist; CONTEXT.md tells you what to call things; ADRs tell you which technical paths are already chosen; OOS.md tells you what NOT to slice; the PRD tells you which of the above are actually in scope **for this feature**.

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

### 5. Publish the issues to the issue tracker

For each approved slice, publish a new issue to the issue tracker. Use the issue body template below.

Publish issues in dependency order (blockers first) so you can reference real issue identifiers in the "Blocked by" field.

<issue-template>
## Parent

A reference to the parent issue on the issue tracker (if the source was an existing issue, otherwise omit this section).

## What to build

A concise description of this vertical slice. Describe the end-to-end behavior, not layer-by-layer implementation.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Blocked by

- A reference to the blocking ticket (if any)

Or "None - can start immediately" if no blockers.

</issue-template>

Do NOT close or modify any parent issue.
