# Wraith Study No. 3: The Sound Remembering Itself
# Kestrel — 2026-06-16
#
# Original used a custom SuperCollider synth (kestrel_wraith).
# This version layers built-in Sonic Pi synths to approximate
# the same character: detuned saws + sub + noise through a
# moving resonant filter.
#
# The "memory" motif: notes start filtered (distant/muffled),
# the filter opens (becoming present), then closes
# (fading back). Like a sound trying to recall what it was.
#
# The wraith filter envelope IS the composition.
# Cutoff controls how present the sound feels.
# Low cutoff = memory (distant, muffled)
# High cutoff = presence (clear, immediate)

use_bpm 52

# The remembering motif: a simple minor progression
# Each note rises from memory (filtered) into presence (open)
# then fades back into distance
remembering_notes = [:A3, :C4, :E4, :G4, :A4]

# Voice 1: The remembering voice
# :prophet gives us the detuned saw character with built-in detune control
live_loop :memory_voice do
  with_fx :reverb, room: 0.8, mix: 0.4 do
    cycle = tick
    note_idx = cycle % remembering_notes.length
    
    # The filter journey: low -> high -> low
    # This IS the emotional arc of the piece
    phase = (cycle % 16) / 16.0
    
    # Cutoff oscillates between distant (60) and present (100)
    cutoff_journey = 60 + (40 * Math.sin(phase * Math::PI * 2).abs)
    
    use_synth :prophet
    play remembering_notes[note_idx],
      attack: 0.8,
      release: 3.0,
      cutoff: cutoff_journey,
      res: 0.6 + (0.3 * Math.sin(cycle * 0.3)),
      detune: 5 + (cycle % 8),  # Slowly increasing detune = increasing uncertainty
      amp: 0.3,
      pan: rrand(-0.2, 0.2)
    
    sleep [2, 3, 2, 4].choose
  end
end

# Voice 2: The echo — same notes, always distant, always filtered
# Like the memory of a sound you can't quite reach
live_loop :distant_echo do
  with_fx :reverb, room: 0.9, mix: 0.6 do
    with_fx :echo, phase: 1.5, decay: 4, mix: 0.3 do
      cycle = tick
      echo_note = remembering_notes.choose
      
      use_synth :hollow
      play echo_note - 12,  # One octave down: the echo is always lower
        attack: 1.5,
        release: 5.0,
        cutoff: 55,  # Always filtered — never fully present
        res: 0.7,
        amp: 0.15,
        pan: rrand(-0.4, 0.4)
      
      sleep [4, 6, 8].choose
    end
  end
end

# Voice 3: Occasional presence — a note that breaks through
# High cutoff, low detune, minimal noise
# The moment of clarity before it fades again
live_loop :the_moment do
  with_fx :reverb, room: 0.5, mix: 0.2 do
    if one_in(5)
      use_synth :dark_sea_horn
      play remembering_notes.choose + 12,
        attack: 0.01,
        release: 1.0,
        cutoff: 105,  # Almost fully open — clarity
        amp: 0.2,
        pan: 0
    end
    
    sleep 3
  end
end
