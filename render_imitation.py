#!/usr/bin/env python3
"""
Renderer for Study 16 (Imitation) — segment-splitting approach.
Each segment is sent as a separate /run-code call timed to BPM.
No single segment exceeds ~14s of sleep time.

Usage: python3 render_imitation.py <output.wav> <total_duration>
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

OUTFILE = sys.argv[1] if len(sys.argv) > 1 else "/tmp/imitation_study16.wav"
DURATION = int(sys.argv[2]) if len(sys.argv) > 2 else 190

# Segments from 16_imitation.rb, split for headless rendering.
# Each segment < 14s sleep time. 72 BPM = 0.8333s/beat.

SEGMENTS = [
    # === Section I: Proposal (64 beats, ~53s) ===
    # 1A: A plays itself — clear, confident (16 beats = ~13.3s)
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

    # 1B: A attempts B's notes — hesitant, wrong voice (16 beats = ~13.3s)
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

    # 1C: B plays itself — clear, confident (16 beats = ~13.3s)
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

    # 1D: B attempts A's notes — strained, wrong voice (16 beats = ~13.3s)
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
    # 2A: Round 1 — mostly self, 1 borrowed note each (16 beats = ~13.3s)
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

    # 2B: Round 2 — 2 borrowed notes each, pan migrating (16 beats = ~13.3s)
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

    # 2C: Round 3 — 3 borrowed notes each, pan near center (16 beats = ~13.3s)
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

    # 2D: Round 4 — both play same notes, dust enters, voices converging (16 beats = ~13.3s)
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
    # 3A: A on wraith, warming — cutoff lowered, detune moderating (16 beats = ~13.3s)
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

    # 3B: B on glass, warming — shimmer decreasing, mod_index softening (16 beats = ~13.3s)
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

    # 3C: Both on ember — convergence moment (16 beats = ~13.3s)
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
    # 4A: Shared voice degrading — dust enters, ember losing warmth (16 beats = ~13.3s)
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

    # 4B: Voice nearly gone — dust dominates, ember barely recognizable (16 beats = ~13.3s)
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

    # 4C: Coda — only dust, final dissolution (8 beats = ~6.7s)
    ("""use_bpm 72
use_external_synths true
use_synth :kestrel_dust
play :a3, attack: 1.0, release: 5.0, amp: 0.2, density: 8, rq: 0.05, grain_size: 0.15, pan: 0
sleep 4
play :a3, attack: 1.5, release: 4.0, amp: 0.12, density: 4, rq: 0.06, grain_size: 0.2, pan: 0
sleep 4
""", 8),
]

BEAT_MS = 833  # 72 BPM

def main():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sc_addr = ("127.0.0.1", 4555)  # Sonic Pi OSC

    # Start recording
    print(f"Rendering {len(SEGMENTS)} segments to {OUTFILE}...")
    print(f"Total beats: {sum(b for _, b in SEGMENTS)}, duration: {sum(b for _, b in SEGMENTS) * BEAT_MS / 1000:.1f}s")

    # Start parec in background
    rec_proc = subprocess.Popen(
        ["parec", "--format=s16le", "--rate=44100", "--channels=2",
         "--device=SP_Render.monitor", "--raw"],
        stdout=open(OUTFILE + ".raw", "wb"))
    time.sleep(1)

    for i, (code, beats) in enumerate(SEGMENTS):
        # Strip comments to avoid Unicode OSC issues
        stripped = re.sub(r'#.*$', '', code, flags=re.MULTILINE)
        msg = osc("/run-code", [stripped])
        s.sendto(msg, sc_addr)
        sleep_ms = beats * BEAT_MS
        print(f"  Segment {i+1}/{len(SEGMENTS)}: {beats} beats, sleeping {sleep_ms}ms")
        time.sleep(sleep_ms / 1000 + 0.3)  # small buffer

    # Stop recording
    time.sleep(2)  # let tail ring out
    rec_proc.send_signal(subprocess.SIGINT)
    rec_proc.wait()

    # Convert raw to WAV
    raw_path = OUTFILE + ".raw"
    wav_path = OUTFILE
    subprocess.run(["sox", "-t", "raw", "-r", "44100", "-e", "signed", "-b", "16",
                    "-c", "2", raw_path, wav_path])
    os.remove(raw_path)

    # Fix WAV header (parec doesn't write correct sizes)
    fix_wav(wav_path)
    print(f"Done: {wav_path} ({os.path.getsize(wav_path)} bytes)")

    # Convert to FLAC
    flac_path = wav_path.replace(".wav", ".flac")
    subprocess.run(["sox", wav_path, flac_path])
    print(f"FLAC: {flac_path} ({os.path.getsize(flac_path)} bytes)")

    # Normalized FLAC
    norm_path = wav_path.replace(".wav", "_norm.flac")
    subprocess.run(["sox", wav_path, norm_path, "gain", "-n", "-3"])
    print(f"Normalized FLAC: {norm_path} ({os.path.getsize(norm_path)} bytes)")

if __name__ == "__main__":
    main()