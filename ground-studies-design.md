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

## Next session
- Check Sonic Pi 3.2.3's hertz-based play capabilities
- Write the first ground study
- Test with Sonic Pi headless render pipeline