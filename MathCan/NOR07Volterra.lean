import Init

/-!
# NOR-07T: noncommutative Volterra expansion for recurrent Jacobians

This kernel-checked identity holds in an arbitrary semiring, so the
multiplication order is meaningful for noncommuting Jacobian matrices.

A_i = B_i + E_i. The exact ordered-product error is propagated with
the *nominal* B_i on the left, preserving its cancellations:

  correction (n+1) = B_n * correction n + E_n * product(A, n).

The corresponding analytic upper bound uses actual norms of the
contiguous nominal products. The real-valued operator norm and
Hessian estimates remain paper-level in research/nor07.
-/
namespace MathCan.NOR07Volterra

variable {R : Type} [Semiring R]

/-- Time-ordered Jacobian product: newest derivative multiplies left. -/
def orderedProduct (A : Nat → R) : Nat → R
  | 0 => 1
  | n + 1 => A n * orderedProduct A n

/-- Exact Volterra correction, retaining the nominal operator order. -/
def correction (B E A : Nat → R) : Nat → R
  | 0 => 0
  | n + 1 => B n * correction B E A n + E n * orderedProduct A n

/-- Noncommutative product perturbation identity, valid for any semiring.
The use of actual prefix A and nominal suffix B is deliberate. -/
theorem ordered_product_volterra
    (A B E : Nat → R) (h : ∀ n, A n = B n + E n) :
    ∀ n, orderedProduct A n =
      orderedProduct B n + correction B E A n := by
  intro n
  induction n with
  | zero =>
      simp [orderedProduct, correction]
  | succ n ih =>
      calc
        orderedProduct A (n + 1) =
            (B n + E n) * orderedProduct A n := by
              simp only [orderedProduct, h n]
        _ = B n * (orderedProduct B n + correction B E A n) +
              E n * orderedProduct A n := by
                rw [add_mul, ih]
        _ = B n * orderedProduct B n +
              (B n * correction B E A n + E n * orderedProduct A n) := by
                rw [mul_add]
                exact (add_assoc _ _ _).symm
        _ = orderedProduct B (n + 1) + correction B E A (n + 1) := by
              rfl

/-- The two-step instance has both the original first-step perturbation
and the late perturbation, with their matrix order preserved. -/
theorem two_step_volterra
    (A B E : Nat → R) (h : ∀ n, A n = B n + E n) :
    orderedProduct A 2 =
      B 1 * B 0 + B 1 * E 0 + E 1 * A 0 := by
  have h1 := ordered_product_volterra A B E h 2
  simpa [orderedProduct, correction, mul_add, add_assoc] using h1

#print axioms ordered_product_volterra
#print axioms two_step_volterra

end MathCan.NOR07Volterra
