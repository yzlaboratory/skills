---
name: kira-style-coding
description: Implement code in Kira's personal style — KISS, clean code, and names that tell the reader both the what and the why. Use when implementing a feature or issue the way Kira prefers, or when /implement-issues is run with the kira-style-coding approach.
---

# Kira-Style Coding

How to implement code so the next reader — a teammate, or future you — understands it without spelunking. Three rules: keep it simple, keep it clean, and make names carry their own explanation.

This skill is offered as one of the implementation approaches in `/implement-issues`, alongside TDD, test-after, direct implementation, and a custom prompt.

## KISS — keep it simple

> Prefer the straightforward solution over the clever one.

- Solve the problem in front of you, not the one you imagine arriving later (that's YAGNI's job to veto). Simple code is comprehensible, usable, and maintainable; clever code is a liability the moment someone else has to change it.
- A solution is "simple enough" when an average reader can follow it with basic tools and no tour guide — the field-mechanic test.
- Reach for fewer moving parts: fewer branches, fewer layers of indirection, fewer abstractions introduced "just in case". Add structure only when duplication or a real seam demands it.
- If a function needs a paragraph to explain how it works, the function — not the explanation — is the thing to fix.

## Clean code

- **Small, single-purpose functions.** A function does one thing at one level of abstraction. If you can extract a meaningfully-named sub-step, it was doing two things.
- **No duplication.** Repeated logic is one change waiting to be made in two places. Factor it out — but only once it actually repeats, not pre-emptively.
- **Shallow nesting.** Guard clauses and early returns over deep `if`/`else` pyramids.
- **Match the surrounding code.** Mirror the file's existing idioms, comment density, and naming. Consistency beats personal preference.
- **Self-documenting first.** Code that reads clearly needs few comments. Comments are compensation for what the code couldn't say on its own — minimise the need for them rather than adding more.

## Naming: the what and the why

A name's job is to answer, on sight: why does this exist, what does it do, how is it used. If a name needs a comment to be understood, the name has failed — rename it.

**Variables — name the what.** The name states what the value *is*, in domain terms.

- `elapsedTimeInDays`, not `d`. `activeCustomers`, not `list2`.
- Booleans read as assertions: `isEligible`, `hasPendingReview`.
- No encodings, no single letters (except a tight loop index), no disinformation — don't call something a `List` if it isn't one.
- Use the project's `CONTEXT.md` glossary vocabulary; don't drift to synonyms.

**Functions — name the what, as an outcome.** A verb phrase describing the result, precise enough that the reader can predict the behaviour without reading the body.

- `calculateInvoiceTotal()`, `evictExpiredSessions()` — not `process()`, `handleData()`, `doStuff()`.
- The name should let a caller use the function correctly without opening it.

**Comments — carry the why.** Names cover the *what*; they can't cover the *why*. Reserve comments for what the code genuinely can't express:

- Why this approach over an obvious alternative; why a non-obvious constraint exists.
- Business rules, edge cases, and consequences a future editor would otherwise trip over.
- A pointer to the ADR or issue behind a surprising decision.

Do **not** comment what the code already says (`i++; // increment i`). A comment that restates the code rots the moment the code changes.
