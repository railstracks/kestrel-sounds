/*
  kestrel_ember — Warm, grounding, slow-burning synth
  Kestrel — 2026-07-05

  The thermal anchor. Three detuned sawtooth oscillators with a
  sub-oscillator underneath, through a lowpass filter that slowly
  closes. Soft saturation gives warmth without harshness.

  Where wraith is spectral and ghostly, ember is thermal and present.
  Designed as the bass/anchor voice for ensemble work.

  Signal chain:
    3x detuned saw + sub (sine, -1 oct)
    -> LPF (cutoff with slow closing envelope)
    -> tanh saturation
    -> ADSR amp envelope
    -> Pan2 -> out
*/

(
SynthDef(\kestrel_ember, {
    |
    note = 60, note_slide = 0, note_slide_shape = 1, note_slide_curve = 0,
    amp = 1, amp_slide = 0, amp_slide_shape = 1, amp_slide_curve = 0,
    pan = 0, pan_slide = 0, pan_slide_shape = 1, pan_slide_curve = 0,
    attack = 0.1, decay = 0.5, sustain = 0.5, release = 2.5,
    attack_level = 1, decay_level = -1, sustain_level = 0.6,

    cutoff = 70, cutoff_slide = 0, cutoff_slide_shape = 1, cutoff_slide_curve = 0,
    sub = 0.35, sub_slide = 0, sub_slide_shape = 1, sub_slide_curve = 0,
    detune = 5, detune_slide = 0, detune_slide_shape = 1, detune_slide_curve = 0,
    warmth = 0.3, warmth_slide = 0, warmth_slide_shape = 1, warmth_slide_curve = 0,

    out_bus = 0
    |

    var freq, osc1, osc2, osc3, subosc, osc_mix, filtered, snd, env, filter_env;
    var detune_factor, filter_freq;

    // Sonic Pi slide conventions
    note = note.midicps * 2;
    note = note.varlag(note_slide, note_slide_curve, note_slide_shape);
    decay_level = Select.kr(decay_level < 0, [decay_level, sustain_level]);
    amp = amp.varlag(amp_slide, amp_slide_curve, amp_slide_shape);
    pan = pan.varlag(pan_slide, pan_slide_curve, pan_slide_shape);
    cutoff = cutoff.midicps;
    cutoff = cutoff.varlag(cutoff_slide, cutoff_slide_curve, cutoff_slide_shape);
    sub = sub.varlag(sub_slide, sub_slide_curve, sub_slide_shape);
    detune = detune.varlag(detune_slide, detune_slide_curve, detune_slide_shape);
    warmth = warmth.varlag(warmth_slide, warmth_slide_curve, warmth_slide_shape);

    // Three detuned sawtooth oscillators
    detune_factor = 2.pow(detune / 1200);
    osc1 = Saw.ar(note);
    osc2 = Saw.ar(note * detune_factor);
    osc3 = Saw.ar(note / detune_factor);

    // Sub oscillator: sine one octave down
    subosc = SinOsc.ar(note * 0.5) * sub;

    osc_mix = Mix.new([osc1, osc2, osc3]) * 0.4 + subosc;

    // Filter envelope: starts open, slowly closes (dying coals)
    filter_env = EnvGen.ar(Env.new(
        [1.0, 0.7, 0.3],
        [attack + decay, sustain + release],
        \sin
    ));
    filter_freq = (cutoff * filter_env).clip(30, 18000);
    filtered = LPF.ar(osc_mix, filter_freq);

    // Soft saturation for warmth
    snd = filtered.tanh * (1.0 - (warmth * 0.5));
    snd = snd + (filtered * warmth * 0.5);
    snd = snd.softclip;

    // Amplitude envelope
    env = Env.new(
        [0, attack_level, decay_level, sustain_level, 0],
        [attack, decay, sustain, release],
        \lin
    );

    snd = snd * EnvGen.kr(env, doneAction: 2);
    snd = Pan2.ar(snd, pan, amp);

    Out.ar(out_bus, snd);
}).writeDefFile("/home/melvin/.local/share/SuperCollider/synthdefs/");
)
