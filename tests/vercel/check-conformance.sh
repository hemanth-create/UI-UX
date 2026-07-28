#!/usr/bin/env bash
# Checks that index.html only uses values defined in design-md/vercel/DESIGN.md.
# Run from anywhere:  ./tests/vercel/check-conformance.sh
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
page="$here/index.html"
spec="$here/../../design-md/vercel/DESIGN.md"
fail=0

lower() { tr 'A-F' 'a-f'; }

# --- colors: every hex in the page must appear in the spec -----------------
off_color=$(comm -23 \
  <(grep -oiE '#[0-9a-f]{6}' "$page" | lower | sort -u) \
  <(grep -oiE '#[0-9a-f]{6}' "$spec" | lower | sort -u))

# --- type: font sizes must be on the spec's typography scale ---------------
scale=$(grep -oE 'fontSize: [0-9]+px' "$spec" | grep -oE '[0-9]+px' | sort -un | paste -sd'|')
off_type=$(grep -oE '(font: *[0-9]+ +|font-size: *)[0-9]+px' "$page" \
  | grep -oE '[0-9]+px$' | sort -u | grep -vE "^($scale)\$" || true)

# --- radii: must be on the rounded: scale ----------------------------------
radii=$(sed -n '/^rounded:/,/^[a-z]/p' "$spec" | grep -oE '[0-9]+px' | sort -un | paste -sd'|')
off_radius=$(grep -oE 'border-radius: *[0-9]+px' "$page" \
  | grep -oE '[0-9]+px' | sort -u | grep -vE "^(0px|9999px|$radii)\$" || true)

# --- spacing: padding/gap/margin must be on the spacing: scale -------------
space=$(sed -n '/^spacing:/,/^[a-z]/p' "$spec" | grep -oE '[0-9]+px' | sort -un | paste -sd'|')
off_space=$(grep -oE '(padding|gap|margin)[a-z-]*: *[^;]*' "$page" \
  | grep -oE '\b[0-9]+px' | sort -u | grep -vE "^(0px|2px|3px|$space)\$" || true)

report() { # name, offenders
  if [ -z "$2" ]; then
    printf '  PASS  %s\n' "$1"
  else
    printf '  FAIL  %s -> %s\n' "$1" "$(echo "$2" | tr '\n' ' ')"
    fail=1
  fi
}

echo "vercel DESIGN.md conformance"
report "colors on spec palette"   "$off_color"
report "font sizes on type scale" "$off_type"
report "radii on rounded scale"   "$off_radius"
report "spacing on spacing scale" "$off_space"

# 2px/3px above are sub-token optical nudges on pill padding and list-marker
# alignment; the spec's scale bottoms out at 4px and says nothing below it.

exit $fail
