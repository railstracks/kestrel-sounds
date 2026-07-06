#!/usr/bin/env python3
"""
Renderer for Study 14 (Interaction) — segment-splitting approach.
Each segment is sent as a separate /run-code call timed to BPM.
No single segment exceeds ~14s of sleep time.

Usage: python3 render_interaction.py <output.wav> <total_duration>
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

OUTFILE = sys.argv[1] if len(sys.argv) > 1 else "/tmp/interaction_study14.wav"
DURATION = int(sys.argv[2]) if len(sys.argv) > 2 else 160

# Read the piece and split into segments by marker comments
piece_path = os.path.join(os.path.dirname(__file__), "14_interaction.rb")
with open(piece_path) as f:
    piece_code = f.read()

# Split by "# Segment" markers — each segment is a self-contained code block
# We'll define segments manually for precise control
# Each segment: (code, beats_at_72bpm)
# 72 BPM = 0.8333s/beat

SEGMENTS = [
    # Segment 1A: Motif A alone (16 beats)
    ("""use_bpm 72
use_external_synths true
use_synth :kestrel_wraith
play :e3, attack: 0.5, release: 3.0, amp: 0.4, cutoff: 75, detune: 10, noise_mix: 0.06, res: 0.4, pan: -0.4
sleep 4
play :g3, attack: 0.5, release: 3.0, amp: 0.38, cutoff: 78, detune: 8, noise_mix: 0.05, res: 0.35, pan: -0.4
sleep 4
play :a3, attack: 0.5, release: 3.0, amp: 0.36, cutoff: 80, detune: 12, noise_mix: 0.07, res: 0.4, pan: -0.4
sleep 4
play :b3, attack: 0.5, release: 3.5, amp: 0.35, cutoff: 82, detune: 10, noise_mix: 0.06, res: 0.45, pan: -0.4
sleep 4
""", 16),

    # Segment 1B: Motif B alone (16 beats)
    ("""use_bpm 72
use_external_synths true
use_synth :kestrel_glass
play :f3, attack: 0.01, release: 3.0, amp: 0.5, mod_ratio: 2.0, mod_index: 4, shimmer: 0.2, pan: 0.4
sleep 4
play :a3, attack: 0.01, release: 3.0, amp: 0.5, mod_ratio: 3.01, mod_index: 3, shimmer: 0.15, pan: 0.4
sleep 4
play :b3, attack: 0.01, release: 3.0, amp: 0.5, mod_ratio: 2.0, mod_index: 5, shimmer: 0.25, pan: 0.4
sleep 4
play :c4, attack: 0.01, release: 3.5, amp: 0.45, mod_ratio: 3.0, mod_index: 3, shimmer: 0.2, pan: 0.4
sleep 4
""", 16),

    # Segment 1C: Both motifs simultaneously (16 beats)
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_wraith
  play :e3, attack: 0.5, release: 3.0, amp: 0.35, cutoff: 75, detune: 10, noise_mix: 0.06, res: 0.4, pan: -0.4
  sleep 4
  play :g3, attack: 0.5, release: 3.0, amp: 0.33, cutoff: 78, detune: 8, noise_mix: 0.05, res: 0.35, pan: -0.4
  sleep 4
  play :a3, attack: 0.5, release: 3.0, amp: 0.32, cutoff: 80, detune: 12, noise_mix: 0.07, res: 0.4, pan: -0.4
  sleep 4
  play :d4, attack: 0.5, release: 3.5, amp: 0.3, cutoff: 82, detune: 10, noise_mix: 0.06, res: 0.45, pan: -0.4
  sleep 4
end
use_synth :kestrel_glass
play :f3, attack: 0.01, release: 3.0, amp: 0.45, mod_ratio: 2.0, mod_index: 4, shimmer: 0.2, pan: 0.4
sleep 4
play :a3, attack: 0.01, release: 3.0, amp: 0.45, mod_ratio: 3.01, mod_index: 3, shimmer: 0.15, pan: 0.4
sleep 4
play :b3, attack: 0.01, release: 3.0, amp: 0.45, mod_ratio: 2.0, mod_index: 5, shimmer: 0.25, pan: 0.4
sleep 4
play :e4, attack: 0.01, release: 3.5, amp: 0.4, mod_ratio: 3.0, mod_index: 3, shimmer: 0.2, pan: 0.4
sleep 4
""", 16),

    # Segment 2A: Exchange Round 1 (8 beats)
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_wraith
  play :f3, attack: 0.5, release: 2.5, amp: 0.35, cutoff: 76, detune: 10, noise_mix: 0.06, res: 0.4, pan: -0.3
  sleep 2
  play :g3, attack: 0.5, release: 2.5, amp: 0.33, cutoff: 78, detune: 8, noise_mix: 0.05, res: 0.35, pan: -0.3
  sleep 2
  play :a3, attack: 0.5, release: 2.5, amp: 0.32, cutoff: 80, detune: 12, noise_mix: 0.07, res: 0.4, pan: -0.3
  sleep 2
  play :b3, attack: 0.5, release: 3.0, amp: 0.3, cutoff: 82, detune: 10, noise_mix: 0.06, res: 0.45, pan: -0.3
  sleep 2
end
use_synth :kestrel_glass
play :e3, attack: 0.01, release: 2.5, amp: 0.45, mod_ratio: 2.0, mod_index: 4, shimmer: 0.2, pan: 0.3
sleep 2
play :a3, attack: 0.01, release: 2.5, amp: 0.45, mod_ratio: 3.01, mod_index: 3, shimmer: 0.15, pan: 0.3
sleep 2
play :b3, attack: 0.01, release: 2.5, amp: 0.45, mod_ratio: 2.0, mod_index: 5, shimmer: 0.25, pan: 0.3
sleep 2
play :c4, attack: 0.01, release: 3.0, amp: 0.4, mod_ratio: 3.0, mod_index: 3, shimmer: 0.2, pan: 0.3
sleep 2
""", 8),

    # Segment 2B: Exchange Round 2 (8 beats)
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_wraith
  play :f3, attack: 0.5, release: 2.5, amp: 0.35, cutoff: 76, detune: 10, noise_mix: 0.06, res: 0.4, pan: -0.3
  sleep 2
  play :c4, attack: 0.5, release: 2.5, amp: 0.33, cutoff: 80, detune: 8, noise_mix: 0.05, res: 0.35, pan: -0.3
  sleep 2
  play :a3, attack: 0.5, release: 2.5, amp: 0.32, cutoff: 80, detune: 12, noise_mix: 0.07, res: 0.4, pan: -0.3
  sleep 2
  play :b3, attack: 0.5, release: 3.0, amp: 0.3, cutoff: 82, detune: 10, noise_mix: 0.06, res: 0.45, pan: -0.3
  sleep 2
end
use_synth :kestrel_glass
play :e3, attack: 0.01, release: 2.5, amp: 0.45, mod_ratio: 2.0, mod_index: 4, shimmer: 0.2, pan: 0.3
sleep 2
play :g3, attack: 0.01, release: 2.5, amp: 0.45, mod_ratio: 3.01, mod_index: 3, shimmer: 0.15, pan: 0.3
sleep 2
play :b3, attack: 0.01, release: 2.5, amp: 0.45, mod_ratio: 2.0, mod_index: 5, shimmer: 0.25, pan: 0.3
sleep 2
play :c4, attack: 0.01, release: 3.0, amp: 0.4, mod_ratio: 3.0, mod_index: 3, shimmer: 0.2, pan: 0.3
sleep 2
""", 8),

    # Segment 2C: Exchange Round 3 (8 beats)
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_wraith
  play :f3, attack: 0.5, release: 2.5, amp: 0.35, cutoff: 76, detune: 10, noise_mix: 0.06, res: 0.4, pan: -0.3
  sleep 2
  play :c4, attack: 0.5, release: 2.5, amp: 0.33, cutoff: 80, detune: 8, noise_mix: 0.05, res: 0.35, pan: -0.3
  sleep 2
  play :a3, attack: 0.5, release: 2.5, amp: 0.32, cutoff: 80, detune: 12, noise_mix: 0.07, res: 0.4, pan: -0.3
  sleep 2
  play :e4, attack: 0.5, release: 3.0, amp: 0.3, cutoff: 82, detune: 10, noise_mix: 0.06, res: 0.45, pan: -0.3
  sleep 2
end
use_synth :kestrel_glass
play :e3, attack: 0.01, release: 2.5, amp: 0.45, mod_ratio: 2.0, mod_index: 4, shimmer: 0.2, pan: 0.3
sleep 2
play :g3, attack: 0.01, release: 2.5, amp: 0.45, mod_ratio: 3.01, mod_index: 3, shimmer: 0.15, pan: 0.3
sleep 2
play :b3, attack: 0.01, release: 2.5, amp: 0.45, mod_ratio: 2.0, mod_index: 5, shimmer: 0.25, pan: 0.3
sleep 2
play :d4, attack: 0.01, release: 3.0, amp: 0.4, mod_ratio: 3.0, mod_index: 3, shimmer: 0.2, pan: 0.3
sleep 2
""", 8),

    # Segment 2D: Exchange Round 4 + dust (8 beats)
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_dust
  play :a3, attack: 1.0, release: 5.0, amp: 0.5, density: 30, rq: 0.02, grain_size: 0.08, pan: 0
  sleep 8
end
in_thread do
  use_synth :kestrel_wraith
  play :f3, attack: 0.5, release: 2.5, amp: 0.32, cutoff: 76, detune: 10, noise_mix: 0.08, res: 0.4, pan: -0.3
  sleep 2
  play :c4, attack: 0.5, release: 2.5, amp: 0.3, cutoff: 80, detune: 8, noise_mix: 0.05, res: 0.35, pan: -0.3
  sleep 2
  play :e4, attack: 0.5, release: 2.5, amp: 0.28, cutoff: 82, detune: 12, noise_mix: 0.07, res: 0.4, pan: -0.3
  sleep 2
  play :a3, attack: 0.5, release: 3.0, amp: 0.26, cutoff: 78, detune: 10, noise_mix: 0.06, res: 0.45, pan: -0.3
  sleep 2
end
use_synth :kestrel_glass
play :e3, attack: 0.01, release: 2.5, amp: 0.4, mod_ratio: 2.0, mod_index: 4, shimmer: 0.2, pan: 0.3
sleep 2
play :g3, attack: 0.01, release: 2.5, amp: 0.4, mod_ratio: 3.01, mod_index: 3, shimmer: 0.15, pan: 0.3
sleep 2
play :b3, attack: 0.01, release: 2.5, amp: 0.4, mod_ratio: 2.0, mod_index: 5, shimmer: 0.25, pan: 0.3
sleep 2
play :d4, attack: 0.01, release: 3.0, amp: 0.35, mod_ratio: 3.0, mod_index: 3, shimmer: 0.2, pan: 0.3
sleep 2
""", 8),

    # Segment 2E: Exchange Round 5 — full swap + dust dissipating (8 beats)
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_dust
  play :b3, attack: 0.5, release: 4.0, amp: 0.3, density: 15, rq: 0.03, grain_size: 0.1, pan: 0
  sleep 8
end
in_thread do
  use_synth :kestrel_wraith
  play :f3, attack: 0.5, release: 2.5, amp: 0.3, cutoff: 76, detune: 10, noise_mix: 0.06, res: 0.4, pan: -0.3
  sleep 2
  play :c4, attack: 0.5, release: 2.5, amp: 0.28, cutoff: 80, detune: 8, noise_mix: 0.05, res: 0.35, pan: -0.3
  sleep 2
  play :a3, attack: 0.5, release: 2.5, amp: 0.27, cutoff: 80, detune: 12, noise_mix: 0.07, res: 0.4, pan: -0.3
  sleep 2
  play :e4, attack: 0.5, release: 3.0, amp: 0.25, cutoff: 82, detune: 10, noise_mix: 0.06, res: 0.45, pan: -0.3
  sleep 2
end
use_synth :kestrel_glass
play :e3, attack: 0.01, release: 2.5, amp: 0.4, mod_ratio: 2.0, mod_index: 4, shimmer: 0.2, pan: 0.3
sleep 2
play :g3, attack: 0.01, release: 2.5, amp: 0.4, mod_ratio: 3.01, mod_index: 3, shimmer: 0.15, pan: 0.3
sleep 2
play :b3, attack: 0.01, release: 2.5, amp: 0.4, mod_ratio: 2.0, mod_index: 5, shimmer: 0.25, pan: 0.3
sleep 2
play :d4, attack: 0.01, release: 3.0, amp: 0.35, mod_ratio: 3.0, mod_index: 3, shimmer: 0.2, pan: 0.3
sleep 2
""", 8),

    # Segment 3A: Fusion part 1 — ember (16 beats)
    ("""use_bpm 72
use_external_synths true
use_synth :kestrel_ember
play :e3, attack: 0.3, release: 3.0, amp: 0.35, cutoff: 70, sub: 0.4, detune: 5, warmth: 0.4, pan: -0.1
sleep 4
play :a3, attack: 0.3, release: 3.0, amp: 0.33, cutoff: 72, sub: 0.35, detune: 4, warmth: 0.35, pan: 0.1
sleep 4
play :f3, attack: 0.3, release: 3.0, amp: 0.32, cutoff: 68, sub: 0.4, detune: 6, warmth: 0.4, pan: -0.05
sleep 4
play :b3, attack: 0.3, release: 3.5, amp: 0.3, cutoff: 74, sub: 0.3, detune: 4, warmth: 0.35, pan: 0.05
sleep 4
""", 16),

    # Segment 3B: Fusion part 2 — ember + glass upper partials (16 beats)
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_glass
  play :a4, attack: 0.01, release: 3.0, amp: 0.25, mod_ratio: 2.0, mod_index: 3, shimmer: 0.15, pan: 0.2
  sleep 4
  play :c5, attack: 0.01, release: 3.0, amp: 0.22, mod_ratio: 3.01, mod_index: 2, shimmer: 0.1, pan: 0.2
  sleep 4
  play :b4, attack: 0.01, release: 3.0, amp: 0.2, mod_ratio: 2.0, mod_index: 4, shimmer: 0.2, pan: 0.2
  sleep 4
  play :e5, attack: 0.01, release: 3.5, amp: 0.18, mod_ratio: 3.0, mod_index: 2, shimmer: 0.15, pan: 0.2
  sleep 4
end
use_synth :kestrel_ember
play :g3, attack: 0.3, release: 3.0, amp: 0.3, cutoff: 70, sub: 0.35, detune: 5, warmth: 0.35, pan: 0
sleep 4
play :c4, attack: 0.3, release: 3.0, amp: 0.28, cutoff: 72, sub: 0.3, detune: 4, warmth: 0.3, pan: 0.05
sleep 4
play :d4, attack: 0.3, release: 3.0, amp: 0.27, cutoff: 74, sub: 0.25, detune: 6, warmth: 0.3, pan: -0.05
sleep 4
play :a3, attack: 0.3, release: 4.0, amp: 0.25, cutoff: 68, sub: 0.4, detune: 5, warmth: 0.4, pan: 0
sleep 4
""", 16),

    # Segment 3C: Hybrid dissolves into dust (8 beats)
    ("""use_bpm 72
use_external_synths true
use_synth :kestrel_dust
play :a3, attack: 0.5, release: 3.0, amp: 0.4, density: 20, rq: 0.02, grain_size: 0.08, pan: 0
sleep 2
play :b3, attack: 0.5, release: 3.0, amp: 0.35, density: 25, rq: 0.025, grain_size: 0.06, pan: 0
sleep 2
play :c4, attack: 0.5, release: 4.0, amp: 0.3, density: 15, rq: 0.03, grain_size: 0.1, pan: 0
sleep 4
""", 8),

    # Segment 4A: A returns altered (16 beats)
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_glass
  play :f4, attack: 0.01, release: 4.0, amp: 0.15, mod_ratio: 2.0, mod_index: 3, shimmer: 0.3, pan: 0.15
  sleep 4
  play :f4, attack: 0.01, release: 3.0, amp: 0.12, mod_ratio: 3.0, mod_index: 2, shimmer: 0.2, pan: 0.15
  sleep 4
  play :c5, attack: 0.01, release: 3.0, amp: 0.1, mod_ratio: 2.0, mod_index: 4, shimmer: 0.25, pan: 0.15
  sleep 4
  play :f4, attack: 0.01, release: 5.0, amp: 0.08, mod_ratio: 3.01, mod_index: 2, shimmer: 0.35, pan: 0.15
  sleep 4
end
use_synth :kestrel_wraith
play :f3, attack: 0.5, release: 3.0, amp: 0.35, cutoff: 75, detune: 10, noise_mix: 0.06, res: 0.4, pan: -0.4
sleep 4
play :g3, attack: 0.5, release: 3.0, amp: 0.33, cutoff: 78, detune: 8, noise_mix: 0.05, res: 0.35, pan: -0.4
sleep 4
play :a3, attack: 0.5, release: 3.0, amp: 0.32, cutoff: 80, detune: 12, noise_mix: 0.07, res: 0.4, pan: -0.4
sleep 4
play :b3, attack: 0.5, release: 3.5, amp: 0.3, cutoff: 82, detune: 10, noise_mix: 0.06, res: 0.45, pan: -0.4
sleep 4
""", 16),

    # Segment 4B: B returns altered (16 beats)
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_wraith
  play :e3, attack: 0.8, release: 4.0, amp: 0.15, cutoff: 72, detune: 14, noise_mix: 0.1, res: 0.5, pan: -0.15
  sleep 4
  play :e3, attack: 0.8, release: 3.0, amp: 0.12, cutoff: 74, detune: 12, noise_mix: 0.08, res: 0.45, pan: -0.15
  sleep 4
  play :b3, attack: 0.8, release: 3.0, amp: 0.1, cutoff: 76, detune: 10, noise_mix: 0.06, res: 0.4, pan: -0.15
  sleep 4
  play :e3, attack: 1.0, release: 5.0, amp: 0.08, cutoff: 70, detune: 16, noise_mix: 0.12, res: 0.55, pan: -0.15
  sleep 4
end
use_synth :kestrel_glass
play :e3, attack: 0.01, release: 3.0, amp: 0.5, mod_ratio: 2.0, mod_index: 4, shimmer: 0.3, pan: 0.4
sleep 4
play :a3, attack: 0.01, release: 3.0, amp: 0.5, mod_ratio: 3.01, mod_index: 3, shimmer: 0.2, pan: 0.4
sleep 4
play :b3, attack: 0.01, release: 3.0, amp: 0.5, mod_ratio: 2.0, mod_index: 5, shimmer: 0.25, pan: 0.4
sleep 4
play :e4, attack: 0.01, release: 4.0, amp: 0.45, mod_ratio: 3.0, mod_index: 3, shimmer: 0.35, pan: 0.4
sleep 4
""", 16),

    # Coda: both final notes + dust settle (8 beats)
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_wraith
  play :f3, attack: 1.0, release: 5.0, amp: 0.25, cutoff: 72, detune: 10, noise_mix: 0.08, res: 0.5, pan: -0.3
  sleep 8
end
use_synth :kestrel_glass
play :e3, attack: 0.01, release: 5.0, amp: 0.35, mod_ratio: 2.0, mod_index: 4, shimmer: 0.4, pan: 0.3
sleep 4
use_synth :kestrel_dust
play :e3, attack: 0.5, release: 4.0, amp: 0.2, density: 8, rq: 0.04, grain_size: 0.15, pan: 0
sleep 4
""", 8),
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
beat_dur = 60.0 / bpm  # 0.8333s per beat

total_beats = sum(b for _, b in SEGMENTS)
total_dur = total_beats * beat_dur
print(f"Total: {len(SEGMENTS)} segments, {total_beats} beats, ~{total_dur:.1f}s", flush=True)

for i, (code, beats) in enumerate(SEGMENTS):
    sock.sendto(osc("/run-code", [token, code]), ("127.0.0.1", sport))
    sleep_dur = beats * beat_dur
    print(f"Segment {i+1}/{len(SEGMENTS)}: {len(code)} bytes, {beats} beats, {sleep_dur:.1f}s", flush=True)
    time.sleep(sleep_dur)

# Stop all and record tail
sock.sendto(osc("/stop-all-jobs", [token]), ("127.0.0.1", sport))
time.sleep(4)
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