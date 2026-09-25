#!/usr/bin/env bash
# Regenerate every artifact in docs/ and fab/ from the KiCad source in hardware/.
# Run from the repo root:  ./scripts/export.sh
#
# Requires kicad-cli (tested against KiCad 10.0.5).

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

SCH="hardware/Amplifier.kicad_sch"
PCB="hardware/Amplifier.kicad_pcb"

command -v kicad-cli >/dev/null || { echo "kicad-cli not found on PATH"; exit 1; }
echo "kicad-cli $(kicad-cli --version)"

mkdir -p docs/schematic docs/renders fab/gerbers

echo "==> Schematic PDF + SVG"
kicad-cli sch export pdf -o docs/schematic/Amplifier-schematic.pdf "$SCH"
# White background, not transparent: a transparent SVG with black strokes is
# invisible on GitHub's dark theme.
kicad-cli sch export svg -o docs/schematic "$SCH"

echo "==> Board renders (top and angled)"
kicad-cli pcb render --side top  --quality high --width 1600 --height 1200 \
  -o docs/renders/board-top.png "$PCB"
kicad-cli pcb render --rotate '-30,0,30' --perspective --floor --quality high \
  --width 1600 --height 1200 -o docs/renders/board-angled.png "$PCB"
kicad-cli pcb render --side bottom --quality high --width 1600 --height 1200 \
  -o docs/renders/board-bottom.png "$PCB"

echo "==> Gerbers"
kicad-cli pcb export gerbers --check-zones \
  -l F.Cu,B.Cu,F.Mask,B.Mask,F.Silkscreen,B.Silkscreen,Edge.Cuts \
  -o fab/gerbers "$PCB"

echo "==> Drill files"
kicad-cli pcb export drill --format excellon --excellon-separate-th \
  --generate-map --map-format pdf -o fab/gerbers "$PCB"

echo "==> BOM"
kicad-cli sch export bom \
  --fields 'Reference,Value,Footprint,QUANTITY,Datasheet' \
  --labels 'Refs,Value,Footprint,Qty,Datasheet' \
  --group-by Value \
  -o fab/Amplifier-BOM.csv "$SCH"

echo "==> Zipping gerbers for the fab house"
( cd fab && rm -f Amplifier-gerbers.zip && zip -q -r Amplifier-gerbers.zip gerbers )

echo "Done. Artifacts in docs/schematic, docs/renders, fab/."
