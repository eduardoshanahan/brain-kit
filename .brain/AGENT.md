# Agent Instructions — brain-kit (public)

This file extends the global instructions at `~/Programming/programs/brain/.brain/AGENT.md`.

---

## Project Context

- **BRAIN_CONTEXT**: dev
- **BRAIN_REPO**: brain-kit
- **Purpose**: Portable brain system implementation — the brainctl CLI, templates, and documentation. What people clone to bootstrap a brain for a new project or client.
- **Private counterpart**: `../brain-kit-private/` (never pushed to public remotes)

---

## Public Brain Rules

- This .brain/ directory is pushed to public remotes — never add sensitive content here
- Raw investigations live in `../brain-kit-private/.brain/` (BRAIN_ROOT points there)
- Only publish content here via `brainctl publish`

---

## Repo-Specific Rules

- Run `brainctl preflight "<task>"` before any non-trivial task
- Run `brainctl capture "task name"` after any non-trivial task
- When modifying brainctl, also update `~/.local/bin/brainctl` by running `./install.sh`
