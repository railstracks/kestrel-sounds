#!/bin/bash
# render23.sh — Render Study 23: Cycles via multi-part OSC send
# Uses Development Sonic Pi (daemon.rb) with system Ruby
# Multi-part send: 4 parts (cycle1, cycle2, cycle3, coda) to avoid OSC size limit

set -e

RENDER_DIR="/tmp/kestrel-sounds-render"
OUTPUT_WAV="$RENDER_DIR/23_cycles.wav"
OUTPUT_FLAC="$RENDER_DIR/23_cycles.flac"
CODE_DIR="$HOME/projects/kestrel-sounds/study23_parts"
SP_ROOT="/home/melvin/Development/sonic-pi/app"
SINK_NAME="sonic_pi_render"
PORT_FILE="/tmp/sonic_pi_ports.txt"

mkdir -p "$RENDER_DIR"

echo "=== Phase 1: Full cleanup ==="
pkill -9 -f "scsynth" 2>/dev/null || true
pkill -9 -f "sonic-pi" 2>/dev/null || true
pkill -9 -f "daemon.rb" 2>/dev/null || true
pkill -9 -f "beam.smp" 2>/dev/null || true
pkill -9 -f "pi_server" 2>/dev/null || true
pkill -9 -f "m2o" 2>/dev/null || true
pkill -9 -f "o2m" 2>/dev/null || true
pkill -9 -f "parec" 2>/dev/null || true
sleep 3

# Remove old null sinks
for sink_id in $(pactl list short sinks 2>/dev/null | grep "$SINK_NAME" | awk '{print $1}'); do
    pactl unload-module "$sink_id" 2>/dev/null || true
done
pactl delete-null-sink "$SINK_NAME" 2>/dev/null || true
sleep 1

echo "=== Phase 2: Skip null sink (using pw-record directly) ==="

echo "=== Phase 3: Boot Sonic Pi (Development daemon.rb + system Ruby) ==="
export QT_QPA_PLATFORM=offscreen

SP_LOG="$RENDER_DIR/sp23.log"

# Use system Ruby which has all deps, with Development Sonic Pi daemon.rb
/usr/bin/ruby "$SP_ROOT/server/ruby/bin/daemon.rb" > "$SP_LOG" 2>&1 &
DAEMON_PID=$!
echo "Daemon PID: $DAEMON_PID"

echo "Waiting 20s for daemon boot..."
sleep 20

if ! kill -0 $DAEMON_PID 2>/dev/null; then
    echo "DAEMON DIED during boot!"
    tail -50 "$SP_LOG"
    exit 1
fi
echo "Daemon alive."

# Parse port info from daemon output
# The daemon prints a line like: 4557 4558 4556 4556 4560 4561 4563 4564 4562 <token>
PORT_LINE=$(head -5 "$SP_LOG" | grep -m1 '^[0-9]')
if [ -z "$PORT_LINE" ]; then
    # Try reading from the spider-server process cmdline
    sleep 3
    SPIDER_PID=$(pgrep -f "spider-server.rb" | head -1)
    if [ -n "$SPIDER_PID" ]; then
        SPIDER_ARGS=$(cat /proc/$SPIDER_PID/cmdline | tr '\0' ' ')
        echo "Spider args: $SPIDER_ARGS"
        SPIDER_PORT=$(echo "$SPIDER_ARGS" | awk '{print $2}')
    fi
else
    read D_GL GS SC OC T TP TOKEN <<< "$PORT_LINE"
    SPIDER_PORT=$GS
fi

# Fallback to default
SPIDER_PORT="${SPIDER_PORT:-4557}"
echo "Spider port: $SPIDER_PORT"

# Write port file for render.rb compatibility
cat > "$PORT_FILE" << EOF
SPIDER_PORT=$SPIDER_PORT
SCSYNTH_PORT=4556
TOKEN=0
SINK_NAME=$SINK_NAME
EOF

echo "=== Phase 4: Audio routing (pw-record targeting SuperCollider) ==="
# SuperCollider creates PipeWire ports automatically. We record directly from it
# using pw-record --target SuperCollider (PipeWire native, not PulseAudio).
sleep 3
pw-link -l 2>/dev/null | grep -i 'SuperCollider.*out_' | head -5
echo "Will record via: pw-record --target SuperCollider"

echo "=== Phase 5: Start recording ==="
pw-record --target SuperCollider "$OUTPUT_WAV" &
REC_PID=$!
echo "Recording PID: $REC_PID"
sleep 2

echo "=== Phase 6: Send test note ==="
/usr/bin/ruby -e '
require "socket"
def pad4(s); s + ("\x00" * ((4 - s.length % 4) % 4)); end
msg = pad4("/run-code\x00")
msg += pad4(",is\x00")
msg += [0].pack("N")
code = "use_bpm 72; use_external_synths true; use_synth :kestrel_wraith; play 52, attack: 0.3, release: 1.5, amp: 0.3, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35"
msg += pad4(code + "\x00")
sock = UDPSocket.new
sock.connect("127.0.0.1", '"$SPIDER_PORT"')
sock.send(msg, 0)
sock.close
puts "Test note sent to port '"$SPIDER_PORT"'"
'
sleep 5
TEST_SIZE=$(stat -c%s "$OUTPUT_WAV" 2>/dev/null || echo 0)
echo "Recording size after test: $TEST_SIZE bytes"

if [ "$TEST_SIZE" -lt 50000 ]; then
    echo "WARNING: Small file — audio may not be routing. Checking connections..."
    pw-link -l 2>/dev/null | grep -iE 'SuperCollider|sonic.*render' | head -20
fi

echo "=== Phase 7: Send Study 23 (multi-part) ==="

send_code() {
    local file="$1"
    local label="$2"
    /usr/bin/ruby -e '
require "socket"
def pad4(s); s + ("\x00" * ((4 - s.length % 4) % 4)); end
code = File.read(ARGV[0]).gsub(/^\s*#.*/, "").gsub(/\s+#.*$/, "")
msg = pad4("/run-code\x00")
msg += pad4(",is\x00")
msg += [0].pack("N")
msg += pad4(code + "\x00")
sock = UDPSocket.new
sock.connect("127.0.0.1", '"$SPIDER_PORT"')
sock.send(msg, 0)
sock.close
puts ARGV[1] + " sent (" + code.length.to_s + " bytes)"
' "$file" "$label"
}

echo "Sending Cycle 1..."
send_code "$CODE_DIR/cycle1.rb" "Cycle 1"
echo "Waiting for Cycle 1 (~160s)..."
sleep 160

echo "Sending Cycle 2..."
send_code "$CODE_DIR/cycle2.rb" "Cycle 2"
echo "Waiting for Cycle 2 (~155s)..."
sleep 155

echo "Sending Cycle 3..."
send_code "$CODE_DIR/cycle3.rb" "Cycle 3"
echo "Waiting for Cycle 3 (~150s)..."
sleep 150

echo "Sending Coda..."
send_code "$CODE_DIR/coda.rb" "Coda"
echo "Waiting for Coda (~35s)..."
sleep 35

echo "=== Phase 8: Stop and verify ==="
/usr/bin/ruby -e '
require "socket"
def pad4(s); s + ("\x00" * ((4 - s.length % 4) % 4)); end
msg = pad4("/stop-all-jobs\x00")
msg += pad4(",i\x00")
msg += [0].pack("N")
sock = UDPSocket.new
sock.connect("127.0.0.1", '"$SPIDER_PORT"')
sock.send(msg, 0)
sock.close
puts "Stop sent"
'
sleep 3

kill $REC_PID 2>/dev/null || true
wait $REC_PID 2>/dev/null || true

if [ -f "$OUTPUT_WAV" ]; then
    SIZE=$(stat -c%s "$OUTPUT_WAV")
    MB=$((SIZE / 1024 / 1024))
    echo "Output: $OUTPUT_WAV ($MB MB)"

    /usr/bin/python3 -c "
import wave, struct, math
w = wave.open('$OUTPUT_WAV', 'r')
n = w.getnframes()
ch = w.getnchannels()
sr = w.getframerate()
sw = w.getsampwidth()
dur = n / sr
print(f'Duration: {dur:.1f}s')
print(f'Channels: {ch}, Sample rate: {sr}, Sample width: {sw}')

max_peak = 0
sum_sq = 0
total_samples = 0
chunk_size = 44100 * ch
while True:
    frames = w.readframes(chunk_size)
    if not frames:
        break
    if sw == 2:
        data = struct.unpack('<' + 'h' * (len(frames) // 2), frames)
    elif sw == 4:
        data = struct.unpack('<' + 'i' * (len(frames) // 4), frames)
    else:
        data = struct.unpack('<' + 'b' * len(frames), frames)
    peak = max(abs(s) for s in data)
    max_peak = max(max_peak, peak)
    sum_sq += sum(s**2 for s in data)
    total_samples += len(data)

if total_samples > 0:
    rms = math.sqrt(sum_sq / total_samples)
    max_possible = (2 ** (sw * 8 - 1)) - 1
    print(f'RMS: {rms:.1f} / {max_possible} ({rms/max_possible*100:.3f}%)')
    print(f'Peak: {max_peak} / {max_possible} ({max_peak/max_possible*100:.3f}%)')
    if max_peak > 100:
        print('AUDIO DETECTED!')
    else:
        print('SILENCE - no audio routed')

    sections = [
        ('Cycle 1 (diss->baseline)', 0, 160),
        ('Cycle 2 (diss->weathered)', 160, 315),
        ('Cycle 3 (diss->saturated)', 315, 465),
        ('Coda (root aging)', 465, 510),
    ]
    for name, start_s, end_s in sections:
        start_frame = int(start_s * sr)
        end_frame = min(int(end_s * sr), n)
        if start_frame >= n:
            break
        w.setpos(start_frame)
        frames = w.readframes(end_frame - start_frame)
        if sw == 2:
            data = struct.unpack('<' + 'h' * (len(frames) // 2), frames)
        elif sw == 4:
            data = struct.unpack('<' + 'i' * (len(frames) // 4), frames)
        else:
            data = struct.unpack('<' + 'b' * len(frames), frames)
        if len(data) > 0:
            s_rms = math.sqrt(sum(s**2 for s in data) / len(data))
            s_peak = max(abs(s) for s in data)
            print(f'  {name}: RMS={s_rms/max_possible*100:.3f}% Peak={s_peak/max_possible*100:.3f}%')

w.close()
" 2>&1

    if command -v sox &>/dev/null; then
        sox "$OUTPUT_WAV" "$OUTPUT_FLAC" 2>/dev/null && echo "FLAC: $OUTPUT_FLAC ($(du -h "$OUTPUT_FLAC" | cut -f1))" || true
    elif command -v ffmpeg &>/dev/null; then
        ffmpeg -y -i "$OUTPUT_WAV" -c:a flac "$OUTPUT_FLAC" 2>/dev/null && echo "FLAC: $OUTPUT_FLAC ($(du -h "$OUTPUT_FLAC" | cut -f1))" || true
    fi
else
    echo "ERROR: No output file created"
fi

# Cleanup
kill $DAEMON_PID 2>/dev/null || true
sleep 2
pkill -9 -f "scsynth" 2>/dev/null || true
pkill -9 -f "daemon.rb" 2>/dev/null || true
pkill -9 -f "beam.smp" 2>/dev/null || true
pkill -9 -f "pi_server" 2>/dev/null || true
pkill -9 -f "m2o" 2>/dev/null || true
pkill -9 -f "o2m" 2>/dev/null || true

echo "=== DONE ==="