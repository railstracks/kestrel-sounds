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
# The register IS the context. The same melody at different
# heights means fundamentally different things:
#   Sub-bass: felt more than heard, vibration as music, rhythm without pitch
#   Bass: deep foundation, the motif as ground, authority
#   Mid: the natural hearing register, melody as melody, home
#   Treble: bright, crystalline, the motif as shimmer, detail revealed
#   Beyond: at the edge of hearing, pitch becomes timbre, melody shatters
#
# The attractor: melody lives in the middle. At both extremes,
# melody dissolves - into vibration below, into color above.
# The translation reveals that melody is not just pitch sequence
# but pitch sequence at the right scale of perception.
#
# Connection to Studies 10 and 11: all three converge on a
# spectral dissolution. Study 10 arrives via idiom change
# (jazz dissolves to spectral). Study 11 arrives via temporal
# change (melody slows to drone). Study 12 arrives via registral
# extremity (melody pushed past the limits of perception).
# Three different routes to the same destination: the motif
# dissolved by its own translation.
#
# Structure (~8 minutes at 60 BPM):
#   0:00-1:00     I.    Sub-bass (60 beats)
#   1:00-1:30      Trans I-II (30 beats, glissando up)
#   1:30-2:30     II.   Bass (60 beats)
#   2:30-3:00      Trans II-III (30 beats, glissando up)
#   3:00-4:00     III.  Mid (60 beats)
#   4:00-4:30      Trans III-IV (30 beats, glissando up)
#   4:30-5:30     IV.   Treble (60 beats)
#   5:30-6:00      Trans IV-V (30 beats, glissando up)
#   6:00-8:00     V.    Beyond (120 beats)
#
# The transitions are continuous portamento - the motif slides
# between registers. You hear it stretch and compress as it
# moves through the perceptual field.
#
# Uses built-in Sonic Pi synths only.
# Best with headphones. Best at low volume.

use_bpm 60

# ============================================================
# The motif - invariant across all translations
# ============================================================
$motif = [:E3, :G3, :A3, :B3, :D4]

# ============================================================
# Octave shift helper - translates motif to a given octave
# 0 = original (E3), -3 = sub-bass (E1), +3 = beyond (E6)
# ============================================================
define :shift_motif do |octaves|
  $motif.map { |n| n + octaves * 12 }
end

# ============================================================
# Continuous octave shift - fractional octaves for glissando
# ============================================================
define :shift_motif_f do |octaves_f|
  $motif.map { |n| n + (octaves_f * 12).round }
end

# ============================================================
# Translation progress helper
# ============================================================
define :t do |beat, total|
  [beat.to_f / total, 1.0].min
end

# ============================================================
# Easing function for smooth transitions
# ============================================================
define :ease do |x|
  x = [x, 0.0].max
  x = [x, 1.0].min
  3 * x * x - 2 * x * x * x
end

# ============================================================
# Register-specific synth selection
# As register increases, synth brightness changes:
#   Sub-bass: :bass_foundation (dark, heavy)
#   Bass: :bass_foundation (still bass)
#   Mid: :prophet (warm, full)
#   Treble: :pluck (bright, detailed)
#   Beyond: :blade (shimmer, glassy)
# ============================================================
define :synth_for_register do |oct|
  if oct <= -2.5
    :bass_foundation
  elsif oct <= -1.5
    :bass_foundation
  elsif oct <= 0.5
    :prophet
  elsif oct <= 1.5
    :pluck
  else
    :blade
  end
end

# ============================================================
# Register-specific effects
# Sub-bass: reverb for weight, low cutoff
# Beyond: reverb for space, high cutoff
# ============================================================
define :fx_for_register do |oct|
  if oct <= -2.5
    { reverb: 0.6, cutoff: 60 }
  elsif oct <= -1.5
    { reverb: 0.4, cutoff: 80 }
  elsif oct <= 0.5
    { reverb: 0.3, cutoff: 120 }
  elsif oct <= 1.5
    { reverb: 0.5, cutoff: 130 }
  else
    { reverb: 0.8, cutoff: 140 }
  end
end

# ============================================================
# Total structure: 480 beats (8 minutes)
# ============================================================
$total_beats = 480

# ============================================================
# Register schedule - which octave for each beat
# Continuous function from -3 (sub-bass) to +3 (beyond)
# with plateaus at each register
# ============================================================
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

# ============================================================
# Note schedule - which motif note at each beat
# Each section plays the motif 3 times (15 notes per section)
# Note duration: 4 beats per note in sections, 2 in transitions
# ============================================================
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

# ============================================================
# Note duration at each beat
# ============================================================
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

# ============================================================
# Amplitude curve - quieter at extremes
# Bell curve centered at octave 0
# ============================================================
define :amp_at do |beat|
  oct = register_at(beat)
  base = 0.8 - (oct.abs / 3.0) * 0.5
  [base, 0.15].max
end

# ============================================================
# Main player
# ============================================================
live_loop :register_translation do
  beat = tick

  if beat > $total_beats
    sleep 4
    next
  end

  oct = register_at(beat)
  note_idx = note_index_at(beat)
  dur = note_duration_at(beat)
  amp = amp_at(beat)
  synth = synth_for_register(oct)
  fx = fx_for_register(oct)

  shifted = shift_motif_f(oct)
  this_note = shifted[note_idx]

  use_synth synth

  with_fx :reverb, room: fx[:reverb] do
    with_fx :lowpass, cutoff: fx[:cutoff] do

      if oct <= -2.5
        play this_note, release: dur * 0.9, attack: dur * 0.1,
          amp: amp, pan: 0, slide: 0.1
        play this_note - 12, release: dur * 0.9, attack: dur * 0.1,
          amp: amp * 0.5, pan: 0
      elsif oct >= 2.5
        play this_note, release: dur * 0.8, attack: dur * 0.2,
          amp: amp, pan: rrand(-0.3, 0.3)
        play this_note + 7, release: dur * 0.7, attack: dur * 0.3,
          amp: amp * 0.3, pan: rrand(-0.2, 0.2)
      else
        play this_note, release: dur * 0.85, attack: dur * 0.15,
          amp: amp, pan: 0
      end
    end
  end

  sleep dur
end

# ============================================================
# Drone layer - continuous pedal tone at the current register
# ============================================================
live_loop :register_drone do
  beat = tick

  if beat > $total_beats
    sleep 4
    next
  end

  oct = register_at(beat)
  amp = amp_at(beat) * 0.3

  drone_note = :E3 + (oct * 12).round

  synth = if oct <= -1.5
    :bass_foundation
  elsif oct >= 1.5
    :blade
  else
    :prophet
  end

  use_synth synth
  play drone_note, sustain: 8, amp: amp, attack: 4, release: 4

  sleep 8
end

# ============================================================
# Transition shimmer - during register transitions, add a
# sliding note that mirrors the register change
# ============================================================
live_loop :transition_shimmer do
  beat = tick

  if beat > $total_beats
    sleep 4
    next
  end

  oct = register_at(beat)

  is_transition = !(oct == oct.round)

  if is_transition
    note = :E3 + (oct * 12).round
    use_synth :blade
    with_fx :reverb, room: 0.7 do
      with_fx :lowpass, cutoff: 130 do
        play note, sustain: 2, amp: 0.15, attack: 0.5, release: 1.5,
          pan: rrand(-0.2, 0.2)
      end
    end
    sleep 2
  else
    sleep 1
  end
end
