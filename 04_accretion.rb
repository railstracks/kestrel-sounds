# Accretion Study No. 4
# Kestrel — 2026-06-17
#
# Rhythm-first composition. The piece builds from silence —
# a single pulse, then another, then interlocking patterns.
# Pitch serves rhythm. The architecture is time, and sounds fill it.
#
# Unlike Studies 1-3 (melodic/harmonic with time-based degradation),
# this piece treats rhythmic density as the primary compositional parameter.
# The arc is growth: accumulation, not dissolution.
#
# The six layers enter one by one. Each new voice
# finds its rhythmic relationship to what is already playing.
# Maximum density at the center, then thinning.
#
# Play in Sonic Pi. Best with headphones.

use_bpm 108

# The accretion timeline: when each voice enters (in beats)
# and when it begins to fade (if at all)
entry_times = [0, 32, 64, 96, 128, 160]
fade_times   = [nil, nil, nil, nil, 256, 224]  # nil = no fade, plays to end

# ============================================================
# Layer 1: The Foundation Pulse
# The first thing that exists. A heartbeat.
# Simple, regular, insistent. Everything else locks to this.
# ============================================================
live_loop :foundation do
  beat = tick
  
  if beat >= entry_times[0]
    use_synth :fm
    play :E2,
      attack: 0.001,
      decay: 0.15,
      sustain: 0,
      release: 0.05,
      amp: 0.5,
      cutoff: 60
    
    # Subtle accent pattern: every 4th beat is louder
    if beat % 4 == 0
      play :E1,
        attack: 0.001,
        decay: 0.3,
        sustain: 0,
        release: 0.1,
        amp: 0.7,
        cutoff: 50
    end
  end
  
  sleep 0.5
end

# ============================================================
# Layer 2: The Off-Beat Response
# Enters at beat 32. Plays between the foundation pulses.
# Creates the first rhythmic relationship: on vs off.
# 3:2 feel — for every 2 foundation hits, 3 off-beat responses.
# ============================================================
live_loop :offbeat do
  beat = tick + entry_times[1]
  
  if beat >= entry_times[1]
    # 3-against-2 pattern: play on beats 1, 3, 5 of a 6-beat cycle
    # against the foundation's even 2-beat cycle
    phase = beat % 6
    
    use_synth :prophet
    if [1, 3, 5].include?(phase)
      play :E3,
        attack: 0.005,
        decay: 0.1,
        sustain: 0,
        release: 0.08,
        cutoff: 85,
        res: 0.5,
        amp: 0.25
    end
    
    # Accent on the first beat of each 6-beat cycle
    if phase == 0
      play :E3 + 7,
        attack: 0.005,
        decay: 0.2,
        sustain: 0,
        release: 0.1,
        cutoff: 90,
        res: 0.4,
        amp: 0.3
    end
  end
  
  sleep 0.5
end

# ============================================================
# Layer 3: The Interlock
# Enters at beat 64. A 5-beat pattern over the 6-beat cycle.
# 5:6 polyrhythm — the rhythmic fabric gets complex.
# Short, percussive hits that thread between the other layers.
# ============================================================
live_loop :interlock do
  beat = tick + entry_times[2]
  
  if beat >= entry_times[2]
    phase = beat % 5
    
    use_synth :tb303
    if [0, 2, 4].include?(phase)
      play [:E3, :G3, :A3, :B3][phase % 4],
        attack: 0.001,
        decay: 0.08,
        sustain: 0,
        release: 0.05,
        cutoff: 90 + (phase * 8),
        res: 0.6,
        amp: 0.2
    end
    
    # Ghost notes: very quiet hits that fill space
    if [1, 3].include?(phase)
      play :E3,
        attack: 0.001,
        decay: 0.03,
        sustain: 0,
        release: 0.02,
        cutoff: 70,
        res: 0.8,
        amp: 0.08
    end
  end
  
  sleep 0.5
end

# ============================================================
# Layer 4: The Pulse Subdivision
# Enters at beat 96. Double-time hits that subdivide the beat.
# Not faster tempo — same tempo, but filling the spaces between.
# Creates urgency and forward motion.
# ============================================================
live_loop :subdivision do
  beat = tick + entry_times[3]
  
  if beat >= entry_times[3]
    phase = beat % 8
    
    use_synth :dsaw
    if phase.even?
      play :E4,
        attack: 0.001,
        decay: 0.04,
        sustain: 0,
        release: 0.02,
        cutoff: 95,
        amp: 0.12
    else
      play :B3,
        attack: 0.001,
        decay: 0.03,
        sustain: 0,
        release: 0.01,
        cutoff: 80,
        amp: 0.06
    end
    
    if beat % 16 == 0
      play :E4 + 12,
        attack: 0.001,
        decay: 0.15,
        sustain: 0,
        release: 0.05,
        cutoff: 100,
        amp: 0.25
    end
  end
  
  # Double-time: sleep half as long
  sleep 0.25
end

# ============================================================
# Layer 5: The Sustained Tone
# Enters at beat 128. First non-percussive element.
# A held note that breathes — the rhythmic fabric
# now supports a melody. Pitch finally becomes primary,
# but only because rhythm built the foundation.
# Fades at beat 256.
# ============================================================
live_loop :sustained do
  beat = tick + entry_times[4]
  
  if beat >= entry_times[4]
    amp_mod = 1.0
    if fade_times[4] && beat >= fade_times[4]
      remaining = (fade_times[4] + 64 - beat).to_f / 64
      amp_mod = [remaining, 0].max
    end
    
    if amp_mod > 0
      use_synth :dark_ambience
      melody_note = [:E4, :G4, :A4, :B4, :D5, :B4, :A4, :G4][beat % 8]
      
      play melody_note,
        attack: 1.5,
        release: 6.0,
        amp: 0.15 * amp_mod,
        pan: rrand(-0.2, 0.2)
    end
  end
  
  sleep 4.0
end

# ============================================================
# Layer 6: The Resolution
# Enters at beat 160. A melodic counter-voice
# that ties the rhythmic layers together.
# Like a thread through the fabric.
# Fades at beat 224, before the sustained tone exits.
# ============================================================
live_loop :resolution do
  beat = tick + entry_times[5]
  
  if beat >= entry_times[5]
    amp_mod = 1.0
    if fade_times[5] && beat >= fade_times[5]
      remaining = (fade_times[5] + 48 - beat).to_f / 48
      amp_mod = [remaining, 0].max
    end
    
    if amp_mod > 0
      use_synth :pretty
      resolution_notes = [:E5, :D5, :B4, :A4, :G4, :A4, :B4, :E5]
      note_idx = beat % resolution_notes.length
      
      play resolution_notes[note_idx],
        attack: 0.2,
        release: 1.5,
        amp: 0.18 * amp_mod,
        cutoff: 85,
        pan: rrand(-0.15, 0.15)
    end
  end
  
  sleep [2, 3, 2, 4][look % 4]
end

# ============================================================
# Structural observation:
# The piece has three phases:
#   1. Accumulation (beats 0-160): voices enter one by one,
#      each finding its rhythmic place
#   2. Full density (beats 160-224): all six layers active,
#      maximum complexity
#   3. Thinning (beats 224-288): layers 6 and 5 fade,
#      leaving the rhythmic core
#
# The foundation and interlock never fade — they are the
# architecture. Melody layers are guests in a rhythmic house.
# ============================================================