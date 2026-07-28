# Conformance render — `vercel` spec

A reference page built strictly from [`design-md/vercel/DESIGN.md`](../../design-md/vercel/DESIGN.md), used to test whether that spec is complete enough for an AI agent to build from without inventing values.

- **[`index.html`](index.html)** — the render. Open it directly in a browser.
- **[`check-conformance.sh`](check-conformance.sh)** — verifies the page uses no color, type size, radius, or spacing step that isn't in the spec. Exits non-zero on a violation.

```
$ ./tests/vercel/check-conformance.sh
vercel DESIGN.md conformance
  PASS  colors on spec palette
  PASS  font sizes on type scale
  PASS  radii on rounded scale
  PASS  spacing on spacing scale
```

## Method

The subject is a **fictional** edge-Postgres product ("Halyard") — deliberately unrelated to Vercel's own product, so the test measures whether the design language generalizes rather than whether one page can be traced. All copy is invented test content.

Sections exercise the spec's specific claims: the 64px nav with 6px-radius CTAs, the hero mesh gradient at hero scale only, the `tab-ghost` pill row, a 3-up feature grid at Level 3 elevation, the polarity-flipped dark band, and a 3-up pricing grid with the middle tier flipped.

## What the spec got right

Near-total coverage. 36 color tokens, a full type scale with per-step letter-spacing, a 12-step spacing scale, 9 radii, 40 component definitions that cross-reference tokens rather than restating values, six elevation levels with exact stacked-shadow values, a five-row breakpoint table with per-component collapse behavior, and seven enforceable don'ts. Building the page required almost no invention.

## Gaps found

1. **No dark token set, and the depth model doesn't survive one.** The spec names the polarity-flipped band (`canvas-soft` → `primary`) as its "chief depth cue". Derive a dark theme by flipping the ground to `#171717` and both the flipped band and the featured pricing tier become invisible against it. This render works around it by inverting the flip into a raised surface plus a hairline ring — that workaround is not in the spec.

2. **No responsive type ramp.** The breakpoint table covers grid collapse and touch targets but never says what 48px display type becomes on mobile. This render steps down the spec's own scale (48 → 32 → 24) rather than inventing sizes.

3. **Internal contradiction on button radius.** The don'ts forbid pairing the 100px marketing pill with the 6px nav radius on one screen, but the component table specifies exactly that split (`nav-cta-signup` at `rounded.sm`, `button-primary` at `rounded.pill`) — unavoidable on any page with both a nav and a hero. This render follows the component table.

4. **Logo strip fails contrast.** `hairline-strong` (`#a1a1a1`) on `canvas-soft` (`#fafafa`) is roughly 2.3:1, below the WCAG minimum. The spec prescribes that pairing directly.
