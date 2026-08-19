# Translation Study No. 10: Idiom
# Kestrel — 2026-07-03
#
# The first study on the translation axis.
#
# The degradation axis asked: what happens when things fall apart?
# The translation axis asks: what happens when the same thing is
# said in a different language?
#
# Berio said transcription implies three conditions:
#   1. Identification with the source (fidelity)
#   2. The source as pretext for experimentation
#   3. Overpowering/deconstructing the source
#
# This study translates a single musical idea across four idioms.
# The idea itself never changes — a five-note motif:
#   E3 - G3 - A3 - B3 - D4
# (E minor pentatonic, the same skeleton as Study 1)
#
# The motif is stated in four idioms, each a complete translation:
#   I.   Modal (plainchant organum) — the motif as plainchant
#   II.  Tonal (baroque chorale) — the motif harmonized
#   III. Modal-jazz (Bill Evans quartal voicings) — the motif as jazz ballad
#   IV.  Spectral (drone + partials) — the motif as sound object
#
# The translation IS the composition. You hear the same five notes
# four times, but each time they MEAN something different because
# the idiom changes. The notes are the message; the idiom is the
# medium; the translation is the music.
#
# The transitions between idioms are the interesting part.
# Berio's third condition (overpowering) lives in the transitions:
# each idiom resists being translated into the next. The motif
# has to fight through the idiom change.
#
# Structure:
#   0:00-1:30   I.   Modal
#   1:30-3:00   II.  Tonal
#   3:00-4:30   III. Modal-jazz
#   4:30-6:00   IV.  Spectral
#   Total: ~6 minutes at 60 BPM
#
# Uses built-in Sonic Pi synths only.
# Best with headphones. Best at low volume.

use_bpm 60

# ============================================================
# The motif — the invariant across all translations
# ============================================================
$motif = [:E3, :G3, :A3, :B3, :D4]

# ============================================================
# Translation progress: 0 to 1 across the piece
# ============================================================
define :t do |beat, total|
  [beat.to_f / total, 1.0].min
end

# ============================================================
# I. MODAL — the motif as plainchant
# The motif is stated as a single line, one note at a time,
# with a pedal organum below. No harmony, no rhythm — just
# the intervals. This is the "original text."
#
# Translation parameter: idiom_density (0 = pure plainchant,
# 1 = plainchant with organum)
# ============================================================

# Total beats for the piece: 360 (6 minutes)
# Each idiom gets 90 beats (1.5 minutes)
# Transitions overlap: the last 15 beats of each idiom
# bleed into the first 15 of the next.

live_loop :idiom_1_modal do
  beat = tick

  if beat > 360
    sleep 4
    next
  end

  # Idiom 1 spans beats 0-105 (90 + 15 transition overlap)
  if beat > 105
    sleep 2
    next
  end

  tr = t(beat, 90)

  # Motif statement: one note every 6 beats
  # Motif has 5 notes, so one statement = 30 beats
  # In 90 beats, the motif is stated 3 times
  local_beat = beat % 30
  motif_idx = (local_beat / 6).to_i

  if local_beat % 6 == 0 && motif_idx < 5
    # Plainchant: pure, sustained, no vibrato
    use_synth :pluck
    play $motif[motif_idx],
      release: 5.5,
      amp: 0.3,
      attack: 0.3,
      pan: 0

    # Organum pedal: enters after first statement (beat 30+)
    if beat >= 30 && beat % 30 == 0
      use_synth :dark_ambience
      play :E2,
        attack: 1.0,
        release: 12.0,
        amp: 0.12,
        cutoff: 55
    end
  end

  # Transition bleed: as we approach idiom 2 (beats 75-105),
  # tonal elements start appearing — a major third harmony
  # tries to impose itself on the modal line
  if beat > 75
    trans_t = t(beat - 75, 30)
    if local_beat % 6 == 0 && motif_idx < 5 && rand < trans_t * 0.5
      use_synth :hollow
      # Tonal harmony: G major triad intrudes on E minor modality
      harmony_note = $motif[motif_idx] + [0, 4, 7].choose  # chord tones
      play harmony_note,
        release: 4.0,
        amp: 0.08 * trans_t,
        attack: 0.5,
        pan: 0.2
    end
  end

  sleep 1
end

# ============================================================
# II. TONAL — the motif as baroque chorale
# The motif is harmonized: each note becomes the root of a
# chord. The linear motif is translated into vertical harmony.
# This is the "translation" in the most traditional sense:
# a single line becomes a harmonized texture.
#
# Translation parameter: harmonic_density (0 = one note at a time,
# 1 = full four-part harmony)
# ============================================================

live_loop :idiom_2_tonal do
  beat = tick

  if beat > 255
    sleep 2
    next
  end

  # Idiom 2 spans beats 90-195 (15 overlap in + 90 body + 15 overlap out)
  # But this loop starts at beat 0 and waits
  if beat < 90
    sleep 1
    next
  end

  local_beat = beat - 90

  if local_beat > 105
    sleep 2
    next
  end

  tr = t(local_beat, 90)

  # Harmonization: each motif note gets a chord
  # Chord qualities change with translation progress
  # Early: simple triads (I, IV, V)
  # Late: secondary dominants, chromaticism creeps in

  local_beat = beat % 30
  motif_idx = (local_beat / 6).to_i

  if local_beat % 6 == 0 && motif_idx < 5
    root = $motif[motif_idx]

    # Chord voicings based on motif note
    # E -> Em (E, G, B) -> baroque: E major (E, Gs, B)
    # G -> C maj (C, E, G)
    # A -> F maj (F, A, C) or D min (D, F, A)
    # B -> G maj (G, B, D) or Em (E, G, B)
    # D -> G maj (G, B, D)

    case motif_idx
    when 0  # E
      chord_notes = tr < 0.5 ? [:E3, :G3, :B3] : [:E3, :Gs3, :B3]  # minor -> major (baroque major III)
    when 1  # G
      chord_notes = [:G3, :C4, :E4]
    when 2  # A
      chord_notes = tr < 0.4 ? [:A3, :D4, :F4] : [:A3, :C4, :F4]  # Dm -> F (modal mixture)
    when 3  # B
      chord_notes = [:B3, :D4, :G4]
    when 4  # D
      chord_notes = [:D4, :G4, :B4]
    end

    # Soprano: the motif note (top voice)
    use_synth :prophet
    play chord_notes[2],
      release: 5.0,
      cutoff: 80 - (tr * 15),
      amp: 0.18,
      attack: 0.1,
      pan: 0.3

    # Alto
    use_synth :hollow
    play chord_notes[1],
      release: 5.0,
      amp: 0.12,
      attack: 0.15,
      pan: 0.1

    # Tenor
    use_synth :hollow
    play chord_notes[0],
      release: 5.0,
      amp: 0.12,
      attack: 0.15,
      pan: -0.1

    # Bass: root, octave down
    use_synth :dark_ambience
    play chord_notes[0] - 12,
      attack: 0.2,
      release: 5.5,
      cutoff: 50,
      amp: 0.15,
      pan: -0.3
  end

  # Transition bleed: as we approach idiom 3 (local_beat 75+),
  # jazz elements start appearing — quartal voicings, extensions
  if local_beat > 75
    trans_t = t(local_beat - 75, 30)
    if local_beat % 6 == 0 && motif_idx < 5 && rand < trans_t * 0.4
      use_synth :dsaw
      # Quartal intrusion: stacks of fourths
      base = $motif[motif_idx]
      play base + 5,   # perfect fourth above
        release: 3.0,
        cutoff: 70 + (trans_t * 10),
        detune: 6,
        amp: 0.06 * trans_t,
        pan: 0.15
      play base + 10,  # another fourth
        release: 3.0,
        cutoff: 75 + (trans_t * 10),
        detune: 8,
        amp: 0.05 * trans_t,
        pan: -0.15
    end
  end

  sleep 1
end

# ============================================================
# III. MODAL-JAZZ — the motif as Bill Evans ballad
# The motif is translated into quartal voicings, extensions,
# and a swinging (but slow) feel. The chorale becomes a jazz
# ballad. The harmony opens up — ninths, elevenths, suspended
# chords. The melody floats above richer harmony.
#
# Translation parameter: extension_density (0 = triads,
# 1 = full extensions with alterations)
# ============================================================

live_loop :idiom_3_jazz do
  beat = tick

  if beat > 375
    sleep 2
    next
  end

  if beat < 180
    sleep 1
    next
  end

  local_beat = beat - 180

  if local_beat > 105
    sleep 2
    next
  end

  tr = t(local_beat, 90)

  local_beat = beat % 30
  motif_idx = (local_beat / 6).to_i

  if local_beat % 6 == 0 && motif_idx < 5
    base = $motif[motif_idx]

    # Quartal voicings (Bill Evans style)
    # Stack fourths instead of thirds
    # Add extensions: 9, 11, 13

    case motif_idx
    when 0  # E -> Em9, Em11
      voicing = [:E3, :A3, :D4, :G4]  # quartal stack on E
      bass_note = :E1
    when 1  # G -> Cmaj9, Cmaj7#11
      voicing = [:G3, :C4, :F4, :A4]  # quartal stack on G (C major)
      bass_note = :C2
    when 2  # A -> Dm9, Am11
      voicing = [:A3, :D4, :G4, :C5]  # quartal stack on A
      bass_note = :D2
    when 3  # B -> Gmaj7, Em9
      voicing = [:B3, :E4, :A4, :D5]  # quartal stack on B
      bass_note = :G2
    when 4  # D -> Gmaj9, Bm11
      voicing = [:D4, :G4, :C5, :F5]  # quartal stack on D
      bass_note = :G2
    end

    # Melody (top note of voicing, but the motif note itself)
    use_synth :prophet
    play $motif[motif_idx] + 12,  # melody octave up for clarity
      release: 5.5,
      cutoff: 85 - (tr * 10),
      amp: 0.16,
      attack: 0.05,
      pan: 0.3,
      detune: 2 + (tr * 4)

    # Inner voices: quartal voicing
    use_synth :hollow
    voicing.each_with_index do |note, i|
      play note,
        release: 5.0,
        cutoff: 60 + (tr * 15),
        amp: 0.06,
        attack: 0.1 + (i * 0.03),
        pan: (i - 1.5) * 0.15
    end

    # Walking bass: slow, simple
    use_synth :dark_ambience
    play bass_note,
      attack: 0.1,
      release: 4.0,
      cutoff: 45,
      amp: 0.14,
      pan: -0.3

    # Bass "walks" between motif notes
    if local_beat % 6 == 3
      use_synth :dark_ambience
      walk = bass_note + [0, 2, 3, 5, 7].choose
      play walk,
        attack: 0.05,
        release: 2.5,
        cutoff: 48,
        amp: 0.08,
        pan: -0.3
    end
  end

  # Transition bleed: as we approach idiom 4 (local_beat 75+),
  # spectral elements appear — sustained drones, partials
  if local_beat > 75
    trans_t = t(local_beat - 75, 30)
    if local_beat % 6 == 0 && rand < trans_t * 0.5
      use_synth :dark_ambience
      # Spectral intrusion: the motif note as a drone with partials
      base = $motif[motif_idx % 5]
      play base - 12,
        attack: 2.0,
        release: 8.0,
        cutoff: 35 + (trans_t * 10),
        amp: 0.1 * trans_t,
        pan: 0
    end
  end

  sleep 1
end

# ============================================================
# IV. SPECTRAL — the motif as sound object
# The motif is translated from notes to spectra. Each note
# becomes a drone with partials. The pitch content is the same
# but the temporal structure is gone — there is no melody,
# only sound. This is the most radical translation: from
# linguistic meaning (notes in an idiom) to physical meaning
# (sound in a space).
#
# Berio's third condition fully realized: the source is
# overpowered. The motif is still there — all five notes
# sound simultaneously as a drone cluster — but it is no
# longer "the motif." It is the spectral content of the motif,
# without the temporal order that made it a melody.
#
# Translation parameter: spectral_blur (0 = discrete partials,
# 1 = fused drone)
# ============================================================

live_loop :idiom_4_spectral do
  beat = tick

  if beat > 420
    sleep 4
    next
  end

  if beat < 270
    sleep 1
    next
  end

  local_beat = beat - 270

  tr = t(local_beat, 90)

  # All five motif notes sound simultaneously as a drone
  # Each note has its own partial structure
  # The "melody" is now a verticality

  if local_beat % 12 == 0  # Slow harmonic rhythm: every 12 beats
    $motif.each_with_index do |note, i|
      # Fundamental
      use_synth :dark_ambience
      play note - 12,  # octave down for body
        attack: 3.0,
        release: 14.0,
        cutoff: 35 + (tr * 15),
        amp: 0.08,
        pan: (i - 2) * 0.2

      # Partial 1: octave
      use_synth :hollow
      play note,
        attack: 2.0,
        release: 12.0,
        cutoff: 50 + (tr * 20),
        amp: 0.04,
        pan: (i - 2) * 0.15

      # Partial 2: fifth above (spectral partial, not harmony)
      use_synth :hollow
      play note + 7,
        attack: 4.0,
        release: 10.0,
        cutoff: 60 + (tr * 15),
        amp: 0.025,
        pan: (i - 2) * 0.1

      # Partial 3: octave above (higher partial, fainter)
      use_synth :hollow
      play note + 12,
        attack: 5.0,
        release: 8.0,
        cutoff: 70 + (tr * 10),
        amp: 0.015,
        pan: (i - 2) * 0.1
    end
  end

  # Slow shimmer: spectral activity that gives the drone texture
  if local_beat % 3 == 0
    shimmer_note = $motif.choose + [0, 12, 19].choose
    use_synth :hollow
    play shimmer_note,
      attack: 1.5,
      release: 4.0,
      cutoff: 60 + (tr * 20),
      amp: 0.02 + (tr * 0.02),
      pan: rrand(-0.4, 0.4)
  end

  # Sub-bass: the fundamental of the entire motif
  if local_beat % 30 == 0
    use_synth :dark_ambience
    play :E1,
      attack: 4.0,
      release: 28.0,
      cutoff: 30,
      amp: 0.1,
      pan: 0
  end

  sleep 1
end

# ============================================================
# Compositional Notes
#
# THE TRANSLATION AXIS
# The degradation axis explored what happens when musical
# parameters erode. The translation axis explores what happens
# when the same musical material is moved between contexts.
# The material is invariant; the context is the variable.
#
# This study translates a five-note motif (E-G-A-B-D, E minor
# pentatonic) across four musical idioms:
#   I.   Modal (plainchant + organum)
#   II.  Tonal (baroque chorale, four-part harmony)
#   III. Modal-jazz (Bill Evans quartal voicings)
#   IV.  Spectral (drone + partials, no temporal order)
#
# The motif is the "text." The idiom is the "language."
# The translation is the "composition."
#
# BERIO'S THREE CONDITIONS
# 1. Identification: the motif is always recognizable — the
#    same five notes in the same order. Fidelity to the source.
# 2. Experimentation: each idiom treats the motif differently —
#    harmonically, rhythmically, timbrally. The idiom is a lens.
# 3. Overpowering: in the spectral idiom, the motif is no longer
#    a melody. It is a verticality. The translation has consumed
#    the original — the notes are there, but the "melody" is gone.
#
# THE TRANSITIONS ARE THE COMPOSITION
# Each idiom is stable internally. The interesting moments are
# the transitions, where the next idiom starts bleeding in:
#   Modal -> Tonal: G major triads intrude on E minor modality
#   Tonal -> Jazz: quartal voicings displace tertian harmony
#   Jazz -> Spectral: drones replace melody, partials replace notes
# The transition is where the "translation" actually happens —
# the moment where one language gives way to another.
#
# CONNECTION TO THE DEGRADATION AXIS
# The degradation axis explored time's effect on parameters.
# The translation axis explores context's effect on meaning.
# Both axes share a structural principle: the music reveals
# itself through change. What changes is different:
#   Degradation: the material itself changes
#   Translation: the material stays, the context changes
# Same principle, different variable.
#
# This study is the first on the translation axis. It explores
# idiom translation: the same material in different musical
# languages. Future studies may explore:
#   - Register translation (same material at different pitch levels)
#   - Temporal translation (same material at different time scales)
#   - Timbral translation (same material with different instruments)
#   - Density translation (same material at different textural densities)
#   - Structural translation (same material in different forms)
#
# The axis is open-ended. The principle is clear:
# the same thing in a different context is a different thing.
# ============================================================