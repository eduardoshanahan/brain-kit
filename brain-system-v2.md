# Brain System v2 — Canonical Specification

**Status:** Active
**Replaces:** brain-system.md, brain-system-full.md, brain-system-scoped.md, brain-system-scoped(1).md

---

## Goal

A self-improving, tool-agnostic knowledge system for managing learnings across many parallel homelab projects. The system:

- Captures learnings from agent/human tasks
- Surfaces relevant past work before starting a task (preflight)
- Promotes stable knowledge into reusable rules
- Prevents repeated mistakes across projects
- Works with any AI agent CLI (Claude, Codex, Gemini, etc.)
- Never leaks private information to public git remotes

---

## Design Principles

1. **Tool-agnostic core**: All agent instructions live in `.brain/AGENT.md`. Tool-specific files (`CLAUDE.md`, `AGENTS.md`) are one-liners pointing to it.
2. **Private-first**: Raw investigations always go to the private brain. The public brain is populated only via `brainctl publish`.
3. **Two investigation levels**: Global (`~/Programming/programs/brain/`) for cross-project learnings; local (per-repo) for scoped work.
4. **Incremental onboarding**: Bootstrap global brain once, then onboard projects one at a time.

---

## Brain Levels

### Global Brain — `~/Programming/programs/brain/`

Private. Never pushed to a public remote. Contains cross-project learnings.

```
~/Programming/programs/brain/
  .brain/
    AGENT.md           # canonical tool-agnostic agent instructions
    known-mistakes.md  # global mistakes (all contexts)
    constraints.md     # global constraints
    investigations/    # cross-project learnings
    INDEX.md           # global index
    decisions/         # cross-project architectural decisions
    runbooks/          # reusable procedures
  CLAUDE.md            # adapter: "Read .brain/AGENT.md"
  AGENTS.md            # adapter: "Read .brain/AGENT.md"
  brain-system-v2.md   # this document
  brainctl             # the script
```

### Fully Private Repo

```
<repo>/
  .brain/
    AGENT.md           # repo-specific additions
    known-mistakes.md
    constraints.md
    investigations/
    INDEX.md
    decisions/
    runbooks/
  CLAUDE.md            # adapter
  AGENTS.md            # adapter
  .envrc
```

### Split Project (private + public)

```
<project>/
  private/                         # private git origin only
    .brain/
      AGENT.md
      known-mistakes.md
      constraints.md
      investigations/              # ALL raw investigations land here
      INDEX.md
    CLAUDE.md
    AGENTS.md
    .envrc                         # BRAIN_ROOT=$(pwd), BRAIN_PUBLIC=../public

  public/                          # origin (private) + github (public)
    .brain/
      AGENT.md                     # public-safe knowledge only
      investigations/              # ONLY sanitized published content
      INDEX.md
    CLAUDE.md
    AGENTS.md
    .envrc                         # BRAIN_ROOT=../private, BRAIN_PUBLIC=$(pwd)
```

**Key invariant**: `BRAIN_ROOT` always points to the private directory. `brainctl capture` always writes there, even when working in the public directory.

---

## Environment Variables

Set via direnv `.envrc` in each repo:

```bash
export BRAIN_GLOBAL=~/Programming/programs/brain   # always the same
export BRAIN_ROOT=$(pwd)                  # local brain (or ../private for public dir)
export BRAIN_PUBLIC=""                    # set only for split projects
export BRAIN_CONTEXT=kubernetes           # platform context (see below)
export BRAIN_REPO=nix-cluster            # repo name
```

### BRAIN_REPO

`BRAIN_REPO` is a plain string label used to scope `preflight` and `capture` to a specific project. It has no relationship to git — it does not need to match the git remote name, repository URL, or directory name. It only needs to be consistent across all captures in the same project so that `preflight` can find past investigations by repo.

For split projects, both the private and public directories should use the same `BRAIN_REPO` value (typically the public repo name, e.g. `brain-kit`).

### BRAIN_CONTEXT values

| Value | Use for |
|-------|---------|
| `kubernetes` | K8s cluster work |
| `raspberry-pi` | RPi NixOS nodes |
| `synology` | Synology NAS / docker-compose |
| `vps` | Internet-facing VPS |
| `nixos` | NixOS configuration |
| `dev` | Custom software / programming |

---

## brainctl Commands

### `capture`

```bash
brainctl capture "task name"           # → local brain
brainctl capture --global "task name"  # → global brain
```

Creates `YYYY-MM-DD-task-name.md` in the target `.brain/investigations/`. Appends a row to `INDEX.md` with AI-generated summary and tags (falls back gracefully if `llm` is not installed).

### `preflight`

```bash
brainctl preflight "deploy kafka"
```

1. Searches local `INDEX.md` filtered by `BRAIN_CONTEXT` + `BRAIN_REPO`
2. If results found: reads file content → LLM insight
3. Searches global `INDEX.md` filtered by `BRAIN_CONTEXT`
4. If results found: reads file content → LLM insight

### `list`

```bash
brainctl list                    # local index
brainctl list --global           # global index
brainctl list --tag kubernetes   # filter by tag
brainctl list --status raw       # filter unpromoted entries
```

### `promote`

```bash
brainctl promote .brain/investigations/2025-01-01-deploy-kafka.md
```

Opens the file in `$EDITOR`, then asks where to promote:
1. Local `.brain/known-mistakes.md`
2. Local `.brain/constraints.md`
3. Global brain (`~/Programming/programs/brain/.brain/known-mistakes.md`)
4. `.brain/decisions/`
5. `.brain/runbooks/`

### `publish`

```bash
brainctl publish .brain/investigations/2025-01-01-public-feature.md
```

Requires `BRAIN_PUBLIC` to be set. Opens file for sanitization review, then copies to `$BRAIN_PUBLIC/.brain/investigations/`. Safe to push to GitHub.

---

## Investigation File Format

```markdown
# Task: <name>

## Status
raw | promoted | published

## Source Repo
<BRAIN_REPO>

## Context
<BRAIN_CONTEXT>

## What was attempted

## What worked

## What failed

## Wrong assumptions

## Reusable insights

## Candidate for promotion
```

## INDEX.md Format

```
| Date | File | Summary | Tags | Context | Repo | Status |
|------|------|---------|------|---------|------|--------|
| 2025-01-01 | 2025-01-01-deploy-kafka.md | Fixed Kafka ingress on K8s | kubernetes, kafka, ingress | kubernetes | nix-cluster | promoted |
```

---

## Tool Adapters

### `CLAUDE.md` (Claude Code)

```markdown
# Claude Instructions

Read `.brain/AGENT.md` for repo-specific agent instructions.
Also read `~/Programming/programs/brain/.brain/AGENT.md` for global cross-project context.
```

### `AGENTS.md` (OpenAI Codex / other)

```markdown
# Agent Instructions

Read `.brain/AGENT.md` for repo-specific agent instructions.
Also read `~/Programming/programs/brain/.brain/AGENT.md` for global cross-project context.
```

Future tools: create `<TOOLNAME>.md` with the same two lines.

---

## Onboarding a New Project

1. Create `.brain/` structure:
   ```bash
   mkdir -p .brain/investigations
   ```

2. Write `.envrc`:
   ```bash
   export BRAIN_GLOBAL=~/Programming/programs/brain
   export BRAIN_ROOT=$(pwd)
   export BRAIN_PUBLIC=""
   export BRAIN_CONTEXT=kubernetes
   export BRAIN_REPO=my-repo
   ```

3. Copy adapter files:
   ```bash
   cp ~/Programming/programs/brain/templates/private/CLAUDE.md .
   cp ~/Programming/programs/brain/templates/private/AGENTS.md .
   cp ~/Programming/programs/brain/templates/private/.brain/AGENT.md .brain/
   ```

4. Allow direnv:
   ```bash
   direnv allow
   ```

For split projects, use the `templates/split-private/` and `templates/split-public/` variants.

---

## llm CLI Setup

```bash
pip install llm
llm keys set openai       # for OpenAI models
# OR
llm install llm-ollama    # for local models via Ollama
```

All brainctl AI features fall back gracefully if `llm` is not installed.

---

## Knowledge Flow

```
Task completed
  ↓
brainctl capture "task name"
  → .brain/investigations/YYYY-MM-DD-task.md  (raw)
  → .brain/INDEX.md                           (row appended)
  ↓
brainctl promote <file>
  → .brain/known-mistakes.md                  (errors to avoid)
  → .brain/constraints.md                     (rules to follow)
  → global brain                              (cross-project learning)
  → .brain/decisions/                         (architectural decisions)
  → .brain/runbooks/                          (repeatable procedures)
  ↓
brainctl publish <file>              (split projects only)
  → public/.brain/investigations/             (sanitized, safe for GitHub)
```

---

## Success Criteria

- Mistakes are not repeated across sessions or projects
- Knowledge accumulates over time and is searchable
- Agents surface past learnings via `preflight` before acting
- Promotion and publishing are deliberate, low-friction acts
- Sensitive information never reaches public git remotes
- The system works with any AI agent tool
