# wraith_showcase.rb — Headless render version
# All chords expanded to individual play calls (headless spider can't play arrays)

use_bpm 72
use_external_synths true
use_synth :kestrel_wraith

# Section 1: Solo wraith — rotating pentatonic notes
4.times do |i|
  n = (scale :e3, :minor_pentatonic)[i]
  play n, release: 3, amp: 0.35,
    cutoff: 70 + (i * 8),
    detune: 5 + (i * 2),
    noise_mix: 0.05,
    res: 0.3,
    pan: (i * 0.3) - 0.45
  sleep 2
end

sleep 1

# Section 2: Chordal — individual voices instead of chord()
3.times do
  play :e3, release: 4, amp: 0.2, cutoff: 75, detune: 8, res: 0.4, noise_mix: 0.06
  play :g3, release: 4, amp: 0.2, cutoff: 75, detune: 8, res: 0.4, noise_mix: 0.06
  play :b3, release: 4, amp: 0.2, cutoff: 75, detune: 8, res: 0.4, noise_mix: 0.06
  play :d4, release: 4, amp: 0.2, cutoff: 75, detune: 8, res: 0.4, noise_mix: 0.06
  sleep 4
  
  play :a3, release: 4, amp: 0.2, cutoff: 80, detune: 12, res: 0.5, noise_mix: 0.08
  play :c4, release: 4, amp: 0.2, cutoff: 80, detune: 12, res: 0.5, noise_mix: 0.08
  play :e4, release: 4, amp: 0.2, cutoff: 80, detune: 12, res: 0.5, noise_mix: 0.08
  play :g4, release: 4, amp: 0.2, cutoff: 80, detune: 12, res: 0.5, noise_mix: 0.08
  sleep 4
end

sleep 1

# Section 3: Filter sweep — single sustained notes with morphing params
8.times do |i|
  morph = i.fdiv(8)
  play :e3, release: 2, amp: 0.25,
    cutoff: 60 + (morph * 60),
    detune: 4 + (morph * 16),
    res: 0.2 + (morph * 0.5),
    noise_mix: 0.03 + (morph * 0.15),
    sub_level: 0.4 - (morph * 0.3)
  sleep 1.5
end

sleep 2

# Section 4: Stacked — wraith pad + prophet lead
in_thread do
  use_synth :kestrel_wraith
  4.times do |i|
    play :e3, release: 3, amp: 0.18, cutoff: 78, detune: 10, res: 0.45
    play :g3, release: 3, amp: 0.18, cutoff: 78, detune: 10, res: 0.45
    play :b3, release: 3, amp: 0.18, cutoff: 78, detune: 10, res: 0.45
    sleep 3
  end
end

use_synth :prophet
4.times do |i|
  n = (scale :e4, :minor_pentatonic, num_octaves: 2)[i * 2]
  play n, release: 2.5, amp: 0.15, cutoff: 80, attack: 0.1
  sleep 3
end

# Final — wide stack
use_synth :kestrel_wraith
play :e2, release: 6, amp: 0.2, cutoff: 72, detune: 14, res: 0.5, noise_mix: 0.1, sub_level: 0.4, pan: -0.3
play :g2, release: 6, amp: 0.2, cutoff: 72, detune: 14, res: 0.5, noise_mix: 0.1, sub_level: 0.4, pan: -0.3
play :b2, release: 6, amp: 0.2, cutoff: 72, detune: 14, res: 0.5, noise_mix: 0.1, sub_level: 0.4, pan: -0.3
play :d3, release: 6, amp: 0.2, cutoff: 72, detune: 14, res: 0.5, noise_mix: 0.1, sub_level: 0.4, pan: -0.3
play :f3, release: 6, amp: 0.2, cutoff: 72, detune: 14, res: 0.5, noise_mix: 0.1, sub_level: 0.4, pan: -0.3

use_synth :prophet
play :e4, release: 6, amp: 0.12, cutoff: 85, attack: 1, pan: 0.3
play :g4, release: 6, amp: 0.12, cutoff: 85, attack: 1, pan: 0.3
play :b4, release: 6, amp: 0.12, cutoff: 85, attack: 1, pan: 0.3
play :d5, release: 6, amp: 0.12, cutoff: 85, attack: 1, pan: 0.3
play :f5, release: 6, amp: 0.12, cutoff: 85, attack: 1, pan: 0.3

sleep 7