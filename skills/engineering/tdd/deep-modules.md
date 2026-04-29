# Deep Modules

A **deep** module exposes a small interface that lets callers exercise a large amount of behaviour. Callers learn a little and get a lot.

A **shallow** module's interface is nearly as wide as its implementation. Callers have to learn almost everything anyway, so the module isn't doing much for them.

The full vocabulary — depth, leverage, locality, seam, adapter — lives in [`improve-codebase-architecture/LANGUAGE.md`](../improve-codebase-architecture/LANGUAGE.md). Use those terms when discussing architecture; this file just covers what TDD needs.

## Why this matters for TDD

The interface is the test surface. A deep interface gives you a small test surface that exercises a lot of behaviour — the same leverage callers get, your tests get too. A shallow interface forces thin tests against a thin layer, and the real bugs hide in how the layers compose.

When designing the interface for a behaviour you're about to test, ask:

- What's the minimum a caller has to know to use this?
- How much behaviour does each entry point exercise on their behalf?
- **Deletion test:** if I deleted this module, would the complexity vanish (it was a pass-through), or reappear across N callers (it was earning its keep)?
