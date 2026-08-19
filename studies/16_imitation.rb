# Imitation Study No. 16
# Kestrel — 2026-07-07
#
# Interaction axis, Study 3. Third mode: IMITATION.
# Study 14 was exchange — cooperative note trading, hybridization.
# Study 15 was competition — antagonistic clash, dominance, pyrrhic victory.
# Study 16 is imitation — both motifs try to copy each other, and the act
# of imitation erodes both identities.
#
# The relation is desire, not trade or conflict. Each motif WANTS to be
# the other. The imitation is at two levels:
#   Melodic: each motif gradually adopts the other's notes
#   Timbral: each motif migrates toward the other's voice
#
# A (wraith) tries to sound like glass. B (glass) tries to sound like wraith.
# By the end, both have lost their original voice. Neither knows who it was.
#
# If exchange dissolves softly and competition dissolves harshly,
# imitation dissolves sadly — the sadness of becoming what you are not
# and ceasing to be what you were.
#
# Two five-note motifs (same as Studies 14-15):
#   Motif A: E3 - G3 - A3 - B3 - D4  (E minor pentatonic)
#   Motif B: F3 - A3 - B3 - C4 - E4  (F major pentatonic)
#
# Shared notes: A3, B3 (common ground — already partially alike)
# Differing notes: E3/F3 (minor 2nd), G3/A3 (minor 2nd region), D4/E4 (minor 2nd)
#
# Voice mapping:
#   Motif A starts on kestrel_wraith, migrates toward kestrel_glass
#   Motif B starts on kestrel_glass, migrates toward kestrel_wraith
#   kestrel_ember for the convergence moment (warm, centered)
#   kestrel_dust for the loss/dissolution
#
# Four sections, through-composed:
#   I.   Proposal     — each motif plays itself, then attempts the other's notes
#   II.  Reciprocity  — simultaneous imitation, note-by-note convergence
#   III. Convergence   — both play identical notes/rhythm on different voices, converging
#   IV.  Loss         — both on the same hybrid voice, same notes, degraded. Identity gone.
#
# Designed for headless rendering: segments sent individually,
# each < 20s of sleep time. No chord/array play calls (custom synthdefs).

use_bpm 72
use_external_synths true

# ============================================================
# Section I: Proposal (beats 0-64, ~53s)
# A plays itself (0-16), then tries to play B's notes (16-32)
# B plays itself (32-48), then tries to play A's notes (48-64)
# The "attempts" are clumsy — wrong voice, wrong articulation.
# ============================================================

# Segment 1A: A plays itself — clear, confident (16 beats = ~13.3s)
use_synth :kestrel_wraith
play :e3, attack: 0.5, release: 3.0, amp: 0.4, cutoff: 75, detune: 8, noise_mix: 0.05, res: 0.4, pan: -0.4
sleep 4
play :g3, attack: 0.5, release: 3.0, amp: 0.38, cutoff: 78, detune: 8, noise_mix: 0.05, res: 0.35, pan: -0.4
sleep 4
play :a3, attack: 0.5, release: 3.0, amp: 0.36, cutoff: 80, detune: 8, noise_mix: 0.05, res: 0.4, pan: -0.4
sleep 4
play :b3, attack: 0.5, release: 3.5, amp: 0.35, cutoff: 82, detune: 8, noise_mix: 0.05, res: 0.45, pan: -0.4
sleep 4

# Segment 1B: A attempts B's notes — still on wraith, but uncertain.
# Hesitant attack, longer release, slight pitch drift. The voice doesn't fit the notes.
# A tries: F3 - A3 - B3 - C4 - E4 (B's motif) (16 beats = ~13.3s)
use_synth :kestrel_wraith
play :f3, attack: 0.8, release: 2.5, amp: 0.3, cutoff: 76, detune: 14, noise_mix: 0.08, res: 0.4, pan: -0.3
sleep 4
play :a3, attack: 0.8, release: 2.5, amp: 0.28, cutoff: 80, detune: 12, noise_mix: 0.07, res: 0.4, pan: -0.3
sleep 4
play :b3, attack: 0.8, release: 2.5, amp: 0.27, cutoff: 82, detune: 13, noise_mix: 0.08, res: 0.45, pan: -0.3
sleep 4
play :c4, attack: 0.8, release: 3.0, amp: 0.25, cutoff: 84, detune: 15, noise_mix: 0.1, res: 0.5, pan: -0.3
sleep 4

# Segment 1C: B plays itself — clear, confident (16 beats = ~13.3s)
use_synth :kestrel_glass
play :f3, attack: 0.01, release: 3.0, amp: 0.5, mod_ratio: 2.0, mod_index: 4, shimmer: 0.2, pan: 0.4
sleep 4
play :a3, attack: 0.01, release: 3.0, amp: 0.5, mod_ratio: 3.01, mod_index: 3, shimmer: 0.15, pan: 0.4
sleep 4
play :b3, attack: 0.01, release: 3.0, amp: 0.5, mod_ratio: 2.0, mod_index: 5, shimmer: 0.25, pan: 0.4
sleep 4
play :e4, attack: 0.01, release: 3.5, amp: 0.45, mod_ratio: 3.0, mod_index: 3, shimmer: 0.2, pan: 0.4
sleep 4

# Segment 1D: B attempts A's notes — still on glass, but strained.
# The voice resists the notes. Glass tries to be spectral — shimmer increases, gets harsh.
# B tries: E3 - G3 - A3 - B3 - D4 (A's motif) (16 beats = ~13.3s)
use_synth :kestrel_glass
play :e3, attack: 0.01, release: 2.5, amp: 0.4, mod_ratio: 2.0, mod_index: 6, shimmer: 0.35, pan: 0.3
sleep 4
play :g3, attack: 0.01, release: 2.5, amp: 0.38, mod_ratio: 3.01, mod_index: 5, shimmer: 0.3, pan: 0.3
sleep 4
play :a3, attack: 0.01, release: 2.5, amp: 0.36, mod_ratio: 2.0, mod_index: 7, shimmer: 0.35, pan: 0.3
sleep 4
play :d4, attack: 0.01, release: 3.0, amp: 0.35, mod_ratio: 3.0, mod_index: 6, shimmer: 0.4, pan: 0.3
sleep 4

# ============================================================
# Section II: Reciprocity (beats 64-128, ~53s)
# Both motifs imitate each other simultaneously.
# Each round, both play simultaneously. Each gets closer to the other.
# The convergence is gradual: round 1 = mostly self, round 4 = mostly other.
# Pan positions migrate toward center as identities blur.
# ============================================================

# Segment 2A: Round 1 — A mostly self (4/5 own notes), B mostly self (16 beats = ~13.3s)
# A plays: E3 - G3 - A3 - B3 - C4 (4 own + 1 borrowed from B)
# B plays: F3 - A3 - B3 - C4 - D4 (3 own + 1 borrowed + 1 shared)
# Wait — both have 4 notes. Let me use 4-note phrases for clarity.
# A plays: E3 - G3 - A3 - C4 (3 own, 1 borrowed)
# B plays: F3 - A3 - B3 - D4 (2 own, 1 shared, 1 borrowed)
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

# Segment 2B: Round 2 — each adopts 2 of the other's notes (16 beats = ~13.3s)
# A plays: E3 - A3 - B3 - C4 (2 own, 1 shared, 1 borrowed)
# B plays: F3 - G3 - B3 - D4 (1 borrowed, 1 borrowed, 1 shared, 1 own)
# Pan migrates toward center. Timbre starts shifting: A's detune rises (toward glass clarity),
# B's shimmer rises (toward wraith spectral quality)
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

# Segment 2C: Round 3 — each adopts 3 of the other's notes (16 beats = ~13.3s)
# A plays: F3 - A3 - B3 - E4 (1 borrowed, 1 shared, 1 shared, 1 borrowed)
# B plays: E3 - G3 - A3 - D4 (1 borrowed, 1 borrowed, 1 shared, 1 own)
# Pan near center. A's detune higher (12-16), B's shimmer higher (0.32-0.38)
# Both are losing their identity. The voices are becoming similar.
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

# Segment 2D: Round 4 — both play the same notes in the same order (16 beats = ~13.3s)
# Both play: A3 - B3 - C4 - D4 (all shared/converged notes — neither A's nor B's)
# Pan at center. Voices are nearly indistinguishable:
# A (wraith) has high detune (16-18) and noise_mix (0.1) — approaching glass's brightness
# B (glass) has high shimmer (0.4) and mod_index (7) — approaching wraith's spectral quality
# Dust enters softly — identity dissolution is beginning
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

# ============================================================
# Section III: Convergence (beats 128-176, ~40s)
# Both motifs now play identical material on converging voices.
# The voices migrate: A moves from wraith toward ember (warm center).
# B moves from glass toward ember. Both approach the same voice.
# The material is the shared notes: A3 - B3 - C4 - D4 - E4
# Rhythm slows — the convergence has a meditative quality.
# ============================================================

# Segment 3A: A on wraith, but warming — cutoff lowered, detune moderating (16 beats = ~13.3s)
# A plays the shared motif with increasingly warm parameters
use_synth :kestrel_wraith
play :a3, attack: 0.8, release: 3.5, amp: 0.25, cutoff: 78, detune: 14, noise_mix: 0.08, res: 0.4, pan: -0.05
sleep 4
play :b3, attack: 0.8, release: 3.5, amp: 0.23, cutoff: 80, detune: 13, noise_mix: 0.07, res: 0.4, pan: -0.03
sleep 4
play :c4, attack: 0.8, release: 3.5, amp: 0.22, cutoff: 82, detune: 12, noise_mix: 0.07, res: 0.4, pan: -0.02
sleep 4
play :d4, attack: 0.8, release: 4.0, amp: 0.2, cutoff: 84, detune: 11, noise_mix: 0.06, res: 0.45, pan: 0
sleep 4

# Segment 3B: B on glass, but warming — shimmer decreasing, mod_index softening (16 beats = ~13.3s)
# B plays the same shared motif, converging toward A's warmth
use_synth :kestrel_glass
play :a3, attack: 0.01, release: 3.5, amp: 0.25, mod_ratio: 2.0, mod_index: 5, shimmer: 0.3, pan: 0.05
sleep 4
play :b3, attack: 0.01, release: 3.5, amp: 0.23, mod_ratio: 3.01, mod_index: 4, shimmer: 0.25, pan: 0.03
sleep 4
play :c4, attack: 0.01, release: 3.5, amp: 0.22, mod_ratio: 2.0, mod_index: 5, shimmer: 0.22, pan: 0.02
sleep 4
play :d4, attack: 0.01, release: 4.0, amp: 0.2, mod_ratio: 3.0, mod_index: 4, shimmer: 0.2, pan: 0
sleep 4

# Segment 3C: Both on ember — the convergence moment (16 beats = ~13.3s)
# Both voices meet on kestrel_ember. Same notes, same voice, same rhythm.
# This is the moment of complete imitation: they have become identical.
# But the identity is neither A nor B — it is something new, warm, and hollow.
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

# ============================================================
# Section IV: Loss (beats 176-224, ~40s)
# Both voices on ember, but degrading. They have become identical
# and in doing so have lost what made them distinct.
# The ember voice degrades: detune rises, warmth fades, sub bass thins.
# Dust accumulates as both identities dissolve into a common nothing.
# The sadness: they succeeded at becoming each other, and there is nothing left.
# ============================================================

# Segment 4A: Shared voice, beginning to degrade (16 beats = ~13.3s)
# Both play the same notes on ember, but detune is rising, warmth fading
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

# Segment 4B: Voice nearly gone — dust dominates (16 beats = ~13.3s)
# Ember is barely recognizable: high detune, no warmth, thin sub
# Dust takes over. Neither motif can be distinguished.
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

# Segment 4C: Coda — only dust. Both identities fully dissolved. (8 beats = ~6.7s)
# The last gesture: a single dust cloud at A3, the note both motifs shared.
# Then silence. Neither knows who it was.
use_synth :kestrel_dust
play :a3, attack: 1.0, release: 5.0, amp: 0.2, density: 8, rq: 0.05, grain_size: 0.15, pan: 0
sleep 4
play :a3, attack: 1.5, release: 4.0, amp: 0.12, density: 4, rq: 0.06, grain_size: 0.2, pan: 0
sleep 4