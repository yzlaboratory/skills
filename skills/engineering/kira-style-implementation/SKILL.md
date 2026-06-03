---
name: kira-style-implementation
description: Implement code in Kira's style — KISS, deep modules, single responsibility, and names that carry both the what and the why. Use whenever writing or changing implementation code (features, fixes, refactors), or when /implement-issues runs with the kira-style approach. For OOP and design-pattern judgement see abstraction.md; for React/TypeScript/MUI/Java/Spring Boot specifics see stack.md.
---

# Kira-Style Implementation

How to implement code so the next reader — a teammate, or future you — understands it without spelunking. Keep it simple, make it a deep module, give each unit one reason to change, and let names carry their own explanation.

Two companion files go deeper, one level down:

- **[abstraction.md](abstraction.md)** — when OOP structure and design patterns are *earned*.
- **[stack.md](stack.md)** — concrete best practices for the stack (React, TypeScript, MUI, Java, Spring Boot). Versioned and date-stamped; consult it when the task touches those.

## KISS — keep it simple

> Prefer the straightforward solution over the clever one.

- Solve the problem in front of you, not the one you imagine arriving later (YAGNI vetoes the rest). Clever code is a liability the moment someone else has to change it.
- A solution is simple enough when an average reader can follow it with basic tools and no tour guide — the field-mechanic test.
- Reach for fewer moving parts: fewer branches, fewer layers of indirection, fewer abstractions introduced "just in case". Add structure only when duplication or a real seam demands it.
- If a function needs a paragraph to explain how it works, the function — not the explanation — is the thing to fix.

## Deep modules over many shallow ones

A **deep** module exposes a small interface that lets callers do a lot; they learn a little and get a lot. A **shallow** module's interface is nearly as wide as its implementation, so it earns its keep for no one.

- Judge a unit by its **depth**, not its line count. A cohesive 60-line method can be clearer than eight tiny ones you must read in sequence to follow.
- **Deletion test:** if you deleted this function/class, would complexity vanish (it was a pass-through) or reappear across N callers (it was earning its keep)? Keep the second kind; inline the first.
- Beware decomposition that creates **entanglement** — two units are entangled when, to understand one, you must read the other. Splitting then costs comprehension instead of buying it.

> This is the deliberate fault line between this skill and "extract-till-you-drop" Clean Code advice. We take Clean Code's genuinely good parts — intention-revealing names, one level of abstraction per function, no duplication — but the **gate for extracting is depth, not a line limit**. When the two conflict, the deeper module wins. (Background: Ousterhout vs. Martin — see abstraction.md.)

## Single responsibility

- A unit has **one reason to change** — one axis of the business it answers to. That is SRP; it is not "does literally one thing".
- Don't mix levels of abstraction inside a function: orchestration and low-level detail in the same body is two responsibilities wearing one name.

## Clean code

- **No duplication.** Repeated logic is one change waiting to be made in two places — but factor it out *once it actually repeats*, not pre-emptively.
- **Shallow nesting.** Guard clauses and early returns over deep `if`/`else` pyramids.
- **Match the surrounding code.** Mirror the file's existing idioms, comment density, and naming. Consistency beats personal preference.
- **Self-documenting first.** Code that reads clearly needs few comments; minimise the need rather than adding more.

## Naming: the what and the why

A name's job is to answer on sight: why does this exist, what does it do, how is it used. If a name needs a comment to be understood, the name has failed — rename it.

**Variables — name the what.** What the value *is*, in domain terms: `elapsedTimeInDays`, not `d`; `activeCustomers`, not `list2`. Booleans read as assertions: `isEligible`, `hasPendingReview`. No single letters (except a tight loop index), no disinformation. Use the project's `CONTEXT.md` vocabulary; don't drift to synonyms.

**Functions — name the what, as an outcome.** A verb phrase precise enough that a caller predicts the behaviour without opening the body: `calculateInvoiceTotal()`, `evictExpiredSessions()` — not `process()`, `handleData()`, `doStuff()`.

**Comments — default to none.** Let the code carry itself. Names cover the *what*; they can't cover the *why*. Add a comment only when the *why* has no other home — and never one that restates the *what*. Before writing any comment, try first to make it unnecessary: a clearer name, a smaller function, an extracted variable. If a comment survives that, it should explain something the code genuinely can't: why this approach over an obvious alternative, a non-obvious constraint, a business rule or edge case, a pointer to the ADR or issue behind a surprising decision. Do **not** restate the code (`i++; // increment i`) — such comments rot the moment the code changes. When in doubt, delete it and let the code speak.

## Tests

Follow loose TDD: cover the happy case, the unhappy cases, and the edges. Tests exercise the module through its interface — a deep interface gives a small test surface that covers a lot, the same leverage callers get.
