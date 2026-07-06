# ensemble_showcase.rb — Five-voice ensemble piece
# Headless-safe: all chords expanded to individual play calls
# No arrays, no chord(), no scale() in play

use_bpm 72
use_external_synths true

# Section 1: Ember solo — the ground
use_synth :kestrel_ember
play :e2, release: 6, amp: 0.4, cutoff: 65, sub: 0.4, detune: 4, warmth: 0.4
sleep 4
play :a2, release: 6, amp: 0.35, cutoff: 60, sub: 0.35, detune: 3, warmth: 0.35
sleep 4
play :b2, release: 6, amp: 0.35, cutoff: 62, sub: 0.35, detune: 5, warmth: 0.3
sleep 5

# Section 2: Glass enters — light from above
use_synth :kestrel_glass
play :b4, release: 4, amp: 0.6, mod_ratio: 2.0, mod_index: 4, shimmer: 0.2
sleep 3
play :a4, release: 4, amp: 0.6, mod_ratio: 3.01, mod_index: 3, shimmer: 0.15
sleep 3
play :g4, release: 5, amp: 0.5, mod_ratio: 2.0, mod_index: 5, shimmer: 0.25
sleep 5

# Section 3: Ember + Glass — earth and sky
in_thread do
  use_synth :kestrel_ember
  play :e2, release: 8, amp: 0.3, cutoff: 58, sub: 0.4, detune: 6, warmth: 0.4
  play :b2, release: 8, amp: 0.25, cutoff: 60, sub: 0.3, detune: 4, warmth: 0.35
  sleep 8
end

use_synth :kestrel_glass
play :e5, release: 5, amp: 0.25, mod_ratio: 3.0, mod_index: 4, shimmer: 0.2
sleep 2.5
play :d5, release: 5, amp: 0.25, mod_ratio: 2.01, mod_index: 6, shimmer: 0.3
sleep 2.5
play :b4, release: 4, amp: 0.2, mod_ratio: 4.0, mod_index: 3, shimmer: 0.15
sleep 3

# Section 4: Dust texture — the air between
use_synth :kestrel_dust
play :e4, release: 6, amp: 0.8, density: 40, rq: 0.02, grain_size: 0.08
sleep 3
play :a4, release: 5, amp: 0.7, density: 60, rq: 0.02, grain_size: 0.05
sleep 3
play :b4, release: 5, amp: 0.6, density: 80, rq: 0.03, grain_size: 0.04
sleep 4

# Section 5: Pulse enters — heartbeat
use_synth :kestrel_pulse
play :e3, release: 0.3, amp: 0.12, width: 0.3, cutoff: 85, edge: 0.2, body: 0.4
sleep 0.5
play :e3, release: 0.3, amp: 0.1, width: 0.4, cutoff: 80, edge: 0.15, body: 0.35
sleep 0.5
play :g3, release: 0.3, amp: 0.12, width: 0.25, cutoff: 90, edge: 0.25, body: 0.4
sleep 0.5
play :a3, release: 0.3, amp: 0.1, width: 0.35, cutoff: 85, edge: 0.2, body: 0.35
sleep 0.5
play :b3, release: 0.4, amp: 0.12, width: 0.3, cutoff: 95, edge: 0.3, body: 0.45
sleep 1
play :e3, release: 0.3, amp: 0.1, width: 0.4, cutoff: 80, edge: 0.15, body: 0.3
sleep 0.5
play :a3, release: 0.3, amp: 0.1, width: 0.3, cutoff: 85, edge: 0.2, body: 0.35
sleep 0.5
play :b3, release: 0.5, amp: 0.12, width: 0.25, cutoff: 90, edge: 0.25, body: 0.4
sleep 2

# Section 6: Wraith + Ember — ghost and ground
in_thread do
  use_synth :kestrel_wraith
  play :e3, release: 6, amp: 0.2, cutoff: 75, detune: 10, noise_mix: 0.06, res: 0.4
  sleep 3
  play :b3, release: 5, amp: 0.18, cutoff: 80, detune: 12, noise_mix: 0.08, res: 0.5
  sleep 3
end

use_synth :kestrel_ember
play :e2, release: 7, amp: 0.3, cutoff: 62, sub: 0.4, detune: 5, warmth: 0.4
play :b2, release: 7, amp: 0.25, cutoff: 65, sub: 0.3, detune: 4, warmth: 0.35
sleep 6

# Section 7: Glass coda — fading light
use_synth :kestrel_glass
play :e5, release: 8, amp: 0.2, mod_ratio: 2.0, mod_index: 5, shimmer: 0.3
sleep 4
play :b4, release: 8, amp: 0.15, mod_ratio: 3.01, mod_index: 4, shimmer: 0.2
sleep 4
play :e5, release: 10, amp: 0.1, mod_ratio: 4.0, mod_index: 3, shimmer: 0.4
sleep 8