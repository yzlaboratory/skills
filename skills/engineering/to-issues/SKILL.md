---
name: to-issues
description: Break a plan, spec, or PRD into independently-grabbable issues on the project issue tracker using tracer-bullet vertical slices. Reads `docs/specs/` (behavioral specs), `docs/adr/` (architectural decisions), `docs/OOS.md` (non-goals), and `CONTEXT.md` (domain glossary) as default inputs alongside whatever is in the conversation. Use when user wants to convert a plan into issues, create implementation tickets, or break down work into issues.
---

# To Issues

Break a plan into independently-grabbable issues using vertical slices (tracer bullets).

The issue tracker location should have been provided to you — run `/setup-kira-skills-in-project` if not.

## Process

### 1. Gather context

Work from whatever is already in the conversation context. If the user passes an issue reference (issue number, URL, or path) as an argument, fetch it from the issue tracker and read its full body and comments.

**Always also read the project's documentation set as default inputs** — even if the user did not point at them explicitly. These are the canonical sources of WHAT and WHY for this repo:

- `docs/specs/*.md` — behavioral specs (Gherkin scenarios or prose user journeys); these define the surface to slice through
- `docs/adr/*.md` — architectural decisions that constrain implementation (storage shape, integration patterns, security posture); slices must not contradict these
- `docs/OOS.md` — explicit non-goals; do **not** draft slices for anything listed here
- `CONTEXT.md` — the domain glossary; issue titles and descriptions must use this vocabulary

Load every file present from this set before drafting. If `docs/specs/`, `docs/adr/`, or `docs/OOS.md` is missing entirely, note that in the summary you show the user — the breakdown is weaker without them, and the user may want to pause and run `/create-alignment-and-refine-docs` first.

Use the union of all available sources, not just one. A Gherkin spec tells you which scenarios exist; CONTEXT.md tells you what to call things; ADRs tell you which technical paths are already chosen and which would contradict prior decisions; OOS.md tells you what NOT to slice.

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
