# Study 19: Temporal Ground Dissolution
# Kestrel -- 2026-07-09
#
# Third ground dissolution study. The first (Study 17) dissolved the
# pitch ground (tuning system). The second (Study 18) dissolved the
# resonance ground (acoustic space). This study dissolves the temporal
# ground -- the beat, the grid, the spacing between notes.
#
# The motif stays the same: E minor pentatonic, 5 notes, 12-EDO.
# The pitches NEVER change. The synth NEVER changes. The space
# (release, cutoff, noise, pan) stays constant across all sections.
# What changes is WHEN notes arrive.
#
# Temporal ground is structurally different from pitch and space grounds.
# Pitch ground operates on what a note IS. Space ground operates on what
# a note EXISTS IN. Temporal ground operates on the BETWEEN -- the
# relationship from one note to the next. It is the most abstract ground
# because it is pure relation, not substance.
#
# A note with correct pitch in correct space at the wrong time is still
# a note. But a motif without temporal organization is not a motif --
# it is five disconnected sounds. The melody lives in the rhythm, not
# the pitches. Dissolve the rhythm and the motif dissolves, even though
# every note is perfect.
#
# Four sections -- the beat breathes, sways, floats, then breaks:
#   I.   STEADY     -- the ground is solid. Regular spacing, clear pulse.
#                       3 beats between notes. The motif is a melody.
#   II.  SWAYING    -- the ground breathes. Spacing varies +/- 30%.
#                       The beat is still there but it wobbles. The motif
#                       feels like it's being played by someone unsteady.
#   III. FLOATING   -- the beat is gone. Notes arrive at irregular intervals.
#                       Sometimes 1 beat, sometimes 7. The motif is now
#                       five notes in a void, with no organizing pulse.
#   IV.  DISSOLUTION -- temporal incoherence. Extreme gaps (10+ beats)
#                       followed by clusters (notes nearly simultaneous).
#                       The concept of "next note" has no meaning. The motif
#                       can't be perceived because there is no temporal
#                       structure to hold it.
#
# Hypothesis: the dissolution basin holds at the temporal level.
# Any rhythmic system, pushed far enough, dissolves the motif built on it.
# The temporal ground is the most fundamental -- even more than pitch or
# space, the motif IS its rhythm. Dissolve rhythm and the motif is gone,
# even if every pitch is perfect.
#
# Root: E3 = MIDI 52
# Motif: E3 - G3 - A3 - B3 - D4 (ascending), D4 - B3 - A3 - G3 - E3 (descending)
# All pitches invariant across all sections. Only time changes.
#
# Constant synth parameters (same in every section, every note):
#   use_synth :kestrel_wraith
#   attack: 0.4, release: 1.8, amp: 0.40, cutoff: 80, detune: 5,
#   noise_mix: 0.03, res: 0.35, pan: 0
#
# Designed for headless rendering: per-section rendering recommended.
# Section IV has extreme sleep values (up to 14 beats = 11.7s) -- well
# within scsynth limits. No voice accumulation risk (constant short release).

use_bpm 72
use_external_synths true

# ============================================================
# Section I: STEADY -- the ground is solid
# Regular 3-beat spacing. The motif is a melody. The beat is the ground.
# Total: 34 beats = 28.3s
# ============================================================

use_synth :kestrel_wraith
play 52, attack: 0.4, release: 1.8, amp: 0.40, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.8, amp: 0.38, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.36, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.38, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 62, attack: 0.6, release: 2.0, amp: 0.42, cutoff: 78, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 4
play 62, attack: 0.4, release: 1.8, amp: 0.40, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 3
play 59, attack: 0.4, release: 1.8, amp: 0.36, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 57, attack: 0.4, release: 1.8, amp: 0.34, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 55, attack: 0.4, release: 1.8, amp: 0.32, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3
play 52, attack: 0.6, release: 2.2, amp: 0.36, cutoff: 78, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 5

# ============================================================
# Section II: SWAYING -- the ground breathes
# Spacing varies by +/- 30% around the steady 3-beat pulse.
# The beat is still there but it wobbles. The motif feels unsteady,
# like being played by someone whose internal clock is drifting.
# Spacing schedule: 2.2, 3.6, 2.8, 3.4, 2.5, 4.2, 2.1, 3.8, 2.6, 4.5
# Total: 32.7 beats = 27.3s
# ============================================================

use_synth :kestrel_wraith
play 52, attack: 0.4, release: 1.8, amp: 0.40, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 2.2
play 55, attack: 0.4, release: 1.8, amp: 0.38, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3.6
play 57, attack: 0.4, release: 1.8, amp: 0.36, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 2.8
play 59, attack: 0.4, release: 1.8, amp: 0.38, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3.4
play 62, attack: 0.6, release: 2.0, amp: 0.42, cutoff: 78, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 2.5
play 62, attack: 0.4, release: 1.8, amp: 0.40, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 4.2
play 59, attack: 0.4, release: 1.8, amp: 0.36, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 2.1
play 57, attack: 0.4, release: 1.8, amp: 0.34, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 3.8
play 55, attack: 0.4, release: 1.8, amp: 0.32, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 2.6
play 52, attack: 0.6, release: 2.2, amp: 0.36, cutoff: 78, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 4.5

# ============================================================
# Section III: FLOATING -- the beat is gone
# No regular pulse. Notes arrive at irregular intervals.
# The spacing is drawn from a schedule that has no pattern:
# 1.0, 6.5, 0.5, 5.0, 1.5, 7.0, 0.8, 4.5, 1.2, 8.0
# Sometimes notes almost overlap (0.5 beats = 0.42s).
# Sometimes there are huge gaps (8 beats = 6.7s).
# The motif is now five notes in a void, with no organizing pulse.
# Total: 36 beats = 30.0s
# ============================================================

use_synth :kestrel_wraith
play 52, attack: 0.4, release: 1.8, amp: 0.40, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 1.0
play 55, attack: 0.4, release: 1.8, amp: 0.38, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 6.5
play 57, attack: 0.4, release: 1.8, amp: 0.36, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 0.5
play 59, attack: 0.4, release: 1.8, amp: 0.38, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 5.0
play 62, attack: 0.6, release: 2.0, amp: 0.42, cutoff: 78, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 1.5
play 62, attack: 0.4, release: 1.8, amp: 0.40, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 7.0
play 59, attack: 0.4, release: 1.8, amp: 0.36, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 0.8
play 57, attack: 0.4, release: 1.8, amp: 0.34, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 4.5
play 55, attack: 0.4, release: 1.8, amp: 0.32, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 1.2
play 52, attack: 0.6, release: 2.2, amp: 0.36, cutoff: 78, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 8.0

# ============================================================
# Section IV: DISSOLUTION -- temporal incoherence
# Extreme gaps followed by clusters. No temporal logic.
# The concept of "next note" has no meaning.
#
# Spacing schedule:
#   0.3, 0.2, 11.0, 0.4, 0.3, 0.2, 12.0, 0.3, 0.2, 14.0
#
# Pattern: clusters of 2-3 notes nearly simultaneous (0.2-0.3 beats
# = 0.17-0.25s apart), then extreme gaps (11-14 beats = 9.2-11.7s).
# The motif arrives as bursts, then silence, then bursts. It cannot
# be heard as a melody because melody requires temporal continuity.
#
# Amp decreases across the section: 0.30 -> 0.06.
# The motif is being absorbed by the temporal void.
#
# Coda: kestrel_dust. Time itself has stopped. A single dust note
# with no temporal reference. The motif has been dissolved by time.
# ============================================================

use_synth :kestrel_wraith
play 52, attack: 0.4, release: 1.8, amp: 0.30, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 0.3
play 55, attack: 0.4, release: 1.8, amp: 0.28, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 0.2
play 57, attack: 0.4, release: 1.8, amp: 0.26, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 11.0
play 59, attack: 0.4, release: 1.8, amp: 0.24, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 0.4
play 62, attack: 0.6, release: 2.0, amp: 0.22, cutoff: 78, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 0.3
play 62, attack: 0.4, release: 1.8, amp: 0.20, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 0.2
play 59, attack: 0.4, release: 1.8, amp: 0.18, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 12.0
play 57, attack: 0.4, release: 1.8, amp: 0.16, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 0.3
play 55, attack: 0.4, release: 1.8, amp: 0.14, cutoff: 80, detune: 5, noise_mix: 0.03, res: 0.35, pan: 0
sleep 0.2
play 52, attack: 0.6, release: 2.2, amp: 0.12, cutoff: 78, detune: 5, noise_mix: 0.03, res: 0.30, pan: 0
sleep 14.0

# Coda: time has stopped. Dust at the root.
# The motif has been dissolved by time, not by pitch or space.
use_synth :kestrel_dust
play 52, attack: 1.5, release: 5.0, amp: 0.08, cutoff: 48, res: 0.20, pan: 0
sleep 6
use_synth :kestrel_dust
play 52, attack: 2.0, release: 7.0, amp: 0.05, cutoff: 45, res: 0.15, pan: 0
sleep 8