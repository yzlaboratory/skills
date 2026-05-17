# Spec format

A feature ticket's spec is the behavioral source of truth for that feature, written as **strict Gherkin inside markdown**. It lives in the `## Spec` section of the feature ticket — never as a file in the repo.

## Conventions

- One feature ticket covers one feature. Its `## Spec` section holds one or
  more `Feature:` blocks describing that feature's behavior.
- Gherkin lives inside a fenced ` ```gherkin ` block. Free-form prose
  (motivation, open questions, links to ADRs) goes outside the block.
- Use the standard keywords: `Feature`, `Background`, `Scenario`,
  `Scenario Outline` + `Examples`, `Given`, `When`, `Then`, `And`, `But`.
- Steps are declarative — describe behavior, not UI mechanics. Prefer
  "I save the film" over "I tap the green button in the top-right".
- Each `Scenario` should be independently understandable; lift shared
  preconditions into `Background`.
- Edge cases get their own `Scenario`, not a bullet list.
- Open questions and design tensions go in a trailing `## Open questions`
  section in prose — do not encode them as Gherkin comments.

## Pairing with ADRs

The spec captures **what the user experiences**. ADRs (`docs/adr/` in the
repo) capture **why we built it that way**. When a scenario depends on a
non-obvious decision, link to the ADR by its repo path from the prose above
the Gherkin block.

## Template

When writing the spec section, follow this structure:

```markdown
## Spec

<One short paragraph: who this is for, why it matters, and any links to
related ADRs by repo path. Delete this paragraph if the Feature block is enough.>

​```gherkin
Feature: <Title, or a tighter restatement>
  As a <role>
  I want <capability>
  So that <outcome>

  Background:
    Given <shared precondition>
    And <another shared precondition>

  Scenario: <Happy path, named as an outcome>
    Given <precondition specific to this scenario>
    When <action>
    And <another action>
    Then <observable outcome>
    And <another observable outcome>

  Scenario: <Unhappy path>
    Given <precondition>
    When <action that fails>
    Then <how the system responds>

  Scenario Outline: <Parameterised scenario, optional>
    Given <precondition with <param>>
    When <action>
    Then <outcome involving <param>>

    Examples:
      | param   |
      | value-1 |
      | value-2 |
​```

## Open questions

- <Things you haven't decided yet — kept out of the Gherkin block so the
  spec stays unambiguous about what *is* committed.>
```
