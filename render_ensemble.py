#!/usr/bin/env python3
"""
Ensemble renderer — splits piece into timed segments.
Each segment is sent as a separate /run-code call so the spider
server doesn't time out on long pieces.

Usage: python3 render_ensemble.py <output.wav> <total_duration>
"""
import socket, struct, time, subprocess, re, os, threading, sys

def osc(path, args=[]):
    nul = chr(0).encode()
    msg = path.encode() + nul
    while len(msg) % 4: msg += nul
    t = ","
    for a in args:
        if isinstance(a, str): t += "s"
        elif isinstance(a, int): t += "i"
        elif isinstance(a, float): t += "f"
    msg += t.encode() + nul
    while len(msg) % 4: msg += nul
    for a in args:
        if isinstance(a, str):
            s = a.encode() + nul
            while len(s) % 4: s += nul
            msg += s
        elif isinstance(a, int): msg += struct.pack(">i", a)
        elif isinstance(a, float): msg += struct.pack(">f", a)
    return msg

def fix_wav(path):
    fsize = os.path.getsize(path)
    with open(path, 'r+b') as f:
        f.seek(12)
        while True:
            cid = f.read(4)
            if len(cid) < 4: break
            csize = struct.unpack('<I', f.read(4))[0]
            if cid == b'data':
                actual = fsize - f.tell()
                f.seek(f.tell() - 4)
                f.write(struct.pack('<I', actual))
                f.seek(4)
                f.write(struct.pack('<I', fsize - 8))
                return
            f.seek(csize, 1)

OUTFILE = sys.argv[1] if len(sys.argv) > 1 else "/tmp/ensemble_final.wav"
DURATION = int(sys.argv[2]) if len(sys.argv) > 2 else 90

# Segments: (code, duration_before_next_segment)
# Each segment is sent when the previous one's sleep time has elapsed.
# The spider server executes them independently — no timeout.

SEGMENTS = [
    # Part 1: Sections 1-2 (Ember + Glass solo) — ~19 beats = 16s
    ("""use_bpm 72
use_external_synths true
use_synth :kestrel_ember
play :e2, release: 6, amp: 0.4, cutoff: 65, sub: 0.4, detune: 4, warmth: 0.4
sleep 4
play :a2, release: 6, amp: 0.35, cutoff: 60, sub: 0.35, detune: 3, warmth: 0.35
sleep 4
play :b2, release: 6, amp: 0.35, cutoff: 62, sub: 0.35, detune: 5, warmth: 0.3
sleep 5
use_synth :kestrel_glass
play :b4, release: 4, amp: 0.6, mod_ratio: 2.0, mod_index: 4, shimmer: 0.2
sleep 3
play :a4, release: 4, amp: 0.6, mod_ratio: 3.01, mod_index: 3, shimmer: 0.15
sleep 3
play :g4, release: 5, amp: 0.5, mod_ratio: 2.0, mod_index: 5, shimmer: 0.25
sleep 5
""", 19),  # 19 beats = ~15.8s

    # Part 2: Sections 3-4 (Duet + Dust) — ~18 beats = 15s
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_ember
  play :e2, release: 8, amp: 0.3, cutoff: 58, sub: 0.4, detune: 6, warmth: 0.4
  play :b2, release: 8, amp: 0.25, cutoff: 60, sub: 0.3, detune: 4, warmth: 0.35
  sleep 8
end
use_synth :kestrel_glass
play :e5, release: 5, amp: 0.4, mod_ratio: 3.0, mod_index: 4, shimmer: 0.2
sleep 2.5
play :d5, release: 5, amp: 0.4, mod_ratio: 2.01, mod_index: 6, shimmer: 0.3
sleep 2.5
play :b4, release: 4, amp: 0.3, mod_ratio: 4.0, mod_index: 3, shimmer: 0.15
sleep 3
use_synth :kestrel_dust
play :e4, release: 6, amp: 0.8, density: 40, rq: 0.02, grain_size: 0.08
sleep 3
play :a4, release: 5, amp: 0.7, density: 60, rq: 0.02, grain_size: 0.05
sleep 3
play :b4, release: 5, amp: 0.6, density: 80, rq: 0.03, grain_size: 0.04
sleep 4
""", 18),  # 18 beats = 15s

    # Part 3: Section 5 (Pulse) — ~8 beats = 6.7s
    ("""use_bpm 72
use_external_synths true
use_synth :kestrel_pulse
play :e3, release: 0.3, amp: 0.12, width: 0.3, cutoff: 85, edge: 0.2, body: 0.4
sleep 0.5
play :e3, release: 0.3, amp: 0.1, width: 0.4, cutoff: 80, edge: 0.15, body: 0.35
sleep 0.5
play :g3, release: 0.3, amp: 0.12, width: 0.25, cutoff: 90, edge: 0.25, body: 0.4
sleep 0.5
play :a3, release: 0.3, amp: 0.1, width: 0.35, cutoff: 85, edge: 0.2, body: 0.35
sleep 0.5
play :b3, release: 0.4, amp: 0.12, width: 0.3, cutoff: 95, edge: 0.3, body: 0.45
sleep 1
play :e3, release: 0.3, amp: 0.1, width: 0.4, cutoff: 80, edge: 0.15, body: 0.3
sleep 0.5
play :a3, release: 0.3, amp: 0.1, width: 0.3, cutoff: 85, edge: 0.2, body: 0.35
sleep 0.5
play :b3, release: 0.5, amp: 0.12, width: 0.25, cutoff: 90, edge: 0.25, body: 0.4
sleep 2
""", 8),  # 8 beats = 6.7s

    # Part 4: Section 6 (Wraith + Ember) — ~6 beats = 5s
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_wraith
  play :e3, release: 6, amp: 0.3, cutoff: 75, detune: 10, noise_mix: 0.06, res: 0.4
  sleep 3
  play :b3, release: 5, amp: 0.25, cutoff: 80, detune: 12, noise_mix: 0.08, res: 0.5
  sleep 3
end
use_synth :kestrel_ember
play :e2, release: 7, amp: 0.4, cutoff: 62, sub: 0.4, detune: 5, warmth: 0.4
play :b2, release: 7, amp: 0.3, cutoff: 65, sub: 0.3, detune: 4, warmth: 0.35
sleep 6
""", 6),  # 6 beats = 5s

    # Part 5: Section 7 (Glass coda) — ~16 beats = 13.3s
    ("""use_bpm 72
use_external_synths true
use_synth :kestrel_glass
play :e5, release: 8, amp: 0.5, mod_ratio: 2.0, mod_index: 5, shimmer: 0.3
sleep 4
play :b4, release: 8, amp: 0.4, mod_ratio: 3.01, mod_index: 4, shimmer: 0.2
sleep 4
play :e5, release: 10, amp: 0.3, mod_ratio: 4.0, mod_index: 3, shimmer: 0.4
sleep 8
""", 16),  # 16 beats = 13.3s
]

# --- Setup ---
for p in ["beam.smp", "spider-server", "scsynth", "daemon.rb"]:
    subprocess.run(["pkill", "-9", "-f", p], capture_output=True)
time.sleep(2)

env = os.environ.copy()
env["QT_QPA_PLATFORM"] = "offscreen"
daemon = subprocess.Popen(
    ["/usr/bin/ruby", "/home/melvin/Development/sonic-pi/app/server/ruby/bin/daemon.rb"],
    env=env, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL
)
port_line = daemon.stdout.readline().decode().strip()
nums = re.findall(r"-?\d+", port_line)
dport, sport, token = int(nums[0]), int(nums[2]), int(nums[7])
print(f"daemon={dport} spider={sport}", flush=True)

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(("127.0.0.1", 0))
stop_ev = threading.Event()
def ka():
    while not stop_ev.is_set():
        sock.sendto(osc("/daemon/keep-alive", [token]), ("127.0.0.1", dport))
        time.sleep(1.5)
threading.Thread(target=ka, daemon=True).start()
time.sleep(5)

subprocess.run(["pactl", "unload-module", "module-null-sink"], capture_output=True)
time.sleep(1)
subprocess.run(["pactl", "load-module", "module-null-sink", "sink_name=kc_test"], capture_output=True)
sock.sendto(osc("/run-code", [token, "play 60, release: 0.05, amp: 0.1\n"]), ("127.0.0.1", sport))
time.sleep(3)
subprocess.run(["pw-link", "SuperCollider:out_1", "kc_test:playback_FL"], capture_output=True)
subprocess.run(["pw-link", "SuperCollider:out_2", "kc_test:playback_FR"], capture_output=True)
print("Setup done", flush=True)

# --- Render ---
rec = subprocess.Popen(["parecord", "--device=kc_test.monitor", "--file=wav", OUTFILE])
time.sleep(0.5)

bpm = 72
beat_dur = 60.0 / bpm  # 0.833s per beat

for i, (code, beats) in enumerate(SEGMENTS):
    sock.sendto(osc("/run-code", [token, code]), ("127.0.0.1", sport))
    sleep_dur = beats * beat_dur
    print(f"Part {i+1}/{len(SEGMENTS)}: sent {len(code)} bytes, sleeping {sleep_dur:.1f}s", flush=True)
    time.sleep(sleep_dur)

# Stop all and record tail
sock.sendto(osc("/stop-all-jobs", [token]), ("127.0.0.1", sport))
time.sleep(3)
rec.send_signal(2)
rec.wait(timeout=5)
print("Recording stopped", flush=True)

fix_wav(OUTFILE)

st = subprocess.run(["sox", OUTFILE, "-n", "stat"], capture_output=True, text=True)
print("\n=== STATS ===", flush=True)
for s in st.stderr.split("\n"):
    if any(k in s for k in ["Length", "Maximum amplitude", "RMS"]):
        print(f"  {s.strip()}", flush=True)

stop_ev.set()
sock.close()
daemon.terminate()
print("\nDone.", flush=True)