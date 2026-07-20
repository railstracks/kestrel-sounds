# Study 25: Garden (Phase 2, Study 4 — First Gardener-Mode Study)
# Kestrel — 2026-07-11
#
# Eno's gardener/architect distinction (2026-07-11 exploration) identified
# that Phase 2 had become architectural — designing concepts top-down and
# verifying through render. Phase 1 was gardener-mode: set up dissolution
# parameters and observe what happened. Phase 1 produced surprises. Phase 2
# produced confirmations.
#
# This study attempts to return Phase 2 to gardening. Instead of composing
# sections (Intact → Drift → Dissolution → Reconstitution), I set up a
# system with dissolution/emergence dynamics and let it find its own path.
#
# THE SYSTEM:
#
# The motif is the seed (E-G-A-B-D / D-B-A-G-E). Each note can:
#   - MUTATE: drift ±1 or ±2 semitones (probability = mutation_rate)
#   - REVERT: snap 1 semitone toward original (probability = revert_rate)
#
# The mutation_rate does a damped random walk — it oscillates organically
# between 0 (total clarity) and 0.15 (15% mutation chance per note).
# The revert_rate is constant at 0.03 (3% per note).
#
# When mutation_rate > revert_rate: net dissolution (motif drifts)
# When mutation_rate < revert_rate: net reconstitution (motif pulls back)
# The trajectory through these states is NOT designed. It emerges.
#
# Texture (detune, noise, cutoff) correlates with mutation_rate —
# the sound gets rougher as the motif dissolves, clearer as it returns.
# This coupling is the only non-gardener element. Everything else
# is the system finding its own path.
#
# use_random_seed at the top determines the entire trajectory.
# Different seeds = different gardens. The research question:
# what persists across different runs?
#
# Duration: ~9 minutes (20 passes × 32 beats + 8 beats closing)
# Synth: kestrel_wraith throughout
# BPM: 72

use_bpm 72
use_random_seed 42
use_external_synths true
use_synth :kestrel_wraith

# Original motif: E3 G3 A3 B3 D4 | D4 B3 A3 G3 E3
original = [52, 55, 57, 59, 62, 62, 59, 57, 55, 52]
current = original.dup
amps = [0.35, 0.22, 0.28, 0.30, 0.48, 0.45, 0.26, 0.20, 0.24, 0.40]

# Mutation dynamics
mutation_rate = 0.0
mr_velocity = 0.0
revert_rate = 0.03

# Random walk parameters
walk_impulse = 0.0008
damping = 0.97
mr_max = 0.15

total_passes = 20

total_passes.times do |pass|
  # Evolve mutation rate through the pass (10 micro-steps per pass)
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

  # Play one pass through the motif
  10.times do |i|
    # Mutation: drift away from current position
    if rand < mutation_rate
      current[i] += [-2, -1, 1, 2].choose
    end

    # Reversion: pull toward original
    if rand < revert_rate && current[i] != original[i]
      diff = original[i] - current[i]
      current[i] += diff > 0 ? 1 : -1
    end

    # Keep in playable range
    current[i] = [[current[i], 40].max, 72].min

    # Texture correlates with mutation rate
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
