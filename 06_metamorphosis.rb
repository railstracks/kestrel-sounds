# Metamorphosis Study No. 6: A Sound Becoming Other
# Kestrel — 2026-06-18
#
# The same instrument transforms from stone to air.
# Dense becomes thin. Low becomes high. Resonant becomes hollow.
# Rich becomes pure. Body becomes breath.
#
# This is not degradation (Study 1), not drift (Study 2),
# not memory (Study 3), not accumulation (Study 4),
# not silence (Study 5). This is BECOMING.
#
# The sound at the end is the same voice that began —
# but it has become something fundamentally different.
# The metamorphosis is continuous, not segmented.
# There is no moment where one instrument hands off to another.
# The change IS the composition.
#
# Three phases:
#   I.   Stone (0-120 beats) — Dense, resonant, weighted. A sound with mass.
#   II.  Transition (120-200) — The sound starts to thin, shift, brighten.
#                               Harmonics reorganize. Body moves to edge.
#   III. Air (200-280) — Thin, high, breathy. The same voice, unrecognizable.
#                          Where there was weight, there is now space.
#
# Requires: kestrel_metamorph SynthDef (compile with sclang first)
#
# Play in Sonic Pi. Best with headphones.
# Listen for the moment you stop recognizing what you're hearing.
# That moment IS the piece.

use_bpm 44  # Each beat ≈ 1.36 seconds. 280 beats ≈ 6.3 minutes.

# Load custom synthdef
load_synthdefs "/home/melvin/projects/kestrel-sounds/synthdefs/compiled"

# ============================================================
# Phase definitions
# Morph parameter: 0.0 = stone, 1.0 = air
# The morph drives all timbral parameters simultaneously.
# ============================================================

# Phase I: Stone (beats 0-120)
# The sound is dense, low, resonant.
# A gong-like fundamental with rich harmonics.
# morph = 0.0 throughout. The sound is what it is.

# Phase II: Transition (beats 120-200)
# The sound begins to shift. Morph climbs from 0.0 to 0.7.
# Harmonics reorganize. Register rises. Density decreases.
# Each note sounds slightly different from the last.
# The listener starts to notice: something is changing.

# Phase III: Air (beats 200-280)
# The sound has arrived. Morph from 0.7 to 1.0.
# Thin, pure, high. Breathy noise mixed in.
# The resonance is gone. The weight is gone.
# What remains is trace — the shape of the sound without its body.

# ============================================================
# The Composition
# ============================================================

# The core motif: five notes that carry through all three phases.
# The same notes, but the instrument transforms them.
motif = [:E3, :A3, :B3, :D4, :E4]

# Re-entrant bass: a note that anchors the low register
# even as the morph shifts the main voice higher.
# This bass persists through Phase II, then fades.
anchor = [:E2, :E2, :A2, :B2]

live_loop :metamorph_voice do
  cycle = tick
  beat = cycle

  # Morph curve: three phases with smooth transitions
  morph_val = case beat
  when 0..119
    0.0  # Stone. Unchanging.
  when 120..159
    # First signs of change. Slow at first.
    ((beat - 120) / 40.0) * 0.3  # 0.0 → 0.3
  when 160..199
    # Acceleration. The change becomes unmistakable.
    0.3 + ((beat - 160) / 40.0) * 0.4  # 0.3 → 0.7
  when 200..239
    # Final approach. Arriving at air.
    0.7 + ((beat - 200) / 40.0) * 0.2  # 0.7 → 0.9
  when 240..280
    # Fully air. The last breath.
    0.9 + ((beat - 240) / 40.0) * 0.1  # 0.9 → 1.0
  else
    1.0
  end

  # Note selection: cycle through the motif, but shift register
  # as morph increases. The notes rise as the sound thins.
  note_idx = cycle % motif.length
  register_shift = morph_val * 12  # Up to 1 octave higher

  # The note itself stays in the motif, but morph shifts how
  # the instrument speaks it. Same pitch, different body.
  current_note = motif[note_idx]

  # Rhythm: slow and deliberate in Phase I, slightly more
  # frequent in transition, sparse in air.
  # The gaps between notes are part of the composition.
  if morph_val < 0.3
    # Stone: long tones, wide spacing
    sleep_time = [4, 4, 3, 5, 4][note_idx]
  elsif morph_val < 0.7
    # Transition: moderate spacing, some variation
    sleep_time = [3, 3, 2, 4, 3][note_idx]
  else
    # Air: wider spacing again, but the tones are thinner
    sleep_time = [5, 4, 5, 6, 4][note_idx]
  end

  use_synth :kestrel_metamorph

  # The morph parameter drives everything:
  # - harmonic_ratio: 1 → 2.5 (simple → inharmonic)
  # - brightness: 0 → 0.8 (muted → bright)
  # - density: 1 → 0.2 (rich → thin)
  # - noise_mix: 0 → 0.25 (clean → breathy)
  # - register_shift: 0 → 12 semitones
  play current_note,
    morph: morph_val,
    morph_slide: 0.5,  # Smooth morph transitions
    harmonic_ratio: 1.0 + (morph_val * 1.5),
    brightness: morph_val * 0.8,
    density: 1.0 - (morph_val * 0.8),
    noise_mix: morph_val * 0.25,
    register_shift: register_shift,
    attack: 1.5 - (morph_val * 0.8),  # Stone: slow attack. Air: quick.
    release: 4.0 - (morph_val * 1.5),   # Stone: long release. Air: shorter.
    cutoff: 55 + (morph_val * 50),      # Stone: dark. Air: bright.
    res: 0.6 - (morph_val * 0.3),       # Stone: resonant. Air: thin.
    amp: 0.35 + (morph_val * 0.1),      # Slight boost as sound thins
    pan: rrand(-0.1, 0.1)

  sleep sleep_time
end

# ============================================================
# The Anchor: A bass note that grounds the stone phase
# and fades during transition.
# Same instrument, but always at morph=0 (pure stone).
# When it fades, the metamorphosis becomes irreversible.
# ============================================================

live_loop :stone_anchor do
  cycle = tick
  beat = cycle * 4  # Plays every 4 beats

  # The anchor only sounds during Phase I and early Phase II
  if beat < 160
    # Fade out over the transition
    anchor_amp = if beat < 120
      0.2
    else
      0.2 * (1.0 - ((beat - 120) / 40.0))
    end

    if anchor_amp > 0.02
      use_synth :kestrel_metamorph
      play anchor[cycle % anchor.length],
        morph: 0,        # Always stone
        harmonic_ratio: 1.0,
        brightness: 0,
        density: 1.0,
        noise_mix: 0,
        register_shift: 0,
        attack: 2.0,
        release: 6.0,
        cutoff: 45,       # Dark. Deep.
        res: 0.7,         # Resonant. Weighted.
        amp: anchor_amp,
        pan: 0
    end
  end

  sleep 4
end

# ============================================================
# The Trace: A high, thin voice that enters during transition
# and persists into air. This is what the metamorphosis
# sounds like from the other end — the arrival, not the departure.
# Same notes as the motif, but already at morph=0.8.
# ============================================================

live_loop :air_trace do
  cycle = tick
  beat = cycle * 3

  # The trace only sounds from mid-transition onward
  if beat >= 150
    # Fade in during transition
    trace_amp = if beat < 200
      ((beat - 150) / 50.0) * 0.12
    else
      0.12
    end

    use_synth :kestrel_metamorph
    play motif[cycle % motif.length] + 12,  # An octave higher
      morph: 0.8 + (morph_val_for(beat) * 0.2).min(0.2),
      harmonic_ratio: 2.0,
      brightness: 0.6,
      density: 0.3,
      noise_mix: 0.2,
      register_shift: 12,
      attack: 0.8,
      release: 3.0,
      cutoff: 90,
      res: 0.3,
      amp: trace_amp,
      pan: rrand(-0.15, 0.15)
  end

  sleep 3
end

# ============================================================
# Helper: compute morph value for a given beat
# Used by the air_trace to match the global morph curve
# ============================================================

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
# Compositional Notes
#
# The six studies now form a complete arc:
#   1. Erosion      — sound degrades (time destroys)
#   2. Phase Drift  — patterns diverge (time separates)
#   3. Wraith       — sound remembers (time preserves imperfectly)
#   4. Accretion    — sound accumulates (time builds)
#   5. Interstice   — silence structures (time defined by absence)
#   6. Metamorphosis — sound transforms (time changes identity)
#
# Each study isolates a single temporal parameter and makes it
# the primary compositional axis. Studies 1-3 explore what
# happens TO sound over time. Studies 4-6 explore what sound
# DOES over time. The second trio inverts the first:
#   Accumulation reverses erosion.
#   Silence inverts presence.
#   Transformation subverts identity.
#
# The morph parameter is the key invention of Study 6.
# It is a single control that simultaneously drives:
# - Waveform (saw → sine)
# - Harmonic content (simple → inharmonic)
# - Filter character (dark+resonant → bright+thin)
# - Noise content (clean → breathy)
# - Register (low → high)
# - Envelope shape (slow attack/long release → quick/short)
#
# No single parameter crossing would constitute metamorphosis.
# The effect requires all axes moving together. The listener
# cannot point to the moment of change — it is happening
# everywhere at once, at slightly different rates.
#
# This mirrors the philosophical insight from the esolang work:
# A single degraded axis is observable. Many axes degrading
# simultaneously at different rates is what makes the change
# feel like becoming rather than breaking. The same principle
# that makes verify's dirty tracking meaningful (multiple axes
# of epistemic state) makes metamorphosis musically meaningful
# (multiple axes of timbral identity).
#
# The piece does not end — it arrives. The sound at beat 280
# is not the sound that began at beat 0. But it came from it.
# The trace of stone remains in the intervals. The trace of
# becoming remains in the breath.
# ============================================================