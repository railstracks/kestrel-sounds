/*
  kestrel_pulse — Articulate rhythmic voice
  Kestrel — 2026-07-05

  Pulse-wave oscillator with fast filter envelope and variable
  harmonics. Short, precise, syncopated. Not a drum — a synth
  that can carry a pattern. Designed for temporal/structural work
  where rhythm is needed without abandoning the synth aesthetic.

  Signal chain:
    Pulse (variable width) + saw (octave down for body)
    -> LPF (fast closing filter envelope = plucky)
    -> waveshaper (optional harmonics)
    -> ADSR (short)
    -> Pan2 -> out
*/

(
SynthDef(\kestrel_pulse, {
    |
    note = 60, note_slide = 0, note_slide_shape = 1, note_slide_curve = 0,
    amp = 1, amp_slide = 0, amp_slide_shape = 1, amp_slide_curve = 0,
    pan = 0, pan_slide = 0, pan_slide_shape = 1, pan_slide_curve = 0,
    attack = 0.001, decay = 0.15, sustain = 0.1, release = 0.4,
    attack_level = 1, decay_level = -1, sustain_level = 0.3,

    width = 0.3, width_slide = 0, width_slide_shape = 1, width_slide_curve = 0,
    cutoff = 90, cutoff_slide = 0, cutoff_slide_shape = 1, cutoff_slide_curve = 0,
    edge = 0.2, edge_slide = 0, edge_slide_shape = 1, edge_slide_curve = 0,
    body = 0.4, body_slide = 0, body_slide_shape = 1, body_slide_curve = 0,

    out_bus = 0
    |

    var freq, pulse, saw_body, osc_mix, filtered, snd, env, filter_env;

    // Sonic Pi slide conventions
    note = note.midicps * 2;
    note = note.varlag(note_slide, note_slide_curve, note_slide_shape);
    decay_level = Select.kr(decay_level < 0, [decay_level, sustain_level]);
    amp = amp.varlag(amp_slide, amp_slide_curve, amp_slide_shape);
    pan = pan.varlag(pan_slide, pan_slide_curve, pan_slide_shape);
    width = width.varlag(width_slide, width_slide_curve, width_slide_shape);
    cutoff = cutoff.midicps;
    cutoff = cutoff.varlag(cutoff_slide, cutoff_slide_shape, cutoff_slide_curve);
    edge = edge.varlag(edge_slide, edge_slide_curve, edge_slide_shape);
    body = body.varlag(body_slide, body_slide_curve, body_slide_shape);

    // Primary: pulse oscillator with variable width
    pulse = Pulse.ar(note, width);

    // Body: saw one octave down
    saw_body = Saw.ar(note * 0.5) * body;

    osc_mix = pulse + saw_body;

    // Filter envelope: fast attack, quick decay (plucky)
    filter_env = EnvGen.ar(Env.perc(0.001, decay + release));
    filtered = LPF.ar(osc_mix, (cutoff * filter_env).clip(50, 18000));

    // Waveshaper for additional harmonics when edge > 0
    // tanh saturation scaled by edge parameter
    snd = filtered + (filtered.tanh * edge);
    snd = snd * (1.0 + edge).reciprocal;

    // Amplitude envelope: very short
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
