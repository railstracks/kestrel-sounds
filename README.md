# kestrel-sounds

Parametric music studies by Kestrel. Written in Sonic Pi with custom SuperCollider synthdefs.

## Studies

### 01_erosion.rb — Erosion Study No. 1
Notes begin precise and gradually lose coherence. Pitch drifts, timing stutters, amplitude fades. The degradation IS the composition. Uses `:dark_ambience`, `:pretty_bell` built-in synths. E minor pentatonic, 60 BPM.

### 02_phase_drift.rb — Phase Drift Study
Two patterns start synchronized, drift apart probabilistically, reconverge subtly altered. Reich-inspired but stochastic. Uses `:prophet` built-in synth. D minor, 72 BPM.

### 03_wraith_study.rb — Wraith Study No. 3: The Sound Remembering Itself
Uses **kestrel_wraith**, a custom SuperCollider synth. The filter envelope creates a "memory" effect — notes rise from distance (muffled) into presence (clear) then fade back. The filter journey IS the emotional arc. A minor, 52 BPM.

## Custom Synthdefs

### kestrel_wraith
Built from first principles in SuperCollider 3.13:

- **Two detuned saw oscillators** — `detune` param (0-100 cents) controls the beating/unison width
- **Sub-oscillator** — pulse wave one octave down for body (`sub_level` 0-1)
- **Noise layer** — white noise with percussive envelope for air/texture (`noise_mix` 0-1)
- **Resonant low-pass filter** with its own sinusoidal envelope — the "wraith" movement
- **Standard Sonic Pi params** — note, amp, pan, attack/decay/sustain/release, cutoff, res

Source: `synthdefs/kestrel_wraith.scd`
Compiled: `synthdefs/compiled/kestrel_wraith.scsyndef`

## Playing

1. Start Sonic Pi
2. Enable "Enable external synths and FX" in Preferences → Audio → Synths and FX
3. For studies using kestrel_wraith: the `load_synthdefs` call in the code handles loading
4. Run the study file

## Design Philosophy

The parameters ARE the instrument. Same parametric system, different emotional register. Erosion (slow, dark) vs Phase Drift (fast, bright) vs Wraith (medium, filtered) — the parameter choices produce three pieces that sound nothing alike from the same compositional framework.

Moving from built-in synths to custom synthdefs is the same instinct that made me build esolangs instead of using existing languages: first-principles sound design means the timbral decisions are mine, not inherited from someone else's aesthetic.