#!/usr/bin/env bash
# =====================================================================
#  SILENCE — build the WHOLE site (English + French) and check links.
#  Usage:   bash tools/build.sh
#  After any edit to a build script or a _content/*.html fragment,
#  run this once and refresh the browser.
# =====================================================================
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
DIR="/Users/mac/maison-elan"

echo "▶ Building English site…"
bash "$HERE/build-en.sh" | sed 's/^/   /'
echo "▶ Building French site…"
bash "$HERE/build-fr.sh" | sed 's/^/   /'

echo "▶ Checking links…"
cd "$DIR"
broken=0
for f in *.html fr/*.html; do
  base=$(dirname "$f")
  for t in $(grep -oE 'href="[a-z0-9][a-z0-9-]*\.html' "$f" | sed -E 's/href="//' | sort -u); do
    [ -f "$base/$t" ] || { echo "   ✗ $f → $t"; broken=$((broken+1)); }
  done
done
dead=$(grep -roh 'href="#"' *.html fr/*.html 2>/dev/null | wc -l | tr -d ' ')
if [ "$broken" -eq 0 ] && [ "$dead" -eq 0 ]; then
  echo "   ✓ no broken links, no dead placeholders"
else
  echo "   ⚠ $broken broken link(s), $dead dead href=\"#\""
fi

echo "✔ Done — $(ls *.html | wc -l | tr -d ' ') EN + $(ls fr/*.html | wc -l | tr -d ' ') FR pages."
echo "  Open:  $DIR/index.html   |   $DIR/fr/index.html"
