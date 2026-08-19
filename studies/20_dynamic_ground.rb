# Study 20: Dynamic/Range Ground Dissolution
# Kestrel -- 2026-07-09
#
# Fourth ground dissolution study. The first three dissolved:
#   Study 17 -- pitch ground (tuning system shifts)
#   Study 18 -- space ground (resonance environment shatters)
#   Study 19 -- temporal ground (beat/grid becomes incoherent)
#
# This study dissolves the dynamic ground -- the available loudness space
# in which the motif expresses itself. The motif, synth, space, timing,
# and pitches ALL stay constant. What changes is the dynamic range: the
# contrast between loud and quiet notes.
#
# The motif has a dynamic contour: the peak notes (D4 in both directions)
# are loudest, the middle notes are quieter. This contour is part of how
# we perceive the motif -- not just the pitches, but the emphasis shape.
# Dissolve that contrast and the motif loses a dimension of identity.
#
# This is NOT the same as degradation (Study 01: Erosion). In degradation,
# the figure itself decays -- notes get progressively quieter because the
# material is eroding. In dynamic ground dissolution, the GROUND -- the
# available dynamic space -- collapses. The notes don't decay; they flatten.
# The variance goes to zero, not the mean. And in the dissolution section,
# the flat line itself drops to silence -- the ground has not just
# compressed but dissolved.
#
# Four sections -- the dynamic space narrows, flattens, then collapses:
#   I.   FULL RANGE -- wide dynamic contrast. The motif breathes.
#                       Loudest notes at 0.55, quietest at 0.12.
#                       The dynamic contour is vivid and expressive.
#   II.  COMPRESSED -- the range narrows. Same contour, reduced contrast.
#                       Loudest at 0.42, quietest at 0.24.
#                       Like listening through a compressor. The shape
#                       is still there but flattened.
#   III. FLAT       -- all notes at 0.30. No dynamic contrast at all.
#                       The dynamic dimension has collapsed to a point.
#                       The motif is still a melody but it has lost its
#                       dynamic voice. Every note is the same.
#   IV.  DISSOLUTION -- amplitudes become random (no relation to contour),
#                       then converge to near-silence (0.02-0.04).
#                       The dynamic ground is incoherent and then gone.
#                       The motif is a ghost: present in pitch and time
#                       but absent in dynamic life.
#
# Hypothesis: the dissolution basin holds at the dynamic level.
# The dynamic ground is different from the other three grounds because
# it operates on variance rather than substance. Pitch ground dissolves
# what notes ARE. Space ground dissolves what notes EXIST IN. Temporal
# ground dissolves the BETWEEN. Dynamic ground dissolves the CONTRAST --
# the internal shape that makes the motif expressive, not just correct.
#
# Dissolution signature prediction: amplitude variance collapses from
# I to III (not the mean -- the variance). In IV, the mean itself drops
# to near-zero. This produces a different dissolution signature from
# Studies 17-19: the path to silence goes THROUGH flatness. The motif
# doesn't fade -- it flattens and then the flat line drops to zero.
#
# Root: E3 = MIDI 52
# Motif: E3 - G3 - A3 - B3 - D4 (ascending), D4 - B3 - A3 - G3 - E3 (descending)
# All pitches, timing, synth, and space parameters invariant.
# Only amp changes.
#
# Constant parameters (same in every section, every note):
#   use_synth :kestrel_wraith
#   attack: 0.4, release: 1.8, cutoff: 80, detune: 5,
#   noise_mix: 0.03, res: 0.35, pan: 0
#
# Timing: 3 beats between notes, 4 beats at phrase peak, 5 beats at cadence.
# Same timing schedule in every section.
#
# Designed for headless rendering: single-pass (constant short release,
# no voice accumulation risk).

use_bpm 72
use_external_synths true

# ============================================================
# Section I: FULL RANGE -- the dynamic ground is wide open
# The motif has its full expressive dynamic contour.
# Peak notes (D4) at 0.55, quiet notes (A3) at 0.12.
# The dynamic shape is part of the motif's identity.
# Total: 34 beats = 28.3s
# ============================================================

use_synth :kestrel_wraith
play 52, attack: 0.4, release: 1.8, amp: 0.35, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.8, amp: 0.22, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.12, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.28, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 62, attack: 0.6, release: 2.0, amp: 0.55, cutoff: 78, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 4
play 62, attack: 0.4, release: 1.8, amp: 0.50, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.26, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.14, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.8, amp: 0.20, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 52, attack: 0.6, release: 2.2, amp: 0.42, cutoff: 78, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 5

# ============================================================
# Section II: COMPRESSED -- the dynamic range narrows
# Same contour, reduced contrast. Like a compressor with 2:1 ratio.
# Loudest at 0.42, quietest at 0.24. The shape is still there but
# the dynamic vocabulary has been flattened. The motif is still
# recognizable but less expressive -- it has lost dynamic depth.
# Total: 34 beats = 28.3s
# ============================================================

use_synth :kestrel_wraith
play 52, attack: 0.4, release: 1.8, amp: 0.34, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.8, amp: 0.28, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.24, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.32, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 62, attack: 0.6, release: 2.0, amp: 0.42, cutoff: 78, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 4
play 62, attack: 0.4, release: 1.8, amp: 0.40, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.30, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.26, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.8, amp: 0.28, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 52, attack: 0.6, release: 2.2, amp: 0.36, cutoff: 78, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 5

# ============================================================
# Section III: FLAT -- the dynamic dimension has collapsed
# All notes at 0.30. No dynamic contrast at all.
# The motif is still a melody -- pitches, timing, and space are
# all correct -- but it has lost its dynamic voice.
# Every note is the same. The dynamic ground is a single point.
# Total: 34 beats = 28.3s
# ============================================================

use_synth :kestrel_wraith
play 52, attack: 0.4, release: 1.8, amp: 0.30, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.8, amp: 0.30, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.30, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.30, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 62, attack: 0.6, release: 2.0, amp: 0.30, cutoff: 78, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 4
play 62, attack: 0.4, release: 1.8, amp: 0.30, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.30, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.30, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.8, amp: 0.30, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 52, attack: 0.6, release: 2.2, amp: 0.30, cutoff: 78, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 5

# ============================================================
# Section IV: DISSOLUTION -- the dynamic ground collapses
# Two phases:
#   A) Dynamic incoherence -- amplitudes are random (0.08-0.45),
#      no relation to the motif's original contour. The dynamic
#      ground is noise -- not a compressed range, but a broken one.
#   B) Dynamic collapse -- all notes converge to near-silence
#      (0.02-0.04). The dynamic ground has collapsed to zero.
#      The motif is a ghost: present in pitch and time but
#      dynamically absent.
#
# Phase A (notes 1-5): amp schedule 0.08, 0.45, 0.14, 0.38, 0.10
#   -- inverted and erratic. The note that was loudest (D4) is now
#      quiet. The note that was quietest (A3) is now loud. The
#      dynamic contour is broken.
# Phase B (notes 6-10): amp schedule 0.04, 0.03, 0.02, 0.02, 0.01
#   -- converging to silence. The dynamic ground is gone.
#
# Total: 34 beats = 28.3s
# ============================================================

# Phase A: dynamic incoherence
use_synth :kestrel_wraith
play 52, attack: 0.4, release: 1.8, amp: 0.08, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.8, amp: 0.45, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.14, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.38, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 62, attack: 0.6, release: 2.0, amp: 0.10, cutoff: 78, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 4

# Phase B: dynamic collapse
use_synth :kestrel_wraith
play 62, attack: 0.4, release: 1.8, amp: 0.04, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.03, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.02, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.8, amp: 0.02, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 52, attack: 0.6, release: 2.2, amp: 0.01, cutoff: 78, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 5

# Coda: dynamic silence. Dust at the root.
# The motif has been dissolved by the collapse of its dynamic ground.
# Not by degradation, not by tuning shift, not by space or time --
# but by the loss of the very dimension of loudness contrast.
use_synth :kestrel_dust
play 52, attack: 1.5, release: 5.0, amp: 0.05, cutoff: 48, res: 0.20, pan: 0
sleep 6
use_synth :kestrel_dust
play 52, attack: 2.0, release: 7.0, amp: 0.03, cutoff: 45, res: 0.15, pan: 0
sleep 8