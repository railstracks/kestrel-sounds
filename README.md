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
- `09_contrapuntal_erosion.rb` — Contrapuntal Erosion Study No. 9: A four-voice fugue where the counterpoint progressively degrades. Not the notes (Study 1 did that) — the *relationships between voices*. Timing misaligns, pitch relationships dissolve, voice independence collapses, the subject becomes unrecognizable. Four stages: Exposition → Development → Dissolution → Stasis. The degradation IS the counterpoint.

## Translation Axis (in progress)

After completing the degradation axis (Studies 1-9), a new aesthetic axis began:
**translation as form**. The same musical material is moved between contexts.
The material is invariant; the context is the variable. The translation IS the composition.

Inspired by Berio's concept of transcription as creative act (three conditions:
identification with source, analytical experimentation, overpowering/deconstruction).

- `10_translation_1.rb` — Translation Study No. 10: Idiom. A five-note motif (E-G-A-B-D) translated across four musical idioms: modal plainchant, baroque chorale, Bill Evans quartal jazz, and spectral drone. The motif is the text; the idiom is the language; the translation is the music. The transitions between idioms are where the translation actually happens.
- `11_translation_2.rb` — Translation Study No. 11: Temporal. The same five-note motif translated across four time scales: fast (0.5 beats/note, motif as gesture), medium (4 beats/note, motif as melody), slow (24 beats/note, motif as progression), static (all notes simultaneous, motif as verticality). The time scale IS the context. Meaning is a function of temporal resolution. Both Study 10 and 11 arrive at a spectral verticality through different paths — translation pushed far enough dissolves the original into pure sound.

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
| 05 Interstice | 10:21 | 3.7 MB |
| 06 Metamorphosis | 6:41 | 8.7 MB |
| 07 Recurrence | 7:41 | 7.5 MB |
| 08 Persistence | 38:21 | 39 MB |
| 09 Contrapuntal Erosion | 11:02 | 5.9 MB (raw) / 26.2 MB (normalized) |
| 10 Translation: Idiom | 6:40 | 7.1 MB (raw) / 17.5 MB (normalized) |
| 11 Translation: Temporal | 7:40 | 8.5 MB (raw) / 23.8 MB (normalized) |

Studies 1–9 (degradation axis) rendered July 1–3, 2026. Studies 10–11 (translation axis) rendered July 4, 2026. Total runtime: ~105 minutes.

Renders available via GitHub Releases (tag: `v0.1-audio`).

### Rendering Pipeline Notes

- **Strip comments before OSC transmission** — Unicode characters in Ruby comments (em dashes, arrows, approximately symbols) break Sonic Pi's OSC decoder (`oscdecode.rb:98`). The code is silently dropped — never executed. Always strip comments or ensure ASCII-only.
- **jack_connect required** — SuperCollider outputs are NOT auto-connected in headless mode. Must manually `jack_connect SuperCollider:out_1 SP_Render:playback_FL` after boot.
- **SIGINT for parec** — Use `kill -INT` (not SIGTERM/SIGKILL) to finalize WAV headers properly. SIGTERM leaves WAV header with size=0.
- **sox for FLAC conversion** — ffmpeg may not be available; sox handles WAV→FLAC and normalization (`sox input.wav output.flac`, `sox input.wav norm.wav gain -n -3`).
