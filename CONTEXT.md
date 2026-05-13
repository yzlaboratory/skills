# Kira Skills

A collection of agent skills (slash commands and behaviors) loaded by Claude Code. Skills are organized into buckets and consumed by per-repo configuration emitted by `/setup-kira-skills-in-project`.

## Language

**Issue tracker**:
The local-markdown convention under `docs/ephemeral/` (gitignored) where this skill set hosts a repo's issues. `to-issues` writes to it; `implement-issues` reads from it. PRDs live separately under `docs/prd/` (committed) and are not part of the issue tracker.
_Avoid_: backlog manager, backlog backend, issue host

**Issue**:
A single tracked unit of work inside the **Issue tracker** — a tracer-bullet slice produced by `to-issues` from a PRD.
_Avoid_: ticket

**PRD**:
A product requirements document under `docs/prd/<feature-slug>.md`. Authored by `create-prd-after-alignment` as the culmination of an alignment session; links out to the ADRs and specs it depends on; consumed by `to-issues` as the required source of truth for what to slice.

## Relationships

- An **Issue tracker** holds many **Issues**
- A **PRD** produces many **Issues** (via `to-issues`)

## Flagged ambiguities

- "backlog" was previously used to mean both the *tool* hosting issues and the *body of work* inside it — resolved: the tool is the **Issue tracker**; "backlog" is no longer used as a domain term.
