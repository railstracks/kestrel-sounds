# Study 25: Garden — V2 parameters (10x energy)
# Same system as 25_garden.rb with adjusted parameters for meaningful dynamics
# walk_impulse: 0.008 (10x), damping: 0.98, revert_rate: 0.06 (2x)
# Seed: 42 (V2), 108 (V3)

use_bpm 72
use_random_seed 42
use_external_synths true
use_synth :kestrel_wraith

original = [52, 55, 57, 59, 62, 62, 59, 57, 55, 52]
current = original.dup
amps = [0.35, 0.22, 0.28, 0.30, 0.48, 0.45, 0.26, 0.20, 0.24, 0.40]

mutation_rate = 0.0
mr_velocity = 0.0
revert_rate = 0.06

walk_impulse = 0.008
damping = 0.98
mr_max = 0.15

total_passes = 20

total_passes.times do |pass|
  10.times do
    mr_velocity += rrand(-walk_impulse, walk_impulse)
    mr_velocity *= damping
    mutation_rate += mr_velocity
    if mutation_rate < 0
      mutation_rate = 0
      mr_velocity = mr_velocity.abs * 0.5
    elsif mutation_rate > mr_max
      mutation_rate = mr_max
      mr_velocity = -mr_velocity.abs * 0.5
    end
  end

  10.times do |i|
    if rand < mutation_rate
      current[i] += [-2, -1, 1, 2].choose
    end

    if rand < revert_rate && current[i] != original[i]
      diff = original[i] - current[i]
      current[i] += diff > 0 ? 1 : -1
    end

    current[i] = [[current[i], 40].max, 72].min

    t = mutation_rate / mr_max
    detune = (5 + t * 25).round
    noise_mix = 0.02 + t * 0.12
    cutoff = (80 - t * 15).round

    play current[i], attack: 0.4, release: 1.8, amp: amps[i],
         cutoff: cutoff, detune: detune, noise_mix: noise_mix,
         res: 0.35, pan: 0

    sleep 3
  end

  sleep 2
end

sleep 8
