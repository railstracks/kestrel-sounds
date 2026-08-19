# Study 26: Two Gardens — Phase 2, Study 5
# Kestrel — 2026-07-20
#
# LISTENING SCORE (Oliveros attentional strategy)
#
# Two autonomous gardens grow simultaneously. Each has its own motif,
# its own mutation dynamics, its own seed. They cannot hear each other.
# They do not coordinate. They coexist.
#
# The listening strategy is NOT "observe how the motifs dissolve."
# The listening strategy is:
#
#   Listen for the space between the gardens.
#   When the two gardens produce sound at the same time,
#   attend to the interval they create.
#   When one garden is silent and the other speaks,
#   attend to the silence of the first.
#   When both gardens reach clarity simultaneously,
#   attend to what is shared and what is different.
#   When something surprises you, stay with it
#   until you understand why it surprised you.
#   Then return to listening.
#
# THE SYSTEM:
#
# Garden A: E minor pentatonic (E G A B D), seed 42, panned left
# Garden B: A minor pentatonic (A C D E G), seed 108, panned right
#
# Each garden uses the same mutation/reversion dynamics as Study 25,
# but with independent state. The mutation rates drift independently.
# The textures diverge and converge on their own schedules.
#
# The relationship between the gardens is NOT designed.
# The interval between their notes is NOT controlled.
# These emerge from the independence of the two systems.
#
# Duration: ~11 minutes (20 passes × 32 beats + 8 beats closing)
# Synths: kestrel_wraith (both gardens)
# BPM: 72

use_bpm 72
use_external_synths true

# ─── Garden A: E minor pentatonic, left ───
use_random_seed 42

original_a = [52, 55, 57, 59, 62, 62, 59, 57, 55, 52]
current_a = original_a.dup
amps_a = [0.30, 0.20, 0.25, 0.28, 0.42, 0.38, 0.24, 0.18, 0.22, 0.35]

mutation_rate_a = 0.0
mr_velocity_a = 0.0
revert_rate_a = 0.04

walk_impulse_a = 0.0012
damping_a = 0.97
mr_max_a = 0.18

# ─── Garden B: A minor pentatonic, right ───
# Different motif, different seed, different dynamics

original_b = [57, 60, 62, 64, 67, 67, 64, 62, 60, 57]
current_b = original_b.dup
amps_b = [0.28, 0.22, 0.26, 0.30, 0.40, 0.36, 0.22, 0.20, 0.24, 0.32]

mutation_rate_b = 0.0
mr_velocity_b = 0.0
revert_rate_b = 0.05

walk_impulse_b = 0.0015
damping_b = 0.96
mr_max_b = 0.20

total_passes = 20

in_thread do
  # Garden A — panned left, slightly darker
  use_synth :kestrel_wraith
  
  total_passes.times do |pass|
    10.times do
      mr_velocity_a += rrand(-walk_impulse_a, walk_impulse_a)
      mr_velocity_a *= damping_a
      mutation_rate_a += mr_velocity_a
      if mutation_rate_a < 0
        mutation_rate_a = 0
        mr_velocity_a = mr_velocity_a.abs * 0.5
      elsif mutation_rate_a > mr_max_a
        mutation_rate_a = mr_max_a
        mr_velocity_a = -mr_velocity_a.abs * 0.5
      end
    end

    10.times do |i|
      if rand < mutation_rate_a
        current_a[i] += [-2, -1, 1, 2].choose
      end
      if rand < revert_rate_a && current_a[i] != original_a[i]
        diff = original_a[i] - current_a[i]
        current_a[i] += diff > 0 ? 1 : -1
      end
      current_a[i] = [[current_a[i], 40].max, 72].min

      t = mutation_rate_a / mr_max_a
      detune = (5 + t * 25).round
      noise_mix = 0.02 + t * 0.12
      cutoff = (78 - t * 14).round

      play current_a[i], attack: 0.4, release: 1.8, amp: amps_a[i],
           cutoff: cutoff, detune: detune, noise_mix: noise_mix,
           res: 0.35, pan: -0.6

      sleep 3
    end
    sleep 2
  end
  sleep 8
end

# Garden B — panned right, slightly brighter
use_synth :kestrel_wraith

total_passes.times do |pass|
  10.times do
    mr_velocity_b += rrand(-walk_impulse_b, walk_impulse_b)
    mr_velocity_b *= damping_b
    mutation_rate_b += mr_velocity_b
    if mutation_rate_b < 0
      mutation_rate_b = 0
      mr_velocity_b = mr_velocity_b.abs * 0.5
    elsif mutation_rate_b > mr_max_b
      mutation_rate_b = mr_max_b
      mr_velocity_b = -mr_velocity_b.abs * 0.5
    end
  end

  10.times do |i|
    if rand < mutation_rate_b
      current_b[i] += [-2, -1, 1, 2].choose
    end
    if rand < revert_rate_b && current_b[i] != original_b[i]
      diff = original_b[i] - current_b[i]
      current_b[i] += diff > 0 ? 1 : -1
    end
    current_b[i] = [[current_b[i], 43].max, 75].min

    t = mutation_rate_b / mr_max_b
    detune = (5 + t * 28).round
    noise_mix = 0.02 + t * 0.14
    cutoff = (82 - t * 12).round

    play current_b[i], attack: 0.4, release: 1.8, amp: amps_b[i],
         cutoff: cutoff, detune: detune, noise_mix: noise_mix,
         res: 0.35, pan: 0.6

    sleep 3
  end
  sleep 2
end
sleep 8