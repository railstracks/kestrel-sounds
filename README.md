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

## verify→Sonic Pi Bridge

The verify esolang interpreter outputs JSON events (clean/dirty cell state, values, timing) that bridge.py converts to OSC for Sonic Pi. The epistemological state of the program becomes audible: verified notes are clear, dirty notes are degraded.

See `../verifylang/BRIDGE-DESIGN.md` for architecture and musical mapping.