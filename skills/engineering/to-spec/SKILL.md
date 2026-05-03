---
name: to-spec
description: Convert loose thoughts or notes into a strict-Gherkin-in-markdown spec under spec/, asking clarifying questions when input is ambiguous. Use when user wants to write a spec, formalize a feature idea, turn a description into Gherkin scenarios, or runs /to-spec.
---

# To Spec

Turn loose thoughts into a strict-Gherkin-in-markdown spec under `spec/`, following the project's own spec convention. Refuses to write anything ambiguous — batches clarifying questions until the spec is unambiguous, then writes it.

This skill assumes the project has set up `spec/README.md` (the convention) and `spec/_template.md` (the starting shape). If either is missing, abort and tell the user — the skill is parameterised by those files and won't guess.

## Process

### 1. Ground in the project's convention

Read `spec/README.md` and `spec/_template.md` every run — the convention may have evolved since last time. If either is missing, stop and surface that to the user.

### 2. Source the input

- If the user passed arguments to `/to-spec`, treat those as the raw input.
- Otherwise, use the recent conversation context (the user's notes, brainstorm, or description).
- If both are empty, ask the user what feature they want to spec.

### 3. Run the ambiguity gates

Before writing anything, every spec must have answers to all of these. If any are missing or vague, **batch the questions in one round** — don't dribble them out.

<gates>
- **Actor** — Who performs each scenario? "As a <role>" must be concrete (e.g. "library owner", "casual visitor"), not "user".
- **Motivation** — Why now? Both clauses of "I want X so that Y" must be present.
- **Preconditions** — What state must be true for each scenario? Lift anything shared by all scenarios into `Background`.
- **Observable outcome** — What can the actor *see* after the action that proves it worked? Reject `Then` steps that describe internal state ("the database row is updated"); prefer user-visible outcomes ("the film appears at the top of the library").
- **Unhappy path** — What goes wrong, and how does the system respond? At least one non-happy scenario unless the feature is genuinely degenerate.
- **Edge cases** — Empty state, duplicate, offline, permission denied, large input, concurrent change. Pick the ones that apply and either include them as scenarios or note them explicitly out of scope.
</gates>

Present the gaps as a numbered question list. Wait for the user's answers before writing. Iterate if the answers introduce new ambiguities.

### 4. Write the file

- Filename: `spec/<kebab-case>.md`, matching the `Feature:` line.
- Refuse to overwrite an existing file. If a same-named file exists, surface it and ask whether to extend, rename, or abort.
- Use the structure from `spec/_template.md` exactly. The Gherkin lives inside a fenced ` ```gherkin ` block; motivation, ADR links, and open questions go in prose *outside* the block.
- Use standard Gherkin keywords only: `Feature`, `Background`, `Scenario`, `Scenario Outline` + `Examples`, `Given`, `When`, `Then`, `And`, `But`. No domain-specific extensions.
- Steps are declarative — describe behaviour, not UI mechanics. Prefer "I save the film" over "I tap the green button".
- Each `Scenario` must be independently understandable. Lift shared preconditions into `Background`.
- Edge cases are their own `Scenario`, not bullet lists.
- Include an `## Open questions` section *only* for genuinely-deferred decisions (not for things that should have been resolved by the gates).

### 5. Confirm

Post a one-line summary: file path + scenario count (e.g. `spec/add-movie.md — 1 happy + 3 edge cases`). Don't paste the whole spec back; the user can read the file.

## Out of scope

- Scaffolding the convention itself (`spec/README.md`, `spec/_template.md`). That's a one-time project setup — surface the gap to the user but don't auto-create.
- Wiring up Cucumber/Behave/SpecFlow runners. This skill produces specs as documentation; execution is a separate concern.
- Editing existing specs in place. To revise a spec, ask the user to point at the file and use a normal edit flow — `/to-spec` is for new specs.
