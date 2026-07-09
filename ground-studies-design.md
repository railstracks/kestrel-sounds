# Ground Studies — Design Sketch

## Concept

A new phase of kestrel-sounds: **ground dissolution**. The motif stays invariant. The presentation context stays invariant. The **tuning system** shifts underneath.

This is not a fourth figure-level axis. It's a ground-level operation — environment engineering applied to music.

## The motif

Same E minor pentatonic: E3 - G3 - A3 - B3 - D4.
In 12-EDO, these are: 40, 43, 45, 47, 50 (MIDI note numbers).

## The principle

In different EDO systems, the same "scale degrees" map to different frequencies:
- 12-EDO: E=164.81, G=196.00, A=220.00, B=246.94, D=293.66 Hz
- 17-EDO: E=164.81, G=195.72, A=218.88, B=247.04, D=291.38 Hz (slightly different)
- 7-EDO: E=164.81, G=189.21, A=216.27, B=247.04, D=310.62 Hz (very different — D jumps)

Wait, that's not quite right. The motif is defined by interval ratios, not scale degree numbers. In different EDO systems, the concept of "minor third" (E to G) maps to different numbers of steps. The study needs to define the motif as interval classes and map them onto each EDO.

Better approach: define the motif by **interval from root** (minor third, perfect fourth, perfect fifth, minor seventh) and map those interval categories onto the nearest available steps in each EDO. The motif is the same in intent; the tuning system changes what "minor third" means.

## Study design: Study 17 — Ground Shift

### Structure
Four sections, each in a different EDO:
1. **12-EDO (home)** — the motif as we know it. Establish the ground.
2. **17-EDO (close stranger)** — the motif almost the same, but intervals subtly wrong. Uncanny valley of tuning.
3. **7-EDO (alien)** — the motif barely recognizable. Steps are too coarse; "minor third" maps to something else entirely.
4. **Dissolution** — the tuning system shifts continuously (pitch bend on all notes simultaneously, detuning toward noise). The ground itself becomes unstable. The motif can't hold because the definition of "note" is dissolving.

### Technical approach in Sonic Pi
- Use `play` with explicit hertz values: `play hz_to_midi(freq)` or `play freq, release: ...`
- Compute frequencies: `freq = root_hz * 2 ** (steps_in_edo / edo_divisions)`
- For continuous dissolution: gradually randomize the `edo_divisions` parameter, or add random cents deviation that increases over time
- Use existing synth voices (kestrel_wraith, kestrel_glass, kestrel_ember, kestrel_dust)

### Key question
Does the dissolution basin hold? If the tuning system is pushed to extremes (very few divisions, very many divisions, or continuous detuning), does the motif dissolve? 

Hypothesis: yes. At very low EDO (5, 7), the motif's identity dissolves because the intervals can't be represented. At very high EDO (24, 31, 53), the motif dissolves because the intervals are too precisely specified — the character of pentatonic melody is lost in the density of available pitches. Continuous detuning dissolves by making "note" meaningless.

This would confirm: the dissolution basin operates at the ground level, not just the figure level. Any ground, pushed far enough, dissolves the figure built on it.

### Relationship to existing axes
- Degradation: figure decays (existential)
- Translation: figure displaced (phenomenological)  
- Interaction: figures transform each other (relational)
- Ground dissolution: ground shifts under invariant figure (environmental)

The EurekAgent connection: the first three are workflow design (changing what the agent does). Ground dissolution is environment design (changing what the agent can do). The vocabulary maps.

## Implementation plan

1. Write `17_ground_shift.rb` — the first ground study
2. Render and analyze: does amplitude/RMS show dissolution signature?
3. If the pattern holds, design 2-3 more ground studies (different ground parameters)
4. Write retrospective connecting ground dissolution to the three figure-level axes

## Study 17: Ground Shift (Tuning Ground) — COMPLETE

Rendered July 8. Same motif across 12-EDO → 17-EDO → 7-EDO → continuous
detuning. Dissolution basin confirmed at ground level: Section IV amplitude
declines monotonically from 0.449 to 0.014. Per-section rendering required
(scsynth voice accumulation). 120.7s, GitHub release study-17.

## Study 18: Space Dissolution (Resonance Ground) — COMPOSED

Second ground parameter: the acoustic/resonance space. The motif's pitches
stay invariant (always 12-EDO, always E-G-A-B-D). What dissolves is the
space: release time, cutoff, noise floor, stereo position.

Four sections:
- I. Intimate — short release (1.5s), bright cutoff (88), low noise (0.02),
  centered pan. A small, dry room.
- II. Room — medium release (2.0s), medium cutoff (80), slight noise (0.04),
  slight pan. The space has body.
- III. Cathedral — long release (3.0s), dark cutoff (72), noticeable noise
  (0.08-0.10), wide pan (±0.20). The space dominates.
- IV. Dissolution — erratic release (0.8-6.0s), fluctuating cutoff (50-92),
  high noise (0.12-0.30), erratic pan (±0.80). Each note exists in its own
  random space. The concept of "room" dissolves.

Key distinction from degradation axis: the motif's pitches are ALWAYS correct.
What dissolves is the resonance environment, not the material.
Key distinction from Study 17: pitch ground is stable, resonance ground dissolves.

No with_fx (headless constraint). Space encoded entirely through synth
parameters: release, cutoff, noise_mix, pan. Post-processing reverb not
used — the "space" is internal to the synth voice.

## Ground parameters explored

1. Tuning/pitch ground (Study 17) — the pitch space shifts underneath
2. Resonance/space ground (Study 18) — the acoustic space shatters

## Study 19: Temporal Ground (Temporal Ground) — COMPLETE

Rendered July 9. Same motif with constant pitches, synth, and space. What
dissolves is the temporal ground: the beat, the grid, the spacing between
notes.

Four sections:
- I. Steady (0-28.5s): regular 3-beat pulse. max=0.471, RMS=0.110
- II. Swaying (28.5-56s): +/-30% timing variation. max=0.472, RMS=0.114
- III. Floating (56-86.5s): irregular, no pulse. max=0.797, RMS=0.109
- IV. Dissolution (86.5-155s): extreme gaps (11-14s) + clusters. max=0.765, RMS=0.036

Dissolution signature: RMS drops 67% from III to IV. Max amplitude NOT
monotonic — different from Studies 17-18. Temporal dissolution doesn't
make notes quieter (that's dynamic degradation). It makes them rarer and
temporally incoherent. The motif dissolves because the temporal
connective tissue between notes dissolves.

Render: 191.3s, max amp 0.797, RMS 0.077. GitHub release study-19.

## Ground parameters explored

1. Tuning/pitch ground (Study 17) — the pitch space shifts underneath
2. Resonance/space ground (Study 18) — the acoustic space shatters
3. Temporal ground (Study 19) — the beat/grid becomes incoherent

## Study 20: Dynamic/Range Ground (Dynamic Ground) — COMPLETE

Rendered July 9. Same motif with constant pitches, synth, space, and
timing. What dissolves is the dynamic range — the contrast between loud
and quiet notes. The motif has a dynamic contour (peak notes loudest,
middle notes quietest) that is part of its identity.

Four sections:
- I. Full Range (0-28s): wide dynamic contrast (0.12-0.55). max=0.617, RMS=0.099
- II. Compressed (28-57s): reduced contrast (0.24-0.42). max=0.472, RMS=0.096
- III. Flat (57-85s): all notes at 0.30. No contrast. max=0.351, RMS=0.088
- IV. Dissolution (85-113s): random dynamics then near-silence. max=0.506, RMS=0.058
- Coda (113-181s): dust at root. max=0.027, RMS=0.004

Dissolution signature: amplitude VARIANCE is the key metric (not max
amplitude or RMS). Variance: 0.0217 -> 0.0036 -> 0.0000 -> 0.0250.
The path to silence goes THROUGH flatness. The motif doesn't fade — it
flattens (variance -> 0), then the flat line drops to zero (mean -> 0).
Section IV has a variance spike (random dynamics = dynamic incoherence)
before the collapse. This is different from all three previous ground
studies: pitch dissolution was gradual, space dissolution was textural,
temporal dissolution was structural (density). Dynamic dissolution is
dimensional — it collapses a dimension of variation rather than changing
the substance.

Render: 181.3s, max amp 0.617, RMS 0.069. GitHub release study-20.

## Ground parameters explored

1. Tuning/pitch ground (Study 17) — the pitch space shifts underneath
2. Resonance/space ground (Study 18) — the acoustic space shatters
3. Temporal ground (Study 19) — the beat/grid becomes incoherent
4. Dynamic ground (Study 20) — the loudness range collapses to zero

## Next ground parameter (future study)

5. Noise floor — the signal-to-noise ratio dissolves (noise overwhelms signal)