import Init

/-!
# PEF-01: finite precision, observable histories, and self-similar recurrence

A self-contained finite algebraic certificate for the precision/entropy
frontier motivated by OpenAI math families #140 (memory-limited inference)
and #148 (entropy-rate dimensions of self-similar measures).

The real-valued toy dynamics have two input-conditioned contractions:
  phi_b(x) = (x + (2^k - 1) * b) / 2^k, b in {0,1}.
Their length-L orbit points form base-(2^k) expansions using digits 0
or 2^k-1. Our proof statements below concern exact finite readouts and
integer bit budgets; no analytic entropy/dimension theorem is imported.

For a uniform length-L input history and an aligned B-bit fixed-point
readout, a separate counting proof in the paper-level note gives:
  t = min(L, ceil(B/k)) recoverable most-recent input bits,
  exact-history Bayes success = 2^(t-L),
  conditional entropy = L-t bits.
The Lean finite instances below test the nontrivial k=2 depth-four
3/6/7-bit fibre sizes and the generic k=2 threshold arithmetic.
-/

namespace MathCan.PrecisionEntropy

set_option maxRecDepth 4096
set_option maxHeartbeats 1500000

/-- Four chronological input bits, oldest in the least-significant place.
    This is the exact depth-four numerator for phi_b(x)=(x+3b)/4,
    with denominator 4^4=256. -/
def quaternaryNumerator (w : Fin 16) : Nat :=
  3 * (w.val % 2) +
  12 * ((w.val / 2) % 2) +
  48 * ((w.val / 4) % 2) +
  192 * ((w.val / 8) % 2)

/-- Two-bit fixed-point observation of the binary contraction. -/
def binaryReadout2 (w : Fin 16) : Nat := w.val / 4

/-- B=3,6,7 aligned fixed-point observations of the quaternary contraction. -/
def quaternaryReadout3 (w : Fin 16) : Nat :=
  quaternaryNumerator w / 32

def quaternaryReadout6 (w : Fin 16) : Nat :=
  quaternaryNumerator w / 4

def quaternaryReadout7 (w : Fin 16) : Nat :=
  quaternaryNumerator w / 2

/-- At B=3, the newest two bits appear as a sparse code with values
    0,1,6,7. Earlier history does not affect the readout. -/
theorem quaternary_three_bit_normal_form :
    ∀ w : Fin 16,
      quaternaryReadout3 w =
        6 * ((w.val / 8) % 2) + ((w.val / 4) % 2) := by
  decide

/-- The B=3 readout identifies exactly the same equivalence classes
    as the two most recent input bits. -/
theorem quaternary_three_bit_suffix_iff :
    ∀ x y : Fin 16,
      quaternaryReadout3 x = quaternaryReadout3 y ↔
      x.val / 4 = y.val / 4 := by
  decide

/-- B=6 identifies the three most recent bits, leaving the oldest hidden. -/
theorem quaternary_six_bit_suffix_iff :
    ∀ x y : Fin 16,
      quaternaryReadout6 x = quaternaryReadout6 y ↔
      x.val / 2 = y.val / 2 := by
  decide

/-- Seven fixed-point bits recover all four past inputs. -/
theorem quaternary_seven_bit_injective :
    ∀ x y : Fin 16,
      quaternaryReadout7 x = quaternaryReadout7 y ↔ x = y := by
  decide

/-- Every output has four preimages when four inputs pass through
    the B=3 quaternary observation, giving optimal success 1/4. -/
theorem quaternary_three_bit_fibres :
    ∀ w : Fin 16,
      ((List.finRange 16).filter
        (fun x => quaternaryReadout3 x == quaternaryReadout3 w)).length = 4 := by
  decide

/-- B=6 leaves exactly two indistinguishable histories. -/
theorem quaternary_six_bit_fibres :
    ∀ w : Fin 16,
      ((List.finRange 16).filter
        (fun x => quaternaryReadout6 x == quaternaryReadout6 w)).length = 2 := by
  decide

/-- B=7 separates the full set of sixteen histories. -/
theorem quaternary_seven_bit_fibres :
    ∀ w : Fin 16,
      ((List.finRange 16).filter
        (fun x => quaternaryReadout7 x == quaternaryReadout7 w)).length = 1 := by
  decide

/-- At the same B=2, the binary contraction keeps the two newest bits
    and therefore has four histories in each fibre. -/
theorem binary_two_bit_fibres :
    ∀ w : Fin 16,
      ((List.finRange 16).filter
        (fun x => binaryReadout2 x == binaryReadout2 w)).length = 4 := by
  decide

/-- At contraction ratio 1/4, retaining all L input bits needs precisely
    B >= 2L-1 bits, for each positive integer depth L. -/
theorem quaternary_precision_threshold (depth precision : Nat)
    (hdepth : 1 ≤ depth) :
    depth ≤ (precision + 1) / 2 ↔ 2 * depth - 1 ≤ precision := by
  omega

/-- Below the threshold, an older input is necessarily lost. -/
theorem quaternary_below_threshold (depth precision : Nat)
    (hdepth : 1 ≤ depth)
    (hbits : precision < 2 * depth - 1) :
    (precision + 1) / 2 < depth := by
  omega

/-- A single additional precision bit cannot reveal more than one
    *additional* input bit in the quaternary system. -/
theorem quaternary_precision_one_step (precision : Nat) :
    (precision + 2) / 2 ≤ (precision + 1) / 2 + 1 := by
  omega

/-- The hypothetical recoverable-bit count is always at most the depth. -/
def recoverableQuaternary (depth precision : Nat) : Nat :=
  min depth ((precision + 1) / 2)

theorem recoverable_quaternary_bound (depth precision : Nat) :
    recoverableQuaternary depth precision ≤ depth := by
  simp [recoverableQuaternary]

#print axioms quaternary_three_bit_normal_form
#print axioms quaternary_three_bit_suffix_iff
#print axioms quaternary_six_bit_suffix_iff
#print axioms quaternary_seven_bit_injective
#print axioms quaternary_three_bit_fibres
#print axioms quaternary_six_bit_fibres
#print axioms quaternary_seven_bit_fibres
#print axioms binary_two_bit_fibres
#print axioms quaternary_precision_threshold
#print axioms quaternary_below_threshold
#print axioms quaternary_precision_one_step
#print axioms recoverable_quaternary_bound

end MathCan.PrecisionEntropy
