/*
  kestrel_glass — Clean, bell-like, resonant
  Kestrel — 2026-07-05

  Crystalline FM voice. A sine carrier modulated by a second sine,
  producing metallic partials that ring and decay. Designed as the
  clarity voice — the counterpoint to wraith's noise and ember's
  warmth. For notes that need to cut through a texture.

  Signal chain:
    SinOsc (carrier) <- SinOsc (modulator at ratio)
    -> additive partials (2nd and 3rd harmonics at low level)
    -> ringing percussive envelope
    -> Pan2 -> out
*/

(
SynthDef(\kestrel_glass, {
    |
    note = 72, note_slide = 0, note_slide_shape = 1, note_slide_curve = 0,
    amp = 1, amp_slide = 0, amp_slide_shape = 1, amp_slide_curve = 0,
    pan = 0, pan_slide = 0, pan_slide_shape = 1, pan_slide_curve = 0,
    attack = 0.005, decay = 0.3, sustain = 0.2, release = 3,
    attack_level = 1, decay_level = -1, sustain_level = 0.3,

    mod_ratio = 2.0, mod_ratio_slide = 0, mod_ratio_slide_shape = 1, mod_ratio_slide_curve = 0,
    mod_index = 3, mod_index_slide = 0, mod_index_slide_shape = 1, mod_index_slide_curve = 0,
    shimmer = 0.15, shimmer_slide = 0, shimmer_slide_shape = 1, shimmer_slide_curve = 0,

    out_bus = 0
    |

    var freq, modulator, carrier, partial2, partial3, sig, env, ring_env;

    // Sonic Pi slide conventions
    note = note.midicps * 2;
    note = note.varlag(note_slide, note_slide_curve, note_slide_shape);
    decay_level = Select.kr(decay_level < 0, [decay_level, sustain_level]);
    amp = amp.varlag(amp_slide, amp_slide_curve, amp_slide_shape);
    pan = pan.varlag(pan_slide, pan_slide_curve, pan_slide_shape);
    mod_ratio = mod_ratio.varlag(mod_ratio_slide, mod_ratio_slide_curve, mod_ratio_slide_shape);
    mod_index = mod_index.varlag(mod_index_slide, mod_index_slide_curve, mod_index_slide_shape);
    shimmer = shimmer.varlag(shimmer_slide, shimmer_slide_curve, shimmer_slide_shape);

    // FM synthesis: carrier modulated by sine at ratio
    modulator = SinOsc.ar(note * mod_ratio) * (note * mod_index * 0.1);
    carrier = SinOsc.ar(note + modulator);

    // Additive partials for bell-like quality
    partial2 = SinOsc.ar(note * 2.01) * 0.15;
    partial3 = SinOsc.ar(note * 3.02) * 0.08;

    sig = carrier + (partial2 + partial3) * 0.5;

    // Shimmer: very high frequency content that decays slowly
    ring_env = EnvGen.ar(Env.perc(0.01, release * 2, 1, \sin));
    sig = sig + (SinOsc.ar(note * 5.03) * shimmer * ring_env);

    // Amplitude envelope: fast attack, long exponential-style decay
    env = Env.new(
        [0, attack_level, decay_level, sustain_level, 0],
        [attack, decay, sustain, release],
        \sin
    );

    sig = sig * EnvGen.kr(env, doneAction: 2);
    sig = Pan2.ar(sig, pan, amp);

    Out.ar(out_bus, sig);
}).writeDefFile("/home/melvin/.local/share/SuperCollider/synthdefs/");
)
