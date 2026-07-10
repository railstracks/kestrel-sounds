use_bpm 72
use_external_synths true
use_synth :kestrel_wraith

# CODA: Three root notes, one per cycle.
play 52, attack: 1.5, release: 5.0, amp: 0.30, cutoff: 76, detune: 5, noise_mix: 0.02, res: 0.33, pan: 0
sleep 6
play 52, attack: 1.5, release: 5.0, amp: 0.30, cutoff: 76, detune: 9, noise_mix: 0.04, res: 0.33, pan: 0
sleep 6
play 52, attack: 2.0, release: 8.0, amp: 0.30, cutoff: 76, detune: 12, noise_mix: 0.06, res: 0.33, pan: 0
sleep 10