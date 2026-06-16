# Wraith Study No. 3: The Sound Remembering Itself
# Kestrel — 2026-06-16
#
# Uses kestrel_wraith — my first custom SuperCollider synth.
# Two detuned saw oscillators, resonant filter with its own
# envelope, sub-oscillator, noise layer.
#
# The "memory" motif: notes start filtered (distant/muffled),
# the filter opens (becoming present), then closes
# (fading back). Like a sound trying to recall what it was.
#
# The wraith filter envelope IS the composition.
# Cutoff controls how present the sound feels.
# Low cutoff = memory (distant, muffled)
# High cutoff = presence (clear, immediate)
#
# Load synthdef first, then play.

# Load the custom synthdef
load_synthdefs "/home/melvin/projects/kestrel-sounds/synthdefs/compiled"

use_bpm 52

# The remembering motif: a simple minor progression
# Each note rises from memory (filtered) into presence (open)
# then fades back into distance
remembering_notes = [:A3, :C4, :E4, :G4, :A4]

live_loop :memory_voice do
  use_synth 'kestrel_wraith'
  
  cycle = tick
  note_idx = cycle % remembering_notes.length
  
  # The filter journey: low -> high -> low
  # This IS the emotional arc of the piece
  phase = (cycle % 16) / 16.0
  
  # Cutoff oscillates between distant (60) and present (100)
  cutoff_journey = 60 + (40 * Math.sin(phase * Math::PI * 2).abs)
  
  play remembering_notes[note_idx],
    attack: 0.8,
    release: 3.0,
    cutoff: cutoff_journey,
    res: 0.6 + (0.3 * Math.sin(cycle * 0.3)),
    detune: 5 + (cycle % 8),  # Slowly increasing detune = increasing uncertainty
    noise_mix: 0.05,
    sub_level: 0.25,
    amp: 0.4,
    pan: rrand(-0.2, 0.2)
  
  sleep [2, 3, 2, 4].choose
end

# The echo: same notes, always distant, always filtered
# Like the memory of a sound you can't quite reach
live_loop :distant_echo do
  use_synth 'kestrel_wraith'
  
  cycle = tick
  echo_note = remembering_notes.choose
  
  play echo_note - 12,  # One octave down: the echo is always lower
    attack: 1.5,
    release: 5.0,
    cutoff: 55,  # Always filtered — never fully present
    res: 0.7,
    detune: 15,  # More detuned: the echo is less precise
    noise_mix: 0.12,  # More noise: less clarity
    sub_level: 0.35,  # More sub: the echo has more body but less detail
    amp: 0.2,
    pan: rrand(-0.4, 0.4)
  
  sleep [4, 6, 8].choose
end

# Occasional presence: a note that breaks through
# High cutoff, low detune, minimal noise
# The moment of clarity before it fades again
live_loop :the_moment do
  use_synth 'kestrel_wraith'
  
  if one_in(5)
    play remembering_notes.choose + 12,
      attack: 0.01,
      release: 1.0,
      cutoff: 105,  # Almost fully open — clarity
      res: 0.3,
      detune: 2,    # Nearly unison — precision
      noise_mix: 0.02,  # Minimal noise — clean
      sub_level: 0.1,
      amp: 0.25,
      pan: 0
  end
  
  sleep 3
end