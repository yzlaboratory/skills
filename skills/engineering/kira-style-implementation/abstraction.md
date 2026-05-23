# Abstraction: OOP and Design Patterns, Earned

Abstraction is a tool you reach for when a problem demands it — never a checklist you apply because a class or pattern *could* exist. Every layer, interface, and pattern you add is something the next reader must learn. It has to pay for that cost by hiding more complexity than it introduces (a deep module). If it doesn't, it's classitis: many shallow units that add surface and subtract clarity.

The vocabulary here — depth, leverage, seam, adapter — is shared with [`../improve-codebase-architecture/LANGUAGE.md`](../improve-codebase-architecture/LANGUAGE.md). The depth idea lives in [`../tdd/deep-modules.md`](../tdd/deep-modules.md).

## The earned-abstraction test

Before introducing a new class, interface, layer, or pattern, one of these must already be true — *now*, not hypothetically:

1. **Real duplication.** The same logic exists in two or more places and has actually diverged or will. (Not "might one day.")
2. **A real seam.** Two responsibilities change for different reasons or on different schedules, and the boundary between them is where change keeps landing.
3. **A real swap point.** Something genuinely needs more than one implementation today — a fake for tests counts only if the seam would exist anyway.

If none hold, write the straightforward code. You can extract a deep module the moment the second caller or the second reason-to-change actually appears — and you'll extract it better, because you'll see the real shape instead of the guessed one.

## OOP done right

- **Composition over inheritance.** Inheritance couples you to a base class's internals and its future changes. Reach for it only for a true *is-a* with a stable, closed hierarchy; otherwise compose. (In closed hierarchies, prefer sealed types + pattern matching — see [stack.md](stack.md).)
- **Encapsulation that hides decisions.** A class earns its keep by hiding *how* behind a small *what*. If callers must drive its internal fields in a particular order to use it, it isn't encapsulating — it's leaking.
- **SRP = one axis of change.** A class should answer to one stakeholder/reason-to-change, not "do one thing". Two reasons to change in one class is a seam waiting to be cut; one reason spread across five classes is classitis waiting to be merged.
- **Deep classes over many shallow ones.** A class whose interface is nearly as wide as its implementation isn't buying callers anything. Prefer fewer, deeper classes to a constellation of pass-throughs.

## Design patterns

A design pattern is the **name of a solution to a recurring problem**. Its value is communication and a well-worn shape — *once you actually have that problem*. Applied speculatively, a pattern is just indirection with a famous name.

- Lead with the problem, not the pattern: "I have N interchangeable behaviours selected at runtime" → Strategy. "I must adapt an interface I don't control" → Adapter. "Object creation has grown conditional and repetitive" → Factory. "I need to notify an open set of listeners" → Observer (and on the frontend, often the framework already does this — don't rebuild it).
- The pattern must produce a **deeper** module than the code it replaces. If wiring up the pattern exposes *more* surface than it hides, you've made it worse.
- Don't pattern-match on nouns. A class called `OrderManager` doesn't need a `Manager` pattern; an `XxxFactory` that wraps a single `new` is ceremony.
- Framework-native mechanisms beat hand-rolled patterns: React composition/hooks, Spring dependency injection. Use the seam the framework already gives you before inventing one.

## Why "earned" — the background

This stance sits on a real fault line. Robert Martin's *Clean Code* pushes toward many tiny functions and classes ("extract till you drop"); John Ousterhout's *A Philosophy of Software Design* argues that over-decomposition manufactures shallow modules and entanglement, raising total complexity. Their long-form debate is worth reading once: [johnousterhout/aposd-vs-clean-code](https://github.com/johnousterhout/aposd-vs-clean-code).

We land on Ousterhout's side for *structure* (depth is the gate) while keeping Martin's *naming, single-level-of-abstraction, and no-duplication* advice. When the two conflict, the deeper module wins.
