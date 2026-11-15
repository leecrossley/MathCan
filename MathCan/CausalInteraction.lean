import MathCan.OrderedTangent

/-!
# PEF-03G: finite causal interaction and hidden-head mediation

When two disjoint hidden feature components are transplanted
independently, the nonlinear future-output change has an exact
four-point interaction term. Even perfect final-head nullspace
invariance says nothing about intermediate hybrid-state behavior.

This file proves the universal additive decomposition of four
integer-valued observations and a nonzero quadratic interaction
witness. Only the finite algebra is formalized.
-/

namespace MathCan.CausalInteraction

/-- An arbitrary four-corner difference always decomposes into
    the two single-component effects and a two-component interaction.
    This is an equality of scalars and imposes no model smoothness. -/
theorem four_corner_decomposition
    (original donor rowPatch nullPatch : Int) :
    donor - original =
      (rowPatch - original) +
      (nullPatch - original) +
      (donor - rowPatch - nullPatch + original) := by
  omega

/-- A linear two-feature readout has zero finite four-corner interaction
    when the two components are changed independently. -/
def linearReadout (x y : Int) : Int := 3 * x + 5 * y + 1

theorem linear_four_corner_interaction_zero
    (x0 y0 x1 y1 : Int) :
    linearReadout x1 y1 -
    linearReadout x1 y0 -
    linearReadout x0 y1 +
    linearReadout x0 y0 = 0 := by
  simp only [linearReadout]
  omega

/-- A nonlinear readout with multiplicative feature coupling. -/
def quadraticReadout (x y : Int) : Int := x * y

/-- Its pure interaction at the square corners is exactly one. -/
theorem quadratic_interaction_witness :
    quadraticReadout 1 1 -
    quadraticReadout 1 0 -
    quadraticReadout 0 1 +
    quadraticReadout 0 0 = 1 := by
  decide

/-- All of the natural output change in the finite witness can
    arise from interaction even when both single-feature patches
    have zero output effect. -/
theorem nonlinear_full_change_without_single_patch_changes :
    quadraticReadout 0 0 = 0 ∧
    quadraticReadout 1 0 = 0 ∧
    quadraticReadout 0 1 = 0 ∧
    quadraticReadout 1 1 = 1 := by
  decide

/-- The final task head reading one coordinate ignores arbitrary
    changes in its second-coordinate kernel. -/
theorem terminal_first_coordinate_head_invariance
    (x y perturbation : Int) :
    MathCan.OrderedTangent.firstCoordinateHead (x, y + perturbation) =
      MathCan.OrderedTangent.firstCoordinateHead (x, y) := by
  rfl

/-- One further recurrent shear can re-activate a final-head invisible
    coordinate. Hence final-head invariance alone cannot license
    inter-visit causal invariance. -/
theorem future_first_coordinate_head_reactivation :
    MathCan.OrderedTangent.firstCoordinateHead (0, (1 : Int)) = 0 ∧
    MathCan.OrderedTangent.firstCoordinateHead
      (MathCan.OrderedTangent.upper (0, (1 : Int))) = 1 := by
  decide

#print axioms four_corner_decomposition
#print axioms linear_four_corner_interaction_zero
#print axioms quadratic_interaction_witness
#print axioms nonlinear_full_change_without_single_patch_changes
#print axioms terminal_first_coordinate_head_invariance
#print axioms future_first_coordinate_head_reactivation

end MathCan.CausalInteraction
