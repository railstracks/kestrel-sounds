#!/bin/bash
# Diagnostic: check Sonic Pi audio routing
pkill -9 -f "scsynth" 2>/dev/null || true
pkill -9 -f "sonic-pi" 2>/dev/null || true
pkill -9 -f "beam.smp" 2>/dev/null || true
pkill -9 -f "m2o\|o2m" 2>/dev/null || true
pkill -9 -f "parec" 2>/dev/null || true
sleep 3

# Clean null sinks
for sid in $(pactl list short sinks 2>/dev/null | grep sonic_pi_render | awk '{print $1}'); do
    pactl unload-module $sid 2>/dev/null || true
done
sleep 1

# Create fresh sink
pactl load-module module-null-sink sink_name=sonic_pi_render sink_properties="device.description='Sonic Pi Render'" 2>/dev/null
sleep 1
echo "=== SINKS ==="
pactl list short sinks | grep sonic_pi_render

# Boot Sonic Pi
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export GEM_PATH=""
export GEM_HOME=""
export PULSE_SINK="sonic_pi_render"

QT_QPA_PLATFORM=offscreen /usr/bin/ruby /usr/lib/sonic-pi/app/server/ruby/bin/sonic-pi-server.rb > /tmp/sp_diag.log 2>&1 &
SP_PID=$!
echo "SP PID: $SP_PID"
sleep 25

if ! kill -0 $SP_PID 2>/dev/null; then
    echo "SERVER DIED"
    tail -30 /tmp/sp_diag.log
    exit 1
fi
echo "Server alive"

echo "=== ALL JACK PORTS ==="
jack_lsp 2>&1

echo ""
echo "=== JACK CONNECTIONS ==="
jack_lsp -c 2>&1 | head -40

echo ""
echo "=== RECORDING + TEST NOTE ==="
parec --device=sonic_pi_render.monitor --file-format=wav /tmp/test_routing.wav &
RPID=$!
sleep 1

# Send test note
/usr/bin/ruby -e '
require "socket"
def pad4(s); s + ("\x00" * ((4 - s.length % 4) % 4)); end
msg = pad4("/run-code\x00")
msg += pad4(",is\x00")
msg += [0].pack("N")
code = "use_synth :prophet; 4.times { play :E3, release: 2, cutoff: 80, amp: 0.4; sleep 2 }"
msg += pad4(code + "\x00")
sock = UDPSocket.new
sock.connect("127.0.0.1", 4557)
sock.send(msg, 0)
sock.close
puts "Test note sent"
'
sleep 12

kill $RPID 2>/dev/null
wait $RPID 2>/dev/null

echo "=== CHECK AUDIO ==="
python3 -c "
import wave, struct, math
try:
    w = wave.open('/tmp/test_routing.wav', 'r')
    n = w.getnframes(); ch = w.getnchannels(); sr = w.getframerate(); sw = w.getsampwidth()
    dur = n/sr
    data = struct.unpack('<' + 'h'*n*ch, w.readframes(n))
    rms = math.sqrt(sum(s**2 for s in data)/len(data))
    peak = max(abs(s) for s in data)
    print(f'Test: {dur:.1f}s, RMS={rms:.1f}, peak={peak} / 32768')
    if peak > 100: print('AUDIO DETECTED!')
    else: print('SILENCE')
    w.close()
except Exception as e:
    print(f'Error: {e}')
"

echo ""
echo "=== TRY MANUAL CONNECT ==="
# Find scsynth/supercollider ports
SC_PORTS=$(jack_lsp 2>/dev/null | grep -iE 'scsynth|SuperCollider' || true)
echo "scsynth ports: [$SC_PORTS]"
SINK_PLAY=$(jack_lsp 2>/dev/null | grep -i 'Sonic_Pi_Render.*playback' || true)
echo "sink playback: [$SINK_PLAY]"

if [ -n "$SC_PORTS" ] && [ -n "$SINK_PLAY" ]; then
    for sc in $(echo "$SC_PORTS" | grep -iE 'out|playback'); do
        for sk in $SINK_PLAY; do
            echo "connect: $sc -> $sk"
            jack_connect "$sc" "$sk" 2>&1 || echo "  failed"
        done
    done
    sleep 1
    parec --device=sonic_pi_render.monitor --file-format=wav /tmp/test_routing2.wav &
    RPID2=$!
    /usr/bin/ruby -e '
require "socket"
def pad4(s); s + ("\x00" * ((4 - s.length % 4) % 4)); end
msg = pad4("/run-code\x00"); msg += pad4(",is\x00"); msg += [0].pack("N")
msg += pad4("use_synth :prophet; play :E3, release: 2, cutoff: 80, amp: 0.4\x00")
sock = UDPSocket.new; sock.connect("127.0.0.1", 4557); sock.send(msg, 0); sock.close
'
    sleep 6
    kill $RPID2 2>/dev/null; wait $RPID2 2>/dev/null
    python3 -c "
import wave, struct, math
try:
    w = wave.open('/tmp/test_routing2.wav', 'r')
    n = w.getnframes(); ch = w.getnchannels(); sr = w.getframerate(); sw = w.getsampwidth()
    data = struct.unpack('<' + 'h'*n*ch, w.readframes(n))
    rms = math.sqrt(sum(s**2 for s in data)/len(data))
    peak = max(abs(s) for s in data)
    print(f'After connect: {n/sr:.1f}s, RMS={rms:.1f}, peak={peak} / 32768')
    if peak > 100: print('AUDIO DETECTED!'); else: print('STILL SILENT')
    w.close()
except Exception as e: print(f'Error: {e}')
"
else
    echo "Missing ports - trying pw-link"
    echo "=== pw-link list ==="
    pw-link -l 2>&1 | head -40
    echo ""
    echo "=== pw-cli nodes ==="
    pw-cli list 2>&1 | grep -iE 'scsynth|supercol|sonic|render' | head -10
fi

echo ""
echo "=== SP LOG TAIL ==="
tail -20 /tmp/sp_diag.log

# Cleanup
pkill -9 -f "scsynth" 2>/dev/null || true
pkill -9 -f "sonic-pi" 2>/dev/null || true
pkill -9 -f "beam.smp" 2>/dev/null || true

echo "=== DONE ==="
