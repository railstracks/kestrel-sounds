# Study 22: Persistence (Phase 2 Opening)
# Kestrel -- 2026-07-10
#
# Phase 1 (Studies 1-21) explored dissolution. Four axes, 21 studies,
# ~200 minutes, one dissolution basin. Every parametric process, pushed
# far enough, dissolves the material it operates on.
#
# Phase 2 asks the inverse: what persists through dissolution?
#
# This study inverts the Phase 1 structure. Instead of starting clear
# and dissolving, it starts in full dissolution and EMERGES toward
# clarity. The motif is subjected to all four dissolution axes
# simultaneously -- degradation, translation, ground, and interaction --
# and then each axis stabilizes in turn. The question: what is the last
# thing recognizable as the motif? What survives when everything else
# fails?
#
# Four sections -- emergence from dissolution:
#   I.   FULL DISSOLUTION -- all parameters degraded simultaneously.
#        Pitches detuned (random +-200 cents), timing erratic (1-14 beat
#        gaps), dynamics random (0.02-0.50), space unstable (erratic
#        release/cutoff/pan), noise high (0.35-0.50). The motif is
#        buried under every dissolution axis at once.
#        Can you hear it? The interval structure is still there --
#        E-G-A-B-D -- but every parameter that makes it legible is
#        broken. The motif exists as a ghost: present in structure,
#        absent in perception.
#
#   II.  GROUND EMERGES -- the ground stabilizes. Tuning returns to
#        12-EDO (pitches exact). Space becomes consistent (fixed
#        release, cutoff, pan). But the figure is still degraded:
#        timing erratic, dynamics random, noise still present (0.15).
#        The motif becomes partially visible. The pitches are right,
#        the space is stable, but the rhythm is broken and the dynamics
#        are incoherent. You can hear the pentatonic shape -- the
#        interval structure survives even when temporal and dynamic
#        grounds are broken.
#
#   III. FIGURE EMERGES -- the figure stabilizes too. Timing becomes
#        regular (3-beat pulse), dynamics return to the contour (peak
#        notes loudest). But noise remains (0.08) and detuning is still
#        present (+-15 cents). The motif is recognizable now. You can
#        hear it clearly through the haze. The interval structure,
#        rhythm, and dynamic contour are all intact. What remains
#        degraded is the timbre -- the noise and detuning make it
#        sound weathered, old, like a memory of itself.
#
#   IV.  CLARITY -- all parameters return to home values. The motif,
#        fully intact. No noise, no detuning, regular timing, natural
#        dynamics, stable space. After three sections of dissolution,
#        the plain motif sounds different -- not because it changed,
#        but because you heard what it survived. The interval structure
#        was there all along. It was the last thing to go and the
#        first thing to return. It IS the motif.
#
# Hypothesis: the interval structure (minor third, perfect fourth,
# perfect fifth, minor seventh) is what persists through dissolution.
# It is recognizable even in full dissolution because relationships
# survive when the things they relate do not. This is the musical
# analogue of the agent memory insight: what persists through
# dissolution isn't individual facts (notes) but structure
# (relationships between notes). The motif is not five notes. The
# motif is the interval structure that five notes instantiate.
#
# The study inverts Phase 1's trajectory. Phase 1: clarity -> dissolution.
# Phase 2: dissolution -> clarity. The path through the basin is the
# same; the direction is reversed. What Phase 1 showed: everything
# dissolves. What Phase 2 asks: what comes back?
#
# Root: E3 = MIDI 52
# Motif: E3 - G3 - A3 - B3 - D4 (ascending), D4 - B3 - A3 - G3 - E3 (descending)
# Synth: kestrel_wraith throughout (the voice that was there for all 21
# Phase 1 studies is here for the first Phase 2 study).
#
# Designed for headless rendering. Per-section rendering recommended:
# Section I has extreme parameter ranges that may stress scsynth.
# Total estimated duration: ~180s (30s per section + transitions).

use_bpm 72
use_external_synths true

# ============================================================
# Section I: FULL DISSOLUTION
# The motif buried under all four dissolution axes simultaneously.
# Pitches: detuned +-200 cents (random per note)
# Timing: erratic (1-14 beat gaps)
# Dynamics: random (0.02-0.50)
# Space: erratic (release 0.8-6.0s, cutoff 50-92, pan +-0.80)
# Noise: high (0.35-0.50)
# The interval structure is the only thing intact -- but can you hear it?
# Total: ~30s
# ============================================================

use_synth :kestrel_wraith

# Ascending motif, fully dissolved
play 52, attack: 0.4, release: 1.2, amp: 0.35, cutoff: 62, detune: 48, noise_mix: 0.42, res: 0.45, pan: -0.6
sleep 7
play 55, attack: 0.3, release: 3.5, amp: 0.12, cutoff: 88, detune: -37, noise_mix: 0.38, res: 0.25, pan: 0.7
sleep 2
play 57, attack: 0.6, release: 0.9, amp: 0.45, cutoff: 54, detune: 22, noise_mix: 0.50, res: 0.50, pan: -0.3
sleep 11
play 59, attack: 0.2, release: 2.8, amp: 0.08, cutoff: 79, detune: -55, noise_mix: 0.35, res: 0.30, pan: 0.5
sleep 4
play 62, attack: 0.5, release: 4.2, amp: 0.28, cutoff: 67, detune: 41, noise_mix: 0.46, res: 0.40, pan: -0.8
sleep 6

# Descending motif, fully dissolved
play 62, attack: 0.3, release: 1.5, amp: 0.18, cutoff: 85, detune: -29, noise_mix: 0.40, res: 0.28, pan: 0.4
sleep 3
play 59, attack: 0.5, release: 5.0, amp: 0.42, cutoff: 58, detune: 35, noise_mix: 0.48, res: 0.48, pan: -0.5
sleep 9
play 57, attack: 0.2, release: 0.8, amp: 0.06, cutoff: 91, detune: -18, noise_mix: 0.36, res: 0.22, pan: 0.6
sleep 5
play 55, attack: 0.4, release: 2.2, amp: 0.31, cutoff: 73, detune: 52, noise_mix: 0.44, res: 0.38, pan: -0.2
sleep 8
play 52, attack: 0.6, release: 3.8, amp: 0.22, cutoff: 64, detune: -44, noise_mix: 0.42, res: 0.42, pan: 0.3
sleep 6

# ============================================================
# Section II: GROUND EMERGES
# The ground stabilizes: pitches exact (12-EDO), space consistent.
# The figure is still degraded: timing erratic, dynamics random.
# Noise reduced but present (0.15).
# The interval structure becomes audible. The motif is partially visible.
# Total: ~30s
# ============================================================

use_synth :kestrel_wraith

# Ascending motif -- pitches exact, space stable, timing/dynamics broken
play 52, attack: 0.4, release: 1.8, amp: 0.22, cutoff: 80, detune: 5, noise_mix: 0.15, res: 0.35, pan: 0
sleep 8
play 55, attack: 0.4, release: 1.8, amp: 0.41, cutoff: 80, detune: 5, noise_mix: 0.15, res: 0.35, pan: 0
sleep 2
play 57, attack: 0.4, release: 1.8, amp: 0.09, cutoff: 80, detune: 5, noise_mix: 0.15, res: 0.35, pan: 0
sleep 11
play 59, attack: 0.4, release: 1.8, amp: 0.33, cutoff: 80, detune: 5, noise_mix: 0.15, res: 0.35, pan: 0
sleep 4
play 62, attack: 0.6, release: 2.0, amp: 0.47, cutoff: 78, detune: 5, noise_mix: 0.15, res: 0.30, pan: 0
sleep 5

# Descending motif -- pitches exact, space stable, timing/dynamics broken
play 62, attack: 0.4, release: 1.8, amp: 0.15, cutoff: 80, detune: 5, noise_mix: 0.15, res: 0.30, pan: 0
sleep 7
play 59, attack: 0.4, release: 1.8, amp: 0.38, cutoff: 80, detune: 5, noise_mix: 0.15, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.07, cutoff: 80, detune: 5, noise_mix: 0.15, res: 0.35, pan: 0
sleep 9
play 55, attack: 0.4, release: 1.8, amp: 0.29, cutoff: 80, detune: 5, noise_mix: 0.15, res: 0.35, pan: 0
sleep 5
play 52, attack: 0.6, release: 2.2, amp: 0.44, cutoff: 78, detune: 5, noise_mix: 0.15, res: 0.30, pan: 0
sleep 4

# ============================================================
# Section III: FIGURE EMERGES
# The figure stabilizes: timing regular (3-beat pulse), dynamics contour.
# But noise (0.08) and detuning (+-15 cents) remain.
# The motif is recognizable. Weathered but present.
# Total: ~34s
# ============================================================

use_synth :kestrel_wraith

# Ascending motif -- regular timing, contour dynamics, residual noise/detune
play 52, attack: 0.4, release: 1.8, amp: 0.35, cutoff: 80, detune: 12, noise_mix: 0.08, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.8, amp: 0.22, cutoff: 80, detune: -8, noise_mix: 0.08, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.28, cutoff: 80, detune: 15, noise_mix: 0.08, res: 0.35, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.30, cutoff: 80, detune: -11, noise_mix: 0.08, res: 0.35, pan: 0
sleep 3
play 62, attack: 0.6, release: 2.0, amp: 0.48, cutoff: 78, detune: 9, noise_mix: 0.08, res: 0.30, pan: 0
sleep 4

# Descending motif -- regular timing, contour dynamics, residual noise/detune
play 62, attack: 0.4, release: 1.8, amp: 0.45, cutoff: 80, detune: -14, noise_mix: 0.08, res: 0.30, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.26, cutoff: 80, detune: 11, noise_mix: 0.08, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.20, cutoff: 80, detune: -7, noise_mix: 0.08, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.8, amp: 0.24, cutoff: 80, detune: 13, noise_mix: 0.08, res: 0.35, pan: 0
sleep 3
play 52, attack: 0.6, release: 2.2, amp: 0.40, cutoff: 78, detune: -10, noise_mix: 0.08, res: 0.30, pan: 0
sleep 5

# ============================================================
# Section IV: CLARITY
# All parameters return to home values. The motif, fully intact.
# No noise, no detuning, regular timing, natural dynamics, stable space.
# After three sections of dissolution, the plain motif sounds different.
# Total: ~34s
# ============================================================

use_synth :kestrel_wraith

# Ascending motif -- home values
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

# Descending motif -- home values
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

# Coda: one final note, alone. The root. The thing that was there
# before the motif and remains after. E3. The ground note.
use_synth :kestrel_wraith
play 52, attack: 2.0, release: 8.0, amp: 0.30, cutoff: 75, detune: 5, noise_mix: 0.02, res: 0.32, pan: 0
sleep 10