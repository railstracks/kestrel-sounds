#!/usr/bin/env python3
"""
Renderer for Study 15 (Competition) — segment-splitting approach.
Each segment is sent as a separate /run-code call timed to BPM.
No single segment exceeds ~14s of sleep time.

Usage: python3 render_competition.py <output.wav> <total_duration>
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

OUTFILE = sys.argv[1] if len(sys.argv) > 1 else "/tmp/competition_study15.wav"
DURATION = int(sys.argv[2]) if len(sys.argv) > 2 else 170

# Segments from 15_competition.rb, split for headless rendering.
# Each segment < 14s sleep time. 72 BPM = 0.8333s/beat.

SEGMENTS = [
    # === Section I: Encounter (48 beats, ~40s) ===
    # 1A: A plays 4 notes (4 beats each), B plays 5+1 notes (3 beats each) — 16 beats
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_wraith
  play :e3, attack: 0.3, release: 3.0, amp: 0.4, cutoff: 75, detune: 8, noise_mix: 0.05, res: 0.4, pan: -0.4
  sleep 4
  play :g3, attack: 0.3, release: 3.0, amp: 0.4, cutoff: 78, detune: 8, noise_mix: 0.05, res: 0.35, pan: -0.4
  sleep 4
  play :a3, attack: 0.3, release: 3.0, amp: 0.4, cutoff: 80, detune: 8, noise_mix: 0.05, res: 0.4, pan: -0.4
  sleep 4
  play :b3, attack: 0.3, release: 3.0, amp: 0.4, cutoff: 82, detune: 8, noise_mix: 0.05, res: 0.45, pan: -0.4
  sleep 4
end
use_synth :kestrel_glass
play :f3, attack: 0.01, release: 2.5, amp: 0.4, mod_ratio: 2.0, mod_index: 4, shimmer: 0.15, pan: 0.4
sleep 3
play :a3, attack: 0.01, release: 2.5, amp: 0.4, mod_ratio: 3.01, mod_index: 3, shimmer: 0.1, pan: 0.4
sleep 3
play :b3, attack: 0.01, release: 2.5, amp: 0.4, mod_ratio: 2.0, mod_index: 5, shimmer: 0.2, pan: 0.4
sleep 3
play :c4, attack: 0.01, release: 2.5, amp: 0.4, mod_ratio: 3.0, mod_index: 3, shimmer: 0.15, pan: 0.4
sleep 3
play :e4, attack: 0.01, release: 2.5, amp: 0.38, mod_ratio: 2.0, mod_index: 4, shimmer: 0.2, pan: 0.4
sleep 3
play :f3, attack: 0.01, release: 1.0, amp: 0.35, mod_ratio: 2.0, mod_index: 4, shimmer: 0.15, pan: 0.4
sleep 1
""", 16),

    # 1B: A continues 2nd cycle, B continues — 16 beats
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_wraith
  play :d4, attack: 0.3, release: 3.0, amp: 0.4, cutoff: 82, detune: 8, noise_mix: 0.05, res: 0.45, pan: -0.4
  sleep 4
  play :e3, attack: 0.3, release: 3.0, amp: 0.4, cutoff: 75, detune: 8, noise_mix: 0.05, res: 0.4, pan: -0.4
  sleep 4
  play :g3, attack: 0.3, release: 3.0, amp: 0.4, cutoff: 78, detune: 8, noise_mix: 0.05, res: 0.35, pan: -0.4
  sleep 4
  play :a3, attack: 0.3, release: 3.0, amp: 0.4, cutoff: 80, detune: 8, noise_mix: 0.05, res: 0.4, pan: -0.4
  sleep 4
end
use_synth :kestrel_glass
play :a3, attack: 0.01, release: 2.5, amp: 0.4, mod_ratio: 3.01, mod_index: 3, shimmer: 0.1, pan: 0.4
sleep 3
play :b3, attack: 0.01, release: 2.5, amp: 0.4, mod_ratio: 2.0, mod_index: 5, shimmer: 0.2, pan: 0.4
sleep 3
play :c4, attack: 0.01, release: 2.5, amp: 0.4, mod_ratio: 3.0, mod_index: 3, shimmer: 0.15, pan: 0.4
sleep 3
play :e4, attack: 0.01, release: 2.5, amp: 0.38, mod_ratio: 2.0, mod_index: 4, shimmer: 0.2, pan: 0.4
sleep 3
play :f3, attack: 0.01, release: 2.5, amp: 0.38, mod_ratio: 2.0, mod_index: 4, shimmer: 0.15, pan: 0.4
sleep 3
play :a3, attack: 0.01, release: 0.5, amp: 0.3, mod_ratio: 3.01, mod_index: 3, shimmer: 0.1, pan: 0.4
sleep 1
""", 16),

    # 1C: A 3rd cycle, B 3rd cycle — 16 beats
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_wraith
  play :b3, attack: 0.3, release: 3.0, amp: 0.4, cutoff: 82, detune: 8, noise_mix: 0.05, res: 0.45, pan: -0.4
  sleep 4
  play :d4, attack: 0.3, release: 3.0, amp: 0.4, cutoff: 82, detune: 8, noise_mix: 0.05, res: 0.45, pan: -0.4
  sleep 4
  play :e3, attack: 0.3, release: 3.0, amp: 0.4, cutoff: 75, detune: 8, noise_mix: 0.05, res: 0.4, pan: -0.4
  sleep 4
  play :g3, attack: 0.3, release: 3.0, amp: 0.4, cutoff: 78, detune: 8, noise_mix: 0.05, res: 0.35, pan: -0.4
  sleep 4
end
use_synth :kestrel_glass
play :b3, attack: 0.01, release: 2.5, amp: 0.4, mod_ratio: 2.0, mod_index: 5, shimmer: 0.2, pan: 0.4
sleep 3
play :c4, attack: 0.01, release: 2.5, amp: 0.4, mod_ratio: 3.0, mod_index: 3, shimmer: 0.15, pan: 0.4
sleep 3
play :e4, attack: 0.01, release: 2.5, amp: 0.38, mod_ratio: 2.0, mod_index: 4, shimmer: 0.2, pan: 0.4
sleep 3
play :f3, attack: 0.01, release: 2.5, amp: 0.38, mod_ratio: 2.0, mod_index: 4, shimmer: 0.15, pan: 0.4
sleep 3
play :a3, attack: 0.01, release: 2.5, amp: 0.38, mod_ratio: 3.01, mod_index: 3, shimmer: 0.1, pan: 0.4
sleep 3
play :b3, attack: 0.01, release: 0.5, amp: 0.3, mod_ratio: 2.0, mod_index: 5, shimmer: 0.2, pan: 0.4
sleep 1
""", 16),

    # === Section II: Escalation (30 beats, ~25s) ===
    # 2A: Round 1 — A 3 beats/note, B 2.5 beats/note, pulse enters — 12 beats
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_pulse
  play :e2, attack: 0.01, release: 0.3, amp: 0.15, pan: 0
  sleep 1.5
  play :e2, attack: 0.01, release: 0.3, amp: 0.15, pan: 0
  sleep 1.5
  play :e2, attack: 0.01, release: 0.3, amp: 0.15, pan: 0
  sleep 1.5
  play :e2, attack: 0.01, release: 0.3, amp: 0.15, pan: 0
  sleep 1.5
  play :e2, attack: 0.01, release: 0.3, amp: 0.15, pan: 0
  sleep 1.5
  play :e2, attack: 0.01, release: 0.3, amp: 0.15, pan: 0
  sleep 1.5
  play :e2, attack: 0.01, release: 0.3, amp: 0.15, pan: 0
  sleep 1.5
  play :e2, attack: 0.01, release: 0.3, amp: 0.15, pan: 0
  sleep 1.5
end
in_thread do
  use_synth :kestrel_wraith
  play :e3, attack: 0.2, release: 2.0, amp: 0.45, cutoff: 76, detune: 10, noise_mix: 0.07, res: 0.4, pan: -0.4
  sleep 3
  play :g3, attack: 0.2, release: 2.0, amp: 0.45, cutoff: 79, detune: 10, noise_mix: 0.07, res: 0.35, pan: -0.4
  sleep 3
  play :a3, attack: 0.2, release: 2.0, amp: 0.45, cutoff: 81, detune: 10, noise_mix: 0.07, res: 0.4, pan: -0.4
  sleep 3
  play :b3, attack: 0.2, release: 2.0, amp: 0.45, cutoff: 83, detune: 10, noise_mix: 0.07, res: 0.45, pan: -0.4
  sleep 3
end
use_synth :kestrel_glass
play :f3, attack: 0.01, release: 1.8, amp: 0.45, mod_ratio: 2.0, mod_index: 4, shimmer: 0.2, pan: 0.4
sleep 2.5
play :a3, attack: 0.01, release: 1.8, amp: 0.45, mod_ratio: 3.01, mod_index: 3, shimmer: 0.15, pan: 0.4
sleep 2.5
play :b3, attack: 0.01, release: 1.8, amp: 0.45, mod_ratio: 2.0, mod_index: 5, shimmer: 0.25, pan: 0.4
sleep 2.5
play :c4, attack: 0.01, release: 1.8, amp: 0.45, mod_ratio: 3.0, mod_index: 3, shimmer: 0.2, pan: 0.4
sleep 2.5
play :e4, attack: 0.01, release: 1.8, amp: 0.42, mod_ratio: 2.0, mod_index: 4, shimmer: 0.25, pan: 0.4
sleep 2
""", 12),

    # 2B: Round 2 — A 2 beats/note, B 2 beats/note, pulse stronger, dust enters — 10 beats
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_pulse
  10.times do
    play :e2, attack: 0.01, release: 0.25, amp: 0.22, pan: 0
    sleep 1
  end
end
in_thread do
  use_synth :kestrel_dust
  play :a3, attack: 0.3, release: 8.0, amp: 0.25, density: 20, rq: 0.03, grain_size: 0.06, pan: 0
  sleep 10
end
in_thread do
  use_synth :kestrel_wraith
  play :e3, attack: 0.15, release: 1.5, amp: 0.5, cutoff: 78, detune: 12, noise_mix: 0.08, res: 0.4, pan: -0.4
  sleep 2
  play :g3, attack: 0.15, release: 1.5, amp: 0.5, cutoff: 81, detune: 12, noise_mix: 0.08, res: 0.35, pan: -0.4
  sleep 2
  play :a3, attack: 0.15, release: 1.5, amp: 0.5, cutoff: 83, detune: 12, noise_mix: 0.08, res: 0.4, pan: -0.4
  sleep 2
  play :b3, attack: 0.15, release: 1.5, amp: 0.5, cutoff: 85, detune: 12, noise_mix: 0.08, res: 0.45, pan: -0.4
  sleep 2
  play :d4, attack: 0.15, release: 1.5, amp: 0.48, cutoff: 85, detune: 12, noise_mix: 0.08, res: 0.45, pan: -0.4
  sleep 2
end
use_synth :kestrel_glass
play :f3, attack: 0.01, release: 1.2, amp: 0.5, mod_ratio: 2.0, mod_index: 4, shimmer: 0.25, pan: 0.4
sleep 2
play :a3, attack: 0.01, release: 1.2, amp: 0.5, mod_ratio: 3.01, mod_index: 3, shimmer: 0.2, pan: 0.4
sleep 2
play :b3, attack: 0.01, release: 1.2, amp: 0.5, mod_ratio: 2.0, mod_index: 5, shimmer: 0.3, pan: 0.4
sleep 2
play :c4, attack: 0.01, release: 1.2, amp: 0.5, mod_ratio: 3.0, mod_index: 3, shimmer: 0.25, pan: 0.4
sleep 2
play :e4, attack: 0.01, release: 1.2, amp: 0.48, mod_ratio: 2.0, mod_index: 4, shimmer: 0.3, pan: 0.4
sleep 2
""", 10),

    # 2C: Round 3 — A 1.5 beats/note, B 1 beat/note, max compression, pulse full, dust thick — 8 beats
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_pulse
  11.times do
    play :e2, attack: 0.01, release: 0.2, amp: 0.3, pan: 0
    sleep 0.75
  end
  play :e2, attack: 0.01, release: 0.2, amp: 0.3, pan: 0
  sleep 0.25
end
in_thread do
  use_synth :kestrel_dust
  play :a3, attack: 0.2, release: 7.0, amp: 0.35, density: 35, rq: 0.02, grain_size: 0.05, pan: 0
  sleep 8
end
in_thread do
  use_synth :kestrel_wraith
  play :e3, attack: 0.1, release: 1.0, amp: 0.55, cutoff: 80, detune: 14, noise_mix: 0.1, res: 0.4, pan: -0.4
  sleep 1.5
  play :g3, attack: 0.1, release: 1.0, amp: 0.55, cutoff: 83, detune: 14, noise_mix: 0.1, res: 0.35, pan: -0.4
  sleep 1.5
  play :a3, attack: 0.1, release: 1.0, amp: 0.55, cutoff: 85, detune: 14, noise_mix: 0.1, res: 0.4, pan: -0.4
  sleep 1.5
  play :b3, attack: 0.1, release: 1.0, amp: 0.55, cutoff: 87, detune: 14, noise_mix: 0.1, res: 0.45, pan: -0.4
  sleep 1.5
  play :d4, attack: 0.1, release: 1.0, amp: 0.53, cutoff: 87, detune: 14, noise_mix: 0.1, res: 0.45, pan: -0.4
  sleep 2
end
use_synth :kestrel_glass
play :f3, attack: 0.01, release: 0.6, amp: 0.55, mod_ratio: 2.0, mod_index: 5, shimmer: 0.3, pan: 0.4
sleep 1
play :a3, attack: 0.01, release: 0.6, amp: 0.55, mod_ratio: 3.01, mod_index: 3, shimmer: 0.25, pan: 0.4
sleep 1
play :b3, attack: 0.01, release: 0.6, amp: 0.55, mod_ratio: 2.0, mod_index: 6, shimmer: 0.35, pan: 0.4
sleep 1
play :c4, attack: 0.01, release: 0.6, amp: 0.55, mod_ratio: 3.0, mod_index: 4, shimmer: 0.3, pan: 0.4
sleep 1
play :e4, attack: 0.01, release: 0.6, amp: 0.53, mod_ratio: 2.0, mod_index: 5, shimmer: 0.35, pan: 0.4
sleep 1
play :f3, attack: 0.01, release: 0.6, amp: 0.5, mod_ratio: 2.0, mod_index: 5, shimmer: 0.3, pan: 0.4
sleep 1
play :a3, attack: 0.01, release: 0.6, amp: 0.5, mod_ratio: 3.01, mod_index: 3, shimmer: 0.25, pan: 0.4
sleep 1
play :b3, attack: 0.01, release: 0.6, amp: 0.5, mod_ratio: 2.0, mod_index: 6, shimmer: 0.35, pan: 0.4
sleep 1
""", 8),

    # === Section III: Dominance (36 beats, ~30s) ===
    # 3A: A asserts dominance, B retreats upward — 16 beats
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_wraith
  play :e3, attack: 0.1, release: 1.5, amp: 0.6, cutoff: 82, detune: 16, noise_mix: 0.12, res: 0.4, pan: -0.4
  sleep 2
  play :g3, attack: 0.1, release: 1.5, amp: 0.6, cutoff: 85, detune: 16, noise_mix: 0.12, res: 0.35, pan: -0.4
  sleep 2
  play :a3, attack: 0.1, release: 1.5, amp: 0.6, cutoff: 87, detune: 16, noise_mix: 0.12, res: 0.4, pan: -0.4
  sleep 2
  play :b3, attack: 0.1, release: 1.5, amp: 0.6, cutoff: 89, detune: 16, noise_mix: 0.12, res: 0.45, pan: -0.4
  sleep 2
  play :d4, attack: 0.1, release: 1.5, amp: 0.58, cutoff: 89, detune: 16, noise_mix: 0.12, res: 0.45, pan: -0.4
  sleep 2
  play :e3, attack: 0.1, release: 1.5, amp: 0.6, cutoff: 82, detune: 18, noise_mix: 0.14, res: 0.4, pan: -0.4
  sleep 2
  play :g3, attack: 0.1, release: 1.5, amp: 0.6, cutoff: 85, detune: 18, noise_mix: 0.14, res: 0.35, pan: -0.4
  sleep 2
  play :a3, attack: 0.1, release: 1.5, amp: 0.6, cutoff: 87, detune: 18, noise_mix: 0.14, res: 0.4, pan: -0.4
  sleep 2
end
use_synth :kestrel_glass
play :c4, attack: 0.01, release: 2.0, amp: 0.35, mod_ratio: 3.0, mod_index: 3, shimmer: 0.3, pan: 0.5
sleep 4
play :e4, attack: 0.01, release: 2.0, amp: 0.3, mod_ratio: 2.0, mod_index: 4, shimmer: 0.35, pan: 0.5
sleep 4
play :c4, attack: 0.01, release: 2.0, amp: 0.25, mod_ratio: 3.0, mod_index: 3, shimmer: 0.3, pan: 0.5
sleep 4
play :e4, attack: 0.01, release: 2.0, amp: 0.2, mod_ratio: 2.0, mod_index: 4, shimmer: 0.35, pan: 0.5
sleep 4
""", 16),

    # 3B: A fills register, B fragments — 12 beats
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_dust
  play :e3, attack: 0.2, release: 10.0, amp: 0.3, density: 25, rq: 0.025, grain_size: 0.07, pan: 0
  sleep 12
end
in_thread do
  use_synth :kestrel_glass
  play :e4, attack: 0.5, release: 3.0, amp: 0.15, mod_ratio: 2.0, mod_index: 3, shimmer: 0.4, pan: 0.6
  sleep 4
  play :c4, attack: 0.5, release: 2.0, amp: 0.1, mod_ratio: 3.0, mod_index: 2, shimmer: 0.3, pan: 0.6
  sleep 4
  play :e4, attack: 1.0, release: 4.0, amp: 0.08, mod_ratio: 2.0, mod_index: 3, shimmer: 0.45, pan: 0.6
  sleep 4
end
use_synth :kestrel_wraith
play :e3, attack: 0.1, release: 1.0, amp: 0.65, cutoff: 80, detune: 20, noise_mix: 0.15, res: 0.4, pan: -0.5
sleep 2
play :g3, attack: 0.1, release: 1.0, amp: 0.65, cutoff: 84, detune: 20, noise_mix: 0.15, res: 0.35, pan: -0.3
sleep 2
play :d4, attack: 0.1, release: 1.0, amp: 0.63, cutoff: 88, detune: 20, noise_mix: 0.15, res: 0.45, pan: -0.2
sleep 2
play :e3, attack: 0.1, release: 1.0, amp: 0.65, cutoff: 82, detune: 22, noise_mix: 0.17, res: 0.4, pan: -0.5
sleep 2
play :a3, attack: 0.1, release: 1.0, amp: 0.65, cutoff: 86, detune: 22, noise_mix: 0.17, res: 0.4, pan: -0.3
sleep 2
play :b3, attack: 0.1, release: 1.0, amp: 0.65, cutoff: 90, detune: 22, noise_mix: 0.17, res: 0.45, pan: -0.2
sleep 2
""", 12),

    # 3C: B silenced, A deformed — 8 beats
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_dust
  play :b3, attack: 0.3, release: 6.0, amp: 0.3, density: 18, rq: 0.03, grain_size: 0.08, pan: 0
  sleep 8
end
use_synth :kestrel_wraith
play :e3, attack: 0.15, release: 1.5, amp: 0.6, cutoff: 75, detune: 28, noise_mix: 0.2, res: 0.5, pan: -0.4
sleep 2
play :g3, attack: 0.15, release: 1.5, amp: 0.58, cutoff: 78, detune: 28, noise_mix: 0.2, res: 0.45, pan: -0.4
sleep 2
play :a3, attack: 0.15, release: 1.5, amp: 0.55, cutoff: 80, detune: 28, noise_mix: 0.2, res: 0.4, pan: -0.4
sleep 2
play :b3, attack: 0.15, release: 1.5, amp: 0.52, cutoff: 82, detune: 28, noise_mix: 0.2, res: 0.45, pan: -0.4
sleep 2
""", 8),

    # === Section IV: Aftermath (40 beats, ~33s) ===
    # 4A: A broken, stuttering — 16 beats
    ("""use_bpm 72
use_external_synths true
use_synth :kestrel_wraith
play :e3, attack: 0.3, release: 2.0, amp: 0.4, cutoff: 72, detune: 30, noise_mix: 0.25, res: 0.55, pan: -0.4
sleep 3
play :g3, attack: 0.5, release: 1.0, amp: 0.3, cutoff: 74, detune: 30, noise_mix: 0.25, res: 0.5, pan: -0.4
sleep 5
play :a3, attack: 0.8, release: 1.5, amp: 0.25, cutoff: 70, detune: 35, noise_mix: 0.3, res: 0.6, pan: -0.4
sleep 4
play :b3, attack: 1.0, release: 1.0, amp: 0.2, cutoff: 68, detune: 35, noise_mix: 0.3, res: 0.55, pan: -0.4
sleep 4
""", 16),

    # 4B: B ghost + A final fragment — 16 beats
    ("""use_bpm 72
use_external_synths true
in_thread do
  use_synth :kestrel_glass
  play :e5, attack: 2.0, release: 5.0, amp: 0.08, mod_ratio: 2.0, mod_index: 2, shimmer: 0.5, pan: 0.3
  sleep 8
  play :c5, attack: 2.0, release: 5.0, amp: 0.06, mod_ratio: 3.0, mod_index: 2, shimmer: 0.5, pan: 0.3
  sleep 8
end
use_synth :kestrel_wraith
play :d4, attack: 1.0, release: 2.0, amp: 0.2, cutoff: 65, detune: 40, noise_mix: 0.35, res: 0.6, pan: -0.3
sleep 6
play :e3, attack: 2.0, release: 6.0, amp: 0.15, cutoff: 60, detune: 45, noise_mix: 0.4, res: 0.65, pan: -0.3
sleep 10
""", 16),

    # Coda: dust settles — 8 beats
    ("""use_bpm 72
use_external_synths true
use_synth :kestrel_dust
play :e3, attack: 1.0, release: 5.0, amp: 0.15, density: 8, rq: 0.04, grain_size: 0.2, pan: 0
sleep 4
play :e3, attack: 1.5, release: 4.0, amp: 0.1, density: 5, rq: 0.05, grain_size: 0.3, pan: 0
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
beat_dur = 60.0 / bpm

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