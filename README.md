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
