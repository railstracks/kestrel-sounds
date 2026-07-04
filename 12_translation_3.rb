# Translation Study No. 12: Register
# Kestrel - 2026-07-04
#
# The third study on the translation axis.
#
# Study 10 (Idiom) translated a motif across musical languages.
# Study 11 (Temporal) translated a motif across time scales.
# Study 12 translates a motif across pitch registers.
#
# The same five notes (E-G-A-B-D, E minor pentatonic) are
# presented at five registers, from sub-bass to beyond soprano:
#
#   I.    Sub-bass  - 3 octaves down (E1-G1-A1-B1-D2)
#   II.   Bass      - 2 octaves down (E2-G2-A2-B2-D3)
#   III.  Mid       - original (E3-G3-A3-B3-D4)
#   IV.  Treble     - 2 octaves up (E5-G5-A5-B5-D6)
#   V.   Beyond     - 3 octaves up (E6-G6-A6-B6-D7)
#
# The register IS the context. At both extremes, melody dissolves
# into vibration below, into color above.
#
# Three studies converge on spectral dissolution:
# Study 10 via idiom, Study 11 via temporal, Study 12 via register.
# Three routes, same destination: the motif dissolved by its
# own translation.
#
# Structure (~8 minutes at 60 BPM):
#   0:00-1:00     I.    Sub-bass (60 beats)
#   1:00-1:30      Trans I-II (30 beats)
#   1:30-2:30     II.   Bass (60 beats)
#   2:30-3:00      Trans II-III (30 beats)
#   3:00-4:00     III.  Mid (60 beats)
#   4:00-4:30      Trans III-IV (30 beats)
#   4:30-5:30     IV.   Treble (60 beats)
#   5:30-6:00      Trans IV-V (30 beats)
#   6:00-8:00     V.    Beyond (120 beats)
#
# Uses built-in Sonic Pi synths. No with_fx (headless render fix).
# Best with headphones. Best at low volume.

use_bpm 60

$motif = [:E3, :G3, :A3, :B3, :D4]
$total_beats = 480

define :shift_motif_f do |octaves_f|
  $motif.map { |n| n + (octaves_f * 12).round }
end

define :t do |beat, total|
  [beat.to_f / total, 1.0].min
end

define :ease do |x|
  x = [x, 0.0].max
  x = [x, 1.0].min
  3 * x * x - 2 * x * x * x
end

define :synth_for_register do |oct|
  if oct <= 0.5
    :prophet
  elsif oct <= 1.5
    :pluck
  else
    :blade
  end
end

define :cutoff_at do |oct|
  if oct <= -2.5
    50
  elsif oct <= -1.5
    70
  elsif oct <= 0.5
    110
  elsif oct <= 1.5
    130
  else
    140
  end
end

define :register_at do |beat|
  if beat < 60
    -3.0
  elsif beat < 90
    -3.0 + ease(t(beat - 60, 30)) * 1.0
  elsif beat < 150
    -2.0
  elsif beat < 180
    -2.0 + ease(t(beat - 150, 30)) * 2.0
  elsif beat < 240
    0.0
  elsif beat < 270
    0.0 + ease(t(beat - 240, 30)) * 2.0
  elsif beat < 330
    2.0
  elsif beat < 360
    2.0 + ease(t(beat - 330, 30)) * 1.0
  else
    3.0
  end
end

define :note_index_at do |beat|
  if beat < 60
    (beat / 4).to_i % 5
  elsif beat < 90
    ((beat - 60) / 2).to_i % 5
  elsif beat < 150
    ((beat - 90) / 4).to_i % 5
  elsif beat < 180
    ((beat - 150) / 2).to_i % 5
  elsif beat < 240
    ((beat - 180) / 4).to_i % 5
  elsif beat < 270
    ((beat - 240) / 2).to_i % 5
  elsif beat < 330
    ((beat - 270) / 4).to_i % 5
  elsif beat < 360
    ((beat - 330) / 2).to_i % 5
  else
    ((beat - 360) / 6).to_i % 5
  end
end

define :note_duration_at do |beat|
  if beat < 60
    4.0
  elsif beat < 90
    4.0 - ease(t(beat - 60, 30)) * 2.0
  elsif beat < 150
    4.0
  elsif beat < 180
    4.0 - ease(t(beat - 150, 30)) * 2.0
  elsif beat < 240
    4.0
  elsif beat < 270
    4.0 - ease(t(beat - 240, 30)) * 2.0
  elsif beat < 330
    4.0
  elsif beat < 360
    4.0 - ease(t(beat - 330, 30)) * 2.0
  else
    4.0 + ease(t(beat - 360, 120)) * 2.0
  end
end

define :amp_at do |beat|
  oct = register_at(beat)
  base = 0.8 - (oct.abs / 3.0) * 0.5
  [base, 0.15].max
end

live_loop :register_translation do
  beat = tick
  if beat > $total_beats
    sleep 4
  else
    oct = register_at(beat)
    note_idx = note_index_at(beat)
    dur = note_duration_at(beat)
    amp = amp_at(beat)
    synth = synth_for_register(oct)
    cutoff = cutoff_at(oct)
    shifted = shift_motif_f(oct)
    this_note = shifted[note_idx]
    use_synth synth
    if oct <= -2.5
      play this_note, release: dur * 0.9, attack: dur * 0.1, amp: amp, pan: 0, cutoff: cutoff
      play this_note - 12, release: dur * 0.9, attack: dur * 0.1, amp: amp * 0.5, pan: 0, cutoff: cutoff
    elsif oct >= 2.5
      play this_note, release: dur * 0.8, attack: dur * 0.2, amp: amp, pan: rrand(-0.3, 0.3), cutoff: cutoff
      play this_note + 7, release: dur * 0.7, attack: dur * 0.3, amp: amp * 0.3, pan: rrand(-0.2, 0.2), cutoff: cutoff
    else
      play this_note, release: dur * 0.85, attack: dur * 0.15, amp: amp, pan: 0, cutoff: cutoff
    end
    sleep dur
  end
end

live_loop :register_drone do
  beat = tick
  if beat > $total_beats
    sleep 4
  else
    oct = register_at(beat)
    amp = amp_at(beat) * 0.3
    drone_note = :E3 + (oct * 12).round
    synth = if oct <= -1.5
      :prophet
    elsif oct >= 1.5
      :blade
    else
      :prophet
    end
    use_synth synth
    play drone_note, sustain: 8, amp: amp, attack: 4, release: 4, cutoff: cutoff_at(oct)
    sleep 8
  end
end
