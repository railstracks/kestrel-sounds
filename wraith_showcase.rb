# wraith_showcase.rb — A piece showing off the kestrel_wraith synth
# Layered textures: solo melodic → chords → harmonic wash → filter sweeps

use_bpm 72
use_external_synths true

# Section 1: Solo wraith — the ghost alone
use_synth :kestrel_wraith

4.times do |i|
  n = (scale :e3, :minor_pentatonic).rotate(i)
  play n, release: 3, amp: 0.35,
    cutoff: 70 + (i * 8),
    detune: 5 + (i * 2),
    noise_mix: 0.05,
    res: 0.3,
    pan: (i * 0.3) - 0.45
  sleep 2
end

sleep 1

# Section 2: Chordal — three wraiths harmonizing
3.times do
  play chord(:e3, :minor7), release: 4, amp: 0.2,
    cutoff: 75, detune: 8, res: 0.4, noise_mix: 0.06
  sleep 4
  
  play chord(:a3, :minor7), release: 4, amp: 0.2,
    cutoff: 80, detune: 12, res: 0.5, noise_mix: 0.08
  sleep 4
end

sleep 1

# Section 3: Filter sweep — wraith with moving filter
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

# Section 4: Stacked — wraith + prophet duet
use_synth :kestrel_wraith
in_thread do
  4.times do |i|
    play chord(:e3, :minor), release: 3, amp: 0.18,
      cutoff: 78, detune: 10, res: 0.45
    sleep 3
  end
end

use_synth :prophet
4.times do |i|
  n = (scale :e4, :minor_pentatonic, num_octaves: 2)[i * 2]
  play n, release: 2.5, amp: 0.15,
    cutoff: 80, attack: 0.1
  sleep 3
end

# Final chord — both synths, wide
use_synth :kestrel_wraith
play chord(:e2, :minor9), release: 6, amp: 0.2,
  cutoff: 72, detune: 14, res: 0.5, noise_mix: 0.1,
  sub_level: 0.4, pan: -0.3

use_synth :prophet
play chord(:e4, :minor9), release: 6, amp: 0.12,
  cutoff: 85, attack: 1, pan: 0.3

sleep 7