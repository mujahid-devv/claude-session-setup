---
description: Brief this session on the repo's current state from git and the worklog (read-only)
argument-hint: [focus, e.g. standup | diagram <feature>]
---

Get oriented without touching code.

1. Read the top 5 entries of `docs/WORKLOG.md`, then run `git branch --show-current`, `git status --short` and `git log --oneline -15`.
2. Reply with at most 10 lines: current branch, what was done recently, status (done, in progress, deployed), key decisions, open items.
3. Flag mismatches: uncommitted changes missing from the worklog, worklog entries with no matching commit, or a missing or empty worklog.
4. If `$ARGUMENTS` names a focus (a standup, a diagram of a feature), keep the summary targeted to it and then do that task using only these facts. Ask when something needed isn't recorded instead of guessing.
5. Don't modify source files. Writing under `docs/` is fine when asked.
