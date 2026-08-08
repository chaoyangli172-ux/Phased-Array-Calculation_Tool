# HFSS Pattern Sweep Automation (VBScript)

Automates a repetitive HFSS post-processing task for a sequentially-rotated CP phased array:
generating realized-gain and axial-ratio far-field pattern plots at multiple frequencies, each
comparing boresight against a 60°-scanned beam, in both principal planes.

## What it does

For each frequency in a 10.5–14.5 GHz sweep (0.5 GHz steps), and for each of the two principal
scan planes (Phi = 0° / `dx` taper, Phi = 90° / `dy` taper):

1. Resets the array's phase-taper variables to 0° (boresight)
2. Creates a `Realized Gain` and an `Axial Ratio` rectangular plot vs. Theta
3. Freezes a static "boresight" trace snapshot (copy → paste)
4. Computes the inter-element phase step needed to scan the beam to θ = 60° for the plane's
   element spacing, and sets the corresponding taper variable
5. Freezes a second, "scanned" trace snapshot
6. Deletes the live (variable-linked) traces, so later loop iterations can keep changing `dx`/
   `dy` without corrupting plots generated earlier in the run

Plot numbering increments automatically across the full run (Phi = 0° sweep first, then
Phi = 90°, continuing the same numbering), so a single script run produces the complete set of
gain/axial-ratio comparison plots for both scan planes across the whole frequency band.

## Usage

1. Open the target HFSS project — a dual-fed sequentially-rotated CP array with `dx`/`dy`
   phase-taper design variables and a far-field setup named `Setup1 : Sweep`
2. Edit the constants at the top of the script (`dSpacingX`, `dSpacingY`, `thetaScan`, project/
   design names) to match your model
3. Tools → Run Script → select `Pattern_Postprocess.vbs`


## Note

The report-creation call hard-codes this specific design's full variable list (patch/feed
dimensions, etc.) — that part is project-specific and would need adapting for a different
antenna. The reusable pieces are the general technique (loop over frequency, reset-then-set the
scan variable, freeze traces via copy/paste so later iterations don't overwrite earlier plots)
and the beam-steering phase formula.

## Requires

Ansys Electronics Desktop / HFSS with a `ReportSetup` module and a far-field `EH` context report
type.
