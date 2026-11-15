import MathCan.PrecisionEntropy

/-!
# PEF-02: history margins, quantization order, and source-prior leakage

Independent finite mathematical certificates derived for the PEF-01 affine
base-four recurrence. The general geometric gap and Markov-prior formulas
are proved in research/compactification/PEF02_FORMAL.md and checked on
bounded parameter grids with exact arithmetic in the applied repository.

This module checks an exact four-step separation (33/256), a sharp
witness, quantified integer perturbation guards, stagewise floor equality
for all sixteen four-step histories, an affine scale-gauge example, and
finite source-prior results for a stationary 3/4-persistence Markov chain.
-/

namespace MathCan.PrecisionEntropyRobust

open MathCan.PrecisionEntropy

set_option maxRecDepth 4096
set_option maxHeartbeats 1600000

/-- Distinct most-recent two-bit suffixes have exact orbit numerator
    separation at least 33. Under denominator 4^4=256, the gap is 33/256. -/
theorem quaternary_four_step_suffix_gap :
    ∀ x y : Fin 16,
      x.val / 4 < y.val / 4 →
      quaternaryNumerator x + 33 ≤ quaternaryNumerator y := by
  decide

/-- The four-step minimum separation is attained by histories 0011
    and 0100 (oldest input is the low binary position). -/
theorem quaternary_four_step_gap_attained :
    quaternaryNumerator (3 : Fin 16) + 33 =
      quaternaryNumerator (4 : Fin 16) := by
  decide

/-- If a separation is at least 33 integer units, two-sided perturbations
    bounded by 16 units preserve a strict ordering. -/
theorem quaternary_gap_robust_under_16_integer_units
    (x y : Fin 16) (radius : Nat)
    (hsuffix : x.val / 4 < y.val / 4)
    (hradius : radius ≤ 16) :
    quaternaryNumerator x + 2 * radius < quaternaryNumerator y := by
  have h := quaternary_four_step_suffix_gap x y hsuffix
  omega

/-- A general additive-noise interval separation lemma in Nat arithmetic.
    For real-valued states, the analogous condition is 2ε<gap. -/
theorem separated_clusters_two_sided_noise
    (leftMax rightMin radius gap : Nat)
    (hseparated : leftMax + gap ≤ rightMin)
    (hsmall : 2 * radius < gap) :
    leftMax + radius < rightMin - radius := by
  omega

/-- Recurrent floor quantizer at three fractional bits, represented as
    an integer state. Digit injection contributes 3*2^3*b=24*b. -/
def floorStep3 (state digit : Nat) : Nat :=
  (state + 24 * digit) / 4

def stagedReadout3 (w : Fin 16) : Nat :=
  floorStep3
    (floorStep3
      (floorStep3
        (floorStep3 0 (w.val % 2))
        ((w.val / 2) % 2))
      ((w.val / 4) % 2))
    ((w.val / 8) % 2)

/-- Four stagewise floors equal the single end-only three-bit floor
    on every finite input history. -/
theorem staged_readout3_equals_end_readout :
    ∀ w : Fin 16,
      stagedReadout3 w = quaternaryReadout3 w := by
  decide

def floorStep7 (state digit : Nat) : Nat :=
  (state + 384 * digit) / 4

def stagedReadout7 (w : Fin 16) : Nat :=
  floorStep7
    (floorStep7
      (floorStep7
        (floorStep7 0 (w.val % 2))
        ((w.val / 2) % 2))
      ((w.val / 4) % 2))
    ((w.val / 8) % 2)

/-- All 16 histories also satisfy stagewise-endpoint floor equality with
    seven fractional bits. -/
theorem staged_readout7_equals_end_readout :
    ∀ w : Fin 16,
      stagedReadout7 w = quaternaryReadout7 w := by
  decide

/-- A 16x hidden-state gain at nominal B=3 is an effective B=7
    uncalibrated readout. This uses additional integer range. -/
theorem absolute_four_bit_gain_changes_readout :
    ∀ w : Fin 16,
      (16 * quaternaryNumerator w) / 32 =
        quaternaryReadout7 w := by
  decide

/-- The uncalibrated gain readout is injective on this finite fibre. -/
theorem gained_absolute_readout_injective :
    ∀ x y : Fin 16,
      ((16 * quaternaryNumerator x) / 32 =
        (16 * quaternaryNumerator y) / 32) ↔ x = y := by
  decide

/-- The calibrated readout divides out that gain, restoring the
    original two-visible-bit partition. -/
theorem calibrated_gain_restores_suffix_classes :
    ∀ x y : Fin 16,
      (quaternaryNumerator x / 32 =
        quaternaryNumerator y / 32) ↔
      x.val / 4 = y.val / 4 := by
  decide

/-- Example exact source prior: a three-input stationary binary Markov
    chain, transition persistence 3/4, integer weights out of 32. -/
def markov3Weight (w : Fin 8) : Nat :=
  (if w.val % 2 == (w.val / 2) % 2 then 3 else 1) *
  (if (w.val / 2) % 2 == (w.val / 4) % 2 then 3 else 1)

def newestBitReadout (w : Fin 8) : Nat :=
  w.val / 4

/-- The eight history weights sum to 32. -/
theorem markov_three_step_mass :
    ((List.finRange 8).map markov3Weight).sum = 32 := by
  decide

/-- The most recent input is fair and each observable code has mass 16. -/
theorem markov_newest_bit_marginals :
    (((List.finRange 8).filter
      (fun w => newestBitReadout w == 0)).map markov3Weight).sum = 16 ∧
    (((List.finRange 8).filter
      (fun w => newestBitReadout w == 1)).map markov3Weight).sum = 16 := by
  decide

/-- No possible three-bit source history has weight above nine out of 32. -/
theorem markov_three_step_max_weight :
    (∀ w : Fin 8, markov3Weight w ≤ 9) ∧
    markov3Weight (0 : Fin 8) = 9 ∧
    markov3Weight (7 : Fin 8) = 9 := by
  decide

/-- One maximum-probability history per observed newest bit gives a MAP
    whole-history success of 18/32=9/16, compared with 1/4 for fair inputs.
    The observation itself still exposes only the newest bit. -/
theorem markov_prior_whole_history_map_numerator :
    markov3Weight (0 : Fin 8) + markov3Weight (7 : Fin 8) = 18 := by
  decide

/-- Observational correlation: penultimate and newest source bits agree
    with probability 24/32=3/4. -/
theorem markov_hidden_observed_alignment :
    (((List.finRange 8).filter
      (fun w => (w.val / 2) % 2 == (w.val / 4) % 2)).map markov3Weight).sum = 24 := by
  decide

/-- Intervention semantics: changing older bits while fixing newest
    always leaves the one-bit readout unchanged, even under this prior. -/
theorem markov_old_history_has_zero_direct_readout_effect :
    ∀ x y : Fin 8,
      x.val / 4 = y.val / 4 →
      newestBitReadout x = newestBitReadout y := by
  intro x y h
  exact h

#print axioms quaternary_four_step_suffix_gap
#print axioms quaternary_four_step_gap_attained
#print axioms quaternary_gap_robust_under_16_integer_units
#print axioms separated_clusters_two_sided_noise
#print axioms staged_readout3_equals_end_readout
#print axioms staged_readout7_equals_end_readout
#print axioms absolute_four_bit_gain_changes_readout
#print axioms gained_absolute_readout_injective
#print axioms calibrated_gain_restores_suffix_classes
#print axioms markov_three_step_mass
#print axioms markov_newest_bit_marginals
#print axioms markov_three_step_max_weight
#print axioms markov_prior_whole_history_map_numerator
#print axioms markov_hidden_observed_alignment
#print axioms markov_old_history_has_zero_direct_readout_effect

end MathCan.PrecisionEntropyRobust
