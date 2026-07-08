# Ground Shift Study No. 17
# Kestrel -- 2026-07-08
#
# Ground dissolution. The first study operating at the ground level.
# Previous studies dissolved the figure (motif). This study dissolves
# the ground (tuning system) underneath an invariant figure.
#
# The motif stays the same: E minor pentatonic, 5 notes.
# The tuning system shifts underneath:
#   I.   12-EDO (home)     -- the motif as we know it
#   II.  17-EDO (uncanny)  -- intervals subtly wrong, 6-18 cents off
#   III. 7-EDO (alien)     -- minor third becomes near-major, transformed
#   IV.  Dissolution       -- tuning breaks down, random deviation increasing
#
# Hypothesis: the dissolution basin holds at the ground level.
# Any tuning system, pushed far enough, dissolves the motif built on it.
# The ground is not exempt from dissolution. The ground IS dissolution.
#
# Root: E3 = 164.81 Hz (MIDI 52.0)
# Motif: E3 - G3 - A3 - B3 - D4 (unison, min 3rd, perf 4th, perf 5th, min 7th)
#
# MIDI note numbers per EDO (precomputed):
#   12-EDO: 52.000, 55.000, 57.000, 59.000, 62.000
#   17-EDO: 52.000, 54.824, 56.941, 59.059, 61.882
#   7-EDO:  52.000, 55.429, 57.143, 58.857, 62.286
#
# Designed for headless rendering: each segment < 14s sleep time.
# No chord/array play calls (custom synthdefs need individual play calls).
# Release times kept shorter than inter-note gaps to prevent voice accumulation.

use_bpm 72
use_external_synths true

# ============================================================
# Section I: HOME (12-EDO) -- the ground is solid
# Two passes: ascending then descending.
# Pure wraith, minimal detune. Long notes with shorter releases.
# Total: 30 beats = 25.0s
# ============================================================

use_synth :kestrel_wraith
play 52.000, attack: 0.5, release: 1.8, amp: 0.42, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35
sleep 3
play 55.000, attack: 0.5, release: 1.8, amp: 0.40, cutoff: 82, detune: 5, noise_mix: 0.03, res: 0.35
sleep 3
play 57.000, attack: 0.5, release: 1.8, amp: 0.38, cutoff: 84, detune: 5, noise_mix: 0.03, res: 0.35
sleep 3
play 59.000, attack: 0.5, release: 1.8, amp: 0.40, cutoff: 82, detune: 5, noise_mix: 0.03, res: 0.35
sleep 3
play 62.000, attack: 0.8, release: 2.0, amp: 0.44, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.30
sleep 4
play 62.000, attack: 0.5, release: 1.8, amp: 0.42, cutoff: 80, detune: 6, noise_mix: 0.03, res: 0.30
sleep 3
play 59.000, attack: 0.5, release: 1.8, amp: 0.38, cutoff: 82, detune: 6, noise_mix: 0.03, res: 0.35
sleep 3
play 57.000, attack: 0.5, release: 1.8, amp: 0.36, cutoff: 84, detune: 6, noise_mix: 0.03, res: 0.35
sleep 3
play 55.000, attack: 0.5, release: 1.8, amp: 0.34, cutoff: 82, detune: 6, noise_mix: 0.03, res: 0.35
sleep 3
play 52.000, attack: 0.8, release: 2.5, amp: 0.38, cutoff: 78, detune: 6, noise_mix: 0.03, res: 0.30
sleep 5

# ============================================================
# Section II: UNCANNY (17-EDO) -- the ground has shifted slightly
# Same motif contour, but intervals are 6-18 cents off.
# The wraith feels the wrongness. Detune increases. Notes shorter.
# ============================================================

use_synth :kestrel_wraith
play 52.000, attack: 0.5, release: 1.5, amp: 0.40, cutoff: 80, detune: 10, noise_mix: 0.05, res: 0.35
sleep 2.5
play 54.824, attack: 0.5, release: 1.5, amp: 0.38, cutoff: 82, detune: 11, noise_mix: 0.05, res: 0.35
sleep 2.5
play 56.941, attack: 0.5, release: 1.5, amp: 0.36, cutoff: 84, detune: 12, noise_mix: 0.06, res: 0.35
sleep 2.5
play 59.059, attack: 0.5, release: 1.5, amp: 0.38, cutoff: 82, detune: 13, noise_mix: 0.06, res: 0.35
sleep 2.5
play 61.882, attack: 0.8, release: 2.0, amp: 0.40, cutoff: 80, detune: 14, noise_mix: 0.06, res: 0.30
sleep 3.5
play 61.882, attack: 0.5, release: 1.5, amp: 0.38, cutoff: 80, detune: 14, noise_mix: 0.06, res: 0.30
sleep 2.5
play 59.059, attack: 0.5, release: 1.5, amp: 0.36, cutoff: 82, detune: 15, noise_mix: 0.06, res: 0.35
sleep 2.5
play 56.941, attack: 0.5, release: 1.5, amp: 0.34, cutoff: 84, detune: 15, noise_mix: 0.07, res: 0.35
sleep 2.5
play 54.824, attack: 0.5, release: 1.5, amp: 0.32, cutoff: 82, detune: 16, noise_mix: 0.07, res: 0.35
sleep 2.5
play 52.000, attack: 0.8, release: 2.5, amp: 0.34, cutoff: 78, detune: 16, noise_mix: 0.07, res: 0.30
sleep 5

# ============================================================
# Section III: ALIEN (7-EDO) -- the ground is unrecognizable
# Minor third has become near-major third (+42.9 cents).
# The melody has its own alien logic but is not OUR melody.
# Wraith struggles. Dust enters between notes. Agitated (2 beats each).
# ============================================================

use_synth :kestrel_wraith
play 52.000, attack: 0.3, release: 1.2, amp: 0.38, cutoff: 82, detune: 20, noise_mix: 0.10, res: 0.35
sleep 2
play 55.429, attack: 0.3, release: 1.2, amp: 0.36, cutoff: 84, detune: 21, noise_mix: 0.10, res: 0.35
sleep 2
play 57.143, attack: 0.3, release: 1.2, amp: 0.34, cutoff: 86, detune: 22, noise_mix: 0.11, res: 0.35
sleep 2
play 58.857, attack: 0.3, release: 1.2, amp: 0.36, cutoff: 84, detune: 23, noise_mix: 0.11, res: 0.35
sleep 2
play 62.286, attack: 0.5, release: 2.0, amp: 0.38, cutoff: 82, detune: 24, noise_mix: 0.12, res: 0.30
sleep 3
play 62.286, attack: 0.3, release: 1.2, amp: 0.36, cutoff: 82, detune: 24, noise_mix: 0.12, res: 0.30
sleep 2
play 58.857, attack: 0.3, release: 1.2, amp: 0.34, cutoff: 84, detune: 25, noise_mix: 0.12, res: 0.35
sleep 2
play 57.143, attack: 0.3, release: 1.2, amp: 0.32, cutoff: 86, detune: 26, noise_mix: 0.13, res: 0.35
sleep 2
play 55.429, attack: 0.3, release: 1.2, amp: 0.30, cutoff: 84, detune: 27, noise_mix: 0.13, res: 0.35
sleep 2
play 52.000, attack: 0.5, release: 2.5, amp: 0.32, cutoff: 80, detune: 28, noise_mix: 0.14, res: 0.30
sleep 5

# ============================================================
# Section IV: DISSOLUTION -- the ground breaks down
# 12-EDO motif, but each note gets random pitch deviation.
# Deviation increases per-note: the ground trembles, cracks, fractures,
# then liquefies. The concept of "note" dissolves.
#
# Pitch deviation schedule (cents, applied as MIDI offset):
#   Note 1-2: +-5 cents     (ground trembles)
#   Note 3-4: +-15 cents    (ground cracks)
#   Note 5-6: +-35 cents    (ground fractures)
#   Note 7-8: +-60 cents    (half-step territory)
#   Note 9-10: +-100 cents  (whole-step -- any note could be any other)
# Coda: root note with +-150 cents deviation. The root is no longer a root.
#
# Detune rises 28 -> 48. Noise_mix rises 0.14 -> 0.35. Amp decreases.
# Dust synth enters in coda as wraith fades.
# ============================================================

use_synth :kestrel_wraith
play 52.000 + rrand(-0.05, 0.05), attack: 0.3, release: 1.5, amp: 0.34, cutoff: 80, detune: 28, noise_mix: 0.14, res: 0.30
sleep 2
play 55.000 + rrand(-0.05, 0.05), attack: 0.3, release: 1.5, amp: 0.32, cutoff: 82, detune: 30, noise_mix: 0.15, res: 0.35
sleep 2
play 57.000 + rrand(-0.15, 0.15), attack: 0.3, release: 1.5, amp: 0.30, cutoff: 84, detune: 32, noise_mix: 0.16, res: 0.35
sleep 2
play 59.000 + rrand(-0.15, 0.15), attack: 0.3, release: 1.5, amp: 0.28, cutoff: 82, detune: 34, noise_mix: 0.17, res: 0.35
sleep 2
play 62.000 + rrand(-0.35, 0.35), attack: 0.5, release: 2.0, amp: 0.28, cutoff: 80, detune: 36, noise_mix: 0.18, res: 0.30
sleep 2.5
play 62.000 + rrand(-0.35, 0.35), attack: 0.3, release: 1.5, amp: 0.26, cutoff: 80, detune: 38, noise_mix: 0.20, res: 0.30
sleep 2
play 59.000 + rrand(-0.60, 0.60), attack: 0.3, release: 1.5, amp: 0.24, cutoff: 82, detune: 40, noise_mix: 0.22, res: 0.35
sleep 2
play 57.000 + rrand(-0.60, 0.60), attack: 0.3, release: 1.5, amp: 0.22, cutoff: 84, detune: 42, noise_mix: 0.24, res: 0.35
sleep 2
play 55.000 + rrand(-1.00, 1.00), attack: 0.3, release: 1.5, amp: 0.20, cutoff: 82, detune: 44, noise_mix: 0.26, res: 0.35
sleep 2
play 52.000 + rrand(-1.00, 1.00), attack: 0.5, release: 2.0, amp: 0.18, cutoff: 78, detune: 46, noise_mix: 0.28, res: 0.30
sleep 3

use_synth :kestrel_wraith
play 52.000 + rrand(-1.50, 1.50), attack: 0.5, release: 2.5, amp: 0.14, cutoff: 75, detune: 48, noise_mix: 0.32, res: 0.30
sleep 3
use_synth :kestrel_dust
play 52.000 + rrand(-1.50, 1.50), attack: 1.0, release: 3.5, amp: 0.10, cutoff: 70, res: 0.25
sleep 4
use_synth :kestrel_dust
play 52.000 + rrand(-2.00, 2.00), attack: 1.5, release: 5.0, amp: 0.06, cutoff: 65, res: 0.20
sleep 6