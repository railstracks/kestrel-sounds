# Erosion Study No. 1
# Kestrel — 2026-06-16
#
# Notes begin precise and gradually lose coherence.
# Pitch drifts, timing stutters, amplitude fades.
# The degradation IS the composition.
#
# Play in Sonic Pi. Best with headphones.

use_bpm 60

# Erosion curve: how quickly things fall apart
# 0 = pristine, 1 = fully eroded
erosion_rate = 0.003

# Base pitch set: a simple pentatonic that feels like wind over ridgeline
base_notes = [:E3, :G3, :A3, :B3, :D4]

# How many cycles before erosion is total
total_cycles = 333

live_loop :erosion_main do
  cycle = tick
  
  # Erosion increases over time
  erosion = [cycle * erosion_rate, 1.0].min
  
  # Choose a note, drifting more as erosion increases
  note_index = [0, 1, 2, 3, 4].choose
  if rand < erosion * 0.3
    # Eroded: skip to a random scale degree instead
    note_index = [0, 1, 2, 3, 4, 0, 4, 2].choose
  end
  
  # Pitch drift: erosion adds random detuning
  drift = erosion * rrand(-0.5, 0.5)
  played_note = base_notes[note_index] + drift
  
  # Timing stutter: erosion makes rhythm imprecise
  timing_offset = erosion * rrand(-0.1, 0.1)
  
  # Amplitude decay: notes get quieter as erosion progresses
  amp_level = 1.0 - (erosion * 0.7)
  
  # Probability of playing at all: erosion sometimes swallows notes entirely
  play_prob = 1.0 - (erosion * 0.4)
  
  if rand < play_prob
    play played_note,
      release: 0.8 + (erosion * 1.2),
      amp: amp_level * 0.5,
      pan: rrand(-0.3, 0.3) + (erosion * rrand(-0.5, 0.5))
      
    # Add a subtle resonance that grows as erosion increases
    if erosion > 0.3
      play base_notes[note_index] - 12,
        release: 2.0 + (erosion * 2.0),
        amp: (erosion - 0.3) * 0.3 if rand < 0.6
    end
  end
  
  # Sleep duration stretches with erosion — time itself slows
  sleep [0.5, 0.25, 0.75, 1.0].choose * (1.0 + (erosion * 0.5)) + timing_offset.abs
end

# Background drone: a single sustained tone that persists even as melody erodes
live_loop :persistence do
  use_synth :dark_ambience
  
  erosion = (tick % 1000) * 0.001
  
  play :E2,
    release: 8.0,
    amp: 0.15 if one_in(2)
  
  # The drone itself erodes, but much more slowly
  sleep 4.0 * (1.0 + erosion * 2.0)
end

# Occasional clear tone: a memory of precision cutting through the erosion
live_loop :memory do
  use_synth :pretty_bell
  erosion = (tick % 333) * 0.003
  
  if one_in(8) && erosion < 0.8
    play base_notes.choose,
      release: 2.0,
      amp: (1.0 - erosion) * 0.3
  end
  
  sleep [2, 4, 6, 8].choose
end