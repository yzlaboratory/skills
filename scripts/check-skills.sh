#!/usr/bin/env bash
set -euo pipefail

# Verifies every skill is consistently registered in:
#   - .claude-plugin/plugin.json
#   - README.md (top-level)
#   - skills/<bucket>/README.md (bucket-level)
#
# Exits non-zero on any mismatch. Run manually or wire into a pre-commit hook.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
ERRORS=0

err() {
  printf 'error: %s\n' "$1" >&2
  ERRORS=$((ERRORS + 1))
}

DISK_SKILLS="$(
  find "$REPO/skills" -name SKILL.md -not -path '*/node_modules/*' \
    | sed "s|^$REPO/||; s|/SKILL.md$||" \
    | sort
)"

PLUGIN_SKILLS="$(
  grep -oE '"\./skills/[^"]+"' "$REPO/.claude-plugin/plugin.json" \
    | tr -d '"' \
    | sed 's|^\./||' \
    | sort
)"

# Disk → plugin.json
while IFS= read -r s; do
  [ -z "$s" ] && continue
  if ! printf '%s\n' "$PLUGIN_SKILLS" | grep -qx "$s"; then
    err "$s exists on disk but is missing from .claude-plugin/plugin.json"
  fi
done <<< "$DISK_SKILLS"

# plugin.json → disk
while IFS= read -r s; do
  [ -z "$s" ] && continue
  if [ ! -f "$REPO/$s/SKILL.md" ]; then
    err "$s listed in .claude-plugin/plugin.json but $s/SKILL.md does not exist"
  fi
done <<< "$PLUGIN_SKILLS"

# Top-level README links
while IFS= read -r s; do
  [ -z "$s" ] && continue
  link="./$s/SKILL.md"
  if ! grep -qF "$link" "$REPO/README.md"; then
    err "$(basename "$s") is missing from README.md (expected a link to $link)"
  fi
done <<< "$DISK_SKILLS"

# Bucket README links
SEEN_MISSING_BUCKETS=""
while IFS= read -r s; do
  [ -z "$s" ] && continue
  bucket_path="$(dirname "$s")"
  name="$(basename "$s")"
  bucket_readme="$REPO/$bucket_path/README.md"
  if [ ! -f "$bucket_readme" ]; then
    case ":$SEEN_MISSING_BUCKETS:" in
      *":$bucket_path:"*) ;;
      *)
        err "$bucket_path/README.md does not exist"
        SEEN_MISSING_BUCKETS="$SEEN_MISSING_BUCKETS:$bucket_path"
        ;;
    esac
    continue
  fi
  link="./$name/SKILL.md"
  if ! grep -qF "$link" "$bucket_readme"; then
    err "$name is missing from $bucket_path/README.md (expected a link to $link)"
  fi
done <<< "$DISK_SKILLS"

if [ "$ERRORS" -gt 0 ]; then
  printf '\n%d issue(s) found.\n' "$ERRORS" >&2
  exit 1
fi

count="$(printf '%s\n' "$DISK_SKILLS" | grep -c '^')"
printf 'ok — %s skill(s), all consistent across plugin.json and READMEs.\n' "$count"
