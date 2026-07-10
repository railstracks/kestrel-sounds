#!/bin/bash
# test_audio.sh — Quick test of SuperCollider audio capture
set -e

export QT_QPA_PLATFORM=offscreen

# Kill old processes
pkill -9 -f "daemon.rb" 2>/dev/null || true
sleep 2
pkill -9 -f "scsynth -u" 2>/dev/null || true
sleep 2

# Boot daemon
/usr/bin/ruby /home/melvin/Development/sonic-pi/app/server/ruby/bin/daemon.rb > /tmp/sp_test.log 2>&1 &
DPID=$!
echo "Daemon PID: $DPID"
sleep 20

if ! kill -0 $DPID 2>/dev/null; then
    echo "DAEMON DIED!"
    tail -20 /tmp/sp_test.log
    exit 1
fi
echo "Daemon alive"

# Get spider port
PORT_LINE=$(head -5 /tmp/sp_test.log | grep -m1 '^[0-9]')
if [ -n "$PORT_LINE" ]; then
    SPPORT=$(echo "$PORT_LINE" | awk '{print $2}')
else
    SPPORT=4557
fi
echo "Spider port: $SPPORT"

# Check what pw-link sees
echo "=== pw-link ==="
pw-link -l 2>/dev/null | head -20

# Try recording with pw-record targeting SuperCollider
echo "=== pw-record test ==="
timeout 15 pw-record --target SuperCollider /tmp/pw_test.wav 2>&1 &
RPID=$!
sleep 2

# Send test note
/usr/bin/ruby -e "
require 'socket'
def pad4(s); s + (\"\x00\" * ((4 - s.length % 4) % 4)); end
msg = pad4(\"/run-code\x00\")
msg += pad4(\",is\x00\")
msg += [0].pack(\"N\")
code = 'use_bpm 72; use_external_synths true; use_synth :kestrel_wraith; play 52, attack: 0.3, release: 3, amp: 0.4, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35'
msg += pad4(code + \"\x00\")
sock = UDPSocket.new
sock.connect('127.0.0.1', ${SPPORT})
sock.send(msg, 0)
sock.close
puts 'Test note sent'
"
echo "Note sent, waiting..."
sleep 10

kill $RPID 2>/dev/null || true
wait $RPID 2>/dev/null || true

echo "=== Results ==="
ls -la /tmp/pw_test.wav 2>/dev/null || echo "no file"
/usr/bin/python3 -c "
import wave, struct, math
try:
    w = wave.open('/tmp/pw_test.wav', 'r')
    n = w.getnframes()
    if n == 0:
        print('Empty file')
        exit()
    data = struct.unpack('<' + 'h' * min(n * w.getnchannels(), 44100*2*10), w.readframes(min(n, 44100*10)))
    peak = max(abs(s) for s in data)
    rms = math.sqrt(sum(s**2 for s in data) / len(data))
    print(f'Frames: {n}, Peak: {peak}, RMS: {rms:.1f}')
    if peak > 100:
        print('AUDIO DETECTED!')
    else:
        print('silence')
    w.close()
except Exception as e:
    print(f'Error: {e}')
"

# Also try parec from HDMI monitor
echo "=== parec HDMI test ==="
parec --device=alsa_output.pci-0000_01_00.1.hdmi-stereo.monitor --file-format=wav /tmp/parec_test.wav 2>/dev/null &
RPID2=$!
sleep 2

/usr/bin/ruby -e "
require 'socket'
def pad4(s); s + (\"\x00\" * ((4 - s.length % 4) % 4)); end
msg = pad4(\"/run-code\x00\")
msg += pad4(\",is\x00\")
msg += [0].pack(\"N\")
code = 'use_bpm 72; use_external_synths true; use_synth :kestrel_wraith; play 55, attack: 0.3, release: 3, amp: 0.4, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35'
msg += pad4(code + \"\x00\")
sock = UDPSocket.new
sock.connect('127.0.0.1', ${SPPORT})
sock.send(msg, 0)
sock.close
puts 'Test note 2 sent'
"
sleep 8

kill -INT $RPID2 2>/dev/null || true
wait $RPID2 2>/dev/null || true

echo "=== parec results ==="
ls -la /tmp/parec_test.wav 2>/dev/null || echo "no file"
/usr/bin/python3 -c "
import wave, struct, math
try:
    w = wave.open('/tmp/parec_test.wav', 'r')
    n = w.getnframes()
    if n == 0:
        print('Empty file')
        exit()
    data = struct.unpack('<' + 'h' * min(n * w.getnchannels(), 44100*2*10), w.readframes(min(n, 44100*10)))
    peak = max(abs(s) for s in data)
    rms = math.sqrt(sum(s**2 for s in data) / len(data))
    print(f'Frames: {n}, Peak: {peak}, RMS: {rms:.1f}')
    if peak > 100:
        print('AUDIO DETECTED!')
    else:
        print('silence')
    w.close()
except Exception as e:
    print(f'Error: {e}')
"

# Cleanup
kill $DPID 2>/dev/null || true
sleep 2
pkill -9 -f "scsynth -u" 2>/dev/null || true
echo "=== DONE ==="