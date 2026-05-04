---
name: grill-with-docs
description: Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates documentation (CONTEXT.md, ADRs, docs/specs/, docs/OOS.md) inline as decisions crystallise. Loads the project's docs/ folder and CONTEXT.md as default inputs. Use when user wants to stress-test a plan against their project's language and documented decisions.
disable-model-invocation: true
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time, waiting for feedback on each question before continuing.

If a question can be answered by exploring the codebase, explore the codebase instead — but cap focused exploration at 4–5 reads. If you still don't have an answer, ask the user.

## Default inputs

Before asking your first question, load the project's documentation set when present:

- `CONTEXT.md` at the repo root — the domain glossary
- The entire `docs/` folder, in particular:
  - `docs/specs/*.md` — behavioral specs (often Gherkin or prose scenarios)
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
- **A new spec is needed for a behavior that does not yet have one.** Author it in the spec format used by the project (typically the convention documented in `docs/specs/README.md` if present).
- **A decision is "yes, but not in v1" — or any other deliberate deferral.** Append it to `docs/OOS.md` immediately as an explicitly deferred item, with one short paragraph explaining what was deferred and why. OOS deferrals are cheap to add and easy to lose if batched.

Spec rewrites at scale (renaming the canonical verb across every file, dropping a removed concept from many scenarios, etc.) should still be done as atomic per-file commits, not one giant change.

### Offer ADRs sparingly

Only offer to create an ADR when all three are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip the ADR. Use the format in [ADR-FORMAT.md](./ADR-FORMAT.md).
