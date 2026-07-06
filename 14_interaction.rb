# Interaction Study No. 14
# Kestrel — 2026-07-06
#
# Third aesthetic axis: INTERACTION.
# Degradation: one motif, changed by time.
# Translation: one motif, changed by context.
# Interaction: two motifs, changed by each other.
#
# The motif is no longer alone. The form is relational.
#
# Two five-note motifs:
#   Motif A: E3 - G3 - A3 - B3 - D4  (E minor pentatonic)
#   Motif B: F3 - A3 - B3 - C4 - E4  (F major pentatonic)
#
# Near-neighbors. Share A3 and B3. Differ on 3 notes.
# Can coexist in C major but pull in different directions.
#
# Voice mapping:
#   Motif A → kestrel_wraith (spectral, ghostly, left pan)
#   Motif B → kestrel_glass  (crystalline, bright, right pan)
#   Fusion  → kestrel_ember  (warm, grounding, center)
#   Texture → kestrel_dust   (granular, for transitions/dissolution)
#   Pulse   → kestrel_pulse  (structural punctuation)
#
# Four sections, through-composed:
#   I.   Statement  — A alone, B alone, both simultaneously
#   II.  Exchange   — motifs trade notes round by round until hybridized
#   III. Fusion     — a single hybrid melody from both motifs
#   IV.  Recall     — A and B separate, each carrying traces of the other
#
# Designed for headless rendering: segments sent individually,
# each < 20s of sleep time. No chord/array play calls (custom synthdefs).

use_bpm 72
use_external_synths true

# ============================================================
# Section I: Statement (beats 0-48, ~40s)
# A states alone (0-16), B states alone (16-32), both together (32-48)
# ============================================================

# Segment 1A: Motif A alone (16 beats = ~13.3s)
use_synth :kestrel_wraith
play :e3, attack: 0.5, release: 3.0, amp: 0.4, cutoff: 75, detune: 10, noise_mix: 0.06, res: 0.4, pan: -0.4
sleep 4
play :g3, attack: 0.5, release: 3.0, amp: 0.38, cutoff: 78, detune: 8, noise_mix: 0.05, res: 0.35, pan: -0.4
sleep 4
play :a3, attack: 0.5, release: 3.0, amp: 0.36, cutoff: 80, detune: 12, noise_mix: 0.07, res: 0.4, pan: -0.4
sleep 4
play :b3, attack: 0.5, release: 3.5, amp: 0.35, cutoff: 82, detune: 10, noise_mix: 0.06, res: 0.45, pan: -0.4
sleep 4

# Segment 1B: Motif B alone (16 beats = ~13.3s)
use_synth :kestrel_glass
play :f3, attack: 0.01, release: 3.0, amp: 0.5, mod_ratio: 2.0, mod_index: 4, shimmer: 0.2, pan: 0.4
sleep 4
play :a3, attack: 0.01, release: 3.0, amp: 0.5, mod_ratio: 3.01, mod_index: 3, shimmer: 0.15, pan: 0.4
sleep 4
play :b3, attack: 0.01, release: 3.0, amp: 0.5, mod_ratio: 2.0, mod_index: 5, shimmer: 0.25, pan: 0.4
sleep 4
play :c4, attack: 0.01, release: 3.5, amp: 0.45, mod_ratio: 3.0, mod_index: 3, shimmer: 0.2, pan: 0.4
sleep 4

# Segment 1C: Both motifs simultaneously (16 beats = ~13.3s)
# A on wraith (left), B on glass (right) — overlapping but independent
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

# ============================================================
# Section II: Exchange (beats 48-96, ~40s)
# Motifs trade notes one by one. 5 rounds, each 8 beats.
# After each round, one note swaps between A and B.
# ============================================================

# Segment 2A: Round 1 — A gets F3 (from B), B gets E3 (from A) (8 beats = ~6.7s)
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

# Segment 2B: Round 2 — A also gets C4, B also gets G3 (8 beats = ~6.7s)
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

# Segment 2C: Round 3 — A gets E4, B gets D4 (8 beats = ~6.7s)
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

# Segment 2D: Round 4 — near-complete swap. Dust enters as transition texture. (8 beats = ~6.7s)
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

# Segment 2E: Round 5 — full swap. A is now B-altered, B is now A-altered. (8 beats = ~6.7s)
# Both motifs have been transformed by the encounter. Dust dissipates.
in_thread do
  use_synth :kestrel_dust
  play :b3, attack: 0.5, release: 4.0, amp: 0.3, density: 15, rq: 0.03, grain_size: 0.1, pan: 0
  sleep 8
end
in_thread do
  use_synth :kestrel_wraith
  # A has become: F3, C4, A3, E4, D4 (B's notes, reordered)
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
# B has become: E3, G3, B3, D4, C4 (A's notes, reordered)
play :e3, attack: 0.01, release: 2.5, amp: 0.4, mod_ratio: 2.0, mod_index: 4, shimmer: 0.2, pan: 0.3
sleep 2
play :g3, attack: 0.01, release: 2.5, amp: 0.4, mod_ratio: 3.01, mod_index: 3, shimmer: 0.15, pan: 0.3
sleep 2
play :b3, attack: 0.01, release: 2.5, amp: 0.4, mod_ratio: 2.0, mod_index: 5, shimmer: 0.25, pan: 0.3
sleep 2
play :d4, attack: 0.01, release: 3.0, amp: 0.35, mod_ratio: 3.0, mod_index: 3, shimmer: 0.2, pan: 0.3
sleep 2

# ============================================================
# Section III: Fusion (beats 96-136, ~33s)
# A single hybrid melody — notes from both motifs interleaved,
# neither A nor B. Ember voice: warm, centered, the resolution
# of the encounter. Dust fades out. The hybrid is born.
# ============================================================

# Segment 3A: Hybrid melody part 1 (16 beats = ~13.3s)
use_synth :kestrel_ember
play :e3, attack: 0.3, release: 3.0, amp: 0.35, cutoff: 70, sub: 0.4, detune: 5, warmth: 0.4, pan: -0.1
sleep 4
play :a3, attack: 0.3, release: 3.0, amp: 0.33, cutoff: 72, sub: 0.35, detune: 4, warmth: 0.35, pan: 0.1
sleep 4
play :f3, attack: 0.3, release: 3.0, amp: 0.32, cutoff: 68, sub: 0.4, detune: 6, warmth: 0.4, pan: -0.05
sleep 4
play :b3, attack: 0.3, release: 3.5, amp: 0.3, cutoff: 74, sub: 0.3, detune: 4, warmth: 0.35, pan: 0.05
sleep 4

# Segment 3B: Hybrid melody part 2 (16 beats = ~13.3s)
# Glass joins ember for upper partials — the hybrid has both warmth and clarity
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

# Segment 3C: Hybrid dissolves into dust (8 beats = ~6.7s)
# The fusion is not stable — it dissolves back into particles
use_synth :kestrel_dust
play :a3, attack: 0.5, release: 3.0, amp: 0.4, density: 20, rq: 0.02, grain_size: 0.08, pan: 0
sleep 2
play :b3, attack: 0.5, release: 3.0, amp: 0.35, density: 25, rq: 0.025, grain_size: 0.06, pan: 0
sleep 2
play :c4, attack: 0.5, release: 4.0, amp: 0.3, density: 15, rq: 0.03, grain_size: 0.1, pan: 0
sleep 4

# ============================================================
# Section IV: Recall (beats 136-176, ~33s)
# A and B separate again, but altered. Each carries one note
# from the other. The encounter has changed them permanently.
# ============================================================

# Segment 4A: A returns, altered (16 beats = ~13.3s)
# A has F3 where E3 was — it remembers B's influence
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

# Segment 4B: B returns, altered (16 beats = ~13.3s)
# B has E3 where F3 was — it remembers A's influence
# Glass shimmer echoes wraith's spectral quality — B has absorbed some of A's character
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

# Coda: both motifs sound their final notes simultaneously, then dust settles
# (8 beats = ~6.7s)
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