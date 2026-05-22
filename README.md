# brain-kit

A portable, self-improving knowledge system for software projects. Clone this once per environment to get `brainctl` and a ready-to-use brain scaffold.

See [brain-system-v2.md](brain-system-v2.md) for the full specification.

---

## Install

```bash
git clone <this-repo> ~/brain-kit
cd ~/brain-kit
./install.sh
```

This copies `brainctl` to `~/.local/bin/`. Make sure that's on your `PATH`.

---

## Bootstrap a new environment

```bash
# 1. Create your global brain (cross-project learnings)
brainctl init --global ~/brain

# 2. Set BRAIN_GLOBAL in each project's .envrc
export BRAIN_GLOBAL=~/brain

# 3. Scaffold a project
cd ~/myproject
brainctl init --type private       # fully private project
# or
brainctl init --type split-private # private half of a split project
```

---

## Project types

| Type | Use when |
|------|----------|
| `private` | Single private repo, no public counterpart |
| `split-private` | Private half of a public+private split |
| `split-public` | Public half of a public+private split |

Templates for each type are in `templates/`. The `.envrc` they produce wires up `BRAIN_ROOT`, `BRAIN_PUBLIC`, and `BRAIN_GLOBAL` correctly.

---

## Daily workflow

```bash
brainctl preflight "what I'm about to do"   # search past work first
# ... do the work ...
brainctl capture "what I did"               # record learnings after
brainctl promote <investigation-file>       # promote stable rules
brainctl publish <investigation-file>       # sanitize + push to public brain
```

---

## Keeping brainctl up to date

When this repo is updated, reinstall:

```bash
cd ~/brain-kit
git pull
./install.sh
```

---

## Structure

```
brain-kit/
├── brainctl          the CLI
├── install.sh        installs brainctl to ~/.local/bin/
├── brain-system-v2.md  canonical spec
├── templates/        project scaffolds (private, split-private, split-public)
├── skeleton/         brain structure created by brainctl init
└── .brain/           public brain rules for this repo
```
