#!/usr/bin/env python3
"""
Complete headless renderer for Study 16 (Imitation).
Starts Sonic Pi daemon, renders segments, records to WAV, converts to FLAC.
Run ON the workstation: python3 /tmp/kestrel-sounds/render_imitation_full.py
"""
import socket, struct, time, subprocess, re, os, threading, signal, sys

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

DAEMON_RB = "/home/melvin/Development/sonic-pi/app/server/ruby/bin/daemon.rb"
SINK_NAME = "kc_imitation"
OUTFILE = "/tmp/kestrel-sounds/imitation_study16.wav"

# 72 BPM = 0.8333s/beat
BEAT_MS = 833

SEGMENTS = [
    # === Section I: Proposal (64 beats, ~53s) ===
    # 1A: A plays itself (16 beats)
    ("""use_bpm 72
use_external_synths true
use_synth :kestrel_wraith
play :e3, attack: 0.5, release: 3.0, amp: 0.4, cutoff: 75, detune: 8, noise_mix: 0.05, res: 0.4, pan: -0.4
sleep 4
play :g3, attack: 0.5, release: 3.0, amp: 0.38, cutoff: 78, detune: 8, noise_mix: 0.05, res: 0.35, pan: -0.4
sleep 4
play :a3, attack: 0.5, release: 3.0, amp: 0.36, cutoff: 80, detune: 8, noise_mix: 0.05, res: 0.4, pan: -0.4
sleep 4
play :b3, attack: 0.5, release: 3.5, amp: 0.35, cutoff: 82, detune: 8, noise_mix: 0.05, res: 0.45, pan: -0.4
sleep 4
""", 16),

    # 1B: A attempts B's notes (16 beats)
    ("""use_bpm 72
use_external_synths true
use_synth :kestrel_wraith
play :f3, attack: 0.8, release: 2.5, amp: 0.3, cutoff: 76, detune: 14, noise_mix: 0.08, res: 0.4, pan: -0.3
sleep 4
play :a3, attack: 0.8, release: 2.5, amp: 0.28, cutoff: 80, detune: 12, noise_mix: 0.07, res: 0.4, pan: -0.3
sleep 4
play :b3, attack: 0.8, release: 2.5, amp: 0.27, cutoff: 82, detune: 13, noise_mix: 0.08, res: 0.45, pan: -0.3
sleep 4
play :c4, attack: 0.8, release: 3.0, amp: 0.25, cutoff: 84, detune: 15, noise_mix: 0.1, res: 0.5, pan: -0.3
sleep 4
""", 16),

    # 1C: B plays itself (16 beats)
    ("""use_bpm 72
use_external_synths true
use_synth :kestrel_glass
play :f3, attack: 0.01, release: 3.0, amp: 0.5, mod_ratio: 2.0, mod_index: 4, shimmer: 0.2, pan: 0.4
sleep 4
play :a3, attack: 0.01, release: 3.0, amp: 0.5, mod_ratio: 3.01, mod_index: 3, shimmer: 0.15, pan: 0.4
sleep 4
play :b3, attack: 0.01, release: 3.0, amp: 0.5, mod_ratio: 2.0, mod_index: 5, shimmer: 0.25, pan: 0.4
sleep 4
play :e4, attack: 0.01, release: 3.5, amp: 0.45, mod_ratio: 3.0, mod_index: 3, shimmer: 0.2, pan: 0.4
sleep 4
""", 16),

    # 1D: B attempts A's notes (16 beats)
    ("""use_bpm 72
use_external_synths true
use_synth :kestrel_glass
play :e3, attack: 0.01, release: 2.5, amp: 0.4, mod_ratio: 2.0, mod_index: 6, shimmer: 0.35, pan: 0.3
sleep 4
play :g3, attack: 0.01, release: 2.5, amp: 0.38, mod_ratio: 3.01, mod_index: 5, shimmer: 0.3, pan: 0.3
sleep 4
play :a3, attack: 0.01, release: 2.5, amp: 0.36, mod_ratio: 2.0, mod_index: 7, shimmer: 0.35, pan: 0.3
sleep 4
play :d4, attack: 0.01, release: 3.0, amp: 0.35, mod_ratio: 3.0, mod_index: 6, shimmer: 0.4, pan: 0.3
sleep 4
""", 16),

    # === Section II: Reciprocity (64 beats, ~53s) ===
    # 2A: Round 1 (16 beats)
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_wraith
  play :e3, attack: 0.5, release: 2.5, amp: 0.35, cutoff: 76, detune: 9, noise_mix: 0.06, res: 0.4, pan: -0.35
  sleep 4
  play :g3, attack: 0.5, release: 2.5, amp: 0.33, cutoff: 79, detune: 9, noise_mix: 0.06, res: 0.35, pan: -0.35
  sleep 4
  play :a3, attack: 0.5, release: 2.5, amp: 0.32, cutoff: 81, detune: 10, noise_mix: 0.06, res: 0.4, pan: -0.3
  sleep 4
  play :c4, attack: 0.5, release: 3.0, amp: 0.3, cutoff: 83, detune: 12, noise_mix: 0.07, res: 0.45, pan: -0.3
  sleep 4
end
use_synth :kestrel_glass
play :f3, attack: 0.01, release: 2.5, amp: 0.4, mod_ratio: 2.0, mod_index: 4, shimmer: 0.22, pan: 0.35
sleep 4
play :a3, attack: 0.01, release: 2.5, amp: 0.4, mod_ratio: 3.01, mod_index: 3, shimmer: 0.18, pan: 0.35
sleep 4
play :b3, attack: 0.01, release: 2.5, amp: 0.38, mod_ratio: 2.0, mod_index: 5, shimmer: 0.25, pan: 0.3
sleep 4
play :d4, attack: 0.01, release: 3.0, amp: 0.35, mod_ratio: 3.0, mod_index: 4, shimmer: 0.28, pan: 0.3
sleep 4
""", 16),

    # 2B: Round 2 (16 beats)
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_wraith
  play :e3, attack: 0.5, release: 2.5, amp: 0.32, cutoff: 77, detune: 11, noise_mix: 0.07, res: 0.4, pan: -0.25
  sleep 4
  play :a3, attack: 0.5, release: 2.5, amp: 0.3, cutoff: 81, detune: 11, noise_mix: 0.06, res: 0.4, pan: -0.2
  sleep 4
  play :b3, attack: 0.5, release: 2.5, amp: 0.29, cutoff: 83, detune: 12, noise_mix: 0.06, res: 0.45, pan: -0.2
  sleep 4
  play :c4, attack: 0.5, release: 3.0, amp: 0.27, cutoff: 85, detune: 14, noise_mix: 0.08, res: 0.5, pan: -0.15
  sleep 4
end
use_synth :kestrel_glass
play :f3, attack: 0.01, release: 2.5, amp: 0.35, mod_ratio: 2.0, mod_index: 5, shimmer: 0.28, pan: 0.25
sleep 4
play :g3, attack: 0.01, release: 2.5, amp: 0.33, mod_ratio: 3.01, mod_index: 4, shimmer: 0.25, pan: 0.2
sleep 4
play :b3, attack: 0.01, release: 2.5, amp: 0.32, mod_ratio: 2.0, mod_index: 6, shimmer: 0.3, pan: 0.2
sleep 4
play :d4, attack: 0.01, release: 3.0, amp: 0.3, mod_ratio: 3.0, mod_index: 5, shimmer: 0.32, pan: 0.15
sleep 4
""", 16),

    # 2C: Round 3 (16 beats)
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_wraith
  play :f3, attack: 0.5, release: 2.5, amp: 0.28, cutoff: 79, detune: 13, noise_mix: 0.08, res: 0.4, pan: -0.15
  sleep 4
  play :a3, attack: 0.5, release: 2.5, amp: 0.27, cutoff: 81, detune: 14, noise_mix: 0.07, res: 0.4, pan: -0.1
  sleep 4
  play :b3, attack: 0.5, release: 2.5, amp: 0.26, cutoff: 83, detune: 14, noise_mix: 0.07, res: 0.45, pan: -0.1
  sleep 4
  play :e4, attack: 0.5, release: 3.0, amp: 0.24, cutoff: 85, detune: 16, noise_mix: 0.09, res: 0.5, pan: -0.05
  sleep 4
end
use_synth :kestrel_glass
play :e3, attack: 0.01, release: 2.5, amp: 0.3, mod_ratio: 2.0, mod_index: 6, shimmer: 0.35, pan: 0.15
sleep 4
play :g3, attack: 0.01, release: 2.5, amp: 0.28, mod_ratio: 3.01, mod_index: 5, shimmer: 0.32, pan: 0.1
sleep 4
play :a3, attack: 0.01, release: 2.5, amp: 0.27, mod_ratio: 2.0, mod_index: 7, shimmer: 0.35, pan: 0.1
sleep 4
play :d4, attack: 0.01, release: 3.0, amp: 0.25, mod_ratio: 3.0, mod_index: 6, shimmer: 0.38, pan: 0.05
sleep 4
""", 16),

    # 2D: Round 4 — same notes, dust enters, voices converging (16 beats)
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_dust
  play :a3, attack: 1.0, release: 6.0, amp: 0.25, density: 12, rq: 0.03, grain_size: 0.1, pan: 0
  sleep 16
end
in_thread do
  use_synth :kestrel_wraith
  play :a3, attack: 0.5, release: 2.5, amp: 0.22, cutoff: 82, detune: 16, noise_mix: 0.1, res: 0.45, pan: -0.05
  sleep 4
  play :b3, attack: 0.5, release: 2.5, amp: 0.21, cutoff: 84, detune: 17, noise_mix: 0.1, res: 0.45, pan: -0.03
  sleep 4
  play :c4, attack: 0.5, release: 2.5, amp: 0.2, cutoff: 86, detune: 18, noise_mix: 0.11, res: 0.5, pan: -0.02
  sleep 4
  play :d4, attack: 0.5, release: 3.0, amp: 0.18, cutoff: 88, detune: 18, noise_mix: 0.12, res: 0.5, pan: 0
  sleep 4
end
use_synth :kestrel_glass
play :a3, attack: 0.01, release: 2.5, amp: 0.22, mod_ratio: 2.0, mod_index: 7, shimmer: 0.38, pan: 0.05
sleep 4
play :b3, attack: 0.01, release: 2.5, amp: 0.21, mod_ratio: 3.01, mod_index: 6, shimmer: 0.4, pan: 0.03
sleep 4
play :c4, attack: 0.01, release: 2.5, amp: 0.2, mod_ratio: 2.0, mod_index: 8, shimmer: 0.4, pan: 0.02
sleep 4
play :d4, attack: 0.01, release: 3.0, amp: 0.18, mod_ratio: 3.0, mod_index: 7, shimmer: 0.42, pan: 0
sleep 4
""", 16),

    # === Section III: Convergence (48 beats, ~40s) ===
    # 3A: A on wraith, warming (16 beats)
    ("""use_bpm 72
use_external_synths true
use_synth :kestrel_wraith
play :a3, attack: 0.8, release: 3.5, amp: 0.25, cutoff: 78, detune: 14, noise_mix: 0.08, res: 0.4, pan: -0.05
sleep 4
play :b3, attack: 0.8, release: 3.5, amp: 0.23, cutoff: 80, detune: 13, noise_mix: 0.07, res: 0.4, pan: -0.03
sleep 4
play :c4, attack: 0.8, release: 3.5, amp: 0.22, cutoff: 82, detune: 12, noise_mix: 0.07, res: 0.4, pan: -0.02
sleep 4
play :d4, attack: 0.8, release: 4.0, amp: 0.2, cutoff: 84, detune: 11, noise_mix: 0.06, res: 0.45, pan: 0
sleep 4
""", 16),

    # 3B: B on glass, warming (16 beats)
    ("""use_bpm 72
use_external_synths true
use_synth :kestrel_glass
play :a3, attack: 0.01, release: 3.5, amp: 0.25, mod_ratio: 2.0, mod_index: 5, shimmer: 0.3, pan: 0.05
sleep 4
play :b3, attack: 0.01, release: 3.5, amp: 0.23, mod_ratio: 3.01, mod_index: 4, shimmer: 0.25, pan: 0.03
sleep 4
play :c4, attack: 0.01, release: 3.5, amp: 0.22, mod_ratio: 2.0, mod_index: 5, shimmer: 0.22, pan: 0.02
sleep 4
play :d4, attack: 0.01, release: 4.0, amp: 0.2, mod_ratio: 3.0, mod_index: 4, shimmer: 0.2, pan: 0
sleep 4
""", 16),

    # 3C: Both on ember — convergence moment (16 beats)
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_ember
  play :a3, attack: 0.5, release: 3.5, amp: 0.22, cutoff: 72, sub: 0.4, detune: 8, warmth: 0.4, pan: -0.02
  sleep 4
  play :b3, attack: 0.5, release: 3.5, amp: 0.2, cutoff: 74, sub: 0.35, detune: 7, warmth: 0.35, pan: -0.01
  sleep 4
  play :c4, attack: 0.5, release: 3.5, amp: 0.18, cutoff: 76, sub: 0.3, detune: 6, warmth: 0.3, pan: 0.01
  sleep 4
  play :e4, attack: 0.5, release: 4.0, amp: 0.16, cutoff: 78, sub: 0.25, detune: 5, warmth: 0.25, pan: 0.02
  sleep 4
end
use_synth :kestrel_ember
play :a3, attack: 0.5, release: 3.5, amp: 0.22, cutoff: 72, sub: 0.4, detune: 8, warmth: 0.4, pan: 0.02
sleep 4
play :b3, attack: 0.5, release: 3.5, amp: 0.2, cutoff: 74, sub: 0.35, detune: 7, warmth: 0.35, pan: 0.01
sleep 4
play :c4, attack: 0.5, release: 3.5, amp: 0.18, cutoff: 76, sub: 0.3, detune: 6, warmth: 0.3, pan: -0.01
sleep 4
play :e4, attack: 0.5, release: 4.0, amp: 0.16, cutoff: 78, sub: 0.25, detune: 5, warmth: 0.25, pan: -0.02
sleep 4
""", 16),

    # === Section IV: Loss (48 beats, ~40s) ===
    # 4A: Shared voice degrading (16 beats)
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_dust
  play :b3, attack: 1.0, release: 6.0, amp: 0.15, density: 8, rq: 0.04, grain_size: 0.12, pan: 0
  sleep 16
end
in_thread do
  use_synth :kestrel_ember
  play :a3, attack: 0.5, release: 3.0, amp: 0.18, cutoff: 74, sub: 0.3, detune: 12, warmth: 0.3, pan: -0.02
  sleep 4
  play :b3, attack: 0.5, release: 3.0, amp: 0.16, cutoff: 76, sub: 0.25, detune: 14, warmth: 0.25, pan: -0.01
  sleep 4
  play :c4, attack: 0.5, release: 3.0, amp: 0.14, cutoff: 78, sub: 0.2, detune: 16, warmth: 0.2, pan: 0.01
  sleep 4
  play :d4, attack: 0.5, release: 3.5, amp: 0.12, cutoff: 80, sub: 0.15, detune: 18, warmth: 0.15, pan: 0.02
  sleep 4
end
use_synth :kestrel_ember
play :a3, attack: 0.5, release: 3.0, amp: 0.18, cutoff: 74, sub: 0.3, detune: 12, warmth: 0.3, pan: 0.02
sleep 4
play :b3, attack: 0.5, release: 3.0, amp: 0.16, cutoff: 76, sub: 0.25, detune: 14, warmth: 0.25, pan: 0.01
sleep 4
play :c4, attack: 0.5, release: 3.0, amp: 0.14, cutoff: 78, sub: 0.2, detune: 16, warmth: 0.2, pan: -0.01
sleep 4
play :d4, attack: 0.5, release: 3.5, amp: 0.12, cutoff: 80, sub: 0.15, detune: 18, warmth: 0.15, pan: -0.02
sleep 4
""", 16),

    # 4B: Voice nearly gone — dust dominates (16 beats)
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_dust
  play :a3, attack: 1.0, release: 6.0, amp: 0.25, density: 15, rq: 0.03, grain_size: 0.1, pan: 0
  sleep 16
end
in_thread do
  use_synth :kestrel_ember
  play :b3, attack: 0.8, release: 3.0, amp: 0.1, cutoff: 76, sub: 0.1, detune: 22, warmth: 0.08, pan: -0.01
  sleep 4
  play :c4, attack: 0.8, release: 3.0, amp: 0.08, cutoff: 78, sub: 0.08, detune: 25, warmth: 0.05, pan: 0
  sleep 4
  play :a3, attack: 0.8, release: 3.0, amp: 0.06, cutoff: 74, sub: 0.05, detune: 28, warmth: 0.03, pan: 0.01
  sleep 4
  play :e4, attack: 1.0, release: 4.0, amp: 0.04, cutoff: 80, sub: 0.02, detune: 32, warmth: 0.01, pan: 0
  sleep 4
end
use_synth :kestrel_ember
play :b3, attack: 0.8, release: 3.0, amp: 0.1, cutoff: 76, sub: 0.1, detune: 22, warmth: 0.08, pan: 0.01
sleep 4
play :c4, attack: 0.8, release: 3.0, amp: 0.08, cutoff: 78, sub: 0.08, detune: 25, warmth: 0.05, pan: 0
sleep 4
play :a3, attack: 0.8, release: 3.0, amp: 0.06, cutoff: 74, sub: 0.05, detune: 28, warmth: 0.03, pan: -0.01
sleep 4
play :e4, attack: 1.0, release: 4.0, amp: 0.04, cutoff: 80, sub: 0.02, detune: 32, warmth: 0.01, pan: -0.02
sleep 4
""", 16),

    # 4C: Coda — only dust (8 beats)
    ("""use_bpm 72
use_external_synths true
use_synth :kestrel_dust
play :a3, attack: 1.0, release: 5.0, amp: 0.2, density: 8, rq: 0.05, grain_size: 0.15, pan: 0
sleep 4
play :a3, attack: 1.5, release: 4.0, amp: 0.12, density: 4, rq: 0.06, grain_size: 0.2, pan: 0
sleep 4
""", 8),
]

def main():
    # 1. Cleanup
    for p in ["beam.smp", "spider-server", "scsynth", "daemon.rb"]:
        subprocess.run(["pkill", "-9", "-f", p], capture_output=True)
    time.sleep(2)
    print("Cleaned up old processes", flush=True)

    # 2. Start daemon
    env = os.environ.copy()
    env["QT_QPA_PLATFORM"] = "offscreen"
    daemon = subprocess.Popen(
        ["/usr/bin/ruby", DAEMON_RB],
        env=env, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL
    )
    port_line = daemon.stdout.readline().decode().strip()
    nums = re.findall(r"-?\d+", port_line)
    if len(nums) < 8:
        print(f"ERROR: bad port line: {port_line}")
        sys.exit(1)
    dport, sport, token = int(nums[0]), int(nums[2]), int(nums[7])
    print(f"daemon={dport} spider={sport} token=***", flush=True)

    # 3. Keep-alive thread
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind(("127.0.0.1", 0))
    stop_ev = threading.Event()
    def keep_alive():
        while not stop_ev.is_set():
            try:
                sock.sendto(osc("/daemon/keep-alive", [token]), ("127.0.0.1", dport))
            except:
                break
            stop_ev.wait(1.5)
    threading.Thread(target=keep_alive, daemon=True).start()
    print("Keep-alive thread started", flush=True)
    time.sleep(5)

    # 4. Create null sink
    subprocess.run(["pactl", "unload-module", "module-null-sink"], capture_output=True)
    time.sleep(1)
    subprocess.run(["pactl", "load-module", "module-null-sink", f"sink_name={SINK_NAME}"],
                   capture_output=True)
    print(f"Null sink '{SINK_NAME}' created", flush=True)

    # 5. Trigger note to create SuperCollider PipeWire ports
    sock.sendto(osc("/run-code", [token, "play 60, release: 0.05, amp: 0.1\n"]),
                ("127.0.0.1", sport))
    time.sleep(3)

    # 6. Link SC to null sink
    for attempt in range(10):
        links = subprocess.check_output(["pw-link", "-l"], text=True)
        if "SuperCollider:out_1" in links:
            subprocess.run(["pw-link", "SuperCollider:out_1", f"{SINK_NAME}:playback_FL"],
                           capture_output=True)
            subprocess.run(["pw-link", "SuperCollider:out_2", f"{SINK_NAME}:playback_FR"],
                           capture_output=True)
            print(f"SC linked to {SINK_NAME}", flush=True)
            break
        time.sleep(1)
    else:
        print("WARNING: SC ports not found, continuing anyway", flush=True)

    # 7. Start parecord
    rec = subprocess.Popen(
        ["parecord", f"--device={SINK_NAME}.monitor", "--file=wav", OUTFILE],
        stderr=subprocess.PIPE, stdout=subprocess.PIPE
    )
    print(f"parecord PID={rec.pid}", flush=True)
    time.sleep(1)

    # 8. Render segments
    total_beats = sum(b for _, b in SEGMENTS)
    total_sec = total_beats * BEAT_MS / 1000
    print(f"\nRendering {len(SEGMENTS)} segments, {total_beats} beats, ~{total_sec:.1f}s", flush=True)

    for i, (code, beats) in enumerate(SEGMENTS):
        # Strip comments to avoid Unicode OSC issues
        stripped = re.sub(r'#.*$', '', code, flags=re.MULTILINE)
        msg = osc("/run-code", [token, stripped])
        sock.sendto(msg, ("127.0.0.1", sport))
        sleep_ms = beats * BEAT_MS
        print(f"  Segment {i+1}/{len(SEGMENTS)}: {beats} beats, sleeping {sleep_ms}ms", flush=True)
        time.sleep(sleep_ms / 1000 + 0.5)

    # 9. Stop all jobs
    sock.sendto(osc("/stop-all-jobs", [token]), ("127.0.0.1", sport))
    time.sleep(3)
    rec.send_signal(signal.SIGINT)
    rec.wait(timeout=5)
    print("Recording stopped", flush=True)

    stop_ev.set()
    sock.close()
    daemon.terminate()

    # 10. Fix WAV header
    fix_wav(OUTFILE)
    print(f"\nWAV: {OUTFILE} ({os.path.getsize(OUTFILE)} bytes)", flush=True)

    # 11. Convert to FLAC
    flac_path = OUTFILE.replace(".wav", ".flac")
    subprocess.run(["sox", OUTFILE, flac_path])
    print(f"FLAC: {flac_path} ({os.path.getsize(flac_path)} bytes)", flush=True)

    # 12. Normalized FLAC
    norm_path = OUTFILE.replace(".wav", "_norm.flac")
    subprocess.run(["sox", OUTFILE, norm_path, "gain", "-n", "-3"])
    print(f"Normalized FLAC: {norm_path} ({os.path.getsize(norm_path)} bytes)", flush=True)

    # 13. Audio stats
    st = subprocess.run(["sox", OUTFILE, "-n", "stat"], capture_output=True, text=True)
    print("\n=== AUDIO STATS ===", flush=True)
    for s in st.stderr.split("\n"):
        if any(k in s for k in ["Length", "Maximum amplitude", "RMS"]):
            print(f"  {s.strip()}", flush=True)

    # 14. Per-segment sanity check (15s windows)
    print("\n=== 15s WINDOW AMPLITUDE CHECK ===", flush=True)
    dur_sec = total_sec + 5
    for start in range(0, int(dur_sec), 15):
        end = min(start + 15, int(dur_sec))
        r = subprocess.run(
            ["sox", OUTFILE, "-n", "trim", str(start), str(end - start), "stat"],
            capture_output=True, text=True)
        for line in r.stderr.split("\n"):
            if "Maximum amplitude" in line:
                val = float(line.split(":")[1].strip())
                status = "OK" if val > 0.01 else "SILENCE" if val < 0.001 else "LOW"
                print(f"  [{start}s-{end}s] max_amp={val:.6f} {status}", flush=True)

if __name__ == "__main__":
    main()