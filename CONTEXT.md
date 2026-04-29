# Kira Skills

A collection of agent skills (slash commands and behaviors) loaded by Claude Code. Skills are organized into buckets and consumed by per-repo configuration emitted by `/setup-kira-skills`.

## Language

**Issue tracker**:
The local-markdown convention under `docs/ephemeral/` (gitignored) where this skill set hosts a repo's issues. Skills like `to-issues` and `to-prd` read from and write to it.
_Avoid_: backlog manager, backlog backend, issue host

**Issue**:
A single tracked unit of work inside the **Issue tracker** — a task, PRD, or slice produced by `to-issues`.
_Avoid_: ticket

## Relationships

- An **Issue tracker** holds many **Issues**

## Flagged ambiguities

- "backlog" was previously used to mean both the *tool* hosting issues and the *body of work* inside it — resolved: the tool is the **Issue tracker**; "backlog" is no longer used as a domain term.
