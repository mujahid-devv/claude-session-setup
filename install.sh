#!/usr/bin/env bash
# Install the shared-session-state setup into a target repo.
# Usage: ./install.sh /path/to/target-repo [--tool claude|codex|devin|all] [--force]
# --tool   which agent to set up (default: all)
# --force  overwrites commands/skills and replaces the instruction block.
# The worklog is never overwritten.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/template" && pwd)"
TARGET=""
TOOL="all"
FORCE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force) FORCE=1 ;;
    --tool)
      [[ $# -ge 2 ]] || { echo "error: --tool needs a value" >&2; exit 1; }
      TOOL="$2"
      shift
      ;;
    -h|--help) sed -n '2,6p' "$0"; exit 0 ;;
    -*) echo "error: unknown option $1" >&2; exit 1 ;;
    *) TARGET="$1" ;;
  esac
  shift
done

if [[ -z "$TARGET" ]]; then
  echo "usage: $0 /path/to/target-repo [--tool claude|codex|devin|all] [--force]" >&2
  exit 1
fi
case "$TOOL" in
  claude|codex|devin|all) ;;
  *) echo "error: --tool must be claude, codex, devin or all (got '$TOOL')" >&2; exit 1 ;;
esac
if [[ ! -d "$TARGET/.git" ]]; then
  echo "error: $TARGET is not the root of a git repo" >&2
  exit 1
fi

START='<!-- session-state:start -->'
END='<!-- session-state:end -->'

want() { [[ "$TOOL" == "all" || "$TOOL" == "$1" ]]; }

copy() { # copy <source in template/> <destination in target> <overwrite-allowed: 0|1>
  local src="$1" rel="$2" may_overwrite="$3" dest="$TARGET/$2"
  if [[ -e "$dest" && ( "$may_overwrite" -eq 0 || $FORCE -eq 0 ) ]]; then
    echo "skip   $rel (exists)"
  else
    mkdir -p "$(dirname "$dest")"
    cp "$SRC/$src" "$dest"
    echo "write  $rel"
  fi
}

add_block() { # add_block <instruction file> <snippet file in template/>
  local name="$1" file="$TARGET/$1" snippet="$SRC/$2" add=1 tmp
  if [[ -f "$file" ]] && grep -qF "$START" "$file"; then
    if [[ $FORCE -eq 1 ]]; then
      tmp="$(mktemp)"
      sed "/$START/,/$END/d" "$file" > "$tmp"
      cat "$tmp" > "$file"
      rm -f "$tmp"
    else
      add=0
      echo "skip   $name (block already present)"
    fi
  fi
  if [[ $add -eq 1 ]]; then
    { [[ -s "$file" ]] && echo; cat "$snippet"; } >> "$file"
    echo "write  $name (session-state block)"
  fi
}

copy "docs/WORKLOG.md" "docs/WORKLOG.md" 0

if want claude; then
  copy ".claude/commands/handoff.md" ".claude/commands/handoff.md" 1
  copy ".claude/commands/catchup.md" ".claude/commands/catchup.md" 1
  add_block "CLAUDE.md" "CLAUDE.snippet.md"
fi

if want codex; then
  copy ".agents/skills/handoff/SKILL.md" ".agents/skills/handoff/SKILL.md" 1
  copy ".agents/skills/catchup/SKILL.md" ".agents/skills/catchup/SKILL.md" 1
fi

if want devin; then
  copy ".agents/skills/handoff/SKILL.md" ".devin/skills/handoff/SKILL.md" 1
  copy ".agents/skills/catchup/SKILL.md" ".devin/skills/catchup/SKILL.md" 1
fi

# Codex and Devin both read AGENTS.md, so they share one block.
if want codex || want devin; then
  add_block "AGENTS.md" "AGENTS.snippet.md"
fi

echo "done. Next: review and commit the changes in $TARGET"
