# Translation Study No. 13: Timbre
# Kestrel - 2026-07-04
#
# The fourth study on the translation axis.
#
# Study 10 (Idiom) translated a motif across musical languages.
# Study 11 (Temporal) translated a motif across time scales.
# Study 12 (Register) translated a motif across pitch registers.
# Study 13 translates a motif across timbres.
#
# The same five notes (E-G-A-B-D, E minor pentatonic) are
# presented at five timbral qualities, from transparent to dense:
#
#   I.    Glass    - pure, few harmonics, transparent (sine-like)
#   II.   Wood     - mellow, mid-heavy, warm (muted midrange)
#   III.  Voice    - vocal-like, formant-shaped, present
#   IV.   Metal    - bright, many high harmonics, sharp attack
#   V.    Spectral - dense partials, inharmonic, shimmering
#
# The timbre IS the context. The same notes in different timbres
# are different music. At both extremes, melody dissolves:
# Glass is too pure to carry expression (melody as tone).
# Spectral is too dense to carry identity (melody as sound object).
#
# Four studies converge on spectral dissolution:
# Study 10 via idiom, Study 11 via temporal, Study 12 via register,
# Study 13 via timbre. Four routes, same destination: the motif
# dissolved by its own translation.
#
# Sonic Pi's built-in synths approximate these timbres through
# cutoff, attack, release, and synth choice. The approximation
# is the translation -- no synth perfectly realizes a timbral
# ideal, and the gap between ideal and realization is where
# the music lives.
#
# Structure (~8 minutes at 60 BPM):
#   0:00-1:00     I.    Glass (60 beats)
#   1:00-1:30      Trans I-II (30 beats)
#   1:30-2:30     II.   Wood (60 beats)
#   2:30-3:00      Trans II-III (30 beats)
#   3:00-4:00     III.  Voice (60 beats)
#   4:00-4:30      Trans IRI-IV (30 beats)
#   4:30-5:30     IV.   Metal (60 beats)
#   5:30-6:00      Trans IV-V (30 beats)
#   6:00-8:00     V.    Spectral (120 beats)
#
# Uses built-in Sonic Pi synths. No with_fx (headless render fix).
# Best with headphones. Best at low volume.

use_bpm 60

$motif = [:E3, :G3, :A3, :B3, :D4]
$total_beats = 480

# Timbre parameter: 0 = glass, 1 = wood, 2 = voice, 3 = metal, 4 = spectral
# Continuous 0.0 to 4.0 for transitions

define :t do |beat, total|
  [beat.to_f / total, 1.0].min
end

define :ease do |x|
  x = [x, 0.0].max
  x = [x, 1.0].min
  3 * x * x - 2 * x * x * x
end

define :timbre_at do |beat|
  if beat < 60
    0.0
  elsif beat < 90
    ease(t(beat - 60, 30))
  elsif beat < 150
    1.0
  elsif beat < 180
    1.0 + ease(t(beat - 150, 30))
  elsif beat < 240
    2.0
  elsif beat < 270
    2.0 + ease(t(beat - 240, 30))
  elsif beat < 330
    3.0
  elsif beat < 360
    3.0 + ease(t(beat - 330, 30))
  else
    4.0
  end
end

define :synth_for_timbre do |timb|
  if timb < 0.5
    :sine
  elsif timb < 1.5
    :prophet
  elsif timb < 2.5
    :pluck
  elsif timb < 3.5
    :blade
  else
    :dark_ambience
  end
end

define :cutoff_for_timbre do |timb|
  if timb < 0.5
    130
  elsif timb < 1.5
    85
  elsif timb < 2.5
    100
  elsif timb < 3.5
    140
  else
    90
  end
end

define :attack_for_timbre do |timb|
  if timb < 0.5
    0.05
  elsif timb < 1.5
    0.15
  elsif timb < 2.5
    0.02
  elsif timb < 3.5
    0.005
  else
    1.5
  end
end

define :release_for_timbre do |timb, dur|
  if timb < 0.5
    dur * 0.7
  elsif timb < 1.5
    dur * 0.6
  elsif timb < 2.5
    dur * 0.4
  elsif timb < 3.5
    dur * 0.3
  else
    dur * 1.5
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
    6.0
  end
end

define :amp_for_timbre do |timb|
  if timb < 0.5
    0.5
  elsif timb < 1.5
    0.7
  elsif timb < 2.5
    0.75
  elsif timb < 3.5
    0.6
  else
    0.45
  end
end

# Partial frequencies for spectral section (inharmonic series based on E)
$partials = [1.0, 1.2, 1.5, 1.87, 2.3, 2.8, 3.4]

live_loop :timbre_translation do
  beat = tick
  if beat > $total_beats
    sleep 4
  else
    timb = timbre_at(beat)
    note_idx = note_index_at(beat)
    dur = note_duration_at(beat)
    this_note = $motif[note_idx]
    synth = synth_for_timbre(timb)
    cutoff = cutoff_for_timbre(timb)
    attack = attack_for_timbre(timb)
    release = release_for_timbre(timb, dur)
    amp = amp_for_timbre(timb)
    use_synth synth
    if timb >= 3.5
      # Spectral: play motif note + inharmonic partials
      # The motif is still there, but buried in its own spectrum
      partial_amps = [1.0, 0.6, 0.4, 0.3, 0.2, 0.15, 0.1]
      $partials.each_with_index do |ratio, i|
        p_amp = partial_amps[i] * amp
        p_note = this_note * ratio
        play p_note, release: release, attack: attack, amp: p_amp, pan: rrand(-0.4, 0.4), cutoff: cutoff
      end
    elsif timb >= 2.5
      # Metal: note + octave + bright fifth (sharp harmonics)
      play this_note, release: release, attack: attack, amp: amp, pan: 0, cutoff: cutoff
      play this_note + 12, release: release * 0.6, attack: attack * 0.5, amp: amp * 0.4, pan: rrand(-0.2, 0.2), cutoff: cutoff + 20
      play this_note + 7, release: release * 0.5, attack: attack * 0.3, amp: amp * 0.3, pan: rrand(-0.15, 0.15), cutoff: cutoff + 10
    elsif timb >= 1.5
      # Voice: note + slight vibrato via detuned unison
      play this_note, release: release, attack: attack, amp: amp, pan: -0.1, cutoff: cutoff
      play this_note + 0.15, release: release, attack: attack, amp: amp * 0.5, pan: 0.1, cutoff: cutoff
    else
      # Glass and Wood: single note, timbre is the synth + cutoff
      play this_note, release: release, attack: attack, amp: amp, pan: 0, cutoff: cutoff
    end
    sleep dur
  end
end

live_loop :timbre_drone do
  beat = tick
  if beat > $total_beats
    sleep 4
  else
    timb = timbre_at(beat)
    amp = amp_for_timbre(timb) * 0.25
    drone_note = :E3
    synth = synth_for_timbre(timb)
    cutoff = cutoff_for_timbre(timb)
    use_synth synth
    if timb >= 3.5
      # Spectral drone: root + partials
      $partials.each_with_index do |ratio, i|
        p_amp = [1.0, 0.5, 0.35, 0.25, 0.18, 0.12, 0.08][i] * amp
        play drone_note * ratio, sustain: 8, attack: 4, release: 4, amp: p_amp, pan: rrand(-0.5, 0.3), cutoff: cutoff
      end
    else
      play drone_note, sustain: 8, amp: amp, attack: 4, release: 4, cutoff: cutoff
    end
    sleep 8
  end
end