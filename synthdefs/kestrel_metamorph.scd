/*
  kestrel_metamorph — Custom SynthDef for Sonic Pi
  Kestrel — 2026-06-18

  A sound that becomes something else.
  Designed for Metamorphosis Study No. 6.

  The synth starts as a dense, resonant, low sound (stone)
  and ends as a thin, breathy, high sound (air).
  The transformation is continuous — no handoff, no switch.
  The same instrument throughout, but unrecognizable at the end.

  Signal chain:
    Phase I: Rich oscillator stack + sub + resonant filter
    → Phase II: Harmonics shift, noise enters, filter thins
    → Phase III: Fundamental only + noise + high register + hollow filter

  Key morphing parameters (0→1 over the piece):
    morph: 0=stone, 1=air. Drives all internal morphing.
    - harmonic_ratio: 1→2.5 (simple→complex harmonics)
    - brightness: 0→1 (muted→bright, via filter cutoff sweep)
    - density: 1→0 (rich→thin, via osc mix levels)
    - noise_mix: 0→0.3 (clean→airy)
    - register_shift: 0→24 semitones (low→high)

  Compile with sclang, then load_synthdefs in Sonic Pi.
*/

(
SynthDef(\kestrel_metamorph, {
    |
    note = 60, note_slide = 0, note_slide_shape = 1, note_slide_curve = 0,
    amp = 1, amp_slide = 0, amp_slide_shape = 1, amp_slide_curve = 0,
    pan = 0, pan_slide = 0, pan_slide_shape = 1, pan_slide_curve = 0,
    attack = 2.0, decay = 1, sustain = 1, release = 3.0,
    attack_level = 1, decay_level = -1, sustain_level = 0.6,

    // Morphing parameter: 0 = stone, 1 = air
    morph = 0, morph_slide = 0, morph_slide_shape = 1, morph_slide_curve = 0,

    // Individual morph overrides (slide-enabled)
    harmonic_ratio = 1, harmonic_ratio_slide = 0, harmonic_ratio_slide_shape = 1, harmonic_ratio_slide_curve = 0,
    brightness = 0, brightness_slide = 0, brightness_slide_shape = 1, brightness_slide_curve = 0,
    density = 1, density_slide = 0, density_slide_shape = 1, density_slide_curve = 0,
    noise_mix = 0, noise_mix_slide = 0, noise_mix_slide_shape = 1, noise_mix_slide_curve = 0,
    register_shift = 0, register_shift_slide = 0, register_shift_slide_shape = 1, register_shift_slide_curve = 0,

    // Sonic Pi standard
    cutoff = 80, cutoff_slide = 0, cutoff_slide_shape = 1, cutoff_slide_curve = 0,
    res = 0.5, res_slide = 0, res_slide_shape = 1, res_slide_curve = 0,

    out_bus = 0
    |

    var osc1, osc2, osc3, sub, filtered, snd, env;
    var morph_val, hr_val, bright_val, dens_val, noise_val, reg_val;
    var freq, base_cutoff, base_res, filter_freq, filter_rq;
    var noise_env, noise_sig, osc_mix, total;

    // Slide all parameters (Sonic Pi convention)
    morph_val = morph.varlag(morph_slide, morph_slide_curve, morph_slide_shape);
    hr_val = harmonic_ratio.varlag(harmonic_ratio_slide, harmonic_ratio_slide_shape, harmonic_ratio_slide_curve);
    bright_val = brightness.varlag(brightness_slide, brightness_slide_shape, brightness_slide_curve);
    dens_val = density.varlag(density_slide, density_slide_shape, density_slide_curve);
    noise_val = noise_mix.varlag(noise_mix_slide, noise_mix_slide_shape, noise_mix_slide_curve);
    reg_val = register_shift.varlag(register_shift_slide, register_shift_slide_shape, register_shift_slide_curve);

    note = note.varlag(note_slide, note_slide_curve, note_slide_shape);
    amp = amp.varlag(amp_slide, amp_slide_curve, amp_slide_shape);
    pan = pan.varlag(pan_slide, pan_slide_curve, pan_slide_shape);
    base_cutoff = cutoff.midicps.varlag(cutoff_slide, cutoff_slide_curve, cutoff_slide_shape);
    base_res = res.varlag(res_slide, res_slide_curve, res_slide_shape);

    decay_level = Select.kr(decay_level < 0, [decay_level, sustain_level]);

    // Register shift: morph drives note upward
    // Stone stays low, air goes high
    freq = (note + reg_val).midicps * 2;

    // Oscillator 1: Fundamental — morphs from rich saw to pure sine
    // Stone: strong saw wave. Air: thin sine wave.
    // Linear crossfade: the waveform IS the morphing.
    osc1 = (Saw.ar(freq) * (1 - morph_val)) + (SinOsc.ar(freq) * morph_val);

    // Oscillator 2: Harmonic oscillator — morph shifts from simple detune
    // to complex harmonic ratio. Stone: warm detuning. Air: inharmonic.
    osc2 = Saw.ar(freq * hr_val) * dens_val;

    // Oscillator 3: Pulse, high harmonics — fades with density and morph
    // Stone: adds edge. Air: gone.
    osc3 = Pulse.ar(freq * 2, 0.3) * 0.3 * dens_val * (1 - morph_val);

    // Sub-oscillator: Stone body, fades with morph
    sub = SinOsc.ar(freq * 0.5) * 0.4 * (1 - morph_val);

    // Noise: absent in stone, present in air
    // Breath-like: filtered noise that increases
    noise_env = EnvGen.ar(Env.perc(attack * 0.3, release * 1.5), doneAction: 0);
    noise_sig = WhiteNoise.ar(noise_val) * noise_env;
    // High-pass the noise for air quality
    noise_sig = HPF.ar(noise_sig, (2000 + (morph_val * 4000)).clip(20, 18000));

    // Mix: density controls how many oscillators are present
    osc_mix = osc1 + (osc2 * dens_val) + (osc3 * (dens_val * 0.5)) + sub;
    total = osc_mix + noise_sig;

    // Filter: stone has low resonant filter, air has high thin filter
    // Brightness morphs the cutoff from warm to bright
    filter_freq = (base_cutoff * (1 + (bright_val * 4))).clip(20, 18000);

    // Resonance: stone is resonant, air is thin
    // Stone: rq ≈ 0.1 (resonant). Air: rq ≈ 2.0 (no resonance)
    // Base_res maps 0-1, then morph shifts it
    filter_rq = base_res.linlin(0, 1, 0.1, 2.0);
    // Morph reduces resonance further (higher rq = less resonance)
    filter_rq = (filter_rq + (morph_val * 1.2)).clip(0.02, 4.0);

    filtered = RLPF.ar(total, filter_freq, filter_rq);

    // Amplitude envelope
    env = Env.new(
        [0, attack_level, decay_level, sustain_level, 0],
        [attack, decay, sustain, release],
        \sin
    );

    snd = filtered * EnvGen.kr(env, doneAction: 2);
    snd = snd.softclip;

    // Amplitude compensation: stone is naturally louder due to density
    // Air needs a slight boost to maintain presence
    snd = snd * (1 + (morph_val * 0.3));

    snd = Pan2.ar(snd, pan, amp);
    Out.ar(out_bus, snd);
}).writeDefFile("/home/melvin/projects/kestrel-sounds/synthdefs/compiled/");
)