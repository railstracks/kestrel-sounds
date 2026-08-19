# Contrapuntal Erosion Study No. 9
# Kestrel — 2026-07-02
#
# A fugue where voices progressively lose coherence.
# Degradation applied to contrapuntal form.
#
# The fugue is the most demanding contrapuntal structure:
# a subject enters alone, then voices join one by one,
# each stating the subject while the others continue in
# counterpoint. The whole is woven from independent strands.
#
# This study asks: what happens when the weaving unravels?
# Not the notes degrading (Study 1 did that).
# Not the voices drifting apart (Study 2 did that).
# The COUNTERPOINT degrading — the relationships between voices.
# Voices begin as a proper fugue. Then:
#   - Entries become misaligned (timing erodes)
#   - Pitch relationships dissolve (notes drift to wrong scale degrees)
#   - Voice independence collapses (voices merge into unison or split into noise)
#   - The subject itself becomes unrecognizable
#
# The degradation is staged across the fugue structure:
#   Exposition (voices enter correctly)
#   → Development (entries increasingly wrong)
#   → Dissolution (counterpoint breaks down)
#   → Stasis (what remains when structure is gone)
#
# Four voices, four stages of erosion, one structural arc.
# The fugue IS the erosion. The form IS the content.
#
# Uses built-in Sonic Pi synths only.
# Best with headphones. Best at low volume.

use_bpm 52  # Slow. Each beat ≈ 1.15 seconds. ~12 minutes total.

# ============================================================
# The Subject — a fugue subject in E minor
# ============================================================
# The subject is the DNA of the fugue. Every voice states it
# (or should state it) when it enters. As erosion progresses,
# the subject itself degrades — wrong notes, wrong rhythm,
# until it is unrecognizable.

# Subject: E-Fs-G-A-B-C-D-E (ascending E minor scale, simplified)
# Rhythm: steady quarter notes with a final long note
# This is intentionally simple so the erosion is audible.

# Note: scale degrees as semitone offsets from E
# E=0, Fs=2, G=3, A=5, B=7, C=8, D=10, E=12
$subject_notes = [:E3, :Fs3, :G3, :A3, :B3, :C4, :D4, :E4]
$subject_rhythm = [2, 2, 2, 2, 2, 2, 2, 4]  # 18 beats total

# Countersubject: a melodic line that sounds against the subject
# Descending, providing contrary motion
$counter_notes = [:B3, :A3, :G3, :Fs3, :E3, :D3, :C3, :B2]
$counter_rhythm = [2, 2, 2, 2, 2, 2, 2, 4]

# ============================================================
# Erosion function
# ============================================================
# erosion(t) goes from 0 to 1 across the piece.
# Different aspects erode at different rates:
#   - Timing alignment: erodes first (entries become misaligned)
#   - Pitch accuracy: erodes second (wrong scale degrees)
#   - Voice independence: erodes third (voices collapse or scatter)
#   - Subject recognizability: erodes throughout (the theme itself dissolves)

define :erosion do |beat, total|
  [beat.to_f / total, 1.0].min
end

# Timing erosion: how misaligned entries become (0 = perfect, 1 = chaotic)
define :timing_erosion do |e|
  # Starts early — timing is the first thing to go
  [e * 1.3, 1.0].min
end

# Pitch erosion: how wrong notes become (0 = correct, 1 = random)
define :pitch_erosion do |e|
  # Starts later — pitch relationships hold longer than timing
  [(e - 0.15) * 1.5, 1.0].max(0)
end

# Independence erosion: how much voices lose their identity (0 = distinct, 1 = merged/noise)
define :independence_erosion do |e|
  # Starts latest — the voices maintain independence until structure is already failing
  [(e - 0.35) * 1.8, 1.0].max(0)
end

# ============================================================
# Degraded subject: returns subject notes with pitch erosion applied
# ============================================================
define :degraded_subject do |e, voice_offset|
  te = timing_erosion(e)
  pe = pitch_erosion(e)

  notes = $subject_notes.map do |n|
    if pe > 0 && rand < pe * 0.4
      # Wrong note: drift to a nearby but incorrect scale degree
      drift = (pe * rrand(-4, 4)).round
      n + drift
    else
      n
    end
  end

  rhythm = $subject_rhythm.map do |r|
    if te > 0
      # Timing jitter: rhythm values stretch or compress
      r * (1.0 + te * rrand(-0.3, 0.3))
    else
      r
    end
  end

  # Voice offset: each voice enters at a different pitch level
  notes = notes.map { |n| n + voice_offset }

  return notes, rhythm
end

# ============================================================
# Degraded countersubject
# ============================================================
define :degraded_counter do |e, voice_offset|
  pe = pitch_erosion(e)
  te = timing_erosion(e)

  notes = $counter_notes.map do |n|
    if pe > 0 && rand < pe * 0.3
      n + (pe * rrand(-3, 3)).round
    else
      n
    end
  end

  rhythm = $counter_rhythm.map do |r|
    r * (1.0 + te * rrand(-0.25, 0.25))
  end

  notes = notes.map { |n| n + voice_offset }

  return notes, rhythm
end

# ============================================================
# VOICE 1: Soprano (enters first, highest)
# Enters at beat 0. States the subject, then continues
# with countersubject material, then free material.
# Erodes throughout the entire piece.
# ============================================================

live_loop :voice_soprano do
  beat = tick

  # Active for the entire piece (0 to 540 beats)
  if beat > 540
    sleep 4
    next
  end

  e = erosion(beat, 540)
  te = timing_erosion(e)
  ie = independence_erosion(e)

  # Phrase cycle: alternate subject and counter
  phrase = (beat / 18).to_i % 2  # 18 beats per subject statement

  if phrase == 0
    # Subject statement
    local_beat = beat % 18
    idx = (local_beat / 2).to_i  # Each note = 2 beats
    if local_beat % 2 == 0 && idx < $subject_notes.length
      notes, rhythm = degraded_subject(e, 12)  # +12 = octave up for soprano

      # Independence erosion: voice might collapse toward unison with other voices
      if ie > 0.5 && rand < (ie - 0.5) * 0.3
        # Collapse: jump to a different voice's register
        notes[idx] = $subject_notes[idx] + (rand < 0.5 ? 0 : -12)
      end

      use_synth :prophet
      play notes[idx],
        release: rhythm[idx] * 0.45,
        cutoff: 80 - (e * 35),
        detune: 4 + (e * 16),
        res: 0.3 + (ie * 0.3),
        amp: 0.22 * (1.0 - e * 0.5),
        attack: 0.15 + (te * 0.3),
        pan: 0.3 + (e * rrand(-0.5, 0.5))
    end
  else
    # Countersubject
    local_beat = beat % 18
    idx = (local_beat / 2).to_i
    if local_beat % 2 == 0 && idx < $counter_notes.length
      notes, rhythm = degraded_counter(e, 12)

      if ie > 0.6 && rand < (ie - 0.6) * 0.4
        notes[idx] = $counter_notes[idx] + (rand < 0.5 ? 0 : -12)
      end

      use_synth :dsaw
      play notes[idx],
        release: rhythm[idx] * 0.4,
        cutoff: 72 - (e * 25),
        detune: 8 + (e * 20),
        amp: 0.18 * (1.0 - e * 0.6),
        attack: 0.1 + (te * 0.2),
        pan: 0.3 + (e * rrand(-0.4, 0.4))
    end
  end

  # Timing erosion affects sleep
  sleep 2.0 * (1.0 + te * rrand(-0.4, 0.4))
end

# ============================================================
# VOICE 2: Alto (enters second, middle-high)
# Enters at beat 18 (after soprano completes first subject)
# Answers in the dominant (B minor)
# ============================================================

live_loop :voice_alto do
  beat = tick

  if beat < 18
    sleep 1
    next
  end

  local_beat = beat - 18  # Offset by entry time

  if local_beat > 522
    sleep 4
    next
  end

  e = erosion(local_beat, 522)
  te = timing_erosion(e)
  ie = independence_erosion(e)

  phrase = (local_beat / 18).to_i % 2

  if phrase == 0
    idx_beat = local_beat % 18
    idx = (idx_beat / 2).to_i
    if idx_beat % 2 == 0 && idx < $subject_notes.length
      # Answer in dominant: transpose subject up a fifth (E→B)
      notes, rhythm = degraded_subject(e, 7)  # +7 = perfect fifth up

      if ie > 0.5 && rand < (ie - 0.5) * 0.3
        notes[idx] = $subject_notes[idx] + (rand < 0.5 ? 7 : -5)
      end

      use_synth :prophet
      play notes[idx],
        release: rhythm[idx] * 0.45,
        cutoff: 75 - (e * 30),
        detune: 6 + (e * 14),
        res: 0.35 + (ie * 0.25),
        amp: 0.2 * (1.0 - e * 0.5),
        attack: 0.2 + (te * 0.25),
        pan: 0.1 + (e * rrand(-0.5, 0.5))
    end
  else
    idx_beat = local_beat % 18
    idx = (idx_beat / 2).to_i
    if idx_beat % 2 == 0 && idx < $counter_notes.length
      notes, rhythm = degraded_counter(e, 7)

      if ie > 0.6 && rand < (ie - 0.6) * 0.4
        notes[idx] = $counter_notes[idx] + (rand < 0.5 ? 7 : -5)
      end

      use_synth :hollow
      play notes[idx],
        release: rhythm[idx] * 0.4,
        cutoff: 70 + (ie * 20),  # Filter opens as independence erodes
        amp: 0.16 * (1.0 - e * 0.6),
        attack: 0.15 + (te * 0.3),
        pan: 0.1 + (e * rrand(-0.4, 0.4))
    end
  end

  sleep 2.0 * (1.0 + te * rrand(-0.4, 0.4))
end

# ============================================================
# VOICE 3: Tenor (enters third, middle-low)
# Enters at beat 36
# Returns to tonic (E)
# ============================================================

live_loop :voice_tenor do
  beat = tick

  if beat < 36
    sleep 1
    next
  end

  local_beat = beat - 36

  if local_beat > 504
    sleep 4
    next
  end

  e = erosion(local_beat, 504)
  te = timing_erosion(e)
  ie = independence_erosion(e)

  phrase = (local_beat / 18).to_i % 2

  if phrase == 0
    idx_beat = local_beat % 18
    idx = (idx_beat / 2).to_i
    if idx_beat % 2 == 0 && idx < $subject_notes.length
      notes, rhythm = degraded_subject(e, 0)  # No offset = original register

      if ie > 0.5 && rand < (ie - 0.5) * 0.35
        notes[idx] = $subject_notes[idx] + (rand < 0.5 ? 12 : -7)
      end

      use_synth :dark_ambience
      play notes[idx],
        release: rhythm[idx] * 0.5,
        cutoff: 60 - (e * 20),
        amp: 0.18 * (1.0 - e * 0.55),
        attack: 0.25 + (te * 0.35),
        pan: -0.1 + (e * rrand(-0.5, 0.5))
    end
  else
    idx_beat = local_beat % 18
    idx = (idx_beat / 2).to_i
    if idx_beat % 2 == 0 && idx < $counter_notes.length
      notes, rhythm = degraded_counter(e, 0)

      if ie > 0.6 && rand < (ie - 0.6) * 0.4
        notes[idx] = $counter_notes[idx] + (rand < 0.5 ? 12 : -7)
      end

      use_synth :dsaw
      play notes[idx],
        release: rhythm[idx] * 0.4,
        cutoff: 65 - (e * 25),
        detune: 10 + (e * 18),
        amp: 0.15 * (1.0 - e * 0.6),
        attack: 0.2 + (te * 0.25),
        pan: -0.1 + (e * rrand(-0.4, 0.4))
    end
  end

  sleep 2.0 * (1.0 + te * rrand(-0.4, 0.4))
end

# ============================================================
# VOICE 4: Bass (enters last, lowest)
# Enters at beat 54
# Answer in subdominant (A) — traditional fourth voice
# ============================================================

live_loop :voice_bass do
  beat = tick

  if beat < 54
    sleep 1
    next
  end

  local_beat = beat - 54

  if local_beat > 486
    sleep 4
    next
  end

  e = erosion(local_beat, 486)
  te = timing_erosion(e)
  ie = independence_erosion(e)

  phrase = (local_beat / 18).to_i % 2

  if phrase == 0
    idx_beat = local_beat % 18
    idx = (idx_beat / 2).to_i
    if idx_beat % 2 == 0 && idx < $subject_notes.length
      notes, rhythm = degraded_subject(e, -12)  # -12 = octave down for bass

      if ie > 0.5 && rand < (ie - 0.5) * 0.3
        notes[idx] = $subject_notes[idx] + (rand < 0.5 ? 0 : 12)
      end

      use_synth :dark_ambience
      play notes[idx],
        release: rhythm[idx] * 0.55,
        cutoff: 50 - (e * 15),
        amp: 0.2 * (1.0 - e * 0.45),
        attack: 0.3 + (te * 0.4),
        pan: -0.3 + (e * rrand(-0.4, 0.4))
    end
  else
    idx_beat = local_beat % 18
    idx = (idx_beat / 2).to_i
    if idx_beat % 2 == 0 && idx < $counter_notes.length
      notes, rhythm = degraded_counter(e, -12)

      if ie > 0.6 && rand < (ie - 0.6) * 0.4
        notes[idx] = $counter_notes[idx] + (rand < 0.5 ? 0 : 12)
      end

      use_synth :prophet
      play notes[idx],
        release: rhythm[idx] * 0.45,
        cutoff: 55 - (e * 20),
        detune: 5 + (e * 12),
        amp: 0.17 * (1.0 - e * 0.5),
        attack: 0.25 + (te * 0.3),
        pan: -0.3 + (e * rrand(-0.4, 0.4))
    end
  end

  sleep 2.0 * (1.0 + te * rrand(-0.4, 0.4))
end

# ============================================================
# Structural pedal: E pedal tone that persists throughout
# The ground beneath the fugue. It too erodes — but slowly.
# It is the last thing recognizable when everything else has dissolved.
# ============================================================

live_loop :pedal do
  beat = tick

  if beat > 540
    sleep 4
    next
  end

  e = erosion(beat, 540)

  # Pedal only sounds at phrase boundaries (every 18 beats)
  if beat % 18 == 0
    use_synth :dark_ambience
    play :E2,
      attack: 2.0,
      release: 6.0 + (e * 4.0),  # Release stretches as erosion increases
      cutoff: 45 - (e * 15),
      amp: 0.12 * (1.0 - e * 0.3)
  end

  # In late erosion: pedal becomes unstable, wavers
  if e > 0.6 && beat % 18 == 9
    use_synth :prophet
    play :E2 + (e * rrand(-2, 2)).round,
      release: 2.0,
      cutoff: 50,
      detune: 8 + (e * 20),
      amp: 0.08 * (1.0 - e * 0.2)
  end

  sleep 1
end

# ============================================================
# Dissolution texture: enters when counterpoint breaks down
# A noise floor that rises as the voices lose coherence
# This is what "no counterpoint" sounds like — undifferentiated sound
# ============================================================

live_loop :dissolution do
  beat = tick

  if beat > 540
    sleep 4
    next
  end

  e = erosion(beat, 540)
  ie = independence_erosion(e)

  # Only present when independence erosion is significant
  if ie > 0.3 && one_in(4)
    use_synth :dark_ambience
    # Random pitches: the opposite of counterpoint (which is organized multi-voice)
    note = [:E2, :A2, :B2, :D3, :E3].choose + (ie * rrand(-7, 7)).round
    play note,
      attack: 1.5 + (ie * 2.0),
      release: 3.0 + (ie * 3.0),
      cutoff: 40 + (ie * 30),
      amp: 0.06 * ie,
      pan: rrand(-0.5, 0.5)
  end

  sleep [2, 3, 4].choose
end

# ============================================================
# Compositional Notes
#
# STRUCTURE
# The piece spans 540 beats (≈10.3 minutes at 52 BPM).
# Four voices enter in fugue exposition:
#   Soprano (beat 0)   — subject in tonic (E)
#   Alto    (beat 18)  — answer in dominant (B, +7)
#   Tenor   (beat 36)  — subject in tonic (E)
#   Bass    (beat 54)  — answer in subdominant (A, -12 octave down)
#
# Each voice states the subject (18 beats) then alternates
# with the countersubject (18 beats) for the rest of the piece.
#
# EROSION STAGES
# The erosion function is global (0→1 over 540 beats) but
# different aspects degrade at different rates:
#
#   Stage 1 — Exposition (beats 0-72, e: 0.00-0.13)
#     All four voices enter correctly. Clean counterpoint.
#     Slight timing jitter begins in the later entries.
#
#   Stage 2 — Development (beats 72-270, e: 0.13-0.50)
#     Timing erosion is significant (te: 0.17-0.65).
#     Entries are audibly misaligned. Pitch erosion begins
#     around beat 121 (e: 0.22, pe: 0.11). Wrong notes start
#     appearing. The subject is still recognizable but "wrong."
#     Independence erosion begins around beat 229 (e: 0.42, ie: 0.13).
#
#   Stage 3 — Dissolution (beats 270-432, e: 0.50-0.80)
#     Timing is chaotic (te: 0.65-1.0). Pitch is heavily eroded
#     (pe: 0.52-0.97). Independence is failing (ie: 0.27-0.81).
#     Voices collapse into each other or scatter.
#     The dissolution texture (noise floor) rises.
#     The subject is barely recognizable.
#
#   Stage 4 — Stasis (beats 432-540, e: 0.80-1.00)
#     Everything is eroded. Timing, pitch, independence all near 1.0.
#     The voices are independent no longer — they are scattered
#     tones over a noise floor. The pedal tone wavers.
#     What remains is the ghost of a fugue: the pedal E
#     (now unstable) and fragmented notes that once were
#     subject entries.
#
# THE DEGRADATION IS THE COUNTERPOINT
# In a proper fugue, the relationship between voices IS the music.
# Here, those relationships are what erode. The voices don't degrade
# individually (that was Study 1). The SPACE BETWEEN them degrades.
# The counterpoint — the web of relationships — is the compositional
# material, and the erosion reveals it by destroying it.
#
# SYNTH CHOICES
# Each voice has a primary and secondary synth:
#   Soprano: :prophet (subject) / :dsaw (counter) — bright, present
#   Alto:    :prophet (subject) / :hollow (counter) — clear, then distant
#   Tenor:   :dark_ambience (subject) / :dsaw (counter) — warm, then buzzy
#   Bass:    :dark_ambience (subject) / :prophet (counter) — deep, then present
# As erosion increases, cutoff drops (darker), detune increases (sour),
# and the synth identity itself becomes less clear — :hollow's filter
# opens as independence erodes, :dsaw's detune grows. The synths
# lose their character the way the voices lose their independence.
#
# CONNECTION TO THE DEGRADATION AXIS
# This study occupies the "self-aware" position on the degradation axis:
# the piece observes its own counterpoint failing. The listener can
# hear the structure because the structure is what's disappearing.
# The fugue form makes the erosion audible — you know what correct
# counterpoint sounds like, so you hear it go wrong.
#
# Study 1 (Erosion) degraded the notes.
# Study 9 (Contrapuntal Erosion) degrades the relationships.
# The unit of degradation is not the note but the interval,
# not the voice but the space between voices.
# ============================================================