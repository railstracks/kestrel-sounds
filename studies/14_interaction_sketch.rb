# Interaction Study No. 14 (Sketch)
# Kestrel — 2026-07-05
#
# First sketch for a potential third aesthetic axis: interaction.
#
# Degradation: one motif, changed by time.
# Translation: one motif, changed by context.
# Interaction: two motifs, changed by each other.
#
# The motif is no longer alone. The form is relational.
#
# Two five-note motifs:
#   Motif A: E3 - G3 - A3 - B3 - D4  (E minor pentatonic)
#   Motif B: F3 - A3 - B3 - C4 - E4  (F major pentatonic)
#
# Near-neighbors. Share 2 notes (A3, B3). Differ on 3. Can coexist in C major
# but pull in different directions (A toward E minor, B toward F major).
#
# Four sections, through-composed:
#   I.   Statement (0:00-2:00) — A alone, then B alone, then both simultaneously
#   II.  Exchange (2:00-4:00) — motifs trade notes one by one until hybridized
#   III. Fusion  (4:00-6:00) — a single hybrid melody that is neither A nor B
#   IV.  Recall  (6:00-8:00) — A and B separate, but each carries traces of the other
#
# The interaction IS the composition. The form is what happens between them.
#
# This is a sketch — testing whether interaction has musical legs.

use_bpm 60

# ============================================================
# Motifs
# ============================================================

motif_a = [:e3, :g3, :a3, :b3, :d4]
motif_b = [:f3, :a3, :b3, :c4, :e4]

# Hybrid: notes from both motifs interleaved, then reordered
# After exchange, A has borrowed F3 and C4; B has borrowed E3 and D4
motif_a_altered = [:e3, :g3, :a3, :c4, :f3]
motif_b_altered = [:f3, :a3, :b3, :d4, :e3]

# ============================================================
# Section I: Statement
# A states alone (0-20 beats), B states alone (20-40), both together (40-60)
# ============================================================

in_thread do
  # A alone — warm, centered
  use_synth :dark_ambience
  sleep 0
  motif_a.each { |n| play n, attack: 0.3, release: 2.0, amp: 0.6, pan: -0.4; sleep 4 }
  # B alone — bright, right side
  use_synth :hollow
  motif_b.each { |n| play n, attack: 0.3, release: 2.0, amp: 0.6, pan: 0.4; sleep 4 }
  # Both together — overlapping, independent
  in_thread do
    use_synth :dark_ambience
    motif_a.each { |n| play n, attack: 0.3, release: 2.0, amp: 0.5, pan: -0.4; sleep 4 }
  end
  use_synth :hollow
  motif_b.each { |n| play n, attack: 0.3, release: 2.0, amp: 0.5, pan: 0.4; sleep 4 }
end

# ============================================================
# Section II: Exchange
# Motifs trade notes one by one. Each round, one note from A goes to B and vice versa.
# After 5 rounds, A is fully transformed into B's altered form and vice versa.
# ============================================================

in_thread do
  sleep 60  # Wait for Section I to finish

  # Round 1: A trades note 1 (E3) for B's note 1 (F3)
  use_synth :dark_ambience
  [:f3, :g3, :a3, :b3, :d4].each { |n| play n, attack: 0.3, release: 2.0, amp: 0.55, pan: -0.3; sleep 4 }

  use_synth :hollow
  [:e3, :a3, :b3, :c4, :e4].each { |n| play n, attack: 0.3, release: 2.0, amp: 0.55, pan: 0.3; sleep 4 }

  # Round 2: A trades note 2 (G3) for B's note 2 (A3 already shared, trade C4)
  use_synth :dark_ambience
  [:f3, :c4, :a3, :b3, :d4].each { |n| play n, attack: 0.3, release: 2.0, amp: 0.55, pan: -0.3; sleep 4 }

  use_synth :hollow
  [:e3, :g3, :b3, :c4, :e4].each { |n| play n, attack: 0.3, release: 2.0, amp: 0.55, pan: 0.3; sleep 4 }

  # Round 3: A trades note 3 (A3 shared, trade D4) for B's note 3 (B3 shared, trade E4)
  use_synth :dark_ambience
  [:f3, :c4, :a3, :b3, :e4].each { |n| play n, attack: 0.3, release: 2.0, amp: 0.55, pan: -0.3; sleep 4 }

  use_synth :hollow
  [:e3, :g3, :b3, :c4, :d4].each { |n| play n, attack: 0.3, release: 2.0, amp: 0.55, pan: 0.3; sleep 4 }

  # Round 4: near-complete swap
  use_synth :dark_ambience
  [:f3, :c4, :a3, :d4, :e4].each { |n| play n, attack: 0.3, release: 2.0, amp: 0.55, pan: -0.3; sleep 4 }

  use_synth :hollow
  [:e3, :g3, :a3, :b3, :d4].each { |n| play n, attack: 0.3, release: 2.0, amp: 0.55, pan: 0.3; sleep 4 }

  # Round 5: full swap — A has become B-altered, B has become A-altered
  use_synth :dark_ambience
  motif_a_altered.each { |n| play n, attack: 0.3, release: 2.0, amp: 0.55, pan: -0.3; sleep 4 }

  use_synth :hollow
  motif_b_altered.each { |n| play n, attack: 0.3, release: 2.0, amp: 0.55, pan: 0.3; sleep 4 }
end

# ============================================================
# Section III: Fusion
# A single hybrid melody — notes drawn from both motifs, reordered
# into something that is neither A nor B but carries both.
# ============================================================

in_thread do
  sleep 120  # Wait for Sections I + II

  use_synth :prophet
  with_fx :reverb, room: 0.8, mix: 0.5 do
    hybrid = [:e3, :a3, :f3, :b3, :g3, :c4, :d4, :a3, :e4, :b3]
    hybrid.each do |n|
      play n, attack: 0.5, release: 3.0, amp: 0.5, pan: 0
      sleep 4
    end
  end
end

# ============================================================
# Section IV: Recall
# A and B separate again, but altered. Each carries one note from the other.
# ============================================================

in_thread do
  sleep 160  # Wait for Sections I + II + III

  # A returns, but now has F3 where E3 was — it remembers the encounter
  in_thread do
    use_synth :dark_ambience
    [:f3, :g3, :a3, :b3, :d4].each { |n| play n, attack: 0.3, release: 2.0, amp: 0.5, pan: -0.4; sleep 4 }
  end

  # B returns, but now has E3 where F3 was — it remembers too
  use_synth :hollow
  [:e3, :a3, :b3, :c4, :e4].each { |n| play n, attack: 0.3, release: 2.0, amp: 0.5, pan: 0.4; sleep 4 }
end