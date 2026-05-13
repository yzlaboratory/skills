---
name: create-prd-after-alignment
description: Synthesise a PRD from a just-completed /create-alignment-and-refine-docs session — the ADRs you confirmed, the specs you authored, and the implementation decisions that crystallised. The PRD lives under docs/prd/ and links back to every ADR and spec it covers. Use after /create-alignment-and-refine-docs when you want a single readable artifact that ties the alignment outcomes together before slicing into issues.
---

# Create PRD After Alignment

The PRD is the **culmination** of `/create-alignment-and-refine-docs`: it stitches together the ADRs, specs, and implementation decisions that came out of the grilling session into one readable document that downstream skills (`/to-issues`) and humans (reviewers, future you) can consume in a single pass.

Do **not** run a fresh grilling session here. If the user has not yet aligned, send them to `/create-alignment-and-refine-docs` first. This skill synthesises; it does not interview.

The PRD storage location (`docs/prd/`) and the supporting docs (`CONTEXT.md`, `docs/adr/`, `docs/specs/`, `docs/OOS.md`) should already exist — run `/setup-kira-skills-in-project` if not.

## Process

### 1. Load the alignment outcome

Read every doc the alignment session touched (and the rest of the documentation set for context):

- `docs/specs/*.md` — the behavioral specs authored or revised during the alignment session
- `docs/adr/*.md` — the architectural decisions confirmed during the session, plus any pre-existing ADRs that apply to the area being scoped
- `docs/OOS.md` — explicit non-goals; the PRD must respect these
- `CONTEXT.md` — the domain glossary; all PRD prose uses this vocabulary

A valid alignment session does not always write a spec or an ADR — specs are only authored when a behavior needs one, and ADRs are offered sparingly (hard-to-reverse + surprising + real trade-off). Edits to `CONTEXT.md` or appends to `docs/OOS.md` are equally valid alignment outcomes.

Stop and refuse only if the alignment produced **no** artifact at all — no spec, no ADR, no OOS entry, no `CONTEXT.md` change in the conversation history. In that case, suggest the user run `/create-alignment-and-refine-docs` first.

### 2. Sketch the module surface

Look at the codebase to understand the current state. Sketch the major modules you will need to build or modify. Actively look for opportunities to extract **deep modules** — modules that encapsulate substantial functionality behind a small, stable, testable interface.

You may ask 1–2 narrow confirmation questions about the module list before publishing — for example, "are these the four modules you have in mind, or am I missing one?" Do **not** walk the design tree; that's `/create-alignment-and-refine-docs`'s job.

### 3. Write the PRD

Filename: `docs/prd/<kebab-case-feature>.md`. Refuse to overwrite an existing file; if one exists, surface it and ask whether to rename, extend, or abort.

Use the template below. Every section that references an ADR or spec **must link to it** by relative path — the PRD is an index over those artifacts, not a copy of them.

<prd-template>

# &lt;Feature title&gt;

## Problem Statement

The problem the user is facing, from the user's perspective. One short paragraph.

## Solution

The solution to the problem, from the user's perspective. One short paragraph. If the alignment session produced a decision about *which* solution shape to pursue (vs. a rejected alternative), name the rejected alternative in a single sentence so the reader knows it was considered.

## Specs covered

The behavioral surface this PRD addresses, as links to the specs in `docs/specs/`. Each entry: a relative link to the spec file plus a one-line summary of what scenarios it covers. **No spec content is duplicated here** — the spec file is authoritative.

- [`docs/specs/<spec-1>.md`](../specs/<spec-1>.md) — one-line summary
- [`docs/specs/<spec-2>.md`](../specs/<spec-2>.md) — one-line summary

## Architectural decisions

Every ADR this PRD depends on, as links to `docs/adr/`. Each entry: a relative link plus a one-line summary of how the decision shapes this PRD's implementation. **No ADR content is duplicated here** — the ADR file is authoritative.

- [`docs/adr/NNNN-<slug>.md`](../adr/<NNNN-slug>.md) — how this decision constrains the work
- [`docs/adr/NNNN-<slug>.md`](../adr/<NNNN-slug>.md) — how this decision constrains the work

If the alignment session produced new ADRs, they should already exist under `docs/adr/` by the time this skill runs — `/create-alignment-and-refine-docs` writes them inline. Reference them here.

## User stories

A numbered list of user stories covering the surface defined by the specs above. Use the project's domain glossary vocabulary throughout. Each story:

1. As a &lt;actor&gt;, I want &lt;capability&gt;, so that &lt;benefit&gt;.

Be extensive — cover happy path, key edge cases, and explicit recovery paths. If the alignment session produced specific scenarios in the Gherkin specs, mirror them as user stories here so the PRD reader does not have to flip to the spec files for the shape of the feature.

## Implementation decisions

Implementation decisions that crystallised during the alignment session and during the module sketch in step 2 above. This is the place for things that did **not** rise to the bar of an ADR (not hard-to-reverse, not surprising, no real trade-off) but still matter for whoever picks this up:

- The modules you sketched and their responsibilities
- The interfaces those modules expose (described in prose, not code)
- Schema shapes, API contracts, and integration patterns that follow from the ADRs
- Specific interactions between modules

Do **not** include file paths or code snippets — they go stale fast. Do **not** restate ADR content; link to the ADR instead.

## Testing decisions

- What makes a good test for this feature (testing external behavior, not implementation details)
- Which modules get tested directly vs. covered by integration tests
- Prior art: similar tests already in the codebase that the test author should look at

## Out of scope

Items from `docs/OOS.md` that apply to this feature, plus any additional non-goals that came up during alignment but were not OOS-worthy on their own. Link to OOS entries by anchor when possible.

## Further notes

Anything else the alignment session surfaced that doesn't fit above — open questions explicitly deferred, future-direction speculation, links to external references discussed during the grill.

</prd-template>

### 4. Confirm

Post a one-line summary: PRD path, plus the number of specs and ADRs it links to (e.g. `docs/prd/checkout-flow.md — 3 specs, 2 ADRs, 14 user stories`). Don't paste the whole PRD back; the user can read the file.

## Out of scope

- Running a fresh grilling session. That's `/create-alignment-and-refine-docs`.
- Authoring or modifying specs and ADRs. The PRD links to them; it doesn't own them. If a spec or ADR needs to change as you write the PRD, that's a signal the alignment was incomplete — stop, go back to `/create-alignment-and-refine-docs`.
- Publishing to an external issue tracker. The PRD is a local markdown file under `docs/prd/`. The follow-up `/to-issues` consumes it as a required input.
