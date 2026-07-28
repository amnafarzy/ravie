#!/bin/bash
# Verify every relative markdown link in the repo resolves to an existing
# file or directory. External (http/mailto) and pure-anchor links are
# skipped; archive/ and dot-directories are not scanned.
# Run from anywhere: /bin/bash scripts/check-links.sh
set -u

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT" || exit 1

FAIL=0
CHECKED=0

while IFS= read -r file; do
  dir=$(dirname "$file")
  while IFS= read -r target; do
    # Strip optional angle brackets and a trailing "title" component.
    target=${target#<}
    target=${target%>}
    target=$(printf '%s' "$target" | sed -E 's/[[:space:]]+"[^"]*"$//')
    case "$target" in
      http://*|https://*|mailto:*|'#'*|'') continue ;;
    esac
    # Drop any #anchor fragment; what remains must exist on disk.
    target=${target%%#*}
    [ -z "$target" ] && continue
    if [ "${target#/}" != "$target" ]; then
      resolved="$REPO_ROOT$target"   # leading slash = repo root
    else
      resolved="$dir/$target"
    fi
    CHECKED=$((CHECKED + 1))
    if [ ! -e "$resolved" ]; then
      echo "BROKEN: $file -> $target"
      FAIL=$((FAIL + 1))
    fi
  done < <(grep -oE '\]\([^)]+\)' "$file" | sed -E 's/^\]\(//; s/\)$//')
done < <(find . -name '*.md' -not -path './.git/*' -not -path './archive/*' -not -path './.*/*' -not -path './node_modules/*')

echo ""
echo "link check: $CHECKED relative links checked, $FAIL broken"
[ "$FAIL" -eq 0 ] || exit 1
exit 0
