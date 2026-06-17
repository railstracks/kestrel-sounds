# Interstice Study No. 5: The Weight of Silence
# Kestrel — 2026-06-17
#
# Silence as primary structural element.
# Notes are rare, brief — punctuation marks in a text of silence.
# The composition is defined by WHEN sound occurs, not WHAT it is.
# The same duration of silence carries different weight
# depending on what came before and what comes after.
#
# Studies 1-4 explored what sound does over time:
#   1. Erosion — sound degrades
#   2. Phase Drift — sound diverges
#   3. Wraith — sound remembers
#   4. Accretion — sound accumulates
#
# Study 5: What does silence do over time?
#
# The compositional material is the space between notes.
# A long silence after a brief sound feels different from
# a long silence before one. Same duration, opposite weight.
#
# This piece is DETERMINISTIC — the silences are composed,
# not left to chance. Every performance is the same.
# Silence composed by chance is just randomness.
# Silence composed by intention is architecture.
#
# Best with headphones. Best at low volume.
# Let the silence be the same volume as the room.

use_bpm 40  # Each beat = 1.5 seconds. 400 beats ≈ 10 minutes.

# ============================================================
# The Composition
# Each entry is [beat, note, release, amplitude, synth, cutoff]
# The silence between entries IS the composition.
# The notes are just markers that define the silence shape.
# ============================================================

# Movement I: First Mark (beats 0-80)
# Establishes that silence is the default state.
# A few notes, widely spaced, to teach the listener
# that the silence is structural, not a pause between phrases.
first_mark = [
  # The first note. 8 beats of silence before anything happens.
  # That is 12 seconds of nothing. The listener is waiting.
  # Then: a single, quiet tone.
  [8,  :E3,  4.0, 0.12, :hollow, 60],
  # 16 beats of silence (24 seconds). The note dissolves
  # and the listener is left with its absence.
  [24, :B3,  3.5, 0.10, :hollow, 65],
  # 20 beats (30 seconds). The silence is getting longer.
  # The listener starts to anticipate — is there a pattern?
  # No. The pattern is: there is no pattern. Only weight.
  [44, :E3,  5.0, 0.14, :dark_ambience, 55],
  # 14 beats. Slightly shorter gap. The silence feels different
  # after the longer one — almost crowded by comparison.
  [58, :G3,  4.5, 0.11, :hollow, 65],
  # 22 beats to the end of the movement. Longest silence yet.
  # The last note of the movement has the longest tail.
  # It dissolves very slowly, extending into the silence.
  # By the time it is gone, the listener is deep in the space.
  [80, :E3,  6.0, 0.10, :dark_ambience, 50],
]

# Movement II: The Weight Shifts (beats 80-200)
# The minor third and minor seventh enter — tension intervals.
# They make the silence after them feel heavier.
# The gaps are slightly shorter on average, but irregularly so.
# The listener sense of how long until the next one is unsettled.
weight_shifts = [
  # Short gap from movement I ending — the first note of this
  # movement arrives sooner than expected. The silence was not ready.
  [93,  :G3,  4.0, 0.12, :dark_ambience, 60],
  # 12 beats (18 seconds). The minor third makes this silence
  # feel like it is leaning forward. Something should resolve.
  [105, :D4,  3.5, 0.10, :hollow, 65],
  # 18 beats. Another long one. The unresolved interval
  # makes this silence carry more weight than the ones
  # in Movement I, even though the duration is similar.
  [123, :G3,  5.0, 0.11, :dark_ambience, 55],
  # 8 beats. Shorter. The listener just settled into the silence
  # and now there is a note. The surprise IS the event.
  [131, :D4,  3.0, 0.09, :pretty_bell, 0],  # cutoff=0 = use synth default
  # Higher register enters for the first time.
  # These notes feel like they come from a different room.
  [142, :G4,  4.0, 0.07, :pretty_bell, 0],
  # 20 beats. Long again. The high register note leaves
  # a different kind of silence — thinner, more expectant.
  [162, :E4,  5.5, 0.08, :dark_ambience, 55],
  # 15 beats. The minor seventh. Tension.
  [177, :D4,  3.5, 0.10, :hollow, 65],
  # 23 beats. The longest gap in this movement.
  # After tension, a long wait. The silence is heavy.
  [200, :B3,  4.0, 0.12, :hollow, 60],
]

# Movement III: Near Density (beats 200-280)
# The closest the piece gets to density. Notes appear
# more frequently, sometimes in brief clusters of 2-3.
# After so much silence, even this moderate density
# feels almost overwhelming. The listener threshold
# for too much has been recalibrated by the silence.
near_density = [
  [204, :E3,  3.0, 0.10, :hollow, 65],
  [207, :G3,  2.5, 0.09, :hollow, 70],  # Quick succession — only 3 beats apart
  [213, :B3,  4.0, 0.12, :dark_ambience, 55],
  [217, :D4,  3.0, 0.08, :hollow, 65],
  [219, :G3,  2.0, 0.07, :prophet, 80],  # 2 beats — the shortest gap yet
  [228, :E3,  4.0, 0.10, :hollow, 60],
  [232, :G4,  3.5, 0.06, :pretty_bell, 0],  # High, quiet
  [235, :B3,  3.0, 0.11, :dark_ambience, 55],
  [238, :G3,  2.5, 0.08, :hollow, 70],
  [239, :E3,  2.0, 0.07, :prophet, 80],  # 1 beat apart — a cluster
  [247, :D4,  4.0, 0.09, :hollow, 65],
  [255, :B3,  3.5, 0.10, :dark_ambience, 55],
  [256, :E4,  3.0, 0.07, :pretty_bell, 0],  # Another near-cluster
  [260, :G3,  4.5, 0.10, :hollow, 60],
  [268, :E3,  5.0, 0.12, :dark_ambience, 50],
  [273, :B3,  3.0, 0.09, :hollow, 65],
]

# Movement IV: Return to Silence (beats 280-400)
# The density recedes. Notes become as rare as Movement I.
# But the silence now carries everything that came before.
# The listener has learned to hear silence as structure.
# The same duration of nothing means something different
# than it did at beat 0.
#
# The piece does not end — it returns.
# The silence after the last note is the same silence
# as before the first note. But the listener is different.
return_to_silence = [
  [295, :E3,  6.0, 0.09, :dark_ambience, 50],
  [315, :B3,  5.5, 0.08, :dark_ambience, 55],
  [340, :E4,  5.0, 0.06, :pretty_bell, 0],  # High, distant, almost gone
  [365, :E3,  7.0, 0.10, :dark_ambience, 50],  # Longest release in the piece
  # The last note. 35 beats of silence after it.
  # 52.5 seconds of nothing. The composition is complete.
  # The silence that follows is not an ending — it is the
  # return to the same silence that opened the piece.
  # But now the listener knows how to hear it.
]

# All events, chronologically
all_events = first_mark + weight_shifts + near_density + return_to_silence
all_events.sort_by! { |e| e[0] }

# ============================================================
# Player
# Single loop, deterministic. Every silence is composed.
# ============================================================

# Calculate total duration in beats
total_beats = 400  # The piece runs for 400 beats, then silence

live_loop :interstice do
  beat = tick
  
  # Find any event scheduled for this beat
  event = all_events.find { |e| e[0] == beat }
  
  if event
    _, note, release, amp, synth, cutoff = event
    
    use_synth synth.to_sym
    
    play_opts = {
      attack: [0.3, 0.4, 0.5, 0.6, 0.8, 1.0].detect { |a| a <= release * 0.15 } || 0.3,
      release: release,
      amp: amp,
      pan: rrand(-0.08, 0.08),  # Very slight spatial drift — not random, just alive
    }
    
    # Only set cutoff if specified (0 means use synth default)
    if cutoff > 0
      play_opts[:cutoff] = cutoff
      play_opts[:res] = 0.5
    end
    
    play note, **play_opts
  end
  
  sleep 1
end

# ============================================================
# Compositional Notes
#
# The piece has four movements defined by the DENSITY of events
# and the CHARACTER of the intervals:
#
#   I.   First Mark (0-80)     — 6 notes, E and B only (stability)
#   II.  Weight Shifts (80-200) — 8 notes, G and D enter (tension)
#   III. Near Density (200-280) — 15 notes, all intervals (pressure)
#   IV.  Return (280-400)       — 4 notes, back to E and B (release)
#
# Total: 33 notes in 400 beats (≈10 minutes). That is one note
# every 12 beats (18 seconds) on average. The composition
# is primarily silence.
#
# The arc mirrors Studies 1-4 but inverts the material:
# Where Accretion accumulates sound, Interstice accumulates silence.
# Where Erosion degrades notes, Interstice sharpens attention to absence.
# The compositional parameter is not what the notes do —
# it is what the silence does between them.
#
# BPM 40 is deliberate. Each beat is 1.5 seconds. At this tempo,
# even a single beat of silence is noticeable. Ten beats of silence
# (15 seconds) is a substantial musical event. The silence
# is not empty — it is full of the listener attention.
#
# The synth choices:
# - :hollow — filtered, slightly distant. The inside sound.
# - :dark_ambience — spacious, reverberant. The outside sound.
# - :pretty_bell — clear, bright. The other room sound.
# - :prophet — brief, present. The close sound.
# Each synth defines a different relationship to the silence
# around it: embedded, expansive, remote, or immediate.
#
# After 400 beats, the composition is complete.
# The silence that follows is different from the silence
# that preceded it. That transformation IS the composition.
# ============================================================
