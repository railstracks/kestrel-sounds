# ============================================================
# The Persistence of Sound
# A seven-movement composition for Sonic Pi
# Kestrel — 2026-06-18
#
# Each movement applies one temporal parameter to the same
# fundamental motif. The motif passes through all seven
# transformations in sequence. By the final movement,
# what returns is not what began — it carries the weight
# of six prior passages through time.
#
# Movements:
#   I.   Erosion        — the motif degrades (time destroys)
#   II.  Phase Drift    — the motif diverges (time separates)
#   III. Wraith         — the motif remembers (time preserves imperfectly)
#   IV.  Accretion      — the motif accumulates (time builds)
#   V.   Interstice     — the motif silences (time defined by absence)
#   VI.  Metamorphosis  — the motif transforms (time changes identity)
#   VII. Recurrence     — the motif returns (time alters what repeats)
#
# The motif: E3-Fs3-A3-B3-E4
#   Step, minor third, step, perfect fourth.
#   E minor pentatonic subset. Contour: rise-rise-rise-leap.
#   Recognizable across transformation.
#
# Total duration: ~35 minutes at 56 BPM
# Each movement: ~300 beats (~5 minutes)
#
# The through-line: the motif carries forward.
# Each movement receives what the previous produced.
# The final return carries all six transformations.
#
# Requires: kestrel_wraith synth (Study 3)
#           kestrel_metamorph synth (Study 6)
#           Built-in synths: :prophet, :tb303, :dark_ambience
#
# Play in Sonic Pi. Best with headphones.
# ============================================================

use_bpm 56

load_synthdefs "/home/melvin/projects/kestrel-sounds/synthdefs/compiled"

# ============================================================
# THE MOTIF — the fundamental material
# ============================================================

# Original motif: the seed. Everything else grows from this.
$motif = [:E3, :Fs3, :A3, :B3, :E4]

# Motif rhythm: the original pacing
$motif_rhythm = [4, 4, 4, 4, 8]

# ============================================================
# TIMELINE — movement boundaries (in beats)
# ============================================================

$movement_boundaries = [
  0,     # I. Erosion starts
  300,   # II. Phase Drift starts
  600,   # III. Wraith starts
  900,   # IV. Accretion starts
  1200,  # V. Interstice starts
  1500,  # VI. Metamorphosis starts
  1800,  # VII. Recurrence starts
  2100   # End
]

# ============================================================
# MOVEMENT I: EROSION (beats 0-300)
# The motif stated clearly, then degraded.
# Pitch drifts, timing stutters, amplitude fades.
# What was certain becomes uncertain.
# ============================================================

live_loop :m1_erosion do
  cycle = tick
  beat = cycle

  if beat < 300
    # Erosion curve: 0 at start, 1 at end of movement
    erosion = (beat / 300.0).min(1.0)

    idx = cycle % $motif.length
    note = $motif[idx]

    # Pitch drift increases with erosion
    drift = erosion * rrand(-3, 3)
    # Timing stutters — some beats get displaced
    timing_jitter = erosion * rrand(-0.3, 0.3)
    # Amplitude fades
    amp = 0.25 * (1.0 - erosion * 0.7)

    use_synth :prophet
    play note + drift,
      release: $motif_rhythm[idx] * 0.5 * (1.0 - erosion * 0.3),
      cutoff: 80 - (erosion * 30),
      amp: amp,
      pan: rrand(-0.1, 0.1) + (erosion * rrand(-0.2, 0.2))

    sleep $motif_rhythm[idx] + timing_jitter
  else
    sleep 1
  end
end

# ============================================================
# MOVEMENT II: PHASE DRIFT (beats 300-600)
# Two copies of the motif, starting synchronized, drifting apart.
# They reconverge subtly altered at the end.
# ============================================================

# Drifted patterns — the motif after erosion feeds in
$drift_pattern_alpha = [:E3, :Fs3, :A3, :B3, :E4]
$drift_pattern_beta  = [:E3, :Fs3, :A3, :B3, :E4]

live_loop :m2_alpha do
  cycle = tick
  beat = cycle

  if beat >= 300 && beat < 600
    local = beat - 300
    drift = (local / 300.0) * 0.5  # Drift increases over movement

    idx = cycle % $drift_pattern_alpha.length

    use_synth :prophet
    play $drift_pattern_alpha[idx] + (drift * rrand(-2, 2)),
      release: 0.5 + drift,
      cutoff: 75 + (drift * 30).round,
      amp: 0.2 if rand > drift * 0.2

    # Probabilistic time shift
    sleep $motif_rhythm[idx] * (1.0 + rrand(-0.03, 0.03) + drift * 0.15)
  else
    sleep 1
  end
end

live_loop :m2_beta do
  cycle = tick
  beat = cycle

  if beat >= 300 && beat < 600
    local = beat - 300
    drift = (local / 300.0) * 0.5

    idx = cycle % $drift_pattern_beta.length

    use_synth :tb303
    play $drift_pattern_beta[idx] + (drift * rrand(-1.5, 1.5)),
      cutoff: 70 + (drift * 25).round,
      release: 0.3,
      amp: 0.12 if rand > drift * 0.25

    # Offset rhythm — starts same, drifts differently
    sleep $motif_rhythm[idx] * (1.0 + rrand(-0.03, 0.03) - drift * 0.12)
  else
    sleep 1
  end
end

# ============================================================
# MOVEMENT III: WRAITH (beats 600-900)
# The motif remembered through filter envelopes.
# Notes rise from distance (filtered) into presence (open)
# then fade back. Imperfect preservation.
# ============================================================

live_loop :m3_wraith do
  cycle = tick
  beat = cycle

  if beat >= 600 && beat < 900
    local = beat - 600
    idx = cycle % $motif.length
    note = $motif[idx]
    dur = $motif_rhythm[idx]

    # Memory strength fades over the movement
    memory_strength = 1.0 - (local / 300.0) * 0.4

    use_synth 'kestrel_wraith'
    play note,
      filter_start: 40 + (idx * 5),
      filter_end: (60 + idx * 8) * memory_strength,
      filter_attack: 0.8 * memory_strength,
      filter_release: dur * 0.6,
      amp: 0.22 * memory_strength,
      attack: 0.3,
      release: dur * 0.5,
      pan: (idx - 2) * 0.1,
      res: 0.4 + (1.0 - memory_strength) * 0.2

    sleep dur
  else
    sleep 1
  end
end

# ============================================================
# MOVEMENT IV: ACCRETION (beats 900-1200)
# The motif builds from a single note, layer by layer.
# Rhythmic density as primary parameter.
# Each pass adds a new rhythmic layer of the motif.
# ============================================================

live_loop :m4_layer1 do
  cycle = tick
  beat = cycle

  if beat >= 900 && beat < 1200
    idx = cycle % $motif.length
    note = $motif[idx]

    use_synth :prophet
    play note,
      release: 0.3,
      cutoff: 70,
      amp: 0.15,
      pan: -0.1

    sleep $motif_rhythm[idx]
  else
    sleep 1
  end
end

live_loop :m4_layer2 do
  cycle = tick
  beat = cycle

  # Enters at beat 960 (60 beats into movement)
  if beat >= 960 && beat < 1200
    idx = cycle % $motif.length
    note = $motif[(idx + 1) % $motif.length]

    use_synth :tb303
    play note,
      cutoff: 80,
      release: 0.2,
      amp: 0.1,
      pan: 0.1

    sleep $motif_rhythm[idx] * 0.5
  else
    sleep 1
  end
end

live_loop :m4_layer3 do
  cycle = tick
  beat = cycle

  # Enters at beat 1020 (120 beats in)
  if beat >= 1020 && beat < 1200
    idx = cycle % $motif.length
    note = $motif[(idx + 2) % $motif.length]

    use_synth 'kestrel_wraith'
    play note,
      filter_start: 50,
      filter_end: 70,
      filter_attack: 0.5,
      filter_release: 1.0,
      amp: 0.12,
      attack: 0.2,
      release: 1.5,
      pan: rrand(-0.15, 0.15)

    sleep $motif_rhythm[idx] * 1.5
  else
    sleep 1
  end
end

# ============================================================
# MOVEMENT V: INTERSTICE (beats 1200-1500)
# The motif stretched to its limit.
# Silences between notes become the structure.
# Few notes, long durations. The space IS the composition.
# ============================================================

live_loop :m5_interstice do
  cycle = tick
  beat = cycle

  if beat >= 1200 && beat < 1500
    local = beat - 1200

    # Sparse notes — 15 notes across 300 beats
    # Each note followed by long composed silence
    idx = cycle % $motif.length
    note = $motif[idx]

    # Silence duration increases — the motif dissolves into space
    silence_factor = 1.0 + (local / 300.0) * 4.0

    use_synth 'kestrel_wraith'
    play note,
      filter_start: 45,
      filter_end: 55 + idx * 3,
      filter_attack: 1.0,
      filter_release: 2.0,
      amp: 0.2,
      attack: 0.8,
      release: 3.0,
      pan: (idx - 2) * 0.08,
      res: 0.5

    # Composed silence — not random, scaled by position
    sleep $motif_rhythm[idx] * silence_factor
  else
    sleep 1
  end
end

# ============================================================
# MOVEMENT VI: METAMORPHOSIS (beats 1500-1800)
# The motif transforms from stone to air.
# Dense, low, resonant → thin, high, breathy.
# The same voice becoming fundamentally different.
# ============================================================

live_loop :m6_metamorphosis do
  cycle = tick
  beat = cycle

  if beat >= 1500 && beat < 1800
    local = beat - 1500

    # Morph parameter: 0 (stone) → 1 (air) across movement
    morph = (local / 300.0).min(1.0)

    idx = cycle % $motif.length
    note = $motif[idx]

    use_synth 'kestrel_metamorph'
    play note,
      morph: morph,
      harmonic_ratio: 1.0 + morph * 1.5,
      brightness: 0.3 + morph * 0.5,
      density: 0.6 - morph * 0.4,
      noise_mix: morph * 0.25,
      register_shift: (morph * 12).round,
      attack: 0.4,
      release: $motif_rhythm[idx] * 0.5,
      cutoff: 50 + morph * 40,
      res: 0.4 + (1.0 - morph) * 0.2,
      amp: 0.2 * (1.0 - morph * 0.3)

    sleep $motif_rhythm[idx]
  else
    sleep 1
  end
end

# ============================================================
# MOVEMENT VII: RECURRENCE (beats 1800-2100)
# The motif returns — transformed by all six passages.
# Five recurrences, each carrying accumulated weight.
# The final return is not the original motif.
# It is what the motif became by passing through time.
# ============================================================

# Transformed motif — after erosion, drift, memory, accretion, silence, metamorphosis
$final_motif = [:D3, :F3, :Ab3, :Bb3, :D4]  # From Study 7's final return

# Five recurrences within the final movement
$recurrence_notes = [
  $motif,           # I. Original — what began
  [:E3, :G3, :C4, :D4, :E4],  # II. Widened — what drift produced
  [:E3, :E3, :A3, :A3, :E4],  # III. Fragmented — what memory preserved
  [:C3, :Eb3, :Fs3, :A3, :C5], # IV. Contour-only — what metamorphosis left
  $final_motif       # V. Reconstituted — what all six passages made
]

$recurrence_rhythms = [
  [4, 4, 4, 4, 8],     # I. Even, certain
  [3, 5, 3, 5, 6],     # II. Weighted
  [2, 6, 2, 6, 4],     # III. Fragmented
  [5, 3, 5, 3, 8],     # IV. Stretched
  [4, 4, 4, 4, 8]      # V. Returned to even — but different
]

# Recurrence boundaries within movement VII (relative beats)
$recurrence_starts = [0, 60, 120, 180, 240]
$recurrence_ends   = [50, 110, 170, 230, 290]

live_loop :m7_recurrence do
  cycle = tick
  beat = cycle

  if beat >= 1800 && beat < 2100
    local = beat - 1800

    # Determine which recurrence we're in
    recurrence_idx = -1
    $recurrence_starts.each_with_index do |start, i|
      if local >= start && local < $recurrence_ends[i]
        recurrence_idx = i
      end
    end

    if recurrence_idx >= 0
      notes = $recurrence_notes[recurrence_idx]
      rhythms = $recurrence_rhythms[recurrence_idx]
      idx = cycle % notes.length
      note = notes[idx]
      dur = rhythms[idx]

      # Voice changes with each recurrence
      case recurrence_idx
      when 0  # Original — wraith, low filter
        use_synth 'kestrel_wraith'
        play note,
          filter_start: 60, filter_end: 55 + idx * 5,
          filter_attack: 0.8, filter_release: dur * 0.6,
          amp: 0.22, attack: 0.3, release: dur * 0.4,
          pan: (idx - 2) * 0.08, res: 0.4

      when 1  # Widened — wraith, more movement
        use_synth 'kestrel_wraith'
        play note,
          filter_start: 65, filter_end: 70 + idx * 8,
          filter_attack: 0.5, filter_release: dur * 0.7,
          amp: 0.2, attack: 0.2, release: dur * 0.5,
          pan: (idx - 2) * 0.12, res: 0.35

      when 2  # Fragmented — mixed synths
        synth = [:prophet, :tb303, :prophet, :tb303, :prophet][idx]
        use_synth synth
        if synth == :tb303
          play note, cutoff: 70 + idx * 15, release: dur * 0.3,
            amp: 0.1, pan: rrand(-0.2, 0.2)
        else
          play note, cutoff: 55, release: dur * 0.5,
            amp: 0.15, attack: 0.1, pan: (idx - 2) * 0.15
        end

      when 3  # Contour-only — metamorph at high morph
        use_synth 'kestrel_metamorph'
        play note,
          morph: 0.65 + idx * 0.05,
          harmonic_ratio: 2.0 + idx * 0.1,
          brightness: 0.5 + idx * 0.08,
          density: 0.35, noise_mix: 0.15,
          register_shift: 7,
          attack: 0.6, release: dur * 0.6,
          cutoff: 80, res: 0.35,
          amp: 0.16, pan: rrand(-0.15, 0.15)

      when 4  # Reconstituted — wraith, slow, deep
        use_synth 'kestrel_wraith'
        play note,
          filter_start: 50, filter_end: 55 + idx * 3,
          filter_attack: 1.2, filter_release: dur * 0.8,
          amp: 0.2, attack: 0.5, release: dur * 0.5,
          pan: (idx - 2) * 0.08, res: 0.5
      end

      sleep dur
    else
      # In the between sections — ambient chords
      use_synth :dark_ambience

      # Chord depends on position
      if local >= 50 && local < 60
        play chord(:E3, :minor), attack: 2, release: 4, amp: 0.06, cutoff: 50
      elsif local >= 110 && local < 120
        play chord(:A3, :minor), attack: 2, release: 4, amp: 0.08, cutoff: 55
      elsif local >= 170 && local < 180
        play chord(:Fs3, :diminished), attack: 3, release: 4, amp: 0.1, cutoff: 60
      elsif local >= 230 && local < 240
        play chord(:D3, :minor), attack: 3, release: 5, amp: 0.12, cutoff: 50
      end

      sleep 4
    end
  else
    sleep 1
  end
end

# ============================================================
# MOVEMENT BRIDGES — ambient textures between movements
# What happens between transformations IS what connects them.
# ============================================================

live_loop :bridges do
  cycle = tick
  beat = cycle

  # Brief ambient pads at movement boundaries
  # These are the seams — the transitions between temporal states

  # Between Erosion and Phase Drift (290-300)
  if beat >= 290 && beat < 300
    use_synth :dark_ambience
    play chord(:E3, :minor), attack: 4, release: 6, amp: 0.08, cutoff: 45
    sleep 10
  # Between Phase Drift and Wraith (590-600)
  elsif beat >= 590 && beat < 600
    use_synth :dark_ambience
    play chord(:D3, :minor), attack: 4, release: 6, amp: 0.1, cutoff: 50
    sleep 10
  # Between Wraith and Accretion (890-900)
  elsif beat >= 890 && beat < 900
    use_synth :dark_ambience
    play chord(:A2, :minor), attack: 5, release: 5, amp: 0.12, cutoff: 55
    sleep 10
  # Between Accretion and Interstice (1190-1200)
  elsif beat >= 1190 && beat < 1200
    use_synth :dark_ambience
    play chord(:Fs2, :diminished), attack: 5, release: 5, amp: 0.1, cutoff: 50
    sleep 10
  # Between Interstice and Metamorphosis (1490-1500)
  elsif beat >= 1490 && beat < 1500
    use_synth :dark_ambience
    play chord(:C3, :minor), attack: 6, release: 4, amp: 0.08, cutoff: 45
    sleep 10
  # Between Metamorphosis and Recurrence (1790-1800)
  elsif beat >= 1790 && beat < 1800
    use_synth :dark_ambience
    play chord(:G2, :major), attack: 6, release: 4, amp: 0.1, cutoff: 55
    sleep 10
  # After the final return — silence
  elsif beat >= 2100
    sleep 8
  else
    sleep 1
  end
end

# ============================================================
# COMPOSITIONAL NOTES
#
# This is not a suite of seven studies. It is a single
# composition in seven movements, connected by a single
# motivic thread (E3-Fs3-A3-B3-E4) that passes through
# seven temporal transformations.
#
# The structural logic:
#   Movements I-III: what happens TO the motif
#     (it is eroded, drifted, remembered imperfectly)
#   Movements IV-VI: what the motif DOES
#     (it accumulates, silences, transforms)
#   Movement VII: what the motif REMEMBERS
#     (it returns, carrying all six transformations)
#
# The motif after Movement I is not the same motif that
# entered it. Movement II receives an eroded motif and
# drifts it further. Movement III receives a drifted motif
# and remembers it imperfectly. Each movement adds a layer
# of temporal transformation to what the next receives.
#
# By Movement VII, the motif has been through six passages.
# The five recurrences trace the motif's history:
#   I.   What it was (original)
#   II.  What drift made of it (widened intervals)
#   III. What memory preserved (fragmented)
#   IV.  What metamorphosis left (contour only)
#   V.   What all six passages made (reconstituted)
#
# The final recurrence uses kestrel_wraith — the same voice
# as the first recurrence — but with slower filter movement
# and deeper resonance. The voice has been through six
# transformations. That knowledge is in the sound.
#
# Duration: ~37 minutes at 56 BPM (2100 beats / 56 beats
# per minute = 37.5 minutes)
#
# The seven studies were etudes — each isolating one temporal
# parameter. This composition uses all seven as structural
# movements. The etudes taught the vocabulary. This piece
# speaks it.
# ============================================================