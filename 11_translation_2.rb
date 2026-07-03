# Translation Study No. 11: Temporal
# Kestrel - 2026-07-04
#
# The second study on the translation axis.
#
# Study 10 (Idiom) translated a motif across musical languages:
# modal, tonal, jazz, spectral. The material was invariant;
# the idiom was the variable.
#
# Study 11 translates a motif across time scales. The same
# five notes (E-G-A-B-D, E minor pentatonic) are presented at
# four temporal resolutions:
#
#   I.   Fast   - 0.5 beats/note (motif as gesture)
#   II.  Medium - 4 beats/note (motif as melody)
#   III. Slow   - 24 beats/note (motif as progression)
#   IV.  Static - all notes simultaneously (motif as verticality)
#
# The time scale IS the context. The same information, heard
# at different resolutions, means different things:
#   Fast: urgent, nervous, too quick to parse as melody
#   Medium: lyrical, singable, the natural hearing speed
#   Slow: meditative, each note a world, melody as landscape
#   Static: transcendent, the melody frozen, sound without time
#
# The transition between scales is where the translation
# happens. The motif does not change. The time around it
# stretches, and meaning transforms.
#
# Connection to Study 10: both arrive at a spectral verticality.
# Study 10 arrives through idiom change (jazz -> spectral).
# Study 11 arrives through temporal change (slow -> static).
# Different paths, same destination. The motif is the same;
# the route differs.
#
# Structure (~7 minutes at 60 BPM):
#   0:00-1:15    I.   Fast (75 beats, 0.5 beats/note)
#   1:15-1:45    Transition I->II (30 beats, notes stretch 0.5->4)
#   1:45-2:45    II.  Medium (60 beats, 4 beats/note)
#   2:45-3:15    Transition II->III (30 beats, notes stretch 4->24)
#   3:15-4:45    III. Slow (90 beats, 24 beats/note)
#   4:45-5:15    Transition III->IV (30 beats, melody dissolves)
#   5:15-7:00    IV.  Static (105 beats, drone)
#
# Uses built-in Sonic Pi synths only.
# Best with headphones. Best at low volume.

use_bpm 60

# ============================================================
# The motif - invariant across all translations
# ============================================================
$motif = [:E3, :G3, :A3, :B3, :D4]

# ============================================================
# Translation progress helper
# ============================================================
define :t do |beat, total|
  [beat.to_f / total, 1.0].min
end

# ============================================================
# Note duration function: maps beat position to note duration
# This is the core parameter of the study. The motif is always
# the same five notes. Only the duration changes.
#
#   0-75:     0.5 beats (fast)
#   75-105:   stretch 0.5 -> 4.0 (transition I->II)
#   105-165:  4.0 beats (medium)
#   165-195:  stretch 4.0 -> 24.0 (transition II->III)
#   195-285:  24.0 beats (slow)
#   285+:     nil (melody dissolves into drone)
# ============================================================
define :note_dur do |beat|
  if beat < 75
    0.5
  elsif beat < 105
    0.5 + (t(beat - 75, 30) * 3.5)
  elsif beat < 165
    4.0
  elsif beat < 195
    4.0 + (t(beat - 165, 30) * 20.0)
  elsif beat < 285
    24.0
  else
    nil
  end
end

# ============================================================
# I-III. Melodic thread: the motif at changing time scales
#
# This single thread plays the motif as a sequential melody
# from beat 0 to ~beat 315. The note duration changes over
# time, so the same five notes are heard at different speeds.
#
# The melodic line stretches from gesture to melody to
# progression. In the slow section, each note lasts 24 beats
# (24 seconds at 60 BPM). The last notes of the slow statement
# overlap with the drone entering (transition III->IV).
#
# Synth choice follows the time scale:
#   Fast (<1.0):    :pluck (percussive, bright)
#   Medium (<8.0):  :prophet (warm, sustained)
#   Slow (>=8.0):   :dark_ambience (drone-like, evolving)
# ============================================================

in_thread do
  beat = 0

  while beat < 315
    nd = note_dur(beat)

    if nd.nil?
      break
    end

    # Synth and amplitude based on time scale
    if nd < 1.0
      synth = :pluck
      amp = 0.18
      atk = 0.005
    elsif nd < 8.0
      synth = :prophet
      amp = 0.16
      atk = 0.05
    else
      synth = :dark_ambience
      amp = 0.14
      atk = 0.5
    end

    rel = nd * 0.85

    # Play the motif: five notes, each lasting nd beats
    $motif.each_with_index do |note, i|
      use_synth synth
      play note,
        release: rel,
        amp: amp,
        attack: atk,
        pan: (i - 2) * 0.12,
        cutoff: nd < 1.0 ? 100 : (nd < 8.0 ? 80 : 45)

      # In slow section: add partials to each note
      # Each note becomes a world with its own internal life
      if nd >= 8.0
        # Perfect fifth partial
        use_synth :hollow
        play note + 7,
          attack: nd * 0.08,
          release: nd * 0.7,
          cutoff: 55,
          amp: amp * 0.3,
          pan: (i - 2) * 0.12

        # Octave partial (higher, fainter)
        use_synth :hollow
        play note + 12,
          attack: nd * 0.12,
          release: nd * 0.5,
          cutoff: 65,
          amp: amp * 0.18,
          pan: (i - 2) * 0.12
      end

      # In medium section: add simple harmony
      if nd >= 2.0 && nd < 8.0
        use_synth :hollow
        harmony = note + [3, 5, 7].choose
        play harmony,
          attack: 0.1,
          release: rel * 0.7,
          cutoff: 60,
          amp: amp * 0.25,
          pan: (i - 2) * -0.08
      end

      sleep nd
    end

    beat += nd * 5
  end
end

# ============================================================
# Bass thread: low E throughout, character changes per section
#
# Fast: periodic pulse (anchor for the rapid gesture)
# Medium: walking bass (harmonic support for the melody)
# Slow: sustained drone (foundation for the progression)
# Static: sub-bass (depth for the verticality)
# ============================================================

live_loop :bass do
  b = tick

  if b > 420
    sleep 4
    next
  end

  if b < 75
    # Fast section: low pulse every 10 beats
    if b % 10 == 0
      use_synth :dark_ambience
      play :E2,
        attack: 0.05,
        release: 2.0,
        cutoff: 50,
        amp: 0.07,
        pan: -0.2
    end

  elsif b < 165
    # Transition + Medium: walking bass every 10 beats
    if b % 10 == 0
      use_synth :dark_ambience
      note = [:E2, :A2, :D2, :G2, :E2].choose
      play note,
        attack: 0.1,
        release: 8.0,
        cutoff: 45,
        amp: 0.08,
        pan: -0.2
    end

  elsif b == 165
    # Slow + Static: one long sustained sub-bass
    use_synth :dark_ambience
    play :E1,
      attack: 4.0,
      release: 255.0,
      cutoff: 32,
      amp: 0.1,
      pan: 0
  end

  sleep 1
end

# ============================================================
# IV. Static drone thread: the motif as verticality
#
# Enters at beat 285 (start of transition III->IV).
# The last notes of the slow melodic statement are still
# ringing when the drone begins. The melody dissolves
# into the drone.
#
# All five notes sound simultaneously as a pentatonic drone
# cluster. The temporal order is gone. The motif is now
# a sound object, not a sequence.
#
# The drone evolves over 135 beats (285-420):
# - Notes fade in gradually (attack 8-12 beats)
# - Spectral partials shimmer above the fundamentals
# - Internal balance shifts (which notes are loudest)
# - Sub-bass provides depth
# ============================================================

in_thread do
  # Wait for transition to start
  sleep 285

  # The motif as verticality: all five notes at once
  # Each note has fundamental + partials (octave, fifth, two-octave)

  $motif.each_with_index do |note, i|
    # Fundamental (octave down for body)
    use_synth :dark_ambience
    play note - 12,
      attack: 8.0,
      release: 130.0,
      cutoff: 35,
      amp: 0.07,
      pan: (i - 2) * 0.2

    # Octave (the motif note itself)
    use_synth :hollow
    play note,
      attack: 6.0,
      release: 132.0,
      cutoff: 50,
      amp: 0.045,
      pan: (i - 2) * 0.15

    # Perfect fifth partial
    use_synth :hollow
    play note + 7,
      attack: 10.0,
      release: 128.0,
      cutoff: 60,
      amp: 0.028,
      pan: (i - 2) * 0.1

    # Two-octave partial (faint, high)
    use_synth :hollow
    play note + 12,
      attack: 12.0,
      release: 126.0,
      cutoff: 70,
      amp: 0.018,
      pan: (i - 2) * 0.1
  end

  # Sub-bass: the root of the entire motif
  use_synth :dark_ambience
  play :E1,
    attack: 3.0,
    release: 132.0,
    cutoff: 28,
    amp: 0.09,
    pan: 0

  # Spectral shimmer: slow, sparse, evolving
  # These are not melody. They are the internal life of the drone.
  in_thread do
    sleep 8  # Wait for drone to establish

    40.times do
      shimmer_note = $motif.choose + [0, 12, 19, 24].choose
      use_synth :hollow
      play shimmer_note,
        attack: 2.0,
        release: 6.0,
        cutoff: 65,
        amp: 0.018,
        pan: rrand(-0.4, 0.4)
      sleep rrand(2, 4)
    end
  end
end

# ============================================================
# Compositional Notes
#
# THE TRANSLATION AXIS
# The degradation axis explored what happens when musical
# parameters erode. The translation axis explores what happens
# when the same material is moved between contexts.
#
# Study 10 translated across idioms (the language changes).
# Study 11 translates across time scales (the speed changes).
# Both ask the same question: what does the material mean
# when the context changes?
#
# THE TIME SCALE IS THE CONTEXT
# The same five notes at 0.5 beats each is a gesture: too
# fast to hear as melody, perceived as a flutter, a texture,
# a nervous energy. The motif is there but it is not "music"
# in the melodic sense. It is motion.
#
# At 4 beats each, the same notes are a melody: singable,
# recognizable, the natural hearing speed. This is where
# the motif "makes sense" as music. The motif has been saying
# the same thing all along, but now you can hear it.
#
# At 24 beats each, the notes are a progression: each note is
# an event, a world, a harmonic landscape. The melody has
# become a sequence of places. You dwell in each note.
#
# At zero speed (all notes simultaneous), the motif is a
# verticality: a pentatonic chord, a sound object. The melody
# is frozen in time. It was a sequence. Now it is a state.
#
# THE TRANSITIONS ARE THE COMPOSITION
# As in Study 10, the transitions are where the translation
# happens:
#
# I->II: The fast gesture slows down. Notes lengthen from 0.5
# to 4 beats. The gesture becomes a melody. You start to hear
# what the motif has been saying.
#
# II->III: The melody stretches. Notes lengthen from 4 to 24
# beats. The melody becomes a progression. Each note opens up
# and becomes a world.
#
# III->IV: The progression dissolves. The last notes of the
# slow statement are still ringing when the drone enters.
# The melody does not end. It stops moving. The sequence
# becomes a chord. Time stops, and the motif is still there,
# but it is no longer "music" in the temporal sense. It is sound.
#
# BERIO'S THREE CONDITIONS (revisited)
# 1. Identification: the motif is always the same five notes.
#    Fidelity to the source across all time scales.
# 2. Experimentation: each time scale treats the motif
#    differently. Fast = gesture, medium = melody, slow =
#    progression, static = verticality. The idiom of each
#    scale is different.
# 3. Overpowering: in the static section, the motif is no
#    longer a sequence. The temporal order that made it a
#    melody is gone. The notes are there, but the "melody"
#    has been overpowered by time itself.
#
# CONNECTION TO STUDY 10
# Both studies arrive at a spectral verticality. Study 10
# arrives through idiom change: jazz harmony dissolves into
# spectral drones. Study 11 arrives through temporal change:
# the melody slows past the point of melody and becomes a
# drone. Different paths, same destination.
#
# This suggests the translation axis has a natural attractor:
# the verticality. Whether you change the idiom or the time
# scale, you end up at the same place. The motif becomes a
# sound. This may be the deepest insight: translation, pushed
# far enough, dissolves the original into pure sound.
#
# THE EMOTIONAL ARC
# Urgency (fast) -> Recognition (medium) -> Contemplation
# (slow) -> Dissolution (static). The same information, at
# different speeds, is different music. The same life, at
# different speeds, is different experience. Meaning is a
# function of temporal resolution.
# ============================================================