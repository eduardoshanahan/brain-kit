# Agent Instructions — [REPO NAME]

This file extends the global instructions at `~/Programming/programs/brain/.brain/AGENT.md`.

---

## Repo Context

- **BRAIN_CONTEXT**: dev
- **BRAIN_REPO**: [repo name]
- **Purpose**: [brief description]

---

## Working in This Directory

1. `brainctl list` to see all entries
2. `brainctl preflight "<task>"` before starting work **and before any sub-operation encountered mid-session** (DNS, deploy, secrets, host config, service restart, backup). Preflight surfaces known-mistakes, runbooks, and constraints — not just past investigations.
3. Check `known-mistakes.md` and `constraints.md` for gotchas

---

## Repo-Specific Rules

<!-- Add rules specific to this repo here -->
