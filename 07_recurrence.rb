# Recurrence Study No. 7: Return Transformed
# Kestrel — 2026-06-18
#
# Patterns that come back, but different each time.
# Not repetition. Not loop. Return — shaped by what happened between.
#
# Uses built-in Sonic Pi synths only.
# Voice changes across recurrences: :prophet → :dsaw → :tb303/:prophet → :sine → :prophet

use_bpm 56

# ============================================================
# The Motif — five-note cell that recurs five times
# ============================================================

original_motif = [:E3, :Fs3, :A3, :B3, :E4]
first_return   = [:E3, :G3, :C4, :D4, :E4]
second_return  = [:E3, :E3, :A3, :A3, :E4]
third_return   = [:C3, :Eb3, :Fs3, :A3, :C5]
final_return   = [:D3, :F3, :Ab3, :Bb3, :D4]

original_rhythm = [4, 4, 4, 4, 8]
first_rhythm    = [3, 5, 3, 5, 6]
second_rhythm   = [2, 6, 2, 6, 4]
third_rhythm    = [5, 3, 5, 3, 8]
final_rhythm    = [4, 4, 4, 4, 8]

# ============================================================
# Recurrence I: First Statement (beats 0-80)
# ============================================================

live_loop :recurrence_first do
  cycle = tick
  beat = cycle

  if beat < 80
    idx = cycle % original_motif.length
    note = original_motif[idx]
    dur = original_rhythm[idx]

    use_synth :prophet
    play note,
      release: dur * 0.5,
      cutoff: 80,
      detune: 6,
      res: 0.4,
      amp: 0.25,
      attack: 0.3,
      pan: (idx - 2) * 0.08

    sleep dur
  else
    sleep 1
  end
end

# ============================================================
# Recurrence II: First Return (beats 100-170)
# ============================================================

live_loop :recurrence_second do
  cycle = tick
  beat = cycle

  if beat >= 100 && beat < 170
    local_beat = beat - 100
    idx = cycle % first_return.length
    note = first_return[idx]
    dur = first_rhythm[idx]

    use_synth :dsaw
    play note,
      release: dur * 0.5,
      cutoff: 75 + idx * 8,
      detune: 10,
      res: 0.35,
      amp: 0.2 - (local_beat / 70.0) * 0.05,
      attack: 0.2,
      pan: (idx - 2) * 0.12

    sleep dur
  else
    sleep 1
  end
end

# ============================================================
# Recurrence III: Second Return (beats 200-260)
# Fragmented — mixed synths within the motif
# ============================================================

live_loop :recurrence_third do
  cycle = tick
  beat = cycle

  if beat >= 200 && beat < 260
    idx = cycle % second_return.length
    note = second_return[idx]
    dur = second_rhythm[idx]

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
# Only contour remains — thin, pure, high
# ============================================================

live_loop :recurrence_fourth do
  cycle = tick
  beat = cycle

  if beat >= 290 && beat < 340
    local_beat = beat - 290
    idx = cycle % third_return.length
    note = third_return[idx]
    dur = third_rhythm[idx]

    use_synth :sine
    play note,
      attack: 0.6,
      release: dur * 0.6,
      amp: 0.16 - (local_beat / 50.0) * 0.04,
      pan: rrand(-0.15, 0.15)

    # Add breath layer
    use_synth :dark_ambience
    play note + 7,
      attack: 1.0,
      release: dur * 0.5,
      cutoff: 4000,
      amp: 0.04,
      pan: rrand(-0.1, 0.1)

    sleep dur
  else
    sleep 1
  end
end

# ============================================================
# Recurrence V: Final Return (beats 370-420)
# Reconstituted — :prophet returns, deeper and slower
# ============================================================

live_loop :recurrence_final do
  cycle = tick
  beat = cycle

  if beat >= 370 && beat < 420
    local_beat = beat - 370
    idx = cycle % final_return.length
    note = final_return[idx]
    dur = final_rhythm[idx]

    use_synth :prophet
    play note,
      release: dur * 0.5,
      cutoff: 60,
      detune: 4,
      res: 0.5,
      amp: 0.2 - (local_beat / 50.0) * 0.06,
      attack: 0.5,
      pan: (idx - 2) * 0.08

    sleep dur
  else
    sleep 1
  end
end

# ============================================================
# The Between: ambient texture in gaps between recurrences
# ============================================================

live_loop :the_between do
  cycle = tick
  beat = cycle

  if beat >= 80 && beat < 100
    use_synth :dark_ambience
    play chord(:E3, :minor), attack: 2, release: 4, amp: 0.06, cutoff: 50
  elsif beat >= 170 && beat < 200
    use_synth :dark_ambience
    play chord(:A3, :minor), attack: 2, release: 4, amp: 0.08, cutoff: 55
  elsif beat >= 260 && beat < 290
    use_synth :dark_ambience
    play chord(:Fs3, :diminished), attack: 3, release: 4, amp: 0.1, cutoff: 60
  elsif beat >= 340 && beat < 370
    use_synth :dark_ambience
    play chord(:D3, :minor), attack: 3, release: 5, amp: 0.12, cutoff: 50
  elsif beat >= 420
    sleep 4
  end

  sleep 4
end
