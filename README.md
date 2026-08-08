# Phased-Array Calculation & Automation Tools

Practical calculation and automation tools built while designing Ku-band circularly-polarized
(sequentially-rotated, dual-fed) phased-array antennas: link budgets, beam-steering calculators,
HFSS post-processing automation, and a feed-network phase generator.

## Contents

| Tool | Type | Description |
|---|---|---|
| [`array-feed-phase-generator/`](./array-feed-phase-generator) | Web app | Interactive tool that generates HFSS Edit Sources CSV files for dual-fed, sequentially-rotated CP arrays (rectangular & triangular lattices). [Live demo](#) |
| [`hfss-pattern-sweep-automation/`](./hfss-pattern-sweep-automation) | HFSS VBScript | Automates realized-gain / axial-ratio pattern generation across a frequency sweep, for boresight vs. 60°-scanned beams, in both principal planes |
| `Beam_steering.xlsx` | Spreadsheet | Beam-steering angle / inter-element phase calculator |
| `Link_Budget.xlsx` | Spreadsheet | Satellite link budget calculator |
