# Competition Study No. 15
# Kestrel — 2026-07-07
#
# Interaction axis, Study 2. Second mode: COMPETITION.
# Study 14 was exchange — cooperative note trading, hybridization.
# Study 15 is competition — antagonistic clash, dominance, pyrrhic victory.
#
# The same two motifs, but the relation is different:
#   Study 14: both motifs change each other through mutual trade → fusion → gentle dissolution
#   Study 15: both motifs try to destroy each other → dominance → exhaustion → harsh dissolution
#
# If both modes converge on dissolution, interaction is a genuine axis
# with its own attractor — relational processes dissolve, like degradation and translation.
# But the QUALITY of dissolution differs: exchange dissolves softly (dust settling),
# competition dissolves harshly (fragments after battle).
#
# Two five-note motifs (same as Study 14):
#   Motif A: E3 - G3 - A3 - B3 - D4  (E minor pentatonic)
#   Motif B: F3 - A3 - B3 - C4 - E4  (F major pentatonic)
#
# Shared notes: A3, B3 (neutral ground — moments of accidental consonance)
# Clashing notes: E3/F3 (minor 2nd), D4/E4 (minor 2nd) — the sites of conflict
#
# Voice mapping (same voices, different use):
#   Motif A → kestrel_wraith (spectral, aggressive when pushed)
#   Motif B → kestrel_glass  (crystalline, brittle under pressure)
#   Debris  → kestrel_dust   (granular, collision residue)
#   Pulse   → kestrel_pulse  (rhythmic reinforcement — escalation marker)
#
# Four sections, through-composed:
#   I.   Encounter   — both motifs play simultaneously at mismatched phase
#   II.  Escalation  — both accelerate, louden, pulse enters, dust accumulates
#   III. Dominance   — A overwhelms B; B retreats upward, fragments; A deforms
#   IV.  Aftermath   — A alone, broken; B ghosts; dust settles over the wreckage
#
# Designed for headless rendering: segments sent individually,
# each < 20s of sleep time. No chord/array play calls (custom synthdefs).

use_bpm 72
use_external_synths true

# ============================================================
# Section I: Encounter (beats 0-48, ~40s)
# Both motifs play simultaneously at mismatched phase.
# A plays 5 notes in 20 beats (4 beats/note).
# B plays 5 notes in 15 beats (3 beats/note).
# They go in and out of sync. Shared notes (A3, B3) = consonance.
# Clashing notes (E3/F3, D4/E4) = friction.
# ============================================================

# Segment 1A: A's first statement (20 beats, but we split at 16)
# A: E3(4) - G3(4) - A3(4) - B3(4) - D4(4) = 20 beats
# B: F3(3) - A3(3) - B3(3) - C4(3) - E4(3) = 15 beats
# They start together. B finishes first, restarts while A is still going.
# Segment 1A = first 16 beats: A plays 4 notes, B plays 5 notes + starts 2nd cycle

# Segment 1A: beats 0-16 (13.3s)
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
# B's 2nd cycle starts at beat 15 — just 1 beat left in this segment
play :f3, attack: 0.01, release: 1.0, amp: 0.35, mod_ratio: 2.0, mod_index: 4, shimmer: 0.15, pan: 0.4
sleep 1

# Segment 1B: beats 16-32 (13.3s)
# A plays D4 (last note, 4 beats) then starts 2nd cycle: E3(4) G3(4) A3(4) B3(4)
# B continues 2nd cycle: A3(3) B3(3) C4(3) E4(3) then starts 3rd cycle: F3(3) A3(1 so far)
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

# Segment 1C: beats 32-48 (13.3s)
# A: B3(4) D4(4) E3(4) G3(4) — 3rd cycle starts
# B: B3(3) C4(3) E4(3) F3(3) A3(3) — continuing
# The phase mismatch creates moments where E3 and F3 sound together (dissonance)
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

# ============================================================
# Section II: Escalation (beats 48-96, ~40s)
# Both motifs accelerate and get louder. Pulse enters as structural
# reinforcement. Dust accumulates as collision debris.
# A: 4 beats/note -> 3 -> 2 -> 1.5 (compressing)
# B: 3 beats/note -> 2.5 -> 2 -> 1 (compressing faster, already shorter)
# Amplitude increases each round. Filter opens (wraith) / shimmer increases (glass).
# ============================================================

# Segment 2A: Escalation round 1 (12 beats = ~10s)
# A: 3 beats/note, louder. B: 2.5 beats/note, louder. Pulse enters softly.
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

# Segment 2B: Escalation round 2 (10 beats = ~8.3s)
# A: 2 beats/note, louder. B: 2 beats/note, louder. Pulse stronger. Dust enters.
in_thread do
  use_synth :kestrel_pulse
  play :e2, attack: 0.01, release: 0.25, amp: 0.22, pan: 0
  sleep 1
  play :e2, attack: 0.01, release: 0.25, amp: 0.22, pan: 0
  sleep 1
  play :e2, attack: 0.01, release: 0.25, amp: 0.22, pan: 0
  sleep 1
  play :e2, attack: 0.01, release: 0.25, amp: 0.22, pan: 0
  sleep 1
  play :e2, attack: 0.01, release: 0.25, amp: 0.22, pan: 0
  sleep 1
  play :e2, attack: 0.01, release: 0.25, amp: 0.22, pan: 0
  sleep 1
  play :e2, attack: 0.01, release: 0.25, amp: 0.22, pan: 0
  sleep 1
  play :e2, attack: 0.01, release: 0.25, amp: 0.22, pan: 0
  sleep 1
  play :e2, attack: 0.01, release: 0.25, amp: 0.22, pan: 0
  sleep 1
  play :e2, attack: 0.01, release: 0.25, amp: 0.22, pan: 0
  sleep 1
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

# Segment 2C: Escalation round 3 (8 beats = ~6.7s)
# A: 1.5 beats/note. B: 1 beat/note. Maximum compression. Pulse at full. Dust thick.
in_thread do
  use_synth :kestrel_pulse
  play :e2, attack: 0.01, release: 0.2, amp: 0.3, pan: 0
  sleep 0.75
  play :e2, attack: 0.01, release: 0.2, amp: 0.3, pan: 0
  sleep 0.75
  play :e2, attack: 0.01, release: 0.2, amp: 0.3, pan: 0
  sleep 0.75
  play :e2, attack: 0.01, release: 0.2, amp: 0.3, pan: 0
  sleep 0.75
  play :e2, attack: 0.01, release: 0.2, amp: 0.3, pan: 0
  sleep 0.75
  play :e2, attack: 0.01, release: 0.2, amp: 0.3, pan: 0
  sleep 0.75
  play :e2, attack: 0.01, release: 0.2, amp: 0.3, pan: 0
  sleep 0.75
  play :e2, attack: 0.01, release: 0.2, amp: 0.3, pan: 0
  sleep 0.75
  play :e2, attack: 0.01, release: 0.2, amp: 0.3, pan: 0
  sleep 0.75
  play :e2, attack: 0.01, release: 0.2, amp: 0.3, pan: 0
  sleep 0.75
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

# ============================================================
# Section III: Dominance (beats 96-136, ~33s)
# A overwhelms B. A plays louder, lower, denser — filling the register.
# B gets pushed higher and thinner, trying to escape.
# Eventually B is just fragments — high, quiet, isolated.
# A is deformed by the effort — more noise, wider filter, more detune.
# ============================================================

# Segment 3A: A asserts dominance (16 beats = ~13.3s)
# A: plays full motif at 2 beats/note, loud, aggressive cutoff/detune
# B: retreats upward — plays only its highest notes (C4, E4), sparse, 4 beats apart
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
# B retreats — high, sparse, weakening
use_synth :kestrel_glass
play :c4, attack: 0.01, release: 2.0, amp: 0.35, mod_ratio: 3.0, mod_index: 3, shimmer: 0.3, pan: 0.5
sleep 4
play :e4, attack: 0.01, release: 2.0, amp: 0.3, mod_ratio: 2.0, mod_index: 4, shimmer: 0.35, pan: 0.5
sleep 4
play :c4, attack: 0.01, release: 2.0, amp: 0.25, mod_ratio: 3.0, mod_index: 3, shimmer: 0.3, pan: 0.5
sleep 4
play :e4, attack: 0.01, release: 2.0, amp: 0.2, mod_ratio: 2.0, mod_index: 4, shimmer: 0.35, pan: 0.5
sleep 4

# Segment 3B: A fills the register, B fragments (12 beats = ~10s)
# A: plays motif in overlapping registers — low E3 + mid G3 + high D4 simultaneously
# (sequential, not chord — custom synthdef constraint)
# B: just 2-3 isolated high notes, very quiet, barely there
in_thread do
  use_synth :kestrel_dust
  play :e3, attack: 0.2, release: 10.0, amp: 0.3, density: 25, rq: 0.025, grain_size: 0.07, pan: 0
  sleep 12
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

# B's last gasp — isolated, high, fading
use_synth :kestrel_glass
play :e4, attack: 0.5, release: 3.0, amp: 0.15, mod_ratio: 2.0, mod_index: 3, shimmer: 0.4, pan: 0.6
sleep 4
play :c4, attack: 0.5, release: 2.0, amp: 0.1, mod_ratio: 3.0, mod_index: 2, shimmer: 0.3, pan: 0.6
sleep 4
play :e4, attack: 1.0, release: 4.0, amp: 0.08, mod_ratio: 2.0, mod_index: 3, shimmer: 0.45, pan: 0.6
sleep 4

# Segment 3C: B silenced, A deformed (8 beats = ~6.7s)
# A plays alone but the effort has deformed it — extreme detune, noise, wide filter
# B is gone — silence from glass
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

# ============================================================
# Section IV: Aftermath (beats 136-176, ~33s)
# A plays alone. But it's broken — stuttering rhythm, long pauses,
# notes barely holding together. The wraith is more noise than tone.
# B is a ghost — a few glass shimmer echoes at the edge of hearing.
# Dust settles over everything. The piece ends with A's final note
# dissolving into noise and silence.
# ============================================================

# Segment 4A: A broken, stuttering (16 beats = ~13.3s)
# A plays fragments of its motif with disrupted rhythm and degraded timbre
# Long pauses. Notes that don't quite land. The winner is spent.
use_synth :kestrel_wraith
play :e3, attack: 0.3, release: 2.0, amp: 0.4, cutoff: 72, detune: 30, noise_mix: 0.25, res: 0.55, pan: -0.4
sleep 3
# Stutter — delayed, hesitant
play :g3, attack: 0.5, release: 1.0, amp: 0.3, cutoff: 74, detune: 30, noise_mix: 0.25, res: 0.5, pan: -0.4
sleep 5
# Long pause — 2 beats of silence
play :a3, attack: 0.8, release: 1.5, amp: 0.25, cutoff: 70, detune: 35, noise_mix: 0.3, res: 0.6, pan: -0.4
sleep 4
# Barely there
play :b3, attack: 1.0, release: 1.0, amp: 0.2, cutoff: 68, detune: 35, noise_mix: 0.3, res: 0.55, pan: -0.4
sleep 4

# Segment 4B: B's ghost + A's final fragment (16 beats = ~13.3s)
# B returns as a ghost — glass shimmer, barely audible, high and ethereal
# A plays one more fragment, then gives up
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
# The last note — E3, barely there, dissolving
play :e3, attack: 2.0, release: 6.0, amp: 0.15, cutoff: 60, detune: 45, noise_mix: 0.4, res: 0.65, pan: -0.3
sleep 10

# Coda: dust settles over the wreckage (8 beats = ~6.7s)
use_synth :kestrel_dust
play :e3, attack: 1.0, release: 5.0, amp: 0.15, density: 8, rq: 0.04, grain_size: 0.2, pan: 0
sleep 4
play :e3, attack: 1.5, release: 4.0, amp: 0.1, density: 5, rq: 0.05, grain_size: 0.3, pan: 0
sleep 4