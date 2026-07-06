/*
  kestrel_dust — Granular texture voice
  Kestrel — 2026-07-05

  Controlled noise bursts through a bandpass filter. Not a note,
  not a pad — a texture. Designed for transitions, negative space,
  and dissolution moments where sound thins into particles before
  disappearing.

  The `note` parameter controls the bandpass center frequency.
  Density controls how many grains per second. At high density,
  approaches white noise. At low density, individual raindrops.

  Signal chain:
    Dust2 (random impulses) -> enveloped grains
    -> BPF (pitched by note)
    -> Pan2 -> out
*/

(
SynthDef(\kestrel_dust, {
    |
    note = 60, note_slide = 0, note_slide_shape = 1, note_slide_curve = 0,
    amp = 1, amp_slide = 0, amp_slide_shape = 1, amp_slide_curve = 0,
    pan = 0, pan_slide = 0, pan_slide_shape = 1, pan_slide_curve = 0,
    attack = 0.1, decay = 0.3, sustain = 1, release = 2,
    attack_level = 1, decay_level = -1, sustain_level = 0.7,

    density = 50, density_slide = 0, density_slide_shape = 1, density_slide_curve = 0,
    rq = 0.01, rq_slide = 0, rq_slide_shape = 1, rq_slide_curve = 0,
    grain_size = 0.05, grain_size_slide = 0, grain_size_slide_shape = 1, grain_size_slide_curve = 0,

    out_bus = 0
    |

    var freq, dust_sig, grains, filtered, snd, env, grain_env;
    var amp_env;

    // Sonic Pi slide conventions
    note = note.midicps * 2;
    note = note.varlag(note_slide, note_slide_curve, note_slide_shape);
    decay_level = Select.kr(decay_level < 0, [decay_level, sustain_level]);
    amp = amp.varlag(amp_slide, amp_slide_curve, amp_slide_shape);
    pan = pan.varlag(pan_slide, pan_slide_curve, pan_slide_shape);
    density = density.varlag(density_slide, density_slide_curve, density_slide_shape);
    rq = rq.varlag(rq_slide, rq_slide_curve, rq_slide_shape);
    grain_size = grain_size.varlag(grain_size_slide, grain_size_slide_curve, grain_size_slide_shape);

    // Dust2: bipolar impulses at variable density
    dust_sig = Dust2.ar(density);

    // Amplitude-shape each impulse with a short decay
    // Using Amplitude.ar as a follower to shape the grains
    grain_env = Amplitude.ar(dust_sig, 0.001, grain_size);
    grains = SinOsc.ar(note) * grain_env;  // pitched grains

    // Bandpass filter for pitch content
    filtered = BPF.ar(grains, note, rq);

    // Amplitude envelope
    env = Env.new(
        [0, attack_level, decay_level, sustain_level, 0],
        [attack, decay, sustain, release],
        \lin
    );

    snd = filtered * EnvGen.kr(env, doneAction: 2);
    snd = Pan2.ar(snd, pan, amp);

    Out.ar(out_bus, snd);
}).writeDefFile("/home/melvin/.local/share/SuperCollider/synthdefs/");
)
