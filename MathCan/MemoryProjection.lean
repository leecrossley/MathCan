import MathCan.PairedHistory

/-!
# PEF-05: Euclidean guard, adaptive preconditioning and signed-margin fibres

The PEF-05 gradient-surgery experiment protects a training-only memory
score to first order by removing an offending task-gradient component.
Its actual optimizer is AdamW, whose diagonal adaptive moments can
change the sign of the update's effect on the score. Independently,
protecting an *average* signed memory separation need not preserve
every individual source pair, nor its downstream decodability.

These are elementary but exact finite and general arithmetic
certificates under a completely explicit two-dimensional model.
They make no claim that the adaptive optimizer is exactly a fixed
diagonal matrix throughout a trained model.
-/

namespace MathCan.MemoryProjection

/-- Signed old-history score gradient, modeled as the linear functional
    m=(1,1). -/
def memoryDot (gradient : Int × Int) : Int :=
  gradient.1 + gradient.2

/-- A fixed unequal coordinate preconditioner with diagonal (2,1).
    This is an exact surrogate for anisotropic adaptive steps. -/
def diagonalStep (gradient : Int × Int) : Int × Int :=
  (2 * gradient.1, gradient.2)

/-- A task gradient can be orthogonal to the old-memory score in the
    Euclidean geometry, yet be score-decreasing after diagonal
    preconditioning and a negative optimizer step. -/
theorem euclidean_guard_fails_for_anisotropic_update :
    memoryDot (1, -1) = 0 ∧
    memoryDot (diagonalStep (1, -1)) = 1 := by
  decide

/-- General family of such counterexamples: if x+y=0, the
    preconditioned old-memory score equals x. The optimizer
    will *decrease* the score when x>0 and theta'=theta-eta*P*g. -/
theorem anisotropic_leak_for_orthogonal_gradient
    (x y : Int) (hzero : x + y = 0) :
    memoryDot (diagonalStep (x,y)) = x := by
  dsimp [memoryDot, diagonalStep]
  omega

/-- The linear score after subtracting c units in the first
    gradient coordinate is nonpositive provided 2c>=2x+y. -/
theorem diagonal_aware_gradient_correction
    (x y c : Int) (h: 2*x+y ≤ 2*c) :
    memoryDot (diagonalStep (x-c, y)) ≤ 0 := by
  dsimp [memoryDot, diagonalStep]
  omega

/-- An optimizer-aware fixed diagonal gradient guard can remain
    necessary when an ordinary Euclidean projection has zero dot. -/
theorem diagonal_aware_correction_witness :
    memoryDot (diagonalStep (1,-1)) = 1 ∧
    memoryDot (diagonalStep (0,-1)) = -1 := by
  decide

/-- Two gradients can have identical Euclidean squared norm
    despite having different effects on the same memory score. -/
def squaredNorm (v : Int × Int) : Int := v.1*v.1 + v.2*v.2

theorem equal_gradient_norm_different_memory_effect :
    squaredNorm (0,1) = squaredNorm (1,0) ∧
    memoryDot (0,1) = 1 ∧
    memoryDot (1,0) = 1 := by
  decide

/-- Explicit equal-norm directions whose influence on the first
    coordinate's old-memory signed score differs. -/
def firstCoordinate (g : Int × Int) : Int := g.1

theorem equal_norm_random_direction_does_not_match_memory_effect :
    squaredNorm (0,1) = squaredNorm (1,0) ∧
    firstCoordinate (0,1) = 0 ∧
    firstCoordinate (1,0) = 1 := by
  decide

/-- For a finite collection of paired history margins, nonnegativity
    of every margin is sufficient for nonnegative aggregate score. -/
theorem all_pair_margins_nonnegative_implies_total_nonnegative
    (margins : List Int)
    (h : ∀ x ∈ margins, 0 ≤ x) :
    0 ≤ margins.sum := by
  induction margins with
  | nil => simp
  | cons x xs ih =>
      have hx : 0 ≤ x := h x (by simp)
      have hxs : ∀ z ∈ xs, 0 ≤ z := by
        intro z hz
        exact h z (by simp [hz])
      have htail := ih hxs
      simp only [List.sum_cons]
      omega

/-- Converse failure: a strictly positive aggregate margin can
    coexist with a source pair whose signed margin is negative.
    Its old-history orientation can be misdecoded by a common
    fixed-direction binary separator. -/
theorem positive_mean_signed_memory_does_not_certify_all_pairs :
    0 < (4:Int) + (-3:Int) ∧
    (-3:Int) < 0 := by
  decide

/-- Different old-history pairs can cancel, leaving an aggregate
    score near zero despite each having a nonzero separation. -/
theorem nonzero_pairs_can_cancel_aggregate :
    (5:Int) ≠ 0 ∧ (-5:Int) ≠ 0 ∧
    (5:Int) + (-5:Int) = 0 := by
  decide

#print axioms euclidean_guard_fails_for_anisotropic_update
#print axioms anisotropic_leak_for_orthogonal_gradient
#print axioms diagonal_aware_gradient_correction
#print axioms diagonal_aware_correction_witness
#print axioms equal_norm_random_direction_does_not_match_memory_effect
#print axioms all_pair_margins_nonnegative_implies_total_nonnegative
#print axioms positive_mean_signed_memory_does_not_certify_all_pairs
#print axioms nonzero_pairs_can_cancel_aggregate

end MathCan.MemoryProjection
