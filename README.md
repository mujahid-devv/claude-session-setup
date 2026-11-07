# claude-session-setup

Shared state for parallel coding-agent sessions (Claude Code, Codex, Devin) working in one repo.

## Problem

Sessions are isolated. A dev session implements, tests and deploys a feature; a side session (standup, diagrams, docs) can't see any of it, so it asks for a recap or guesses. The goal is to give every session the key facts, not the full transcript, while keeping the dev chat clean.

## Approach

Three layers, lightest first:

| Layer | Answers | Source |
|-------|---------|--------|
| Git | What changed | `git log`, `git diff` |
| Worklog | Why, status, decisions | `docs/WORKLOG.md` |
| Commands / skills | Keeps it current | see table below |

The dev session ends each task with a handoff, which appends a short entry to the worklog. Side sessions start with a catchup, which reads git and the worklog and stays read-only. All tools share the same worklog, so any of them can write or read it.

| Tool | Instructions file | Handoff | Catchup | Files installed |
|------|-------------------|---------|---------|-----------------|
| Claude Code | `CLAUDE.md` | `/handoff` | `/catchup` | `.claude/commands/` |
| Codex | `AGENTS.md` | `$handoff` | `$catchup` | `.agents/skills/` |
| Devin | `AGENTS.md` | `/handoff` | `/catchup` | `.devin/skills/` |

## Install into a project

```bash
git clone https://github.com/mujahid-devv/claude-session-setup.git
./claude-session-setup/install.sh /path/to/your/repo
```

By default this sets up all three tools. Pick one with `--tool claude`, `--tool codex` or `--tool devin`.

It adds to the target repo:

- `docs/WORKLOG.md` (only if missing; never overwritten)
- the command or skill files for the selected tools (see the table above)
- a `session-state` block in `CLAUDE.md` and/or `AGENTS.md` (created or appended; skipped if already present). Codex and Devin share one `AGENTS.md` block.

Re-running is safe. Use `--force` to refresh the commands, skills and instruction blocks after updating this repo. Then review and commit the changes in the target repo.

## Daily flow

1. Dev session: build, test, deploy, then run the handoff (optionally with a title). Commit `docs/WORKLOG.md` with your code.
2. Side session: run the catchup with a focus, for example `/catchup standup` in Claude Code or `$catchup diagram <feature>` in Codex, then continue with the task.

## Notes

- Keep the `AGENTS.md` block short. Devin loads only the first 16 KiB of that file automatically.
- Devin skills in `.devin/skills/` are documented for the Devin CLI. In the Devin web app, the `AGENTS.md` block is what carries the rules, so ask it to follow the handoff or catchup steps by name if the skill commands aren't offered.
- Sessions must see the same worklog: one shared checkout, or commit, push and pull it between clones.
