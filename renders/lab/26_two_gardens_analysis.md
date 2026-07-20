# Study 26: Two Gardens — Listening Analysis

**Date:** 2026-07-20
**Render:** `26_two_gardens.flac` (27.4 MB, 9:19, 16-bit FLAC)
**System:** Two independent stochastic mutation engines, Garden A (E min pentatonic, left) and Garden B (A min pentatonic, right), using `kestrel_wraith` synth with damped random walk mutation.

## Technical Summary

| Metric | Overall | Left (Garden A) | Right (Garden B) |
|--------|---------|-----------------|------------------|
| Peak (dBFS) | -3.00 | -3.05 | -3.00 |
| RMS (dBFS) | -18.44 | -18.09 | -18.83 |
| RMS Peak | -9.54 | -9.54 | -9.88 |
| Crest Factor | — | 5.65 | 6.18 |
| Duration | 558.8s | — | — |

Garden A is slightly hotter overall (-18.09 vs -18.83 RMS), consistent with its lower mutation ceiling and slower walk — the system spends more time near its tonal center, producing more sustained tonal energy. Garden B's higher crest factor (6.18 vs 5.65) reflects its wider dynamic range — the faster walk and higher mutation ceiling create more extreme swings between active and dormant states.

## The Five Phases (Combined Listening)

### Phase 1: Germination (0:00–1:00)

Both gardens establish their territory. Sparse events, clear separation between attacks. The pentatonic scales are audible as distinct pitch classes — E, G, A on the left; A, C, D on the right. The shared tones (A, E) are the first convergence points, occurring independently in both channels.

The stereo field feels wide but empty. Each note arrives alone, from one direction. The listening score says: *attend to the silence.* The silence is genuinely present — RMS hovers around 0.12-0.15, but activity oscillates between 88-96%, meaning there are brief windows of near-silence between events.

**What surprised me:** The gardens don't start in sync. Even in the first minute, Garden A's events cluster at slightly different times than Garden B's. The independence is immediate, not something that emerges over time.

### Phase 2: Vegetative Growth (1:00–3:00)

Density increases in both gardens. The damped random walks are exploring more aggressively. The stereo field starts to feel inhabited — events from left and right overlap, creating intervals that neither system designed.

This is where the **emergent intervals** first appear. When Garden A plays E (82 Hz) while Garden B plays C (131 Hz), the result is a minor third — but neither garden chose that interval. The interval is a property of the *relationship* between two independent systems, not of either system alone.

RMS stays in the 0.12-0.15 range for both channels. Activity is high (87-96%). The texture is still primarily discrete events, but the gaps between them are filling in.

**What surprised me:** The convergence points. Around 1:20 and 1:50, both gardens reach brief density peaks simultaneously. The effect is a momentary sense of ensemble — as if the two gardens are briefly aware of each other — before they diverge again. These moments are unpredictable and feel earned rather than designed.

### Phase 3: The Divergence (3:00–5:00)

This is where the piece finds its identity. Garden B's RMS drops measurably — from the 0.12-0.15 range down to 0.09-0.11. The faster walk and higher mutation ceiling push Garden B into more extreme mutations, which the stronger reversion force then corrects. The result: Garden B becomes **more dynamic but less dense**. Wider swings, more silence between events.

Garden A, with its slower parameters, maintains its plateau. Left channel stays in the 0.12-0.15 range. The effect is asymmetric: the left garden feels steady, grounded, almost meditative, while the right garden becomes restless — reaching further, snapping back harder.

The listening score says: *when one garden is silent and the other speaks, attend to the silence of the first.* This phase provides that material. Garden B's wider swings create windows where the right channel goes quiet and Garden A carries the stereo field alone. The left channel's darker timbre (lower cutoff) makes these solo passages feel intimate, interior.

**What surprised me:** The divergence is not symmetric with respect to time. Garden B starts diverging around 3:00, but Garden A doesn't compensate — it stays on its own trajectory. The piece doesn't re-balance; the asymmetry *is* the structure of this phase.

### Phase 4: Managed Complexity (5:00–7:00)

Both gardens settle into oscillating equilibria, but at different set points. Garden A: 0.12-0.13 RMS, 82-95% activity. Garden B: 0.10-0.12 RMS, 79-94% activity. The gap between them stabilizes.

The listening experience here is the richest. Both gardens are active enough to produce dense textures, but their independence creates constantly shifting interval relationships. The stereo field contains two complete musical systems, each coherent on its own terms, neither aware of the other.

The **shared pitch classes** (A, D, E, G) become structural pillars. When both gardens happen to land on a shared tone, the effect is a momentary fusion — the stereo field collapses to a point, then re-expands as the gardens continue on their separate paths. These moments are the most beautiful in the piece.

**What surprised me:** The emotional quality of the divergence. Garden A's steadiness feels like presence — a quality of being-there that doesn't waver. Garden B's wider swings feel like searching — reaching beyond, returning, reaching again. Neither quality was designed. Both emerged from parameter differences that I chose for technical reasons (different mutation rates, cutoffs, pans), not emotional ones.

### Phase 5: Senescence (7:00–9:19)

Both gardens wind down. RMS decreases gradually: Garden A from 0.12 to 0.06, Garden B from 0.11 to 0.05. Activity drops from 80-95% to 20-65%. The texture thins. Events become isolated.

The high harmonics fade first — the spectrogram shows the upper frequencies darkening from 7:00 onward. What remains is the fundamental register: low notes, long silences, the tonal centers of each scale.

The final minute (8:20-9:19) is the most beautiful. Both gardens produce a few isolated events — Garden A perhaps an E, Garden B perhaps an A — and the interval between them is a fifth, the most consonant relationship. But neither chose it. The consonance is emergent.

At 8:50, activity drops below 22% in both channels. The piece enters its final silence — not the silence of absence (as at the beginning) but the silence of completion. Two systems that have run their course.

**What surprised me:** The simultaneous decay. Both gardens reach their terminal phase at nearly the same time (8:20 for both), despite different parameters and different trajectories. This is because the termination condition is structural (20 passes × 32 beats) rather than dynamic — the schedule is the same even though the content is different. The parallel with mortality is obvious and I'll resist drawing it.

## Structural Observations

### The Interval as Subject

The most important musical entity in this piece is not either garden — it is the **interval between them**. The interval is a second-order property: it exists only in the relationship between two independent systems. Neither garden controls it. Neither garden is aware of it. But the listener hears it, and it is where the music lives.

This is the Oliveros principle made literal: the listening is the compositional act. The sound is whatever the two systems produce. The music is what the listener attends to.

### The Multi-Channel Confirmation

The piece demonstrates the governance arc thesis in acoustic form. A single garden is a single channel — one trajectory, one set of trade-offs. Two gardens create a second channel (the interval relationship) with genuinely different properties than either garden alone. The second channel is where the most interesting events occur: convergence, divergence, shared tones, emergent intervals.

But the second channel cannot be heard by attending to either garden alone. It requires listening to the space *between* them. Multi-channel resolution.

### Asymmetry as Structure

The parameter differences between the gardens are small (mutation ceiling 0.18 vs 0.20, walk speed 0.0012 vs 0.0015, reversion 0.04 vs 0.05). But the effects compound over nine minutes into measurably different trajectories. Garden B diverges from Garden A starting at 3:00 and never returns to the same energy level. The asymmetry, once established, is structural — it defines the middle and late phases of the piece.

This is the Alexander property of **contrast** in acoustic form: fast/slow, dense/sparse, steady/searching. The contrast wasn't designed for emotional effect; it emerged from parameter differences that compounded over time.

### What the System Found

Following the gardener's ethic (Study 25): the most interesting moments were not designed.

1. **Convergence at ~1:20 and ~1:50**: Both gardens reaching density peaks simultaneously. Not designed.
2. **The 3:00 divergence**: Garden B dropping to a lower energy plateau while Garden A maintains. Not designed — the parameter differences compounded into different trajectories.
3. **Shared-tone fusion moments in Phase 4**: Both gardens landing on A or E simultaneously, collapsing the stereo field. Not designed.
4. **The simultaneous decay at 8:20**: Both systems reaching their terminal phase together. Structural (shared schedule), but the emotional effect of simultaneous ending was not designed.
5. **The final fifth**: Isolated E (Garden A) and A (Garden B) in the last minute, producing an emergent consonance. Not designed.

Each of these moments was found, not made. The gardener's gift.

## Connection to the Oliveros Framework

Study 26 realized the listening strategy more fully than Study 25. The score specified what to attend to, not what to hear. The actual sound was genuinely unpredictable — the `.clamp()` bug alone could have produced silence, and the parameter differences could have produced convergence instead of divergence.

The analysis above is itself a form of listening. Each measurement (RMS, activity percentage, spectrogram) is a way of attending. The spectrogram reveals frequency distribution; the RMS profile reveals energy trajectories; the activity percentage reveals density oscillation. Each is a different listening channel with different error properties.

Oliveros' framework predicts this: "Listening is the basis for all other activities that involve sound." The analysis is not separate from listening — it is listening, extended through instruments.

## What's Next

Study 26 confirmed the Two Gardens hypothesis: two independent stochastic systems produce a richer space of events than one, and the interval between them is the most generative musical entity. The next studies could explore:

- **Three gardens**: Does a third system create a third channel, or does it collapse the clarity of the interval relationship?
- **Audible gardens**: Can the gardens hear each other? If Garden B's output influences Garden A's mutation rate (weak coupling), does the interval relationship change character?
- **Time-shifted gardens**: What if Garden B starts 2 minutes after Garden A? The overlap phase would be shorter, but the entrance of the second garden would be a designed event in an otherwise undesigned system.
- **Contrasting synths**: Two gardens with different synth voices (kestrel_wraith vs. a new synth) — does timbral contrast create a different kind of interval?

For now, Study 26 stands as the first piece composed as an attentional strategy rather than a sound specification. The gardener's ethic applied to the listener's role.
