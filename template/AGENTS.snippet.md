<!-- session-state:start -->
## Shared session state

Several coding agent sessions (Codex, Devin, Claude Code) may work in this repo at the same time. A dev session implements, tests and deploys. Side sessions handle things like standups, diagrams and docs. Sessions can't see each other's chats, so shared state lives in the repo.

- Source of truth for what happened: `git log`, `git diff` and `docs/WORKLOG.md`.
- Side sessions: use the `catchup` skill first (Codex: `$catchup`, Devin: `/catchup`). Don't modify source code unless asked; writing under `docs/` is fine.
- Dev session: after finishing a task (implemented, tested, deployed, or a notable decision made), use the `handoff` skill (Codex: `$handoff`, Devin: `/handoff`) to add a worklog entry.
- Keep worklog entries short: facts, decisions and status, not transcripts. Never invent results; write "unknown" instead.
<!-- session-state:end -->
