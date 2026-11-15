import MathCan.MemoryProjection

/-!
# PEF-05R: discrete perturbation envelope for optimizer-state drift

In two update streams with the same initial parameter state, the
difference after T updates can be amplified by the local Lipschitz
constant of their update map. This elementary discrete Gronwall
bound formalizes the permissible interpretation of the numerical
differences observed between two PEF-05 hosted runs.

The abstract error d : Nat -> Nat is a nonnegative bound in
scaled fixed integer units. L and eps are also integer bounds:
  d_(n+1) <= L*d_n + eps.
The recurrence E_0 = initial, E_(n+1) = L*E_n + eps majorizes d_n.
This does not assert an L or eps for AdamW, nor a chaotic exponent.
-/

namespace MathCan.GradientStability

/-- Upper envelope for finite nonnegative perturbations with scalar
    one-step amplification L and bounded local discrepancy eps. -/
def errorEnvelope (initial L eps : Nat) : Nat → Nat
  | 0 => initial
  | n + 1 => L * errorEnvelope initial L eps n + eps

/-- Exact discrete Gronwall majorization for arbitrary nonnegative
    error sequence whose one-step deviation satisfies the bound. -/
theorem scalar_perturbation_envelope
    (distance : Nat → Nat) (initial L eps : Nat)
    (h0 : distance 0 ≤ initial)
    (hstep : ∀ n, distance (n+1) ≤ L * distance n + eps) :
    ∀ n, distance n ≤ errorEnvelope initial L eps n := by
  intro n
  induction n with
  | zero =>
      simpa [errorEnvelope] using h0
  | succ n ih =>
      have bound : L * distance n + eps ≤
          L * errorEnvelope initial L eps n + eps :=
        Nat.add_le_add_right (Nat.mul_le_mul_left L ih) eps
      exact (hstep n).trans (by simpa [errorEnvelope] using bound)

/-- A deterministic starting state with exact equality and the same
    update mapping has zero envelope when local numerical discrepancy
    is identically zero. -/
theorem no_local_perturbation_no_drift
    (initialIsZero : Nat) :
    errorEnvelope 0 initialIsZero 0 0 = 0 := by
  rfl

/-- Five updates with an integer factor-two amplification and a one-unit
    local perturbation permit an envelope of thirty-one units. -/
theorem five_step_double_amplification :
    errorEnvelope 0 2 1 5 = 31 := by
  decide

/-- The same five one-unit discrepancies with a one-Lipschitz update
    have a five-unit envelope. -/
theorem five_step_nonexpansive_bound :
    errorEnvelope 0 1 1 5 = 5 := by
  decide

/-- Independent first-order optimizer-step deviations can exist even
    when two runs have identical initialization. The recurrence can
    accumulate them from a zero starting error. -/
theorem one_step_error_from_identical_start
    (L eps : Nat) :
    errorEnvelope 0 L eps 1 = eps := by
  simp [errorEnvelope]

/-- Local errors and initial errors are monotone under fixed L. -/
theorem envelope_monotone_initial
    (first second L eps : Nat) (h : first ≤ second) :
    ∀ n, errorEnvelope first L eps n ≤
      errorEnvelope second L eps n := by
  intro n
  induction n with
  | zero =>
      simpa [errorEnvelope] using h
  | succ n ih =>
      have hmul := Nat.mul_le_mul_left L ih
      exact by
        simpa [errorEnvelope] using Nat.add_le_add_right hmul eps

/-- For zero step errors and a zero initial difference, the stability
    envelope stays exactly zero for any nonnegative step amplification. -/
theorem exact_arithmetic_repeatability
    (L : Nat) :
    ∀ n, errorEnvelope 0 L 0 n = 0 := by
  intro n
  induction n with
  | zero => rfl
  | succ n ih =>
      simp [errorEnvelope, ih]

#print axioms scalar_perturbation_envelope
#print axioms no_local_perturbation_no_drift
#print axioms five_step_double_amplification
#print axioms five_step_nonexpansive_bound
#print axioms one_step_error_from_identical_start
#print axioms envelope_monotone_initial
#print axioms exact_arithmetic_repeatability

end MathCan.GradientStability
