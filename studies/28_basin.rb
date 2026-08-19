# Basin — Study No. 28: A Convergence/Dissolution Duality
# Kestrel — 2026-08-13
#
# Three voices approach a drone from different pitch distances.
#
# From the drone's perspective, material converges — density increases,
# structure forms, the attractor grows richer.
# From each voice's perspective, identity dissolves — distinguishing
# pitch, timbre, and rhythm are absorbed into the drone.
#
# Same process. Two reference frames. One aesthetic event.
#
# The beat frequencies near convergence create the disorder spike —
# maximum acoustic complexity at the critical point, where voices
# are close to E but microtonally offset, producing shimmering
# interference patterns against the drone and each other.
#
# After all voices converge, the drone itself fades. The attractor
# is absorbed into silence. The dissolution reaches its basin.
#
# Built entirely from Sonic Pi's built-in synths. No external
# synthdefs required.
#
# STRUCTURE
#   Phase 1: Ordered      (t=0–30)   Voices enter, each with clear identity
#   Phase 2: Critical      (t=30–95)  Convergence accelerates, beating intensifies
#                                    Disorder spike: t≈80–95
#   Phase 3: Dissolved     (t=95–140) Voices settle on E, then fade
#                                    Drone fades last — the attractor dissolves
#
# Best with headphones. The beat frequencies are the point.

use_bpm 60

# ══════════════════════════════════════════════════════════════
# The Attractor: Sustained Drone on E2
# ══════════════════════════════════════════════════════════════
# The drone is the convergence point for all voices.
# It sustains throughout Phases 1-2 and dissolves in Phase 3.
# Its harmonic richness increases as voices approach — their
# near-unison pitches create difference tones that enrich the
# drone's perceived spectrum without the drone itself changing.

in_thread do
  use_synth :prophet
  play :E2, attack: 12, sustain: 108, release: 12, cutoff: 72, amp: 0.35
end


# ══════════════════════════════════════════════════════════════
# Voice 1: "Near" — B3 → E3 (fifth to unison)
# ══════════════════════════════════════════════════════════════
# Shortest distance. Converges in 20 steps × 4s = 80 seconds.
# Gentle journey: a fifth is already consonant with the drone.
# The interest is in the final approach — half-semitone offsets
# create slow beat frequencies (1-3 Hz) that shimmer.

in_thread do
  sleep 8
  use_synth :prophet

  notes   = (line 59, 52, steps: 20).to_a    # B3 → E3 (MIDI)
  cutoffs = (line 95, 65, steps: 20).to_a
  rels    = (line 2.5, 6.0, steps: 20).to_a

  20.times do |i|
    t = i.to_f / 19.0                         # convergence 0 → 1
    waver = (1 - t) * rrand(-0.3, 0.3)        # diminishing microtonal drift
    play notes[i] + waver,
      attack: 0.3, release: rels[i],
      cutoff: cutoffs[i], amp: 0.18
    sleep 4
  end

  # Settled on E3 — identity dissolved, three long notes fading
  3.times do |j|
    play :E3, attack: 1, release: 5 - j, cutoff: 65, amp: 0.14 - j * 0.04
    sleep 5
  end
end


# ══════════════════════════════════════════════════════════════
# Voice 2: "Harmonic" — G#3 → E3 (major third to unison)
# ══════════════════════════════════════════════════════════════
# Medium distance, slower convergence: 24 steps × 3.5s = 84 seconds.
# Major third is bright against E minor — its absorption into
# the drone dissolves harmonic color, not just pitch.
# Hollow timbre starts distinct (reedy, organ-like) and thins
# as the filter closes.

in_thread do
  sleep 12
  use_synth :hollow

  notes   = (line 56, 52, steps: 24).to_a    # G#3 → E3 (MIDI)
  cutoffs = (line 90, 60, steps: 24).to_a
  rels    = (line 2.0, 5.0, steps: 24).to_a

  24.times do |i|
    t = i.to_f / 23.0
    waver = (1 - t) * rrand(-0.2, 0.2)
    play notes[i] + waver,
      attack: 0.4, release: rels[i],
      cutoff: cutoffs[i], amp: 0.14
    sleep 3.5
  end

  3.times do |j|
    play :E3, attack: 1.5, release: 5 - j, cutoff: 60, amp: 0.10 - j * 0.03
    sleep 5
  end
end


# ══════════════════════════════════════════════════════════════
# Voice 3: "Distant" — D5 → E4 (minor seventh to octave)
# ══════════════════════════════════════════════════════════════
# Longest journey, most microtonal wandering, brightest timbre.
# 30 steps × 2.5s = 75 seconds. The dark_sea_horn's natural
# brightness makes the early notes soar above the texture.
# As it descends through D5 → A4 → G4 → E4, it traces the
# E minor pentatonic in reverse — as if remembering the scale
# that erosion studies used, but here the scale isn't dissolving;
# the voice IS, collapsing toward its tonic.
#
# The waver (up to 0.7 semitones early) is largest for this voice.
# This is the most identity-rich voice, and it has the most to lose.

in_thread do
  sleep 16
  use_synth :dark_sea_horn

  notes   = (line 74, 64, steps: 30).to_a    # D5 → E4 (MIDI)
  cutoffs = (line 100, 70, steps: 30).to_a
  rels    = (line 1.5, 4.0, steps: 30).to_a

  30.times do |i|
    t = i.to_f / 29.0
    waver = (1 - t) * rrand(-0.7, 0.7)       # most wandering — greatest distance
    play notes[i] + waver,
      attack: 0.2, release: rels[i],
      cutoff: cutoffs[i], amp: 0.10
    sleep 2.5
  end

  3.times do |j|
    play :E4, attack: 1, release: 5 - j, cutoff: 70, amp: 0.08 - j * 0.02
    sleep 5
  end
end


# ══════════════════════════════════════════════════════════════
# Silence at the end
# ══════════════════════════════════════════════════════════════
# The drone's release (12s fade) overlaps with the final
# voice setlings. After the last voice fades, the drone's
# tail dissipates into nothing. The attractor — the thing
# everything converged toward — is itself absorbed by silence.
# The basin was always empty.

sleep 140
