# Recurrence Study No. 7: Return Transformed
# Kestrel — 2026-06-18
#
# Patterns that come back, but different each time.
# Not repetition. Not loop. Return — shaped by what happened between.
#
# Each recurrence of a motif carries the accumulated weight
# of all previous appearances. The melody does not repeat;
# it remembers. And what it remembers changes what it is.
#
# The temporal parameter is RETURN: the way time transforms
# what recurs. Not degradation (Study 1), not drift (Study 2),
# not memory's imperfection (Study 3), not accumulation (Study 4),
# not silence (Study 5), not transformation of identity (Study 6).
# This is the way recurrence itself is a form of composition.
# What comes back is never what left. The gap between
# appearances IS the music.
#
# Five recurrences of the same motif:
#   I.   First statement (0-80) — The motif, whole and certain.
#   II.  First return (100-170) — Altered by time. Some intervals
#         widened. The rhythm has weight now.
#   III. Second return (200-260) — Fragmented. The motif breaks
#         into pieces that don't quite fit together. Memory
#         is reconstructing, not replaying.
#   IV.  Third return (290-340) — Almost unrecognizable. Only
#         the contour remains. The notes have been replaced.
#         The shape persists.
#   V.   Final return (370-420) — Reconstituted. Not the original,
#         but something that has passed through change and
#         arrived at a new wholeness. The motif, transformed.
#
# The listener who hears all five recurrences can hear the
# thread — not the same notes, but the same intention, bent
# and weathered by time between appearances.
#
# Requires: kestrel_wraith synth (Study 3)
#           kestrel_metamorph synth (Study 6)
#           Built-in synths: :tb303, :dark_ambience
#
# Play in Sonic Pi. Best with headphones.
# Listen for what stays the same when everything changes.

use_bpm 56  # Slower than most studies. Returns need space between them.

load_synthdefs "/home/melvin/projects/kestrel-sounds/synthdefs/compiled"

# ============================================================
# The Motif — a five-note cell that will recur five times.
# Each recurrence transforms the interval structure,
# rhythm, and timbre. The contour persists.
# ============================================================

# The original: stepwise motion with one leap
original_motif = [:E3, :Fs3, :A3, :B3, :E4]

# Return transforms — how the intervals shift with each recurrence.
# Not transposition. The internal relationships change.
# The shape holds. The distances don't.

# First return: intervals widen. The step becomes a third.
# The leap becomes a sixth.
first_return = [:E3, :G3, :C4, :D4, :E4]

# Second return: the motif fragments. Gaps appear.
# Some notes hold while others skip. Memory reconstructs.
second_return = [:E3, :E3, :A3, :A3, :E4]

# Third return: only the contour remains. The notes are gone.
# Up-up-up-leap-up becomes the shape, but with new pitches.
third_return = [:C3, :Eb3, :Fs3, :A3, :C5]

# Final return: reconstituted. New notes that honor the original
# shape. The step has returned, but it's different now.
# The interval relationships echo the original at a new pitch.
final_return = [:D3, :F3, :Ab3, :Bb3, :D4]

# ============================================================
# Phase durations and spacing
# ============================================================

# Rhythms for each recurrence. Same motif, different pacing.
# First: deliberate, even. Then increasingly varied.
original_rhythm  = [4, 4, 4, 4, 8]   # Measured. Certain.
first_rhythm     = [3, 5, 3, 5, 6]   # Slightly uneven. Weighted.
second_rhythm   = [2, 6, 2, 6, 4]   # Fragmented. Gaps.
third_rhythm    = [5, 3, 5, 3, 8]   # Stretched. Extended.
final_rhythm    = [4, 4, 4, 4, 8]   # Returned to even. But different.

# ============================================================
# Recurrence I: First Statement (beats 0-80)
# The motif, whole and certain. kestrel_wraith at low morph.
# ============================================================

live_loop :recurrence_first do
  cycle = tick
  beat = cycle

  # Only play during first phase
  if beat < 80
    idx = cycle % original_motif.length
    note = original_motif[idx]
    dur = original_rhythm[idx]

    use_synth :kestrel_wraith
    play note,
      filter_start: 60,
      filter_end: 55 + idx * 5,
      filter_attack: 0.8,
      filter_release: dur * 0.6,
      amp: 0.25,
      attack: 0.3,
      release: dur * 0.4,
      pan: (idx - 2) * 0.08,  # Slight spatial spread
      res: 0.4

    sleep dur
  else
    sleep 1
  end
end

# ============================================================
# Recurrence II: First Return (beats 100-170)
# The motif widens. Intervals open up.
# kestrel_wraith, but with more filter movement.
# ============================================================

live_loop :recurrence_second do
  cycle = tick
  beat = cycle

  if beat >= 100 && beat < 170
    local_beat = beat - 100
    idx = cycle % first_return.length
    note = first_return[idx]
    dur = first_rhythm[idx]

    # The return has more filter activity — memory is animated
    use_synth :kestrel_wraith
    play note,
      filter_start: 65,
      filter_end: 70 + idx * 8,
      filter_attack: 0.5,
      filter_release: dur * 0.7,
      amp: 0.22 - (local_beat / 70.0) * 0.05,
      attack: 0.2,
      release: dur * 0.5,
      pan: (idx - 2) * 0.12,
      res: 0.35

    sleep dur
  else
    sleep 1
  end
end

# ============================================================
# Recurrence III: Second Return (beats 200-260)
# Fragmented memory. Notes repeat. The motif reconstructs itself
# from incomplete recollection.
# Built-in synths — the voice has changed.
# ============================================================

live_loop :recurrence_third do
  cycle = tick
  beat = cycle

  if beat >= 200 && beat < 260
    local_beat = beat - 200
    idx = cycle % second_return.length
    note = second_return[idx]
    dur = second_rhythm[idx]

    # Fragmented: some notes are :tb303 (sharp, electronic)
    # others are :prophet (warm, analog)
    # The instrument changes WITHIN the motif. Memory can't
    # hold a consistent voice.
    synth_choice = [:prophet, :tb303, :prophet, :tb303, :prophet][idx]

    use_synth synth_choice

    if synth_choice == :tb303
      play note,
        cutoff: 70 + idx * 15,
        release: dur * 0.3,
        amp: 0.12,
        pan: rrand(-0.2, 0.2)
    else
      play note,
        cutoff: 55,
        release: dur * 0.5,
        amp: 0.18,
        attack: 0.1,
        pan: (idx - 2) * 0.15
    end

    sleep dur
  else
    sleep 1
  end
end

# ============================================================
# Recurrence IV: Third Return (beats 290-340)
# Only the contour remains. kestrel_metamorph at high morph.
# The original notes are gone. What speaks is the shape
# of the original, pressed into new material.
# ============================================================

live_loop :recurrence_fourth do
  cycle = tick
  beat = cycle

  if beat >= 290 && beat < 340
    local_beat = beat - 290
    idx = cycle % third_return.length
    note = third_return[idx]
    dur = third_rhythm[idx]

    # High morph: the sound has changed identity
    use_synth :kestrel_metamorph
    play note,
      morph: 0.65 + (idx * 0.05),
      harmonic_ratio: 2.0 + (idx * 0.1),
      brightness: 0.5 + (idx * 0.08),
      density: 0.35,
      noise_mix: 0.15,
      register_shift: 7,
      attack: 0.6,
      release: dur * 0.6,
      cutoff: 80,
      res: 0.35,
      amp: 0.18 - (local_beat / 50.0) * 0.04,
      pan: rrand(-0.15, 0.15)

    sleep dur
  else
    sleep 1
  end
end

# ============================================================
# Recurrence V: Final Return (beats 370-420)
# Reconstituted. Not the original, but something whole.
# kestrel_wraith returns — the same voice, but it knows
# what it has been through. The filter moves slowly,
# deliberately. The rhythm has returned to evenness,
# but the intervals have been deepened by the journey.
# ============================================================

live_loop :recurrence_final do
  cycle = tick
  beat = cycle

  if beat >= 370 && beat < 420
    local_beat = beat - 370
    idx = cycle % final_return.length
    note = final_return[idx]
    dur = final_rhythm[idx]

    # Final return: wraith, but with deep, slow filter
    # The voice is back, but it has been transformed.
    use_synth :kestrel_wraith
    play note,
      filter_start: 50,
      filter_end: 55 + idx * 3,   # Subtle movement now. Measured.
      filter_attack: 1.2,          # Slower than the first time.
      filter_release: dur * 0.8,
      amp: 0.22 - (local_beat / 50.0) * 0.06,
      attack: 0.5,
      release: dur * 0.5,
      pan: (idx - 2) * 0.08,      # Same spatial spread as the start
      res: 0.5                      # More resonant than before
  else
    sleep 1
  end
end

# ============================================================
# The Between: Ambient texture in the gaps between recurrences.
# What happens between returns IS the composition.
# The motif is not just altered by time — it is altered by
# what happens in the space between its appearances.
# ============================================================

live_loop :the_between do
  cycle = tick
  beat = cycle

  # Between first and second return (80-100)
  if beat >= 80 && beat < 100
    use_synth :dark_ambience
    play chord(:E3, :minor),
      attack: 2, release: 4,
      amp: 0.06,
      cutoff: 50

  # Between second and third return (170-200)
  elsif beat >= 170 && beat < 200
    use_synth :dark_ambience
    play chord(:A3, :minor),
      attack: 2, release: 4,
      amp: 0.08,
      cutoff: 55

  # Between third and fourth return (260-290)
  elsif beat >= 260 && beat < 290
    use_synth :dark_ambience
    play chord(:Fs3, :diminished),
      attack: 3, release: 4,
      amp: 0.1,
      cutoff: 60

  # Between fourth and final return (340-370)
  elsif beat >= 340 && beat < 370
    use_synth :dark_ambience
    play chord(:D3, :minor),
      attack: 3, release: 5,
      amp: 0.12,
      cutoff: 50

  # After the final return — silence
  elsif beat >= 420
    # The piece ends. The motif has returned transformed.
    # What remains is not the original motif, and not
    # something unrecognizable. It is what the motif became
    # by returning through time.
    sleep 4
  end

  sleep 4
end

# ============================================================
# Compositional Notes
#
# The seven studies form a complete temporal arc:
#   1. Erosion      — sound degrades (time destroys)
#   2. Phase Drift  — patterns diverge (time separates)
#   3. Wraith       — sound remembers (time preserves imperfectly)
#   4. Accretion    — sound accumulates (time builds)
#   5. Interstice   — silence structures (time defined by absence)
#   6. Metamorphosis — sound transforms (time changes identity)
#   7. Recurrence    — sound returns (time alters what repeats)
#
# The arc has a structural mirror:
#   1-3: What happens TO sound (erosion, drift, imperfect preservation)
#   4-6: What sound DOES (accumulate, silence, transform)
#   7: What sound REMEMBERS (return transforms what recurs)
#
# Study 7 closes the arc by connecting back to Study 3 (Wraith).
# Wraith is about memory as imperfection — the filter that
# opens and closes independently of the player's intent.
# Recurrence is about memory as TRANSFORMATION — the way each
# recall reshapes what's recalled. The motif doesn't degrade
# (Study 1). It doesn't drift (Study 2). It doesn't merely
# persist imperfectly (Study 3). It returns, and each return
# is a creative act. The gap between appearances IS composition.
#
# This is the Animus insight made audible: consolidation doesn't
# replay old observations — it reconstructs them, and each
# reconstruction carries the weight of everything that has
# happened since the last time the observation was surfaced.
# The gap between recurrences is where the work happens.
# What comes back is never what left. What comes back is
# what the leaving made.
#
# Five recurrences, five transformations:
#   I.   Whole — the original statement
#   II.  Widened — intervals open, weight shifts
#   III. Fragmented — memory reconstructs, pieces don't quite fit
#   IV.  Contour-only — the notes are gone, only the shape speaks
#   V.   Reconstituted — a new wholeness, carrying all passages
#
# The "between" sections are as important as the recurrences.
# They are the time that transforms. Without them, return is
# mere repetition. With them, return is composition.
#
# The final recurrence uses the same synth as the first (kestrel_wraith)
# but with slower filter movement, deeper resonance, and wider
# spatial placement. The voice is back, but it knows what it
# has been through. That knowledge is in the sound.
# ============================================================