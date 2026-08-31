# Phased-Array Calculation & Automation Tools

A collection of practical **calculation, simulation, and automation tools** developed during the design and analysis of **Ku-band circularly polarized phased-array antennas**, including dual-fed, sequentially rotated CP arrays.

The repository covers **beam steering, link-budget analysis, HFSS post-processing automation, feed-network phase generation, and equivalent S-parameter analysis for large antenna arrays**.

## Contents

| Tool                                                                | Type                          | Description                                                                                                                                                                                                                            |
| ------------------------------------------------------------------- | ----------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`array-feed-phase-generator/`](./array-feed-phase-generator)       | Web App                       | Interactive tool for generating **HFSS Edit Sources CSV files** for dual-fed, sequentially rotated circularly polarized arrays with rectangular and triangular lattices. [Live Demo](#)                                                |
| [`array_equivalent_S_parameter/`](./array_equivalent_S_parameter)   | MATLAB / HFSS Post-Processing | Calculates the **equivalent S-parameter of an entire phased array** from the active S-parameters of all array ports exported from HFSS. Useful for evaluating array-level matching performance under different beamforming conditions. |
| [`hfss-pattern-sweep-automation/`](./hfss-pattern-sweep-automation) | HFSS VBScript                 | Automates **realized-gain and axial-ratio pattern generation** over a frequency sweep for both boresight and 60°-scanned beams in the principal planes.                                                                                |
| [`Beam_steering.xlsx`](./Beam_steering.xlsx)                        | Spreadsheet                   | Beam-steering angle and **inter-element phase-shift calculator** for phased arrays.                                                                                                                                                    |
| [`Link_Budget.xlsx`](./Link_Budget.xlsx)                            | Spreadsheet                   | **Satellite communication link-budget calculator** for evaluating system-level RF link performance.                                                                                                                                    |
