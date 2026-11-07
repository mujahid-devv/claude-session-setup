#!/usr/bin/env bash
# Install the shared-session-state setup into a target repo.
# Usage: ./install.sh /path/to/target-repo [--force]
# --force overwrites the slash commands and replaces the CLAUDE.md block.
# The worklog is never overwritten.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/template" && pwd)"
TARGET="${1:-}"
FORCE=0
[[ "${2:-}" == "--force" ]] && FORCE=1

if [[ -z "$TARGET" ]]; then
  echo "usage: $0 /path/to/target-repo [--force]" >&2
  exit 1
fi
if [[ ! -d "$TARGET/.git" ]]; then
  echo "error: $TARGET is not the root of a git repo" >&2
  exit 1
fi

START='<!-- session-state:start -->'
END='<!-- session-state:end -->'

copy() { # copy <relative path> <overwrite-allowed: 0|1>
  local rel="$1" may_overwrite="$2" dest="$TARGET/$1"
  if [[ -e "$dest" && ( "$may_overwrite" -eq 0 || $FORCE -eq 0 ) ]]; then
    echo "skip   $rel (exists)"
  else
    mkdir -p "$(dirname "$dest")"
    cp "$SRC/$rel" "$dest"
    echo "write  $rel"
  fi
}

copy ".claude/commands/handoff.md" 1
copy ".claude/commands/catchup.md" 1
copy "docs/WORKLOG.md" 0

CLAUDE_MD="$TARGET/CLAUDE.md"
add_block=1
if [[ -f "$CLAUDE_MD" ]] && grep -qF "$START" "$CLAUDE_MD"; then
  if [[ $FORCE -eq 1 ]]; then
    tmp="$(mktemp)"
    sed "/$START/,/$END/d" "$CLAUDE_MD" > "$tmp"
    mv "$tmp" "$CLAUDE_MD"
  else
    add_block=0
    echo "skip   CLAUDE.md (block already present)"
  fi
fi
if [[ $add_block -eq 1 ]]; then
  { [[ -s "$CLAUDE_MD" ]] && echo; cat "$SRC/CLAUDE.snippet.md"; } >> "$CLAUDE_MD"
  echo "write  CLAUDE.md (session-state block)"
fi

echo "done. Next: review and commit the changes in $TARGET"
