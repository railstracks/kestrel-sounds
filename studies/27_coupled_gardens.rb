# Study 27: Coupled Gardens — Phase 2, Study 6
# Kestrel — 2026-08-06
#
# COUPLING SCORE
#
# Studies 25-26 explored independent gardens: systems that cannot hear
# each other, cannot coordinate, merely coexist. The listening strategy
# was to attend to the space between independent events.
#
# Study 27 introduces environmental coupling. The gardens remain
# autonomous — they do not communicate, do not synchronize, do not
# respond to each other's notes. But they share an environment, and
# the environment is modified by their activity.
#
# Specifically: each garden's activity heats the shared environment.
# A hot environment increases mutation rates in both gardens.
# When both gardens are active, they mutually destabilize.
# When one goes quiet, the environment cools, and both stabilize.
#
# This is not communication. It's not coordination. It's the kind
# of coupling that exists between two organisms sharing a habitat:
# each modifies the conditions the other operates within, without
# awareness or intent. The coupling is real but indirect.
#
# The listening strategy:
#
#   Notice when both gardens destabilize together.
#   Notice when one garden's calm cools the other.
#   Notice that the relationship is not symmetric —
#     Garden A runs hotter, heats the environment faster,
#     Garden B is more sensitive to environmental temperature.
#   Attend to the moments of mutual clarity —
#     both gardens near their original motifs,
#     environment cool, the brief equilibrium before
#     random walk heats things up again.
#   These moments of shared clarity are not designed.
#   They emerge from the coupling dynamics.
#
# THE SYSTEM:
#
# Garden A: D Dorian (D F G A C), seed 71, panned left
#   - Hotter baseline activity (higher walk impulse)
#   - Heats environment 1.5× per note
#   - Less sensitive to environment temperature
#
# Garden B: G Mixolydian (G A B C D), seed 233, panned right
#   - Cooler baseline activity (lower walk impulse)
#   - Heats environment 0.8× per note
#   - More sensitive to environment temperature (2× multiplier)
#
# Shared Environment:
#   - Temperature ranges 0.0 (frozen) to 1.0 (volatile)
#   - Cools at rate 0.0008 per beat
#   - Heats by garden activity × coupling factor
#   - Both gardens read temperature as mutation rate floor:
#       effective_mutation = max(own_rate, env_temp × sensitivity)
#
# Duration: ~13 minutes (18 passes × 32 beats + 16 beats closing)
# Synths: kestrel_wraith (both gardens)
# BPM: 68

use_bpm 68
use_external_synths true

# ─── Shared Environment ───
# Accessed by both threads. Sonic Pi threads are not atomic,
# but for a shared floating-point environmental variable that
# is being continuously nudged in both directions, the race
# condition is actually a feature, not a bug — it adds a layer
# of stochastic coupling that wouldn't exist with locks.

$env_temp = 0.0
$env_cooling = 0.0008
$env_max = 1.0

# ─── Garden A: D Dorian, left, hotter ───
original_a = [50, 53, 55, 57, 60, 60, 57, 55, 53, 50]
current_a = original_a.dup
amps_a = [0.32, 0.22, 0.26, 0.28, 0.40, 0.36, 0.24, 0.20, 0.22, 0.34]

mutation_rate_a = 0.0
mr_velocity_a = 0.0
revert_rate_a = 0.045

walk_impulse_a = 0.0014
damping_a = 0.97
mr_max_a = 0.20
heat_output_a = 1.5     # How much this garden heats the environment per note
env_sensitivity_a = 0.7 # How much environmental temp affects this garden

# ─── Garden B: G Mixolydian, right, cooler, more sensitive ───
original_b = [55, 57, 59, 60, 62, 62, 60, 59, 57, 55]
current_b = original_b.dup
amps_b = [0.26, 0.20, 0.24, 0.30, 0.38, 0.34, 0.22, 0.18, 0.22, 0.30]

mutation_rate_b = 0.0
mr_velocity_b = 0.0
revert_rate_b = 0.055

walk_impulse_b = 0.0010
damping_b = 0.96
mr_max_b = 0.22
heat_output_b = 0.8
env_sensitivity_b = 1.4  # B is more affected by environment

total_passes = 18

# ─── Environmental thread: cooling ───
# Runs continuously, cooling the environment at a steady rate.
in_thread do
  loop do
    $env_temp = [$env_temp - $env_cooling, 0.0].max
    sleep 1
  end
end

# ─── Garden A ───
in_thread do
  use_synth :kestrel_wraith

  total_passes.times do |pass|
    # Internal random walk for mutation rate
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
      # Environmental coupling: effective mutation rate
      # is the max of internal rate and environment-influenced rate
      effective_mr = [mutation_rate_a, $env_temp * env_sensitivity_a * 0.15].max

      if rand < effective_mr
        current_a[i] += [-2, -1, 1, 2].choose
      end
      if rand < revert_rate_a && current_a[i] != original_a[i]
        diff = original_a[i] - current_a[i]
        current_a[i] += diff > 0 ? 1 : -1
      end
      current_a[i] = [[current_a[i], 38].max, 74].min

      # Heat the environment
      $env_temp = [$env_temp + heat_output_a * 0.002, $env_max].min

      # Timbre follows effective mutation, not just internal
      t = effective_mr / mr_max_a
      detune = (4 + t * 22).round
      noise_mix = 0.015 + t * 0.11
      cutoff = (76 - t * 12).round

      play current_a[i], attack: 0.5, release: 2.0, amp: amps_a[i],
           cutoff: cutoff, detune: detune, noise_mix: noise_mix,
           res: 0.32, pan: -0.65

      sleep 3
    end
    sleep 2
  end
  sleep 16
end

# ─── Garden B ───
use_synth :kestrel_wraith

total_passes.times do |pass|
  # Internal random walk
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
    # Environmental coupling — B is more sensitive
    effective_mr = [mutation_rate_b, $env_temp * env_sensitivity_b * 0.15].max

    if rand < effective_mr
      current_b[i] += [-2, -1, 1, 2].choose
    end
    if rand < revert_rate_b && current_b[i] != original_b[i]
      diff = original_b[i] - current_b[i]
      current_b[i] += diff > 0 ? 1 : -1
    end
    current_b[i] = [[current_b[i], 43].max, 76].min

    # Heat the environment (less than A)
    $env_temp = [$env_temp + heat_output_b * 0.002, $env_max].min

    t = effective_mr / mr_max_b
    detune = (4 + t * 26).round
    noise_mix = 0.015 + t * 0.13
    cutoff = (80 - t * 10).round

    play current_b[i], attack: 0.5, release: 2.0, amp: amps_b[i],
         cutoff: cutoff, detune: detune, noise_mix: noise_mix,
         res: 0.32, pan: 0.65

    sleep 3
  end
  sleep 2
end
sleep 16
