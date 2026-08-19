# Metamorphosis Study No. 6: A Sound Becoming Other
# Kestrel — 2026-06-18
#
# The same instrument transforms from stone to air.
# Dense becomes thin. Low becomes high. Resonant becomes hollow.
# Rich becomes pure. Body becomes breath.
#
# Uses built-in Sonic Pi synths. The morph from stone to air is
# achieved by crossfading between :prophet (rich/dense) and :sine
# (pure/thin) while sweeping cutoff, resonance, and octave.
#
# Three phases:
#   I.   Stone (0-120 beats) — Dense, resonant, weighted. A sound with mass.
#   II.  Transition (120-200) — The sound starts to thin, shift, brighten.
#   III. Air (200-280) — Thin, high, breathy. The same voice, unrecognizable.

use_bpm 44

# ============================================================
# Phase definitions
# Morph parameter: 0.0 = stone, 1.0 = air
# ============================================================

motif = [:E3, :A3, :B3, :D4, :E4]
anchor = [:E2, :E2, :A2, :B2]

def morph_val_for(beat)
  case beat
  when 0..119
    0.0
  when 120..159
    ((beat - 120) / 40.0) * 0.3
  when 160..199
    0.3 + ((beat - 160) / 40.0) * 0.4
  when 200..239
    0.7 + ((beat - 200) / 40.0) * 0.2
  when 240..280
    0.9 + ((beat - 240) / 40.0) * 0.1
  else
    1.0
  end
end

# ============================================================
# Main voice: morphs from stone to air
# Stone = :prophet (rich saws, dark filter, low register)
# Air = :sine (pure tone, bright filter, high register, noise)
# The crossfade is driven by the morph parameter.
# ============================================================

live_loop :metamorph_voice do
  cycle = tick
  beat = cycle

  morph_val = morph_val_for(beat)
  note_idx = cycle % motif.length
  current_note = motif[note_idx]

  # Rhythm changes with morph
  sleep_time = if morph_val < 0.3
    [4, 4, 3, 5, 4][note_idx]
  elsif morph_val < 0.7
    [3, 3, 2, 4, 3][note_idx]
  else
    [5, 4, 5, 6, 4][note_idx]
  end

  # Register shift: notes rise as morph increases
  shifted_note = current_note + (morph_val * 12).round

  # Cutoff: dark (stone) → bright (air)
  cutoff_val = 55 + (morph_val * 50)

  # Resonance: high (stone) → low (air)
  res_val = 0.7 - (morph_val * 0.4)

  # Amp: slight boost as sound thins
  amp_val = 0.3 + (morph_val * 0.1)

  # Stone voice: :prophet with rich harmonics
  # As morph increases, this voice fades
  stone_amp = amp_val * (1.0 - morph_val)
  if stone_amp > 0.02
    use_synth :prophet
    play shifted_note,
      attack: 1.5 - (morph_val * 0.8),
      release: 4.0 - (morph_val * 1.5),
      cutoff: cutoff_val,
      res: res_val,
      detune: 8 - (morph_val * 6),
      amp: stone_amp,
      pan: rrand(-0.1, 0.1)
  end

  # Air voice: :sine with noise, high and thin
  # As morph increases, this voice grows
  air_amp = amp_val * morph_val * 0.8
  if air_amp > 0.02
    use_synth :sine
    play shifted_note,
      attack: 0.3 + (morph_val * 0.5),
      release: 3.0 - (morph_val * 1.0),
      cutoff: cutoff_val + 20,
      amp: air_amp,
      pan: rrand(-0.1, 0.1)

    # Breath noise layer for air phase
    if morph_val > 0.4
      use_synth :dark_ambience
      play shifted_note + 7,
        attack: 0.5,
        release: 2.0,
        cutoff: 3000 + (morph_val * 3000),
        amp: air_amp * 0.3,
        pan: rrand(-0.2, 0.2)
    end
  end

  sleep sleep_time
end

# ============================================================
# Stone Anchor: bass note that grounds Phase I, fades in II
# ============================================================

live_loop :stone_anchor do
  cycle = tick
  beat = cycle * 4

  if beat < 160
    anchor_amp = if beat < 120
      0.18
    else
      0.18 * (1.0 - ((beat - 120) / 40.0))
    end

    if anchor_amp > 0.02
      use_synth :prophet
      play anchor[cycle % anchor.length],
        attack: 2.0,
        release: 6.0,
        cutoff: 45,
        res: 0.8,
        detune: 12,
        amp: anchor_amp,
        pan: 0
    end
  end

  sleep 4
end

# ============================================================
# Air Trace: high thin voice entering during transition
# ============================================================

live_loop :air_trace do
  cycle = tick
  beat = cycle * 3

  if beat >= 150
    morph_at_beat = morph_val_for(beat)
    trace_amp = if beat < 200
      ((beat - 150) / 50.0) * 0.1
    else
      0.1
    end

    if trace_amp > 0.02
      use_synth :sine
      play motif[cycle % motif.length] + 12,
        attack: 0.8,
        release: 3.0,
        cutoff: 90,
        amp: trace_amp,
        pan: rrand(-0.15, 0.15)
    end
  end

  sleep 3
end
