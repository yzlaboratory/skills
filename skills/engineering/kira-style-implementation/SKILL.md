---
name: kira-style-implementation
description: Implement code in Kira's style — KISS, deep modules, single responsibility, and names that carry both the what and the why. Use whenever writing or changing implementation code (features, fixes, refactors), whenever reviewing code or running a code review (e.g. /code-review, /review), or when /implement-issues runs with the kira-style approach. For OOP and design-pattern judgement see abstraction.md; for React/TypeScript/MUI/Java/Spring Boot specifics see stack.md.
---

# Kira-Style Implementation

How to implement code so the next reader — a teammate, or future you — understands it without spelunking. Keep it simple, make it a deep module, give each unit one reason to change, and let names carry their own explanation.

Two companion files go deeper, one level down:

- **[abstraction.md](abstraction.md)** — when OOP structure and design patterns are *earned*.
- **[stack.md](stack.md)** — concrete best practices for the stack (React, TypeScript, MUI, Java, Spring Boot). Versioned and date-stamped; consult it when the task touches those.

## Before writing OR reviewing code (required)

Do this **first** — before the first edit or the first review finding, not after. The principles below are general; the companion files are how they land in real code, and skipping them is how stack-specific rules get missed.

1. Does the task touch **React, TypeScript, MUI, Java, or Spring Boot**? → **Read [stack.md](stack.md) now.** It carries rules the general principles don't spell out — e.g. `Optional` only for return values (never fields), errors as `ProblemDetail` via `@RestControllerAdvice`, Effects only for genuine fetch-on-display, sealed-type variant sets.
2. Are you **introducing or judging** a class, interface, layer, or pattern? → **Read [abstraction.md](abstraction.md) now.**

This applies to reviews as much as to implementation: a kira-style review is only as trustworthy as the layer it checks against, so load that layer before you start judging.

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

Default: **no comment.** A comment earns its place only when the reason can't be moved *into the code itself* — into a name, a type, a structure, or a test. Before writing one, in order:

1. Can a clearer **name** carry it? Rename, delete the comment.
2. Can a **type or structure** *enforce* it? This rung applies only when the why is an **invariant** — a rule about which states are legal. Then encode it so the wrong code can't compile — a sealed variant set, a boundary DTO with no field to leak, a narrowed type — or pin it with a test that fails when the rule is broken. If the code can enforce the why, it must not merely narrate it; trimming a comment's prose is not the same as making the comment unnecessary, and this is the rung most often skipped. But not every why is an invariant. A **rationale** — why this approach beat an obvious alternative, why this ordering, why this catch arm — is not a rule about legal states and cannot be typed or tested away. Don't contort the code to encode it; forcing a rationale into a type is its own kind of cleverness. A rationale-shaped why falls through to rung 4, and landing there is the normal, healthy outcome — not a failure to encode.
3. Is it narrating a *block*? **Extract the block into a function (or hook) whose name says what the comment said, then delete the comment.** This is mandatory, not optional — a comment that introduces a block is a function waiting to be named.
4. Only a *why no code can hold* earns a comment — a non-obvious rationale, a real constraint, a business rule, the reason this approach beat an obvious alternative, or an *implementation* gotcha (why this ordering, why this catch arm, why a deliberate-looking-wrong choice is right). This covers both interface whys ("why this exists") and implementation whys ("why this code does what it does"); don't narrow it to existence and silently evict the line-level ones. Reaching this rung is not a consolation prize for failing rungs 1–3: a rationale no name, type, or test could hold was always going to live here, and it earns its comment the way a deep module earns its interface.

**Never write these — delete them on sight:**

- **File / module / JSDoc / class-Javadoc header blocks** that summarise a file or class whose names already describe it. A header longer than ~2 sentences, or one using `<ul>` / multiple `<p>`, is a smell — re-audit it sentence by sentence; long headers are where what-comments hide.
- **Provenance or history** — "moved from X", "recreated locally", "was Y in the toolkit", ticket numbers. That belongs in the commit message and the PR, never in the source.
- **Restatements of the *what*** — `// debounced search` above a debounced search, `// increment i` above `i++`, `// flatten back to the API shape` above a `toStepData` mapper. These rot the moment the code changes.
- **The ADR-justified paragraph.** A single ADR reference, ticket link, or security rationale justifies *one clause* — not the summary wrapped around it. Keep the why-sentence; cut the surrounding what. This is the trap that survives a careless review: a block reads as "keep" because it *contains* a why.
- **The bare ADR pointer.** When the comment's *whole* content is the reference — `// matches ADR 0021`, `// per ADR 0024` with no local rationale of its own beside it — there is no why-sentence to keep: the ADR already holds the why, so cut the comment outright. An ADR reference earns inline space only as the anchor to a why **the code states in its own words**; a bare pointer states nothing the reader can't get by opening the ADR. If the link is worth recording at all, it goes in the commit message, not the source.
- **The amnestied frame.** One genuine *why* sentence does not absolve the sentences around it. Two shapes recur and both go: a **summary opener** that names what the class/method already names (`Issues and consumes the … tokens`; `Sends mail after commit, off-thread, best-effort`), and a **roll-call tail** that lists members the code already lists (`Covers issue, expiry, single-use…` over the `@Test` names; a colon-list of the fields beneath it). Keep the why; delete the frame around it.

**What a kept comment looks like** — it explains a decision the reader would otherwise question, and the code genuinely cannot express it:

```
✅ // Validate the name but raise the error on the companyRegistration object
   // itself, not the name field — that's the path the autocomplete binds to,
   // so fieldState.error surfaces it like any single field.

🔴 /** Company-name field rule. Recreated locally — it was useCompanyNameSchema
    *  from @lexware/lexbank-react-toolkit, used nowhere else… */   ← provenance, delete
```

**Cleanup pass — emit a per-sentence ledger, don't eyeball.** A header arrives as one visual block, so it gets one judgment — and "contains a why" reads as "keep." Defeat this by making the *sentence*, not the comment, the row. Before committing, and for every header a review touches, write out the ledger — one row per sentence — and only then act:

| location | sentence | what can the code / name / type / test NOT say here? | verdict |

A sentence earns `keep` only when column 3 is a concrete *why* — rationale, constraint, rejected alternative, ordering/catch gotcha — that no name, type, or test could carry. Otherwise the verdict is `extract` (it narrates a block → name a function), `move` (it's a real why but belongs in another home → see routing below), or `cut` (it carries nothing). A multi-sentence header that yields one `keep` and three `cut`/`move`s is the normal result, not a failure. Emit the ledger as text: judged in-head, the block re-collapses into one verdict. Don't trust a prior "cut to why" commit — re-audit from scratch. The default is none; a comment that survives should be a rare, deliberate *why*.

A *why* predicated on a mechanism may keep that mechanism, but only as the single minimal **anchor** it needs to be intelligible and protective — never a full restatement. When several `what` clauses each claim to anchor the why, keep the one the warning attaches to and cut the rest. Test per clause: if deleting it leaves the why still standing and still protective, it was narration. `hash stored, never raw → leak-safe` keeps one anchor; `hash persisted, raw returned once, never stored → leak-safe` keeps two and is over-anchored.

**Route the why before you cut it — much of "cut" is "misfiled", not "worthless".** A code comment is one of three homes a why can live in, and most that fail the ledger fail because they're in the *wrong* home, not because the why is dead. Before deleting, ask which kind of why it is and route it — by scope and lifetime:

| home | carries which *why* | why it lives there |
|---|---|---|
| **Code comment** | local rationale tied to *this* code — why this ordering, why this catch arm, why a workaround that looks wrong is right | the reader is already looking at the line; it travels with the code |
| **Commit message** | why *this change* happened — the diff's rationale, provenance, what it replaced and why | tied to exactly one change, evolves with the code, never bloats the source, can run as long as it needs |
| **ADR (`docs/adr/`)** | a decision with cross-cutting, long-lived consequences — the rejected alternative, the trade-off, the constraint that shaped the design | outlives any single file; one stable, named home instead of a paragraph copied across call sites |

This is why a `move` verdict carries a destination: record the why in its proper home, *then* cut the inline line (leaving at most the one anchoring clause an ADR/ticket reference is allowed). The "provenance → commit message" and "an ADR reference justifies one clause" rules in the delete-on-sight list above are this same routing in its negative form: the prohibition is on leaving the *what* inline, never on the why existing. A why with no fitting home — and only then — is a true `cut`.

## Tests

Follow loose TDD: cover the happy case, the unhappy cases, and the edges — but first decide *what is worth testing*.

**Test behaviour you own, not the framework.** A test earns its place when it protects logic that could plausibly break: a validation rule, a mapper, a branch, a state transition. A unit that only forwards to the framework or the design system — a thin field binding a value to a controlled input, a component that just renders its props — has no behaviour of *yours* to protect. A test there exercises React or the library, not your code; skip it. The depth gate above applies to tests too: a shallow unit warrants a shallow test surface, often none.

**Match the test's weight to the unit's depth.** If the harness — mocks, render plumbing, DOM setup — dwarfs the assertion, either the unit is too trivial to test or you're testing the wrong seam. Pull the logic into a unit you can test directly (the validation schema, the typed-vs-selected normalizer) and test *that*, not the rendered field around it. Test through the deepest interface that still isolates your logic — a deep interface gives a small test surface that covers a lot, the same leverage callers get.

**A test states what it protects.** Its name and body should make the protected behaviour obvious on sight. If a reader can't tell what would break, restructure it.
