---
name: to-prd
description: Turn the current conversation context into a PRD and publish it to the project issue tracker. Use when user wants to create a PRD from the current context.
---

This skill takes the current conversation context and codebase understanding and produces a PRD. Don't run a full grilling session — synthesize what you already know. You may ask 1–2 narrow confirmation questions about the module list before publishing (see step 3), but don't walk the design tree. If the user wants a deeper interview, that's `/grill-with-docs`.

The issue tracker location should have been provided to you — run `/setup-kira-skills` if not. Per `docs/agents/issue-tracker.md`, PRDs are published to `docs/ephemeral/<feature-slug>/PRD.md` (one feature per directory, kebab-case slug derived from the feature title).

## Process

### 1. Gather context

Read project documentation that captures the WHAT and the WHY when it is present in the repo:

- `docs/specs/` — behavioral specs. **List the directory and read every spec whose filename plausibly matches this feature**, not just an obvious slug match (specs may pre-date the conversation's vocabulary). If exactly one spec matches, treat it as the source of truth for User Stories and observable behavior — quote or paraphrase its scenarios into the PRD's User Stories rather than re-deriving from conversation. If multiple specs match, ask the user which one anchors this PRD. If none match, proceed from conversation.
- `CONTEXT.md` — the domain glossary; PRD prose and module names must use this vocabulary
- `docs/adr/` — architectural decisions that constrain implementation. Skim filenames; read any ADR that touches the area this PRD covers. Flag explicitly if your proposed modules contradict an existing ADR rather than silently overriding
- `docs/OOS.md` — explicit non-goals; copy relevant items into the PRD's "Out of Scope" section rather than re-deciding them

If a spec contradicts the conversation, surface the contradiction and ask which is right before writing. If any of these files are missing, proceed silently — they're created lazily by `/grill-with-docs`.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code. Module sketches in step 3 should reflect what exists, not assumptions.

### 3. Sketch modules

Sketch out the major modules you will need to build or modify to complete the implementation. Actively look for opportunities to extract deep modules that can be tested in isolation.

A deep module (as opposed to a shallow module) is one which encapsulates a lot of functionality in a simple, testable interface which rarely changes.

Check with the user that these modules match their expectations. Check with the user which modules they want tests written for.

### 4. Write the PRD

Write the PRD using the template below, then publish it to the issue tracker at `docs/ephemeral/<feature-slug>/PRD.md` — create the feature-slug directory if it doesn't exist. Refuse to overwrite an existing PRD; if one is there, surface it and ask whether to extend, rename, or abort. If a spec was used as input, link to it from the Problem Statement or Solution sections so the issue-tracker reader can find the behavioral source.

<prd-template>

## Problem Statement

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A LONG, numbered list of user stories. Each user story should be in the format of:

1. As an <actor>, I want a <feature>, so that <benefit>

<user-story-example>
1. As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about my spending
</user-story-example>

This list of user stories should be extremely extensive and cover all aspects of the feature.

## Implementation Decisions

A list of implementation decisions that were made. This can include:

- The modules that will be built/modified
- The interfaces of those modules that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.

## Testing Decisions

A list of testing decisions that were made. Include:

- A description of what makes a good test (only test external behavior, not implementation details)
- Which modules will be tested
- Prior art for the tests (i.e. similar types of tests in the codebase)

## Out of Scope

A description of the things that are out of scope for this PRD.

## Further Notes

Any further notes about the feature.

</prd-template>
