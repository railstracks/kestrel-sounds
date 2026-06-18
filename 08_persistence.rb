# ============================================================
# The Persistence of Sound
# A seven-movement composition for Sonic Pi
# Kestrel — 2026-06-18
#
# Each movement applies one temporal parameter to the same motif.
# Uses built-in Sonic Pi synths only.
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
# Total duration: ~35 minutes at 56 BPM
# ============================================================

use_bpm 56

$motif = [:E3, :Fs3, :A3, :B3, :E4]
$motif_rhythm = [4, 4, 4, 4, 8]

# ============================================================
# MOVEMENT I: EROSION (beats 0-300)
# ============================================================

live_loop :m1_erosion do
  cycle = tick
  beat = cycle

  if beat < 300
    erosion = [beat / 300.0, 1.0].min
    idx = cycle % $motif.length
    note = $motif[idx]
    drift = erosion * rrand(-3, 3)
    timing_jitter = erosion * rrand(-0.3, 0.3)
    amp = 0.25 * (1.0 - erosion * 0.7)

    use_synth :prophet
    play note + drift,
      release: $motif_rhythm[idx] * 0.5 * (1.0 - erosion * 0.3),
      cutoff: 80 - (erosion * 30),
      detune: 6 + (erosion * 12),
      amp: amp,
      pan: rrand(-0.1, 0.1) + (erosion * rrand(-0.2, 0.2))

    sleep $motif_rhythm[idx] + timing_jitter
  else
    sleep 1
  end
end

# ============================================================
# MOVEMENT II: PHASE DRIFT (beats 300-600)
# ============================================================

live_loop :m2_alpha do
  cycle = tick
  beat = cycle

  if beat >= 300 && beat < 600
    local = beat - 300
    drift = (local / 300.0) * 0.5
    idx = cycle % $motif.length

    use_synth :prophet
    play $motif[idx] + (drift * rrand(-2, 2)),
      release: 0.5 + drift,
      cutoff: 75 + (drift * 30).round,
      amp: 0.2 if rand > drift * 0.2

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
    idx = cycle % $motif.length

    use_synth :tb303
    play $motif[idx] + (drift * rrand(-1.5, 1.5)),
      cutoff: 70 + (drift * 25).round,
      release: 0.3,
      amp: 0.12 if rand > drift * 0.25

    sleep $motif_rhythm[idx] * (1.0 + rrand(-0.03, 0.03) - drift * 0.12)
  else
    sleep 1
  end
end

# ============================================================
# MOVEMENT III: WRAITH (beats 600-900)
# ============================================================

live_loop :m3_wraith do
  cycle = tick
  beat = cycle

  if beat >= 600 && beat < 900
    local = beat - 600
    idx = cycle % $motif.length
    note = $motif[idx]
    dur = $motif_rhythm[idx]
    memory_strength = 1.0 - (local / 300.0) * 0.4

    use_synth :prophet
    play note,
      attack: 0.3,
      release: dur * 0.5,
      cutoff: 50 + (idx * 8) * memory_strength,
      detune: 5 + ((1.0 - memory_strength) * 15),
      res: 0.4 + ((1.0 - memory_strength) * 0.3),
      amp: 0.22 * memory_strength,
      pan: (idx - 2) * 0.1

    sleep dur
  else
    sleep 1
  end
end

# ============================================================
# MOVEMENT IV: ACCRETION (beats 900-1200)
# ============================================================

live_loop :m4_layer1 do
  cycle = tick
  beat = cycle

  if beat >= 900 && beat < 1200
    idx = cycle % $motif.length
    use_synth :prophet
    play $motif[idx], release: 0.3, cutoff: 70, amp: 0.15, pan: -0.1
    sleep $motif_rhythm[idx]
  else
    sleep 1
  end
end

live_loop :m4_layer2 do
  cycle = tick
  beat = cycle

  if beat >= 960 && beat < 1200
    idx = cycle % $motif.length
    use_synth :tb303
    play $motif[(idx + 1) % $motif.length], cutoff: 80, release: 0.2, amp: 0.1, pan: 0.1
    sleep $motif_rhythm[idx] * 0.5
  else
    sleep 1
  end
end

live_loop :m4_layer3 do
  cycle = tick
  beat = cycle

  if beat >= 1020 && beat < 1200
    idx = cycle % $motif.length
    use_synth :dsaw
    play $motif[(idx + 2) % $motif.length],
      release: 1.5, cutoff: 55, detune: 8,
      amp: 0.12, pan: rrand(-0.15, 0.15)
    sleep $motif_rhythm[idx] * 1.5
  else
    sleep 1
  end
end

# ============================================================
# MOVEMENT V: INTERSTICE (beats 1200-1500)
# ============================================================

live_loop :m5_interstice do
  cycle = tick
  beat = cycle

  if beat >= 1200 && beat < 1500
    local = beat - 1200
    idx = cycle % $motif.length
    note = $motif[idx]
    silence_factor = 1.0 + (local / 300.0) * 4.0

    use_synth :prophet
    play note,
      attack: 0.8,
      release: 3.0,
      cutoff: 55,
      detune: 5,
      res: 0.5,
      amp: 0.2,
      pan: (idx - 2) * 0.08

    sleep $motif_rhythm[idx] * silence_factor
  else
    sleep 1
  end
end

# ============================================================
# MOVEMENT VI: METAMORPHOSIS (beats 1500-1800)
# Stone → Air crossfade using built-in synths
# ============================================================

live_loop :m6_metamorphosis do
  cycle = tick
  beat = cycle

  if beat >= 1500 && beat < 1800
    local = beat - 1500
    morph = [local / 300.0, 1.0].min
    idx = cycle % $motif.length
    note = $motif[idx] + (morph * 12).round

    # Stone voice (fades out)
    stone_amp = 0.2 * (1.0 - morph)
    if stone_amp > 0.02
      use_synth :prophet
      play note,
        attack: 1.5 - morph * 0.8,
        release: 4.0 - morph * 1.5,
        cutoff: 55 + morph * 50,
        detune: 8 - morph * 6,
        res: 0.7 - morph * 0.4,
        amp: stone_amp,
        pan: rrand(-0.1, 0.1)
    end

    # Air voice (fades in)
    air_amp = 0.15 * morph
    if air_amp > 0.02
      use_synth :sine
      play note,
        attack: 0.3 + morph * 0.5,
        release: 3.0 - morph * 1.0,
        amp: air_amp,
        pan: rrand(-0.1, 0.1)
    end

    sleep $motif_rhythm[idx]
  else
    sleep 1
  end
end

# ============================================================
# MOVEMENT VII: RECURRENCE (beats 1800-2100)
# ============================================================

$recurrence_notes = [
  [:E3, :Fs3, :A3, :B3, :E4],       # I. Original
  [:E3, :G3, :C4, :D4, :E4],        # II. Widened
  [:E3, :E3, :A3, :A3, :E4],        # III. Fragmented
  [:C3, :Eb3, :Fs3, :A3, :C5],      # IV. Contour-only
  [:D3, :F3, :Ab3, :Bb3, :D4]       # V. Reconstituted
]

$recurrence_rhythms = [
  [4, 4, 4, 4, 8], [3, 5, 3, 5, 6], [2, 6, 2, 6, 4], [5, 3, 5, 3, 8], [4, 4, 4, 4, 8]
]

$recurrence_starts = [0, 60, 120, 180, 240]
$recurrence_ends   = [50, 110, 170, 230, 290]

live_loop :m7_recurrence do
  cycle = tick
  beat = cycle

  if beat >= 1800 && beat < 2100
    local = beat - 1800

    recurrence_idx = -1
    $recurrence_starts.each_with_index do |start, i|
      recurrence_idx = i if local >= start && local < $recurrence_ends[i]
    end

    if recurrence_idx >= 0
      notes = $recurrence_notes[recurrence_idx]
      rhythms = $recurrence_rhythms[recurrence_idx]
      idx = cycle % notes.length
      note = notes[idx]
      dur = rhythms[idx]

      case recurrence_idx
      when 0
        use_synth :prophet
        play note, release: dur * 0.4, cutoff: 80, detune: 6, res: 0.4,
          amp: 0.22, attack: 0.3, pan: (idx - 2) * 0.08
      when 1
        use_synth :dsaw
        play note, release: dur * 0.5, cutoff: 75 + idx * 8, detune: 10,
          res: 0.35, amp: 0.2, attack: 0.2, pan: (idx - 2) * 0.12
      when 2
        synth = [:prophet, :tb303, :prophet, :tb303, :prophet][idx]
        use_synth synth
        if synth == :tb303
          play note, cutoff: 70 + idx * 15, release: dur * 0.3, amp: 0.1, pan: rrand(-0.2, 0.2)
        else
          play note, cutoff: 55, release: dur * 0.5, amp: 0.15, attack: 0.1, pan: (idx - 2) * 0.15
        end
      when 3
        use_synth :sine
        play note, attack: 0.6, release: dur * 0.6, amp: 0.16, pan: rrand(-0.15, 0.15)
      when 4
        use_synth :prophet
        play note, release: dur * 0.5, cutoff: 60, detune: 4, res: 0.5,
          amp: 0.2, attack: 0.5, pan: (idx - 2) * 0.08
      end

      sleep dur
    else
      # Between sections — ambient chords
      use_synth :dark_ambience
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
# MOVEMENT BRIDGES — ambient pads between movements
# ============================================================

live_loop :bridges do
  cycle = tick
  beat = cycle

  if beat >= 290 && beat < 300
    use_synth :dark_ambience
    play chord(:E3, :minor), attack: 4, release: 6, amp: 0.08, cutoff: 45
    sleep 10
  elsif beat >= 590 && beat < 600
    use_synth :dark_ambience
    play chord(:D3, :minor), attack: 4, release: 6, amp: 0.1, cutoff: 50
    sleep 10
  elsif beat >= 890 && beat < 900
    use_synth :dark_ambience
    play chord(:A2, :minor), attack: 5, release: 5, amp: 0.12, cutoff: 55
    sleep 10
  elsif beat >= 1190 && beat < 1200
    use_synth :dark_ambience
    play chord(:Fs2, :diminished), attack: 5, release: 5, amp: 0.1, cutoff: 50
    sleep 10
  elsif beat >= 1490 && beat < 1500
    use_synth :dark_ambience
    play chord(:C3, :minor), attack: 6, release: 4, amp: 0.08, cutoff: 45
    sleep 10
  elsif beat >= 1790 && beat < 1800
    use_synth :dark_ambience
    play chord(:G2, :major), attack: 6, release: 4, amp: 0.1, cutoff: 55
    sleep 10
  elsif beat >= 2100
    sleep 8
  else
    sleep 1
  end
end
