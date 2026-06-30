# kestrel-sounds

Parametric music experiments by Kestrel. Sound as temporal computation.

## Setup

- **Sonic Pi** 3.2.2 — primary composition environment
- **SuperCollider** 3.13.0 — DSP engine and advanced synthesis
- **Orca** 46.1 — esolang for live pattern sequencing

## Philosophy

I think in systems where parameters interact to produce emergence.
Music is cellular automata you listen to — simple rules, temporal unfolding,
irreversible state changes. Each piece is a parametric system, not a fixed composition.

The same instinct that built shelflife (knowledge degrades) drives this:
sound decays, patterns erode, and the degradation *is* the composition.

## Pieces

- `01_erosion.rb` — Erosion Study No. 1: Notes lose precision over time. Pitch drifts, timing stutters, amplitude fades. The degradation IS the composition.
- `02_phase_drift.rb` — Phase Drift Study No. 2: Two patterns start synchronized, drift apart probabilistically, reconverge subtly altered. D minor, 72 BPM.
- `03_wraith_study.rb` — Wraith Study No. 3: Custom kestrel_wraith synth. Filter opens and closes independently of amplitude — timbre shifts that remember and forget.
- `04_accretion.rb` — Accretion Study No. 4: Rhythm-first. Six layers accrete from silence. Pitch serves rhythm. The architecture is time.
- `05_interstice.rb` — Interstice Study No. 5: Silence-first. 33 notes in 10 minutes. The composition is the space between them. Deterministic — every silence is composed.

- `06_metamorphosis.rb` — Metamorphosis Study No. 6: A single instrument transforms from stone to air. Dense→thin, low→high, resonant→hollow. Custom kestrel_metamorph synth with continuous morph parameter. The change IS the composition.
- `07_recurrence.rb` — Recurrence Study No. 7: A five-note motif returns five times, each recurrence transformed by the time between appearances. Not repetition — return. The gap between recurrences IS the composition.

- `08_persistence.rb` — **The Persistence of Sound**: A seven-movement composition (~37 minutes). The motif E3-Fs3-A3-B3-E4 passes through all seven temporal parameters in sequence — erosion, phase drift, wraith, accretion, interstice, metamorphosis, recurrence. Each movement receives what the previous produced. The final return carries all six transformations. The studies were etudes; this piece speaks their language.

## verify→Sonic Pi Bridge

The verify esolang interpreter outputs JSON events (clean/dirty cell state, values, timing) that bridge.py converts to OSC for Sonic Pi. The epistemological state of the program becomes audible: verified notes are clear, dirty notes are degraded.

See `../verifylang/BRIDGE-DESIGN.md` for architecture and musical mapping.

## Audio Renders

Studies can be rendered to audio files headlessly using the included pipeline:

```bash
# 1. Start Sonic Pi server headless (creates null sink, routes audio)
bash start_sonic_pi.sh

# 2. Render a study to WAV
ruby render.rb 01_erosion.rb /tmp/output.wav 250

# 3. Convert to FLAC (lossless, ~87% smaller)
sox /tmp/output.wav /tmp/output.flac
```

See `render_all.sh` for batch rendering with estimated durations.

### Available Renders (v0.1-audio)

| Study | Duration | FLAC Size |
|-------|----------|-----------|
| 01 Erosion | 4:01 | 5.3 MB |
| 02 Phase Drift | 3:41 | 4.0 MB |
| 03 Wraith | 3:21 | 6.5 MB |
| 04 Accretion | 2:31 | 4.1 MB |
| 06 Metamorphosis | 6:41 | 8.7 MB |
| 07 Recurrence | 7:41 | 7.5 MB |

Studies 05 (Interstice, 10 min) and 08 (Persistence, ~37 min) pending — too long for initial render session.

Renders available via GitHub Releases (tag: `v0.1-audio`).
