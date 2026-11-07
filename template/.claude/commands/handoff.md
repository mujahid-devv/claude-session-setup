---
description: Record the work just completed in this session as a worklog entry
argument-hint: [optional short title]
---

Add a handoff entry to `docs/WORKLOG.md` so other sessions know what happened here.

1. Gather facts: run `git branch --show-current`, `git status --short`, `git log --oneline -10`, and `git diff --stat main...HEAD` if on a feature branch.
2. Write one entry directly under the `<!-- entries: newest first -->` line, using the format at the top of the file. Use `$ARGUMENTS` as the title if given, otherwise a short summary.
3. Record only what actually happened in this session. Don't invent test results, deploy status or file lists; write "unknown" where you don't know.
4. Favor decisions and their reasons over a play-by-play. Keep the entry under about 15 lines.
5. Stage `docs/WORKLOG.md` but don't commit unless asked. Reply with the entry title and one line of status.
