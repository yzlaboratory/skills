---
name: create-prd-after-alignment
description: Synthesise a PRD from a just-completed /create-alignment-and-refine-docs session — the ADRs you confirmed, the spec you authored, and the implementation decisions that crystallised. The PRD is written as a section of the feature ticket, alongside the spec and out-of-scope list. Use after /create-alignment-and-refine-docs when you want a single readable artifact that ties the alignment outcomes together before slicing into issues.
---

# Create PRD After Alignment

The PRD is the **culmination** of `/create-alignment-and-refine-docs`: it stitches together the ADRs, the spec, and the implementation decisions that came out of the grilling session into one readable summary that downstream skills (`/to-issues`) and humans (reviewers, future you) can consume in a single pass.

The PRD is written into the **feature ticket** — the Jira Story or GitHub issue the alignment session used — as a `## PRD` section above the existing `## Spec` and `## Out of scope` sections. It does not live in the repo.

Do **not** run a fresh grilling session here. If the user has not yet aligned, send them to `/create-alignment-and-refine-docs` first. This skill synthesises; it does not interview.

## Process

### 1. Find the feature ticket

Read the tracker mode from the `## Agent skills` block in `CLAUDE.md`. Derive the feature ticket from the current branch name (`<ticket>-<slug>`). If you cannot — not on a feature branch, or no `## Agent skills` block — stop and ask the user which feature ticket to use.

### 2. Load the alignment outcome

Read everything the alignment session produced:

- The feature ticket's `## Spec` section — the behavioral specs authored or revised during alignment
- The feature ticket's `## Out of scope` section — explicit non-goals the PRD must respect
- `docs/adr/*.md` — architectural decisions confirmed during the session, plus any pre-existing ADRs that apply to the area being scoped
- `CONTEXT.md` — the domain glossary; all PRD prose uses this vocabulary

A valid alignment session does not always write a spec or an ADR — specs are only authored when a behavior needs one, and ADRs are offered sparingly (hard-to-reverse + surprising + real trade-off). Edits to `CONTEXT.md` or out-of-scope entries are equally valid alignment outcomes.

Stop and refuse only if the alignment produced **no** artifact at all — no spec, no ADR, no out-of-scope entry, no `CONTEXT.md` change in the conversation history. In that case, suggest the user run `/create-alignment-and-refine-docs` first.

### 3. Sketch the module surface

Look at the codebase to understand the current state. Sketch the major modules you will need to build or modify. Actively look for opportunities to extract **deep modules** — modules that encapsulate substantial functionality behind a small, stable, testable interface.

You may ask 1–2 narrow confirmation questions about the module list before publishing — for example, "are these the four modules you have in mind, or am I missing one?" Do **not** walk the design tree; that's `/create-alignment-and-refine-docs`'s job.

### 4. Write the PRD into the feature ticket

Write the `## PRD` into the feature ticket — as a section of the issue body for GitHub (above the existing `## Spec` and `## Out of scope` sections), or as a dedicated Story comment for Jira (see the `## Agent skills` block in `CLAUDE.md`; never touch the Story's own description). If a `## PRD` already exists, surface it and ask whether to replace, extend, or abort.

Use the template below. The spec and the out-of-scope list already live on the **same feature ticket** — do not duplicate them here. Reference ADRs by their repo path so the reader can open them.

<prd-template>
## PRD

### Problem statement

The problem the user is facing, from the user's perspective. One short paragraph.

### Solution

The solution to the problem, from the user's perspective. One short paragraph. If the alignment session produced a decision about *which* solution shape to pursue (vs. a rejected alternative), name the rejected alternative in a single sentence so the reader knows it was considered.

### Architectural decisions

Every ADR this PRD depends on, referenced by repo path. Each entry: the path plus a one-line summary of how the decision shapes this PRD's implementation. **No ADR content is duplicated here** — the ADR file in the repo is authoritative.

- `docs/adr/NNNN-<slug>.md` — how this decision constrains the work
- `docs/adr/NNNN-<slug>.md` — how this decision constrains the work

If the alignment session produced new ADRs, they should already be committed under `docs/adr/` by the time this skill runs.

### User stories

A numbered list of user stories covering the surface defined by the ticket's `## Spec` section. Use the project's domain glossary vocabulary throughout. Each story:

1. As a &lt;actor&gt;, I want &lt;capability&gt;, so that &lt;benefit&gt;.

Be extensive — cover happy path, key edge cases, and explicit recovery paths. Mirror the Gherkin scenarios from the `## Spec` section so the reader gets the shape of the feature without scrolling.

### Implementation decisions

Implementation decisions that crystallised during the alignment session and during the module sketch in step 3 above. This is the place for things that did **not** rise to the bar of an ADR (not hard-to-reverse, not surprising, no real trade-off) but still matter for whoever picks this up:

- The modules you sketched and their responsibilities
- The interfaces those modules expose (described in prose, not code)
- Schema shapes, API contracts, and integration patterns that follow from the ADRs
- Specific interactions between modules

Do **not** include file paths or code snippets — they go stale fast. Do **not** restate ADR content; reference the ADR instead.

### Testing decisions

- What makes a good test for this feature (testing external behavior, not implementation details)
- Which modules get tested directly vs. covered by integration tests
- Prior art: similar tests already in the codebase that the test author should look at

### Further notes

Anything else the alignment session surfaced that doesn't fit above — open questions explicitly deferred, future-direction speculation, links to external references discussed during the grill.
</prd-template>

### 5. Confirm

Post a one-line summary: the feature ticket reference, plus the number of ADRs the PRD references and user stories it covers (e.g. `#42 — PRD added: 2 ADRs, 14 user stories`). Don't paste the whole PRD back; the user can open the ticket.

## Out of scope

- Running a fresh grilling session. That's `/create-alignment-and-refine-docs`.
- Authoring or modifying the spec, the out-of-scope list, or ADRs. The PRD references them; it doesn't own them. If any need to change as you write the PRD, that's a signal the alignment was incomplete — stop, go back to `/create-alignment-and-refine-docs`.
- Slicing the feature into implementation issues. The follow-up `/to-issues` reads this PRD from the feature ticket and does that.
