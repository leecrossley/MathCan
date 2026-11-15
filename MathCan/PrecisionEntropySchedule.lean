import MathCan.PrecisionEntropyRobust

/-!
# PEF-02S: finite mixed-contraction loop schedule certificates

The three three-step schedules below have identical total contraction
exponent k0+k1+k2 = 8, with width multiset {2,2,4}. Every state is a
finite binary fraction of denominator 256. At B=6, two schedules have
the same two-bit visible history and different exact geometric margins
9/256 and 57/256. Moving the width-four contraction to the oldest
step allows all three input bits to be observed at B=6.

These are finite kernel-checked examples of the general mixed-radix
schedule theorem proved in research/compactification/PEF02S_FORMAL.md.
-/

namespace MathCan.PrecisionEntropySchedule

set_option maxRecDepth 4096
set_option maxHeartbeats 1300000

/-- Oldest to newest widths: (2,2,4).
    Numerator = 3*b0 + 12*b1 + 240*b2, denominator 256. -/
def numA (w : Fin 8) : Nat :=
  3 * (w.val % 2) +
  12 * ((w.val / 2) % 2) +
  240 * ((w.val / 4) % 2)

/-- Oldest to newest widths: (2,4,2).
    Numerator = 3*b0 + 60*b1 + 192*b2. -/
def numB (w : Fin 8) : Nat :=
  3 * (w.val % 2) +
  60 * ((w.val / 2) % 2) +
  192 * ((w.val / 4) % 2)

/-- Oldest to newest widths: (4,2,2).
    Numerator = 15*b0 + 48*b1 + 192*b2. -/
def numC (w : Fin 8) : Nat :=
  15 * (w.val % 2) +
  48 * ((w.val / 2) % 2) +
  192 * ((w.val / 4) % 2)

/-- B=6 fixed-point readouts, with common denominator 2^8=256. -/
def codeA6 (w : Fin 8) : Nat := numA w / 4
def codeB6 (w : Fin 8) : Nat := numB w / 4
def codeC6 (w : Fin 8) : Nat := numC w / 4

/-- A and B read out exactly the two newest binary inputs. -/
theorem scheduleA_two_bit_suffix_iff :
    ∀ x y : Fin 8,
      (codeA6 x = codeA6 y ↔ x.val / 2 = y.val / 2) := by
  decide

theorem scheduleB_two_bit_suffix_iff :
    ∀ x y : Fin 8,
      (codeB6 x = codeB6 y ↔ x.val / 2 = y.val / 2) := by
  decide

/-- Moving the four-bit contraction to the oldest step changes the
    observed-history capacity: schedule C is injective at B=6. -/
theorem scheduleC_three_bit_injective :
    ∀ x y : Fin 8,
      (codeC6 x = codeC6 y ↔ x = y) := by
  decide

/-- Exact analog inter-suffix gap for schedule A is 9/256. -/
theorem scheduleA_suffix_gap_9 :
    ∀ x y : Fin 8,
      x.val / 2 < y.val / 2 →
      numA x + 9 ≤ numA y := by
  decide

theorem scheduleA_gap_9_attained :
    numA (1 : Fin 8) + 9 = numA (2 : Fin 8) := by
  decide

/-- At identical readout precision and retained capacity, schedule B
    has an exact geometric gap 57/256. -/
theorem scheduleB_suffix_gap_57 :
    ∀ x y : Fin 8,
      x.val / 2 < y.val / 2 →
      numB x + 57 ≤ numB y := by
  decide

theorem scheduleB_gap_57_attained :
    numB (1 : Fin 8) + 57 = numB (2 : Fin 8) := by
  decide

/-- At B=6 schedule A tolerates any symmetric integer-numerator
    perturbation radius at most 4 without merging suffix intervals. -/
theorem scheduleA_integer_radius4_safe :
    ∀ x y : Fin 8,
      x.val / 2 < y.val / 2 →
      numA x + 8 < numA y := by
  decide

/-- Schedule B tolerates numerator radius at most 28 (2*28=56). -/
theorem scheduleB_integer_radius28_safe :
    ∀ x y : Fin 8,
      x.val / 2 < y.val / 2 →
      numB x + 56 < numB y := by
  decide

/-- At B=7 schedule A also recovers the oldest history bit. -/
def codeA7 (w : Fin 8) : Nat := numA w / 2

theorem scheduleA_full_history_precision7 :
    ∀ x y : Fin 8, (codeA7 x = codeA7 y ↔ x = y) := by
  decide

/-- For schedule C the full-history threshold is B=5. At B=4
    the oldest bit is hidden; at B=5 it is distinguishable. -/
def codeC4 (w : Fin 8) : Nat := numC w / 16
def codeC5 (w : Fin 8) : Nat := numC w / 8

theorem scheduleC_precision4_two_bit_suffix :
    ∀ x y : Fin 8, (codeC4 x = codeC4 y ↔ x.val / 2 = y.val / 2) := by
  decide

theorem scheduleC_precision5_full_history :
    ∀ x y : Fin 8, (codeC5 x = codeC5 y ↔ x = y) := by
  decide

/-- End-only and stagewise floor quantizers coincide on all histories
    for both orderings of the same multiset of recurrence factors. -/
def step2 (state bit : Nat) : Nat := (state + 192 * bit) / 4
def step4 (state bit : Nat) : Nat := (state + 960 * bit) / 16

def stagedA6 (w : Fin 8) : Nat :=
  step4 (step2 (step2 0 (w.val % 2)) ((w.val / 2) % 2))
    ((w.val / 4) % 2)

def stagedB6 (w : Fin 8) : Nat :=
  step2 (step4 (step2 0 (w.val % 2)) ((w.val / 2) % 2))
    ((w.val / 4) % 2)

theorem stagedA_floor_commutes :
    ∀ w : Fin 8, stagedA6 w = codeA6 w := by
  decide

theorem stagedB_floor_commutes :
    ∀ w : Fin 8, stagedB6 w = codeB6 w := by
  decide

#print axioms scheduleA_two_bit_suffix_iff
#print axioms scheduleB_two_bit_suffix_iff
#print axioms scheduleC_three_bit_injective
#print axioms scheduleA_suffix_gap_9
#print axioms scheduleA_gap_9_attained
#print axioms scheduleB_suffix_gap_57
#print axioms scheduleB_gap_57_attained
#print axioms scheduleA_integer_radius4_safe
#print axioms scheduleB_integer_radius28_safe
#print axioms scheduleA_full_history_precision7
#print axioms scheduleC_precision4_two_bit_suffix
#print axioms scheduleC_precision5_full_history
#print axioms stagedA_floor_commutes
#print axioms stagedB_floor_commutes

end MathCan.PrecisionEntropySchedule
