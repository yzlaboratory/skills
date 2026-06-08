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

**Comments — see the section below.** Names cover the *what*; the *why* is the only thing a comment may carry.

## Comments: only the why the code can't carry

Default: **no comment.** A comment is the last resort, reached only after you've tried to make it unnecessary. Before writing one, in order:

1. Can a clearer **name** carry it? Rename, delete the comment.
2. Is it narrating a *block*? **Extract the block into a function (or hook) whose name says what the comment said, then delete the comment.** This is mandatory, not optional — a comment that introduces a block is a function waiting to be named.
3. Only if the surviving meaning is a *why* no name can hold — a non-obvious rationale, a real constraint, a business rule, the reason this approach beat an obvious alternative — does a comment earn its place.

**Never write these — delete them on sight:**

- **File / module / JSDoc header blocks** that summarise a file whose names already describe it.
- **Provenance or history** — "moved from X", "recreated locally", "was Y in the toolkit", ticket numbers. That belongs in the commit message and the PR, never in the source.
- **Restatements of the *what*** — `// debounced search` above a debounced search, `// increment i` above `i++`, `// flatten back to the API shape` above a `toStepData` mapper. These rot the moment the code changes.

**What a kept comment looks like** — it explains a decision the reader would otherwise question, and the code genuinely cannot express it:

```
✅ // Validate the name but raise the error on the companyRegistration object
   // itself, not the name field — that's the path the autocomplete binds to,
   // so fieldState.error surfaces it like any single field.

🔴 /** Company-name field rule. Recreated locally — it was useCompanyNameSchema
    *  from @lexware/lexbank-react-toolkit, used nowhere else… */   ← provenance, delete
```

**Cleanup pass.** Comments accumulate while you draft. Before committing, re-read the diff and delete every comment that step 1 or step 2 above could remove. The default is none; a comment that survives this pass should be a rare, deliberate *why*.

## Tests

Follow loose TDD: cover the happy case, the unhappy cases, and the edges — but first decide *what is worth testing*.

**Test behaviour you own, not the framework.** A test earns its place when it protects logic that could plausibly break: a validation rule, a mapper, a branch, a state transition. A unit that only forwards to the framework or the design system — a thin field binding a value to a controlled input, a component that just renders its props — has no behaviour of *yours* to protect. A test there exercises React or the library, not your code; skip it. The depth gate above applies to tests too: a shallow unit warrants a shallow test surface, often none.

**Match the test's weight to the unit's depth.** If the harness — mocks, render plumbing, DOM setup — dwarfs the assertion, either the unit is too trivial to test or you're testing the wrong seam. Pull the logic into a unit you can test directly (the validation schema, the typed-vs-selected normalizer) and test *that*, not the rendered field around it. Test through the deepest interface that still isolates your logic — a deep interface gives a small test surface that covers a lot, the same leverage callers get.

**A test states what it protects.** Its name and body should make the protected behaviour obvious on sight. If a reader can't tell what would break, restructure it.
