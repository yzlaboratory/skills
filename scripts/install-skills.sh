#!/usr/bin/env bash
set -euo pipefail

# Copies all skills in the repository into ~/.claude/skills, so that
# they can be used by the local Claude CLI.
#
# Re-run after pulling new changes — copies are snapshots, not live links.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$HOME/.claude/skills"

# If ~/.claude/skills is a symlink that resolves into this repo (left over
# from the old link-based installer), bail out — copying into it would write
# back into the repo's own skills/ tree.
if [ -L "$DEST" ]; then
  resolved="$(readlink -f "$DEST")"
  case "$resolved" in
    "$REPO"|"$REPO"/*)
      echo "error: $DEST is a symlink into this repo ($resolved)." >&2
      echo "Remove it (rm \"$DEST\") and re-run; the script will recreate it as a real dir." >&2
      exit 1
      ;;
  esac
fi

mkdir -p "$DEST"

find "$REPO/skills" -name SKILL.md -not -path '*/node_modules/*' -print0 |
while IFS= read -r -d '' skill_md; do
  src="$(dirname "$skill_md")"
  name="$(basename "$src")"
  target="$DEST/$name"

  rm -rf "$target"
  cp -R "$src" "$target"
  echo "copied $name -> $target"
done
