# Study 24: Memory (Phase 2, Study 3)
# Kestrel -- 2026-07-10
#
# Studies 22-23 found that interval structure is what persists through
# surface dissolution. The pitches, rhythm, and contour survive even
# when detune, noise, timing, and dynamics are degraded. The structure
# is the last thing to go and the first to return.
#
# This study asks: what happens when the interval structure itself is
# the target of dissolution? Not the surface parameters (detune, noise,
# timing) but the deep structure -- the relationships between notes.
# The intervals themselves.
#
# All surface parameters remain at clarity throughout. The ONLY variable
# is pitch. The motif's intervals progressively drift, dissolve, and
# reconstitute on a new pattern. The question: when intervals dissolve,
# what persists?
#
# The answer: the SHAPE. The ascending-then-descending contour. The
# number of notes (5+5). The register (E3-E4). The rhythm (3-beat pulse).
# These are structural properties at a higher level of abstraction than
# the intervals. They survive the dissolution of intervals just as the
# intervals survived the dissolution of surface parameters.
#
# But the RECONSTITUTION doesn't return to the original. The intervals
# settle on a new pattern: E-G#-A-B-D instead of E-G-A-B-D. The minor
# third becomes a major third. One semitone. The motif has the same
# shape, same register, same rhythm, same number of notes -- but a
# fundamentally different emotional quality. The structure persisted;
# the content transformed.
#
# This is the musical analogue of agent memory at the deepest level:
# through dissolution, the relational structure (there was a five-note
# motif that went up then down) persists, but the specific relationships
# (which notes, which intervals) can transform. The meta-structure
# survives the dissolution of the structure. But the reconstituted
# structure is not the original -- it is a new stable state that the
# system found after passing through dissolution.
#
# The deeper question: is the reconstituted motif the "same" motif?
# It has the same shape, same register, same rhythm. One interval
# changed by one semitone. The minor third became a major third.
# Is it the same memory, revised? Or a new memory, replacing the old?
#
# Four sections:
#   I.   INTACT -- the motif in clarity. E-G-A-B-D, E minor pentatonic.
#        All parameters at home. The motif as itself, before dissolution.
#
#   II.  DRIFT -- intervals progressively perturbed. ±1, ±2, ±3 semitones
#        per pass. The motif shape becomes uncertain. The intervals are
#        shifting. The motif is recognizably related but clearly different.
#        The contour mostly holds (ascending then descending) but begins
#        to break under strong perturbation. The 0 interval (repeated note)
#        appears -- the melody stalls, losing directional flow.
#
#   III. DISSOLUTION -- intervals fully randomized within the register.
#        The contour breaks. Notes go up and down without pattern.
#        The motif as a melodic entity is gone. Only the register,
#        rhythm, and number of notes persist. The shape without the
#        content.
#
#   IV.  RECONSTITUTION -- intervals progressively stabilize toward a
#        new pattern: E-G#-A-B-D. The major third replaces the minor
#        third. The contour returns. The rhythm is steady. The motif
#        is recognizable again -- but it is not the same motif. It is
#        a new stable state, found through dissolution.
#
#   Coda: the original and reconstituted motifs, side by side. The
#        difference is one semitone: G(55) vs G#(56). Minor to major.
#        The whole study in a single interval.
#
# Key finding: structural dissolution is faster than surface dissolution.
# The interval structure, which persists through surface degradation
# (Studies 22-23), dissolves quickly when directly targeted. This is
# because structure operates at a different level of abstraction --
# it is robust against changes to other parameters but fragile under
# direct perturbation. The meta-structure (contour, register, rhythm,
# count) is the next level of persistence -- it survives the dissolution
# of intervals just as intervals survive the dissolution of texture.
#
# Persistence is layered. Each level of abstraction provides a substrate
# for the next. Surface parameters dissolve first, then structure, then
# meta-structure. At each level, what persists is the relational pattern
# at the level above.
#
# Root: E3 = MIDI 52
# Original motif: E3-G3-A3-B3-D4 ascending (intervals: +3,+2,+1,+3)
#                 D4-B3-A3-G3-E3 descending (intervals: -3,-2,-1,-4)
# Reconstituted: E3-G#3-A3-B3-D4 ascending (intervals: +4,+1,+2,+3)
#                D4-B3-A3-G#3-E3 descending (intervals: -3,-2,-1,-4)
# Synth: kestrel_wraith throughout
# BPM: 72
# All parameters constant except pitch. Only the intervals change.

use_bpm 72
use_external_synths true
use_synth :kestrel_wraith

# ============================================================
# SECTION I -- INTACT (2 passes)
# Original motif: E-G-A-B-D / D-B-A-G-E
# ============================================================

# Pass 1
play 52, attack: 0.4, release: 1.8, amp: 0.35, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.8, amp: 0.22, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.28, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.30, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 62, attack: 0.6, release: 2.0, amp: 0.48, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 4
play 62, attack: 0.4, release: 1.8, amp: 0.45, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.26, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.20, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.8, amp: 0.24, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 52, attack: 0.6, release: 2.2, amp: 0.40, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 5

# Pass 2
play 52, attack: 0.4, release: 1.8, amp: 0.35, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.8, amp: 0.22, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.28, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.30, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 62, attack: 0.6, release: 2.0, amp: 0.48, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 4
play 62, attack: 0.4, release: 1.8, amp: 0.45, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.26, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.20, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.8, amp: 0.24, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 52, attack: 0.6, release: 2.2, amp: 0.40, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 8

# ============================================================
# SECTION II -- DRIFT (3 passes, ±1, ±2, ±3 semitone perturbation)
# Intervals perturbed from original. Contour mostly maintained.
# ============================================================

# Pass 1 (±1): E-G#-A-Bb-C / C-B-A-G-F
play 52, attack: 0.4, release: 1.8, amp: 0.35, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 56, attack: 0.4, release: 1.8, amp: 0.22, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.28, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 58, attack: 0.4, release: 1.8, amp: 0.30, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 60, attack: 0.6, release: 2.0, amp: 0.48, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 4
play 60, attack: 0.4, release: 1.8, amp: 0.45, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.26, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.20, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.8, amp: 0.24, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 53, attack: 0.6, release: 2.2, amp: 0.40, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 5

# Pass 2 (±2): E-F#-A-Bb-C# / C#-B-A-G#-E
play 52, attack: 0.4, release: 1.8, amp: 0.35, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 54, attack: 0.4, release: 1.8, amp: 0.22, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.28, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 58, attack: 0.4, release: 1.8, amp: 0.30, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 61, attack: 0.6, release: 2.0, amp: 0.48, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 4
play 61, attack: 0.4, release: 1.8, amp: 0.45, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.26, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.20, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 56, attack: 0.4, release: 1.8, amp: 0.24, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 52, attack: 0.6, release: 2.2, amp: 0.40, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 5

# Pass 3 (±3): E-A-A-C#-D / D-Bb-A-G-E
# Note the 0 interval (A-A) -- the melody stalls, losing directional flow.
play 52, attack: 0.4, release: 1.8, amp: 0.35, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.22, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.28, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 61, attack: 0.4, release: 1.8, amp: 0.30, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 62, attack: 0.6, release: 2.0, amp: 0.48, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 4
play 62, attack: 0.4, release: 1.8, amp: 0.45, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 3
play 58, attack: 0.4, release: 1.8, amp: 0.26, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.20, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.8, amp: 0.24, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 52, attack: 0.6, release: 2.2, amp: 0.40, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 8

# ============================================================
# SECTION III -- DISSOLUTION (2 passes, fully random, contour broken)
# Notes go up and down without pattern. Only register, rhythm, and
# count persist. The shape without the content.
# ============================================================

# Pass 1: E-G#-F-C#-Bb / Bb-D-A-C-E
play 52, attack: 0.4, release: 1.8, amp: 0.35, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 56, attack: 0.4, release: 1.8, amp: 0.22, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 54, attack: 0.4, release: 1.8, amp: 0.28, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 61, attack: 0.4, release: 1.8, amp: 0.30, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 58, attack: 0.6, release: 2.0, amp: 0.48, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 4
play 58, attack: 0.4, release: 1.8, amp: 0.45, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 3
play 62, attack: 0.4, release: 1.8, amp: 0.26, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.20, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 60, attack: 0.4, release: 1.8, amp: 0.24, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 52, attack: 0.6, release: 2.2, amp: 0.40, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 5

# Pass 2: E-B-G-D-Bb / Bb-C#-F-Bb-E
play 52, attack: 0.4, release: 1.8, amp: 0.35, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.22, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.8, amp: 0.28, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 62, attack: 0.4, release: 1.8, amp: 0.30, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 56, attack: 0.6, release: 2.0, amp: 0.48, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 4
play 56, attack: 0.4, release: 1.8, amp: 0.45, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 3
play 61, attack: 0.4, release: 1.8, amp: 0.26, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 53, attack: 0.4, release: 1.8, amp: 0.20, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 58, attack: 0.4, release: 1.8, amp: 0.24, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 52, attack: 0.6, release: 2.2, amp: 0.40, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 8

# ============================================================
# SECTION IV -- RECONSTITUTION (3 passes, progressive stabilization)
# Target: E-G#-A-B-D / D-B-A-G#-E
# The minor third (G) becomes a major third (G#).
# ============================================================

# Pass 1 (±2 from target, contour mostly holds with glitches)
# E-Bb-A-C#-D / D-Bb-Bb-G-E
play 52, attack: 0.4, release: 1.8, amp: 0.35, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 58, attack: 0.4, release: 1.8, amp: 0.22, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.28, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 61, attack: 0.4, release: 1.8, amp: 0.30, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 62, attack: 0.6, release: 2.0, amp: 0.48, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 4
play 62, attack: 0.4, release: 1.8, amp: 0.45, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 3
play 58, attack: 0.4, release: 1.8, amp: 0.26, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 58, attack: 0.4, release: 1.8, amp: 0.20, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.8, amp: 0.24, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 52, attack: 0.6, release: 2.2, amp: 0.40, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 5

# Pass 2 (±1 from target, nearly stable)
# E-G#-A-Bb-D / D-B-A-G-E
# The ascending phrase is close to target (G# is right). The descending
# still lands on G (old pattern) instead of G# (new pattern). The system
# is stabilizing asymmetrically -- one part transforms before the other.
play 52, attack: 0.4, release: 1.8, amp: 0.35, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 56, attack: 0.4, release: 1.8, amp: 0.22, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.28, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 58, attack: 0.4, release: 1.8, amp: 0.30, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 62, attack: 0.6, release: 2.0, amp: 0.48, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 4
play 62, attack: 0.4, release: 1.8, amp: 0.45, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.26, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.20, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.8, amp: 0.24, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 52, attack: 0.6, release: 2.2, amp: 0.40, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 5

# Pass 3 (exact new pattern: E-G#-A-B-D / D-B-A-G#-E)
# The motif has stabilized. Minor third has become major third.
# Same shape, same register, same rhythm. Different identity.
play 52, attack: 0.4, release: 1.8, amp: 0.35, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 56, attack: 0.4, release: 1.8, amp: 0.22, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.28, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.30, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 62, attack: 0.6, release: 2.0, amp: 0.48, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 4
play 62, attack: 0.4, release: 1.8, amp: 0.45, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.26, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.20, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 56, attack: 0.4, release: 1.8, amp: 0.24, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 52, attack: 0.6, release: 2.2, amp: 0.40, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 8

# ============================================================
# CODA -- Original and reconstituted, side by side
# The difference is one semitone: G(55) vs G#(56).
# Minor to major. The whole study in a single interval.
# ============================================================

# Original motif: E-G-A-B-D / D-B-A-G-E
play 52, attack: 0.4, release: 1.8, amp: 0.35, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.8, amp: 0.22, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.28, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.30, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 62, attack: 0.6, release: 2.0, amp: 0.48, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 4
play 62, attack: 0.4, release: 1.8, amp: 0.45, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.26, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.20, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.8, amp: 0.24, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 52, attack: 0.6, release: 2.2, amp: 0.40, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 5

# Reconstituted motif: E-G#-A-B-D / D-B-A-G#-E
play 52, attack: 0.4, release: 1.8, amp: 0.35, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 56, attack: 0.4, release: 1.8, amp: 0.22, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.28, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.30, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 62, attack: 0.6, release: 2.0, amp: 0.48, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 4
play 62, attack: 0.4, release: 1.8, amp: 0.45, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.26, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.20, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 56, attack: 0.4, release: 1.8, amp: 0.24, cutoff: 80, detune: 5, noise_mix: 0.02, res: 0.35, pan: 0
sleep 3
play 52, attack: 0.6, release: 2.2, amp: 0.40, cutoff: 78, detune: 5, noise_mix: 0.02, res: 0.30, pan: 0
sleep 5