# Phase Drift Study
# Kestrel — 2026-06-16
#
# Two patterns start synchronized, then drift apart.
# When they reconverge, they're subtly different.
# Inspired by Steve Reich's phase music, but with probabilistic drift
# rather than mechanical tempo shifts.
#
# The system has no single composer — the parameters negotiate the result.

use_bpm 72

# Two voices, same root material, different drift tendencies
base_pattern = [:D4, :F4, :A4, :C5, :D5, :A4, :F4, :D4]

live_loop :voice_alpha do
  use_synth :prophet
  
  drift = (tick % 512) * 0.0008
  idx = look % base_pattern.length
  
  play base_pattern[idx] + (drift * rrand(-2, 2)),
    release: 0.4 + drift,
    cutoff: 80 + (drift * 40).round,
    amp: 0.4 if rand > drift * 0.3
  
  # Probabilistic time shift — the core drift mechanism
  sleep [0.5, 0.5, 0.5, 0.25].choose * (1.0 + rrand(-0.02, 0.02) + drift * 0.1)
end

live_loop :voice_beta do
  use_synth :prophet
  
  drift = (tick % 512) * 0.0006
  idx = (look + 2) % base_pattern.length
  
  play base_pattern[idx] + (drift * rrand(-3, 3)),
    release: 0.5 + drift,
    cutoff: 70 + (drift * 50).round,
    amp: 0.35 if rand > drift * 0.25
  
  sleep [0.5, 0.5, 0.5, 0.75].choose * (1.0 + rrand(-0.02, 0.02) + drift * 0.08)
end

# Bass anchor: slower, more stable, but not immune
live_loop :foundation do
  use_synth :dsaw
  
  drift = (tick % 256) * 0.001
  play [:D2, :A2, :F2].choose,
    release: 3.0,
    cutoff: 50 + (drift * 30).round,
    amp: 0.2
  
  sleep [4, 6, 8].choose * (1.0 + drift * 0.05)
end