# Study list

Things this project made me look up, and anything in this repo I did not write
line by line. The point of the list is that I should be able to re-derive each of
these without the file in front of me.

## Analog concepts

### Resistor power derating
`P = I²R`, and then the derating curve on top of it. A 1/4 W part is 1/4 W at
25 °C in free air; in a crowded build with no airflow the usable number is lower,
which is why the 2 W replacement is also mounted raised off the board. This is
what destroyed the first build — R2 at 910 Ω and 24 mA is 0.52 W in a 0.25 W part.
**Learn:** how to read a derating curve, and why a 2× margin is the usual rule.

### AC load line and output swing limit
The DC operating point sets where you sit; the AC load line sets how far you can
move from there. For a common-emitter stage the positive swing is capped at
`I_bias × (R_C ∥ R_L)`, independent of the supply rail. This is the thing I missed:
6.6 mA × 500 Ω = 3.3 V, against the 4.47 V peak that 10 mW into 1 kΩ needs.
**Learn:** draw the DC and AC load lines on the same axes and read the clipping
points off both ends.

### Bias sensitivity to Vbe
The Q4 bias divider puts under 1 V across a junction whose drop is about 0.65 V and
moves −2 mV/°C. What is left over is a small difference of two similar numbers, so
everything that perturbs either one gets amplified: ±5 % on R4 is roughly ±25 % on
collector current, and +25 °C on Q4 is roughly +30 %.
**Learn:** why emitter degeneration and current-mirror biasing exist, and what
fraction of the supply a divider-biased emitter should sit at to be stable.

### Cascode and the Miller effect
A common-emitter stage's collector-base capacitance appears at the input
multiplied by `(1 + gain)` — the Miller effect — and that product is what sets the
high-frequency corner. Stacking a common-base transistor on top pins the
common-emitter collector to a near-constant voltage, so its gain to the collector
is about −1 and the multiplication almost disappears. That is the whole reason
this design reaches 60 MHz in simulation.
**Learn:** derive the Miller capacitance, then work out where the cascode moves
the pole to.

### Probe loading
A 10× probe is 10–15 pF at the tip. Against this amplifier's ~500 Ω output node
that is a pole at 20–30 MHz, well below the circuit's own bandwidth — so the scope
measures the probe, not the board. Coax straight into a 1 MΩ input is ~115 pF and
far worse.
**Learn:** probe compensation, why 10× exists at all, and when to reach for an
active or FET probe instead.

### Reading a simulator honestly
Both failures in this project were visible in output I had already generated. The
power dissipation was in the operating point; the clipping was in the shape of the
transient waveform. Neither was flagged, because a simulator answers the question
you asked.
**Learn:** build a habit of a post-simulation checklist — per-part power, swing
headroom at both rails, and what the measurement gear will add.

## Generated files in this repo

These were written for me rather than by me, so they are on the list.

### `sim/spice/amp_sanity_ngspice.cir`
ngspice port of the LTspice netlist. Differences worth understanding: `SINE(`
becomes `SIN(`, and LTspice's standalone `.meas` cards become `meas` commands
inside a `.control` block, which lets op, ac and tran all run in one invocation.
**Learn:** ngspice `.control` block syntax and the `meas` command forms
(`FIND ... AT`, `WHEN ... FALL=LAST`, `AVG ... FROM ... TO`), plus what the
`fourier` command's THD number is actually computed from.

### `scripts/export.sh`
Regenerates the schematic PDF/SVG, the 3D renders, gerbers, drill files and BOM
from the KiCad source, so no exported artifact in the repo is hand-made.
**Learn:** the `kicad-cli` subcommand set, and why generated output should be
reproducible from source rather than committed by hand once and drifted from.
The stale `hardware/Amplifier.csv` in this repo is exactly that failure mode — an
export from Sept 22 that still showed the pre-fix resistor values two days after
the schematic changed.

### `README.md` spec and probe-loading tables
The numbers came from ngspice runs of the as-built and original values, and from
the original PSpice run for input impedance. Nothing in them is measured.
**Learn:** re-run each of these myself before quoting them in an interview.
