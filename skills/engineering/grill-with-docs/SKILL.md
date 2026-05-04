---
name: grill-with-docs
description: Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates documentation (CONTEXT.md, ADRs, docs/specs/, docs/OOS.md) inline as decisions crystallise. Closes by sweeping every spec for infrastructure assumptions that aren't yet covered by an ADR or explicitly deferred to OOS. Loads the project's docs/ folder and CONTEXT.md as default inputs. Use when user wants to stress-test a plan against their project's language and documented decisions.
disable-model-invocation: true
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time, waiting for feedback on each question before continuing.

If a question can be answered by exploring the codebase, explore the codebase instead — but cap focused exploration at 4–5 reads *per question*. If you still don't have an answer after that, ask the user. (This cap is about not rabbit-holing on a single question; it does not apply to the upfront docs load described under "Default inputs", which can read more.)

## Default inputs

Before asking your first question, load the project's documentation set when present:

- `CONTEXT.md` at the repo root — the domain glossary
- The entire `docs/` folder, in particular:
  - `docs/specs/*.md` — behavioral specs (often Gherkin or prose scenarios)
  - `docs/specs/_template.md` — the canonical structure every spec must follow
  - `docs/specs/README.md` — the spec-authoring convention (Gherkin discipline, prose-vs-fenced-block placement, ADR cross-linking)
  - `docs/adr/*.md` — architectural decisions already taken
  - `docs/OOS.md` — explicit non-goals

These define the WHAT, the WHY, and what has already been said NO to. Without them, your questions will re-litigate decisions that already exist or violate constraints that are already settled.

If the user passes specific files or topics as arguments, focus the grilling on those — but still load the full set above as background context.

## Domain awareness

During codebase exploration, also look for existing documentation:

### File structure

Always single-context:

```
/
├── CONTEXT.md
├── docs/
│   ├── OOS.md
│   ├── adr/
│   │   ├── 0001-event-sourced-orders.md
│   │   └── 0002-postgres-for-write-model.md
│   └── specs/
│       ├── _template.md
│       └── place-order.md
└── src/
```

Create files lazily — only when you have something to write:

- `CONTEXT.md` → on the first resolved term
- `docs/adr/` → on the first ADR
- `docs/specs/` → on the first spec authored or rewritten in-session
- `docs/OOS.md` → on the first deferral

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

### Update specs and OOS.md inline

You may also create or edit `docs/specs/*.md` and `docs/OOS.md` as the grilling lands decisions:

- **A spec is contradicted, expanded, or simplified by a resolved decision.** The spec is the source of behavioral truth and should reflect the latest agreed model. Small edits go in immediately. Large rewrites that touch many scenarios may be deferred to an explicit editing pass at the end of the session — but only if you announce that intent and keep notes of what needs to change.
- **A new spec is needed for a behavior that does not yet have one.** Every spec — newly-authored or rewritten — **must follow `docs/specs/_template.md` exactly**, with `docs/specs/README.md` providing the surrounding convention (Gherkin discipline, prose-vs-fenced-block placement, ADR cross-linking). If either file is missing, stop and ask the user to run `/setup-kira-skills` first — those files come from a single canonical scaffold. The same template adherence applies when editing an existing spec: keep the file's structure aligned with `docs/specs/_template.md`.
- **A decision is "yes, but not in v1" — or any other deliberate deferral.** Append it to `docs/OOS.md` immediately as an explicitly deferred item, with one short paragraph explaining what was deferred and why. OOS deferrals are cheap to add and easy to lose if batched.

Spec rewrites at scale (renaming the canonical verb across every file, dropping a removed concept from many scenarios, etc.) should still be done as atomic per-file commits, not one giant change.

### Offer ADRs sparingly

Only offer to create an ADR when all three are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip the ADR. Use the format in [ADR-FORMAT.md](./ADR-FORMAT.md).

## Before wrapping up: check infrastructure ADR coverage

The body of this skill grills **domain alignment** — vocabulary, relationships, scenarios, contradictions with existing decisions. **Infrastructure** decisions only come up reactively, if a question about *how* happens to surface during the grill. Most of the time it doesn't.

Before closing the session, do one explicit sweep to catch infrastructure assumptions that the domain grilling never forced into the open.

**Scope the sweep.** Walk specs in this order:

1. **Specs touched this session** (newly authored, rewritten, or referenced) — always sweep these.
2. **Specs adjacent to the session's decisions** — any spec that names a concept the session resolved, or that depends on infrastructure that just got named.
3. **Older, untouched specs** — only if the user opts in. Tell them how many remain ("12 specs were untouched this session — sweep them too?") and let them choose. Don't quietly walk every spec in the repo on every grill; that turns short sessions into marathons once the spec set grows.

For each spec in scope, ask two questions:

- **What infrastructure does this spec implicitly assume?** Storage shape, integration pattern, auth/identity model, external dependencies, deployment target, performance envelope. Pull each one out of the Gherkin steps explicitly so it's named, not buried.
- **Is each assumption decided?** Cross-check against `docs/adr/` (decided), `CONTEXT.md` (committed vocabulary), and `docs/OOS.md` (deliberately deferred). If an assumption is in none of those, it's an open infrastructure gap.

Surface gaps one feature at a time, and for each gap apply the same ADR-offer threshold from "Offer ADRs sparingly" (hard to reverse + surprising + real trade-off):

1. **All three criteria hold** — offer the ADR now. If accepted, draft it inline before closing the session.
2. **The decision is real but not yet ready** — append it to `docs/OOS.md` with one short paragraph on what's deferred and why.
3. **Easy to reverse, unsurprising, no real trade-off** — mention it once in the closing summary so the user knows it was considered, then move on without writing anything.

Close the session with a one-line summary of what got an ADR, what went to OOS, what was acknowledged but not recorded, and how many older specs (if any) were left unswept.

If `docs/specs/` is empty or absent, skip this check.
