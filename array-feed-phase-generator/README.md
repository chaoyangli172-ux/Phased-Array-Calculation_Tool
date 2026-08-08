# Array Feed Phase Generator

An interactive, browser-based tool that generates ready-to-import HFSS **Edit Sources** CSV
files for dual-fed, sequentially-rotated circularly-polarized phased arrays — rectangular or
triangular (staggered-row) lattices, up to 8×8 elements.

**[Live demo](#)** — runs entirely client-side, no install, no dependencies.

## Why this exists

Configuring Edit Sources by hand for a sequentially-rotated CP array is tedious and
error-prone: every element's initial phase depends on its position inside a 2×2 rotated
subarray *and* on the beam-steering phase taper, and triangular (staggered) lattices add an
extra offset term on top of that. Doing this by hand for anything bigger than a 2×2 quickly
turns into copy-paste errors. This tool computes every port's phase from a handful of clicks.

## Features

- N×N array sizes (2–8, even), three lattice types:
  - Rectangular
  - Triangular A / Triangular B (mirrored) — staggered-row lattices, reference element always
    at the top-left with zero phase offset
- Click-to-number element ordering — maps the physical grid position to HFSS port indices in
  whatever order you actually built/labeled the array
- Single-port or dual-port (orthogonal-feed) excitation, with a configurable quadrature phase
  offset between the two ports of each element
- Selectable sequential-rotation sense (0 / −90 / −180 / −270° vs. 0 / 90 / 180 / 270°, for the
  two circular-polarization handedness options)
- Exports a CSV in the exact `Source,Magnitude,Phase` format HFSS's Edit Sources dialog expects

## Coordinate convention

Matches HFSS's top-view orientation: **x points down, y points right, z into the screen**
(shown as a small axis legend on the grid). The top-left element (i = 0, j = 0) is always the
phase reference — its dx/dy coefficients are exactly zero under every lattice type.

## Phase formulas

For an element at grid position (i, j), 0-indexed from the top-left reference element:

- **Rectangular:** `X = i`, `Y = j`
- **Triangular A:** `X = 2·i + (j mod 2)`, `Y = j`
- **Triangular B (mirror):** `X = 2·i − (j mod 2)`, `Y = j`

Each port's phase is `base − dx·X − dy·Y`, where `base` comes from the sequential-rotation
sequence indexed by the element's position (L0–L3) inside its own 2×2 subarray. All three
formulas were verified line-by-line (zero mismatches) against real Edit Sources exports for
16-element rectangular and triangular reference arrays, including both triangular mirror
conventions. See the "formulas & assumptions" panel inside the tool for the full derivation.

## Usage

Open `array_feed_generator.html` in any modern browser, or use the live demo. Walk through the
four steps (array size & lattice → element numbering → excitation mode → rotation sense), then
export and import the CSV directly into HFSS's Edit Sources dialog.
