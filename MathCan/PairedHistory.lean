import MathCan.CausalInteraction

/-!
# PEF-04: exact pair-closed history controls

A source history is a pair (b, s), with hidden oldest bit b:Bool
and fixed recent suffix s. Assign both members (false,s),(true,s)
to the same evaluation split.

Any predictor that depends only on the recent suffix assigns the
same answer to both histories. Exactly one of its two predictions is
correct, and it cannot recover both members simultaneously.
A decoder that correctly separates both members therefore certifies
distinct observed states on this counterfactual pair.

These are kernel-checked, type-generic claims. They require no
measure theory or probabilistic independence assumption, and
apply to any number of suffixes.
-/

namespace MathCan.PairedHistory

/-- Number of correct oldest-bit answers from both labels on a single
    suffix when predictions depend only on that suffix. -/
def suffixPairCorrect {Suffix : Type} (predict : Suffix → Bool)
    (suffix : Suffix) : Nat :=
  (if predict suffix then 0 else 1) +
  (if predict suffix then 1 else 0)

theorem suffixPairCorrect_one {Suffix : Type}
    (predict : Suffix → Bool) (suffix : Suffix) :
    suffixPairCorrect predict suffix = 1 := by
  cases h : predict suffix <;> simp [suffixPairCorrect, h]

/-- A list of N paired suffixes has exactly N correctly predicted
    oldest bits among its 2N histories for every suffix-only decoder. -/
theorem pairedSuffixAccuracyExactHalf {Suffix : Type}
    (predict : Suffix → Bool) (suffixes : List Suffix) :
    (suffixes.map (suffixPairCorrect predict)).sum = suffixes.length := by
  induction suffixes with
  | nil => rfl
  | cons suffix rest ih =>
      simp [suffixPairCorrect_one, ih]

/-- The same suffix-only predictor cannot be correct on both
    members of any oldest-bit intervention pair. -/
theorem suffixOnlyCannotDecodeBoth {Suffix : Type}
    (predict : Suffix → Bool) (suffix : Suffix) :
    ¬ (predict suffix = false ∧ predict suffix = true) := by
  cases h : predict suffix <;> simp [h]

/-- Identical observed hidden states force identical decoded bits.
    Correct answers on both members imply distinct observable states. -/
theorem bothCorrectImpliesDistinctStates {Hidden : Type}
    (decode : Hidden → Bool) (state0 state1 : Hidden)
    (h0 : decode state0 = false)
    (h1 : decode state1 = true) :
    state0 ≠ state1 := by
  intro h
  have equalOutputs : decode state0 = decode state1 := congrArg decode h
  rw [h0, h1] at equalOutputs
  cases equalOutputs

/-- A source-only predictor which factors through the exact seven-bit
    suffix has equal outputs on a paired pair. -/
theorem suffixFactorizedDecoderAgrees {Suffix Hidden : Type}
    (hidden : Bool → Suffix → Hidden)
    (decode : Hidden → Bool)
    (suffixPredict : Suffix → Bool)
    (hfactor : ∀ bit suffix, decode (hidden bit suffix) = suffixPredict suffix)
    (suffix : Suffix) :
    decode (hidden false suffix) = decode (hidden true suffix) := by
  rw [hfactor false suffix, hfactor true suffix]

#print axioms suffixPairCorrect_one
#print axioms pairedSuffixAccuracyExactHalf
#print axioms suffixOnlyCannotDecodeBoth
#print axioms bothCorrectImpliesDistinctStates
#print axioms suffixFactorizedDecoderAgrees

end MathCan.PairedHistory
