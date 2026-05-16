---
name: create-alignment-and-refine-docs
description: Grilling session that challenges your plan against the existing domain model, sharpens terminology, writes the spec into the feature ticket, and updates CONTEXT.md and ADRs inline as decisions crystallise. Closes by sweeping the spec for infrastructure assumptions that aren't yet covered by an ADR or explicitly deferred to the ticket's out-of-scope list. Use when user wants to stress-test a plan against their project's language and documented decisions.
disable-model-invocation: true
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time, waiting for feedback on each question before continuing.

If a question can be answered by exploring the codebase, explore the codebase instead — but cap focused exploration at 4–5 reads. If you still don't have an answer, ask the user.

## Set up the feature ticket and branch

The spec, the out-of-scope list, and (later) the PRD all live in one **feature ticket** in the project's tracker — never in the repo. Read the tracker mode from the `## Agent skills` block in `CLAUDE.md`. If that block is absent, stop and ask the user to run `/setup-kira-skills-in-project` first.

**GitHub mode:**

- If the user passed an existing issue (number, URL, or name), use it as the feature ticket.
- Otherwise, create the feature ticket now with `gh issue create` — title it after the feature, body empty for now. Confirm the title with the user before creating.

**Jira mode:**

- The Story already exists and must be passed to this skill (key, URL, or branch already named after it). If none was given, stop and ask the user for the Story key.

Then put yourself on the feature branch: `<ticket>-<slug>` (e.g. `42-checkout-flow` or `PROJ-42-checkout-flow`). If you're already on that branch, stay. Never grill on `main`.

The spec and out-of-scope edits below go into the feature ticket via the tracker. ADRs and `CONTEXT.md` edits are committed to the repo on this branch.

## Default inputs

Before asking your first question, load the project's documentation set when present:

- `CONTEXT.md` at the repo root — the domain glossary
- `docs/adr/*.md` — architectural decisions already taken
- The **feature ticket** — its spec section (behavioral specs) and its out-of-scope section, if it already has content

These define the WHAT, the WHY, and what has already been said NO to. Without them, your questions will re-litigate decisions that already exist or violate constraints that are already settled.

If the user passes specific files or topics as arguments, focus the grilling on those — but still load the set above as background context.

## Domain awareness

The repo commits exactly two planning artifacts; everything else lives in the feature ticket:

```
/
├── CONTEXT.md
├── docs/adr/
│   ├── 0001-event-sourced-orders.md
│   └── 0002-postgres-for-write-model.md
└── src/
```

Create these lazily — only when you have something to write:

- `CONTEXT.md` → on the first resolved term
- `docs/adr/` → on the first ADR

Never create empty stubs.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in `CONTEXT.md`, call it out immediately. "Your glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account' — do you mean the Customer or the User? Those are different things."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts.

### Cross-reference with code

When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your code cancels entire Orders, but you just said partial cancellation is possible — which is right?"

### Update CONTEXT.md inline

When a term is resolved, update `CONTEXT.md` right there. Don't batch these up — capture them as they happen. Use the format in [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

Don't couple `CONTEXT.md` to implementation details. Only include terms that are meaningful to domain experts.

### Update the spec and out-of-scope list inline

As the grilling lands decisions, edit the feature ticket through the tracker:

- **A spec scenario is contradicted, expanded, or simplified by a resolved decision.** The spec is the source of behavioral truth and should reflect the latest agreed model. Edit the ticket's `## Spec` section right away. Large rewrites that touch many scenarios may be deferred to an explicit editing pass at the end of the session — but only if you announce that intent and keep notes of what needs to change.
- **A new behavior needs a spec.** Write it into the ticket's `## Spec` section following [SPEC-FORMAT.md](./SPEC-FORMAT.md) (Gherkin discipline, prose-vs-fenced-block placement, ADR cross-linking) exactly.
- **A decision is "yes, but not in v1" — or any other deliberate deferral.** Add it to the ticket's `## Out of scope` section immediately as an explicitly deferred item, with one short paragraph explaining what was deferred and why. Deferrals are cheap to add and easy to lose if batched.

The spec lives in the feature ticket's body (GitHub) or description (Jira) under a `## Spec` heading; the out-of-scope list under `## Out of scope`. Edit those sections in place — don't open a second ticket.

### Offer ADRs sparingly

Only offer to create an ADR when all three are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip the ADR. ADRs are committed to `docs/adr/` in the repo. Use the format in [ADR-FORMAT.md](./ADR-FORMAT.md).

## Before wrapping up: check infrastructure ADR coverage

The body of this skill grills **domain alignment** — vocabulary, relationships, scenarios, contradictions with existing decisions. **Infrastructure** decisions only come up reactively, if a question about *how* happens to surface during the grill. Most of the time it doesn't.

Before closing the session, do one explicit sweep to catch infrastructure assumptions that the domain grilling never forced into the open.

For every `Feature:` block in the feature ticket's `## Spec` section, ask two questions:

- **What infrastructure does this spec implicitly assume?** Storage shape, integration pattern, auth/identity model, external dependencies, deployment target, performance envelope. Pull each one out of the Gherkin steps explicitly so it's named, not buried.
- **Is each assumption decided?** Cross-check against `docs/adr/` (decided), `CONTEXT.md` (committed vocabulary), and the ticket's `## Out of scope` section (deliberately deferred). If an assumption is in none of those, it's an open infrastructure gap.

Surface gaps one at a time, and for each gap apply the same ADR-offer threshold from "Offer ADRs sparingly" (hard to reverse + surprising + real trade-off):

1. **All three criteria hold** — offer the ADR now. If accepted, draft it inline before closing the session.
2. **The decision is real but not yet ready** — add it to the ticket's `## Out of scope` section with one short paragraph on what's deferred and why.
3. **Easy to reverse, unsurprising, no real trade-off** — mention it once in the closing summary so the user knows it was considered, then move on without writing anything.

Close the session with a one-line summary of what got an ADR, what went to out-of-scope, and what was acknowledged but not recorded.

If the feature ticket has no spec content yet, skip this check.
