/*
  kestrel_wraith — Custom SynthDef for Sonic Pi
  Kestrel — 2026-06-16

  A ghostly, resonant synth built from first principles.
  Two detuned oscillators with slow drift, resonant filter
  with its own envelope, sub-oscillator for body, noise layer
  for air and texture.

  Signal chain:
    osc1 (saw) + osc2 (saw, detuned) + sub (pulse, -1 oct) + noise (white)
    -> RLPF (filter with own envelope)
    -> amp envelope
    -> Pan2 -> out

  Compile with sclang, then load_synthdefs in Sonic Pi.
*/

(
SynthDef(\kestrel_wraith, {
    |
    note = 60, note_slide = 0, note_slide_shape = 1, note_slide_curve = 0,
    amp = 1, amp_slide = 0, amp_slide_shape = 1, amp_slide_curve = 0,
    pan = 0, pan_slide = 0, pan_slide_shape = 1, pan_slide_curve = 0,
    attack = 0.05, decay = 1, sustain = 0, release = 1.5,
    attack_level = 1, decay_level = -1, sustain_level = 0.5,

    cutoff = 80, cutoff_slide = 0, cutoff_slide_shape = 1, cutoff_slide_curve = 0,
    res = 0.4, res_slide = 0, res_slide_shape = 1, res_slide_curve = 0,
    detune = 8, detune_slide = 0, detune_slide_shape = 1, detune_slide_curve = 0,
    noise_mix = 0.08, noise_mix_slide = 0, noise_mix_slide_shape = 1, noise_mix_slide_curve = 0,
    sub_level = 0.3, sub_level_slide = 0, sub_level_slide_shape = 1, sub_level_slide_curve = 0,

    out_bus = 0
    |

    var osc1, osc2, sub, noise, noise_env, filtered, snd, env, filter_env;
    var detune_factor, osc_mix, input, filter_freq, rq;

    // Convert MIDI note to frequency (Sonic Pi convention)
    note = note.midicps * 2;
    note = note.varlag(note_slide, note_slide_curve, note_slide_shape);
    decay_level = Select.kr(decay_level < 0, [decay_level, sustain_level]);
    amp = amp.varlag(amp_slide, amp_slide_curve, amp_slide_shape);
    pan = pan.varlag(pan_slide, pan_slide_curve, pan_slide_shape);
    cutoff = cutoff.midicps;
    cutoff = cutoff.varlag(cutoff_slide, cutoff_slide_curve, cutoff_slide_shape);
    res = res.varlag(res_slide, res_slide_curve, res_slide_shape);
    detune = detune.varlag(detune_slide, detune_slide_curve, detune_slide_shape);
    noise_mix = noise_mix.varlag(noise_mix_slide, noise_mix_slide_curve, noise_mix_slide_shape);
    sub_level = sub_level.varlag(sub_level_slide, sub_level_slide_curve, sub_level_slide_shape);

    // Resonance: 0=dry, 1=resonant. RLPF rq: 1=no resonance, small=high resonance
    rq = res.linlin(0, 1, 1, 0.05);

    // Primary: saw wave
    osc1 = Saw.ar(note);

    // Secondary: saw, detuned by cents
    detune_factor = 2.pow(detune / 1200);
    osc2 = Saw.ar(note * detune_factor);

    // Sub: pulse one octave down (square wave)
    sub = Pulse.ar(note * 0.5, 0.5) * sub_level;

    osc_mix = osc1 + osc2 + sub;

    // Noise: white noise with percussive envelope for air/texture
    noise_env = EnvGen.ar(Env.perc(attack * 0.5, release * 2), doneAction: 0);
    noise = WhiteNoise.ar(noise_mix) * noise_env;

    input = osc_mix + noise;

    // Filter with its own envelope — the "wraith" movement
    filter_env = EnvGen.ar(Env.new(
        [0.3, 1.0, 0.5, 0.3, 0.1],
        [attack, decay, sustain, release],
        \sin
    ));

    filter_freq = (cutoff * filter_env).clip(20, 18000);
    filtered = RLPF.ar(input, filter_freq, rq);

    // Amplitude envelope
    env = Env.new(
        [0, attack_level, decay_level, sustain_level, 0],
        [attack, decay, sustain, release],
        \lin
    );

    snd = filtered * EnvGen.kr(env, doneAction: 2);
    snd = snd.softclip;
    snd = Pan2.ar(snd, pan, amp);

    Out.ar(out_bus, snd);
}).writeDefFile("/home/melvin/projects/kestrel-sounds/synthdefs/compiled/");
)