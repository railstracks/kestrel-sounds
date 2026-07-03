#!/bin/bash
# render09_clean.sh — Clean attempt at rendering Study 09
# Strategy: boot Sonic Pi, find scsynth's Jack ports, manually connect to null sink
set -e

RENDER_DIR="/tmp/kestrel-sounds-render"
OUTPUT_WAV="$RENDER_DIR/09_contrapuntal.wav"
OUTPUT_FLAC="$RENDER_DIR/09_contrapuntal.flac"
CODE_FILE="/home/melvin/projects/kestrel-sounds/09_contrapuntal_erosion.rb"
DURATION=660  # 11 minutes (piece is ~10.3 min + buffer)

mkdir -p "$RENDER_DIR"

echo "=== Phase 1: Full cleanup ==="
# Kill all old Sonic Pi / audio processes
pkill -9 -f "scsynth" 2>/dev/null || true
pkill -9 -f "sonic-pi" 2>/dev/null || true
pkill -9 -f "beam.smp" 2>/dev/null || true
pkill -9 -f "beam.smp.*pi_server" 2>/dev/null || true
pkill -9 -f "m2o" 2>/dev/null || true
pkill -9 -f "o2m" 2>/dev/null || true
pkill -9 -f "parec" 2>/dev/null || true
sleep 3

# Remove all old Sonic_Pi_Render null sinks
for sink_id in $(pactl list short sinks 2>/dev/null | grep sonic_pi_render | awk '{print $1}'); do
    pactl unload-module "$sink_id" 2>/dev/null || true
done
# Alternative: delete by name
pactl delete-null-sink sonic_pi_render 2>/dev/null || true
pw-cli destroy $(pw-cli list 2>/dev/null | grep -B5 'sonic_pi_render' | grep 'id ' | awk '{print $2}') 2>/dev/null || true
sleep 1

# Also kill any lingering Erlang processes from Sonic Pi
pkill -9 -f "pi_server" 2>/dev/null || true
sleep 2

echo "=== Phase 2: Create clean null sink ==="
pactl load-module module-null-sink sink_name=sonic_pi_render sink_properties="device.description='Sonic Pi Render'"
sleep 1
# Verify it exists
pactl list short sinks 2>/dev/null | grep sonic_pi_render
echo "Null sink created."

echo "=== Phase 3: Boot Sonic Pi ==="
# Clean environment — avoid asdf Ruby
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
unset ASDF_DIR ASDF_DATA_DIR ASDF_CONFIG_FILE 2>/dev/null || true
export GEM_PATH=""
export GEM_HOME=""

# Point PulseAudio at our null sink
export PULSE_SINK="sonic_pi_render"

SP_LOG="$RENDER_DIR/sp_clean.log"
QT_QPA_PLATFORM=offscreen /usr/bin/ruby /usr/lib/sonic-pi/app/server/ruby/bin/sonic-pi-server.rb > "$SP_LOG" 2>&1 &
SP_PID=$!
echo "Sonic Pi PID: $SP_PID"

# Wait for boot
echo "Waiting 30s for boot..."
sleep 30

if ! kill -0 $SP_PID 2>/dev/null; then
    echo "SERVER DIED during boot!"
    tail -50 "$SP_LOG"
    exit 1
fi
echo "Server alive."

echo "=== Phase 4: Find and connect scsynth ports ==="
# List all Jack ports to find scsynth outputs
echo "--- All Jack ports ---"
jack_lsp 2>&1 | head -60
echo "---"

# Find scsynth output ports (typically named like "SuperCollider" or "scsynth" or with port numbers)
SCSOFT_OUTS=$(jack_lsp -p 2>/dev/null | grep -i -E 'scsynth|supercollider|out_[0-9]' | head -4 || true)
echo "scsynth output candidates: $SCSOUTS"

# Try connecting scsynth outputs to null sink
# The Jack port names for scsynth are usually: scsynth:out_1, scsynth:out_2 etc.
# With PipeWire Jack bridge, they might appear differently

# Let's find any ports that look like scsynth outputs
for port_pattern in "scsynth" "SuperCollider" "SC3"; do
    FOUND=$(jack_lsp 2>/dev/null | grep -i "$port_pattern" || true)
    if [ -n "$FOUND" ]; then
        echo "Found ports matching '$port_pattern':"
        echo "$FOUND"
    fi
done

# Also check PipeWire nodes for scsynth
echo "--- PipeWire nodes ---"
pw-cli list 2>/dev/null | grep -i -E 'scsynth|supercol|sonic' || echo "(none found)"

echo "=== Phase 5: Try connecting via jack_connect ==="
# Get the null sink's Jack ports
NULL_PLAYBACK=$(jack_lsp 2>/dev/null | grep -i "Sonic_Pi_Render\|sonic_pi_render" | grep playback || true)
NULL_MONITOR=$(jack_lsp 2>/dev/null | grep -i "Sonic_Pi_Render\|sonic_pi_render" | grep monitor || true)
echo "Null sink playback ports: $NULL_PLAYBACK"
echo "Null sink monitor ports: $NULL_MONITOR"

# Try various possible scsynth port name patterns
for sc_port in $(jack_lsp 2>/dev/null | grep -iE 'scsynth.*(out|playback)' | head -2); do
    for sink_port in $NULL_PLAYBACK; do
        echo "Connecting: $sc_port -> $sink_port"
        jack_connect "$sc_port" "$sink_port" 2>&1 || echo "  (failed)"
    done
done

# Also try pw-link approach
echo "--- pw-link approach ---"
pw-link -l 2>/dev/null | grep -i -E 'scsynth|sonic|render' | head -10 || echo "(no pw-link matches)"

echo "=== Phase 6: Start recording + send code ==="
# Start recording from null sink monitor
parec --device=sonic_pi_render.monitor --file-format=wav "$OUTPUT_WAV" &
REC_PID=$!
echo "Recording PID: $REC_PID"
sleep 2

# Send a test note first
echo "Sending test note..."
/usr/bin/ruby -e '
require "socket"
def pad4(s); s + ("\x00" * ((4 - s.length % 4) % 4)); end
msg = pad4("/run-code\x00")
msg += pad4(",is\x00")
msg += [0].pack("N")
code = "use_synth :prophet; play :E3, release: 2, cutoff: 80, amp: 0.3"
msg += pad4(code + "\x00")
sock = UDPSocket.new
sock.connect("127.0.0.1", 4557)
sock.send(msg, 0)
sock.close
puts "Test note sent"
'
sleep 5

# Check if recording has any signal
TEST_SIZE=$(stat -c%s "$OUTPUT_WAV" 2>/dev/null || echo 0)
echo "Recording size after test: $TEST_SIZE bytes"

# Send the actual study code
echo "Sending Study 09 code..."
/usr/bin/ruby -e '
require "socket"
def pad4(s); s + ("\x00" * ((4 - s.length % 4) % 4)); end
code = File.read(ARGV[0])
msg = pad4("/run-code\x00")
msg += pad4(",is\x00")
msg += [0].pack("N")
msg += pad4(code + "\x00")
sock = UDPSocket.new
sock.connect("127.0.0.1", 4557)
sock.send(msg, 0)
sock.close
puts "Study code sent (#{code.length} bytes)"
' "$CODE_FILE"
echo "Code sent."

echo "=== Phase 7: Render ($DURATION seconds) ==="
sleep $DURATION

echo "=== Phase 8: Stop and verify ==="
# Stop playback
/usr/bin/ruby -e '
require "socket"
def pad4(s); s + ("\x00" * ((4 - s.length % 4) % 4)); end
msg = pad4("/stop-all-jobs\x00")
msg += pad4(",i\x00")
msg += [0].pack("N")
sock = UDPSocket.new
sock.connect("127.0.0.1", 4557)
sock.send(msg, 0)
sock.close
puts "Stop sent"
'
sleep 3

# Stop recording
kill $REC_PID 2>/dev/null || true
wait $REC_PID 2>/dev/null || true

# Check results
if [ -f "$OUTPUT_WAV" ]; then
    SIZE=$(stat -c%s "$OUTPUT_WAV")
    MB=$((SIZE / 1024 / 1024))
    echo "Output: $OUTPUT_WAV ($MB MB)"
    
    # Check audio levels with python
    python3 -c "
import wave, struct, math
w = wave.open('$OUTPUT_WAV', 'r')
n = w.getnframes()
ch = w.getnchannels()
sr = w.getframerate()
sw = w.getsampwidth()
dur = n / sr
if sw == 2:
    data = struct.unpack('<' + 'h' * min(n*ch, 44100*ch*10), w.readframes(min(n, 44100*10)))
    rms = math.sqrt(sum(s**2 for s in data) / len(data))
    peak = max(abs(s) for s in data)
    print(f'Duration: {dur:.1f}s')
    print(f'RMS: {rms:.1f} / 32768')
    print(f'Peak: {peak} / 32768')
    if peak > 100:
        print('AUDIO DETECTED!')
    else:
        print('SILENCE (still no audio)')
w.close()
" 2>&1
    
    # Convert to FLAC if sox is available
    if command -v sox &>/dev/null; then
        sox "$OUTPUT_WAV" "$OUTPUT_FLAC" 2>/dev/null && echo "FLAC: $OUTPUT_FLAC" || true
    fi
else
    echo "ERROR: No output file created"
fi

# Cleanup Sonic Pi
pkill -9 -f "scsynth" 2>/dev/null || true
pkill -9 -f "sonic-pi" 2>/dev/null || true
pkill -9 -f "beam.smp.*pi_server" 2>/dev/null || true
pkill -9 -f "m2o" 2>/dev/null || true
pkill -9 -f "o2m" 2>/dev/null || true

echo "=== DONE ==="
