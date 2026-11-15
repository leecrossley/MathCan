import MathCan.PrecisionEntropySchedule

/-!
# PEF-03: a noncommuting Jacobian-product witness

A recurrent model can have identical individual Jacobian maps and the
same local singular-value data while its history-input sensitivity
changes with application order. This module proves an explicit integer
shear witness and a two-dimensional general commutator identity.

Let U(x,y)=(x+y,y), D(x,y)=(x,x+y). These are unipotent 2x2
linear maps with determinant 1 and both eigenvalues 1. Their ordered
products act differently on an input perturbation along e1=(1,0):

  U(D(e1)) = (2,1), squared norm 5;
  D(U(e1)) = (1,1), squared norm 2.

The source of the difference is the commutator, with
U(D(x,y))-D(U(x,y))=(x,-y).
-/

namespace MathCan.OrderedTangent

/-- Two elementary determinant-one shears. -/
def upper (z : Int × Int) : Int × Int :=
  (z.1 + z.2, z.2)

def lower (z : Int × Int) : Int × Int :=
  (z.1, z.1 + z.2)

/-- Squared Euclidean magnitude, represented exactly in integers. -/
def squareNorm (z : Int × Int) : Int :=
  z.1 * z.1 + z.2 * z.2

/-- The first ordering of the same two Jacobians. -/
theorem upper_after_lower_general (x y : Int) :
    upper (lower (x, y)) = (2 * x + y, x + y) := by
  simp [upper, lower] <;> omega

/-- The reversed ordering. -/
theorem lower_after_upper_general (x y : Int) :
    lower (upper (x, y)) = (x + y, x + 2 * y) := by
  simp [upper, lower] <;> omega

/-- Noncommutativity of two locally unipotent update Jacobians:
    the input-directed difference is (x,-y) for every integer vector. -/
theorem shear_commutator (x y : Int) :
    (upper (lower (x,y))).1 - (lower (upper (x,y))).1 = x ∧
    (upper (lower (x,y))).2 - (lower (upper (x,y))).2 = -y := by
  simp [upper, lower] <;> omega

/-- A directional input tangent is amplified differently by two schedules
    with identical per-step operators. -/
theorem first_ordered_input_tangent :
    upper (lower (1, 0)) = (2, 1) := by
  decide

theorem reversed_ordered_input_tangent :
    lower (upper (1, 0)) = (1, 1) := by
  decide

/-- Exact nonzero squared-norm gap in the same input direction. -/
theorem ordered_squared_gain_five_vs_two :
    squareNorm (upper (lower (1, 0))) = 5 ∧
    squareNorm (lower (upper (1, 0))) = 2 := by
  decide

/-- The complementary input tangent e2 reverses the two squared gains. -/
theorem complementary_direction_reverses_gain :
    squareNorm (upper (lower (0, 1))) = 2 ∧
    squareNorm (lower (upper (0, 1))) = 5 := by
  decide

/-- Each shear has determinant one on the standard ordered basis. The
    universal area-preserving statement is established algebraically in
    the research note; here the two integer-basis determinants are checked. -/
def orientedArea (left right : Int × Int) : Int :=
  left.1 * right.2 - left.2 * right.1

theorem upper_determinant_one :
    orientedArea (upper (1,0)) (upper (0,1)) = 1 := by
  decide

theorem lower_determinant_one :
    orientedArea (lower (1,0)) (lower (0,1)) = 1 := by
  decide

#print axioms upper_after_lower_general
#print axioms lower_after_upper_general
#print axioms shear_commutator
#print axioms first_ordered_input_tangent
#print axioms reversed_ordered_input_tangent
#print axioms ordered_squared_gain_five_vs_two
#print axioms complementary_direction_reverses_gain
#print axioms upper_determinant_one
#print axioms lower_determinant_one

end MathCan.OrderedTangent
