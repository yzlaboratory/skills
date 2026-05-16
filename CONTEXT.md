# Kira Skills

A collection of agent skills (slash commands and behaviors) loaded by Claude Code. Skills are organized into buckets and consumed by per-repo configuration emitted by `/setup-kira-skills-in-project`.

## Language

**Tracker**:
The external system that holds a repo's specs, PRDs, and implementation issues. Each project picks one of two modes — **Jira** (via the Atlassian MCP) or **GitHub Issues** (via the `gh` CLI) — recorded in the `## Agent skills` block of `CLAUDE.md`. Planning docs are deliberately kept out of the source tree; only `CONTEXT.md` and `docs/adr/` are committed.
_Avoid_: issue tracker, backlog, backlog manager

**Feature ticket**:
The tracker artifact that holds, for one feature, its spec, its PRD, and its out-of-scope list. A GitHub parent **issue** (the three live as sections of its body) or a Jira **Story** (they live as separate comments on it — the Story's own description is left alone). Created or received by `create-alignment-and-refine-docs`; the PRD is added by `create-prd-after-alignment`.

**Issue**:
A single tracer-bullet implementation slice — a Jira **Subtask** or a GitHub **sub-issue**, always a child of a **Feature ticket**. Produced by `to-issues`; implemented by `tdd` or `implement-issues`.
_Avoid_: ticket (reserve "feature ticket" for the parent)

**Spec**:
Strict Gherkin in markdown, the behavioral source of truth for a feature. Lives in the `## Spec` of a **Feature ticket** — an issue-body section in GitHub, a Story comment in Jira. Authored by `create-alignment-and-refine-docs`.

**PRD**:
A product requirements document — the readable synthesis of an alignment session. Lives in the `## PRD` of a **Feature ticket**, alongside the spec and out-of-scope list. Authored by `create-prd-after-alignment`; consumed by `to-issues`.

## Relationships

- A **Tracker** holds many **Feature tickets**
- A **Feature ticket** holds one **Spec**, one **PRD**, and many **Issues**
- A **PRD** is sliced into many **Issues** (via `to-issues`)

## Flagged ambiguities

- "issue tracker" / "backlog" were previously used for the local-markdown `docs/ephemeral/` convention — resolved: planning artifacts now live in an external **Tracker** (Jira or GitHub); the local convention is retired.
- "ticket" is ambiguous between the parent and the child — resolved: the parent is a **Feature ticket**; the child is an **Issue**.
