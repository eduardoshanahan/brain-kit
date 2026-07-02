# Agent Instructions — brain-kit

This file extends the global instructions at `~/Programming/brain/.brain/AGENT.md`.

---

## Project Context

- **BRAIN_CONTEXT**: dev
- **BRAIN_REPO**: brain-kit
- **Purpose**: Portable brain system implementation — the brainctl CLI, templates, and documentation. What people clone to bootstrap a brain for a new project or client.

---

## Repo-Specific Rules

- Run `brainctl preflight "<task>"` before any non-trivial task
- Run `brainctl capture "task name"` after any non-trivial task
- When modifying brainctl, also update `~/.local/bin/brainctl` by running `./install.sh`
