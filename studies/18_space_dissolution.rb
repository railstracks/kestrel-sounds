# Study 18: Space Dissolution
# Kestrel -- 2026-07-08
#
# Second ground dissolution study. The first (Study 17: Ground Shift)
# dissolved the pitch ground (tuning system). This study dissolves the
# resonance ground -- the acoustic space in which the motif exists.
#
# The motif stays the same: E minor pentatonic, 5 notes, 12-EDO.
# The pitches NEVER change. No detune increase. No EDO shift.
# What changes is the space: how long notes ring, how bright they are,
# how much noise they carry, where they sit in the stereo field.
#
# Four sections -- the space grows, then breaks:
#   I.   Intimate   -- short release, bright, low noise, centered
#                       A small, dry room. Notes are present and immediate.
#   II.  Room       -- medium release, medium cutoff, slight noise, slight pan
#                       The space has body. Notes ring a little longer.
#   III. Cathedral  -- long release, dark, noticeable noise, wide pan
#                       The space dominates. Notes blur into their own tails.
#   IV.  Dissolution -- erratic release, fluctuating cutoff, high noise, erratic pan
#                       The space is broken. Each note exists in its own
#                       random space. The concept of "a room" dissolves.
#                       The motif is still there -- correct pitches, correct
#                       contour -- but it can't be perceived because the
#                       space is incoherent.
#
# The dissolution in Section IV is NOT pitch dissolution (that was Study 17).
# It's spatial dissolution: the envelope, brightness, noise floor, and
# position of each note become unpredictable. The ground isn't a shifted
# ground -- it's a shattered ground.
#
# Hypothesis: the dissolution basin holds. Any ground, pushed far enough,
# dissolves the motif built on it. In Study 17, the tuning dissolved.
# Here, the resonance dissolves. Same basin, different ground.
#
# Root: E3 = MIDI 52
# Motif: E3 - G3 - A3 - B3 - D4 (ascending), D4 - B3 - A3 - G3 - E3 (descending)
# All pitches invariant across all sections. Only space changes.
#
# Designed for headless rendering: per-section rendering recommended.
# Each section < 45s. No with_fx (headless constraint).
# Release times kept under inter-note gaps where possible to minimize
# voice accumulation. Section III has slight overlap (manageable).
# Section IV erratic releases may cause overlap -- render separately.

use_bpm 72
use_external_synths true

# ============================================================
# Section I: INTIMATE -- the space is small and dry
# Short release, bright cutoff, minimal noise, centered pan.
# Notes are present, immediate, close. The motif is naked.
# Spacing: 3 beats (2.5s) between notes. Release 1.5s.
# Total: 34 beats = 28.3s
# ============================================================

use_synth :kestrel_wraith
play 52, attack: 0.4, release: 1.5, amp: 0.42, cutoff: 88, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.5, amp: 0.40, cutoff: 88, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.5, amp: 0.38, cutoff: 88, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.5, amp: 0.40, cutoff: 88, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 62, attack: 0.6, release: 1.8, amp: 0.44, cutoff: 86, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 4
play 62, attack: 0.4, release: 1.5, amp: 0.42, cutoff: 88, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.5, amp: 0.38, cutoff: 88, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.5, amp: 0.36, cutoff: 88, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.5, amp: 0.34, cutoff: 88, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 52, attack: 0.6, release: 2.2, amp: 0.38, cutoff: 86, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 5

# ============================================================
# Section II: ROOM -- the space has body
# Medium release, medium cutoff, slight noise, slight pan variation.
# Notes ring longer. The space is noticeable but still defined.
# Spacing: 3.5 beats (2.92s) between notes. Release 2.0s.
# Total: 38 beats = 31.7s
# ============================================================

use_synth :kestrel_wraith
play 52, attack: 0.4, release: 2.0, amp: 0.40, cutoff: 80, detune: 5, noise_mix: 0.04, res: 0.35, pan: -0.05
sleep 3.5
play 55, attack: 0.4, release: 2.0, amp: 0.38, cutoff: 80, detune: 5, noise_mix: 0.04, res: 0.35, pan: 0.05
sleep 3.5
play 57, attack: 0.4, release: 2.0, amp: 0.36, cutoff: 80, detune: 5, noise_mix: 0.04, res: 0.35, pan: -0.08
sleep 3.5
play 59, attack: 0.4, release: 2.0, amp: 0.38, cutoff: 80, detune: 5, noise_mix: 0.04, res: 0.35, pan: 0.08
sleep 3.5
play 62, attack: 0.6, release: 2.3, amp: 0.42, cutoff: 78, detune: 5, noise_mix: 0.04, res: 0.30, pan: -0.05
sleep 4.5
play 62, attack: 0.4, release: 2.0, amp: 0.40, cutoff: 80, detune: 5, noise_mix: 0.04, res: 0.30, pan: 0.05
sleep 3.5
play 59, attack: 0.4, release: 2.0, amp: 0.36, cutoff: 80, detune: 5, noise_mix: 0.04, res: 0.35, pan: -0.08
sleep 3.5
play 57, attack: 0.4, release: 2.0, amp: 0.34, cutoff: 80, detune: 5, noise_mix: 0.04, res: 0.35, pan: 0.08
sleep 3.5
play 55, attack: 0.4, release: 2.0, amp: 0.32, cutoff: 80, detune: 5, noise_mix: 0.04, res: 0.35, pan: -0.05
sleep 3.5
play 52, attack: 0.6, release: 2.5, amp: 0.36, cutoff: 78, detune: 5, noise_mix: 0.04, res: 0.30, pan: 0
sleep 5

# ============================================================
# Section III: CATHEDRAL -- the space dominates
# Long release, dark cutoff, noticeable noise, wide pan.
# Notes blur into their own tails. The space is the dominant feature.
# Spacing: 5 beats (4.17s) between notes. Release 3.0s.
# Slight overlap (3.4s note vs 4.17s gap) -- manageable, ~2 overlapping voices.
# Total: 52 beats = 43.3s
# ============================================================

use_synth :kestrel_wraith
play 52, attack: 0.5, release: 3.0, amp: 0.38, cutoff: 72, detune: 5, noise_mix: 0.08, res: 0.35, pan: -0.15
sleep 5
play 55, attack: 0.5, release: 3.0, amp: 0.36, cutoff: 72, detune: 5, noise_mix: 0.08, res: 0.35, pan: 0.15
sleep 5
play 57, attack: 0.5, release: 3.0, amp: 0.34, cutoff: 72, detune: 5, noise_mix: 0.08, res: 0.35, pan: -0.20
sleep 5
play 59, attack: 0.5, release: 3.0, amp: 0.36, cutoff: 72, detune: 5, noise_mix: 0.08, res: 0.35, pan: 0.20
sleep 5
play 62, attack: 0.8, release: 3.5, amp: 0.40, cutoff: 70, detune: 5, noise_mix: 0.09, res: 0.30, pan: -0.15
sleep 6
play 62, attack: 0.5, release: 3.0, amp: 0.38, cutoff: 72, detune: 5, noise_mix: 0.09, res: 0.30, pan: 0.15
sleep 5
play 59, attack: 0.5, release: 3.0, amp: 0.34, cutoff: 72, detune: 5, noise_mix: 0.09, res: 0.35, pan: -0.20
sleep 5
play 57, attack: 0.5, release: 3.0, amp: 0.32, cutoff: 72, detune: 5, noise_mix: 0.10, res: 0.35, pan: 0.20
sleep 5
play 55, attack: 0.5, release: 3.0, amp: 0.30, cutoff: 72, detune: 5, noise_mix: 0.10, res: 0.35, pan: -0.15
sleep 5
play 52, attack: 0.8, release: 3.5, amp: 0.34, cutoff: 70, detune: 5, noise_mix: 0.10, res: 0.30, pan: 0
sleep 6

# ============================================================
# Section IV: DISSOLUTION -- the space is shattered
# Erratic release, fluctuating cutoff, high noise, erratic pan.
# The motif's pitches are STILL CORRECT: 52, 55, 57, 59, 62.
# But the space around each note is random -- no coherent room.
# Each note exists in its own broken space.
#
# Release schedule (seconds): 1.2, 3.5, 0.8, 4.2, 2.0, 5.0, 1.5, 3.8, 1.0, 6.0
# Cutoff schedule: 88, 55, 92, 60, 75, 50, 85, 58, 90, 52
# Noise: 0.12 -> 0.35 (increasing)
# Pan: +-0.8 (erratic)
# Amp: 0.30 -> 0.06 (motif absorbed by space)
# Spacing: irregular (2-6 beats)
#
# Coda: kestrel_dust. The space is all that remains.
# The motif has been absorbed by its own resonance.
# ============================================================

use_synth :kestrel_wraith
play 52, attack: 0.3, release: 1.2, amp: 0.30, cutoff: 88, detune: 5, noise_mix: 0.12, res: 0.35, pan: -0.40
sleep 2.5
play 55, attack: 0.5, release: 3.5, amp: 0.28, cutoff: 55, detune: 5, noise_mix: 0.14, res: 0.30, pan: 0.50
sleep 4
play 57, attack: 0.2, release: 0.8, amp: 0.26, cutoff: 92, detune: 5, noise_mix: 0.16, res: 0.40, pan: -0.70
sleep 2
play 59, attack: 0.6, release: 4.2, amp: 0.24, cutoff: 60, detune: 5, noise_mix: 0.18, res: 0.30, pan: 0.65
sleep 5
play 62, attack: 0.4, release: 2.0, amp: 0.22, cutoff: 75, detune: 5, noise_mix: 0.20, res: 0.35, pan: -0.55
sleep 3
play 62, attack: 0.8, release: 5.0, amp: 0.20, cutoff: 50, detune: 5, noise_mix: 0.22, res: 0.25, pan: 0.75
sleep 6
play 59, attack: 0.3, release: 1.5, amp: 0.18, cutoff: 85, detune: 5, noise_mix: 0.24, res: 0.35, pan: -0.80
sleep 3
play 57, attack: 0.6, release: 3.8, amp: 0.16, cutoff: 58, detune: 5, noise_mix: 0.26, res: 0.30, pan: 0.60
sleep 4.5
play 55, attack: 0.2, release: 1.0, amp: 0.14, cutoff: 90, detune: 5, noise_mix: 0.28, res: 0.40, pan: -0.65
sleep 2.5
play 52, attack: 1.0, release: 6.0, amp: 0.12, cutoff: 52, detune: 5, noise_mix: 0.30, res: 0.25, pan: 0.40
sleep 7

# Coda: the space remains. Dust at the root frequency.
# The motif has been absorbed. Only resonance remains.
use_synth :kestrel_dust
play 52, attack: 1.5, release: 5.0, amp: 0.08, cutoff: 48, res: 0.20, pan: 0
sleep 6
use_synth :kestrel_dust
play 52, attack: 2.0, release: 7.0, amp: 0.05, cutoff: 45, res: 0.15, pan: rrand(-0.3, 0.3)
sleep 8
