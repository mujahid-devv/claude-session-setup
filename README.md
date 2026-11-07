# claude-session-setup

Shared state for parallel Claude coding sessions working in one repo.

## Problem

Sessions are isolated. A dev session implements, tests and deploys a feature; a side session (standup, diagrams, docs) can't see any of it, so it asks for a recap or guesses. The goal is to give every session the key facts, not the full transcript, while keeping the dev chat clean.

## Approach

Three layers, lightest first:

| Layer | Answers | Source |
|-------|---------|--------|
| Git | What changed | `git log`, `git diff` |
| Worklog | Why, status, decisions | `docs/WORKLOG.md` |
| Commands | Keeps it current | `/handoff`, `/catchup` |

The dev session ends each task with `/handoff`, which appends a short entry to the worklog. Side sessions start with `/catchup`, which reads git and the worklog and stays read-only.

## Install into a project

```bash
git clone https://github.com/mujahid-devv/claude-session-setup.git
./claude-session-setup/install.sh /path/to/your/repo
```

This adds to the target repo:

- `.claude/commands/handoff.md` and `.claude/commands/catchup.md`
- `docs/WORKLOG.md` (only if missing; never overwritten)
- a `session-state` block in `CLAUDE.md` (created or appended; skipped if already present)

Re-running is safe. Use `--force` to refresh the commands and the `CLAUDE.md` block after updating this repo. Then review and commit the changes in the target repo.

## Daily flow

1. Dev session: build, test, deploy, then `/handoff` (optionally with a title).
2. Side session: `/catchup standup` or `/catchup diagram <feature>`, then continue with the task.
