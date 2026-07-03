#!/bin/bash
# render_all.sh — Batch render all Sonic Pi studies to WAV
# Usage: bash render_all.sh [output_dir]
#
# Prerequisites:
#   - Sonic Pi server running headless (start_sonic_pi.sh)
#   - PulseAudio null sink 'sp_render' created and routed
#   - jack_connect: SuperCollider outputs → sp_render playback
#
# Fixes applied (July 3):
#   - Comment stripping before OSC transmission (Unicode in comments breaks oscdecode.rb)
#   - SIGINT for parec (SIGTERM leaves WAV header with size=0)
#   - Study 09 added to durations list
#   - Port 4557 assumed (default Sonic Pi OSC port)

set -e

OUTPUT_DIR="${1:-/tmp/kestrel-renders}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$OUTPUT_DIR"

# Study durations (in seconds) — generous estimates including tail
declare -A DURATIONS=(
  ["01_erosion.rb"]=250
  ["02_phase_drift.rb"]=220
  ["03_wraith_study.rb"]=200
  ["04_accretion.rb"]=150
  ["05_interstice.rb"]=620
  ["06_metamorphosis.rb"]=400
  ["07_recurrence.rb"]=460
  ["08_persistence.rb"]=2300
  ["09_contrapuntal_erosion.rb"]=670
)

echo "=== Kestrel Sounds — Batch Render ==="
echo "Output: $OUTPUT_DIR"
echo "Studies: ${#DURATIONS[@]}"
echo ""

for file in "$SCRIPT_DIR"/0*_*.rb; do
  filename=$(basename "$file")
  output="$OUTPUT_DIR/${filename%.rb}.wav"
  duration=${DURATIONS[$filename]:-60}

  echo ">>> Rendering $filename (${duration}s)..."

  # Skip if already rendered
  if [ -f "$output" ] && [ $(stat -c%s "$output") -gt 100000 ]; then
    echo "    Already exists ($(du -h "$output" | cut -f1)), skipping"
    continue
  fi

  ruby "$SCRIPT_DIR/render.rb" "$file" "$output" "$duration"
  echo ""
done

echo "=== All renders complete ==="
echo "Files:"
ls -lh "$OUTPUT_DIR"/*.wav 2>/dev/null || echo "  (none)"
echo ""
echo "To convert to FLAC:"
echo "  for f in $OUTPUT_DIR/*.wav; do sox \"\$f\" \"${f%.wav}.flac\"; done"
echo "  for f in $OUTPUT_DIR/*.wav; do sox \"\$f\" \"${f%.wav}_norm.wav\" gain -n -3 && sox \"${f%.wav}_norm.wav\" \"${f%.wav}_norm.flac\"; done"