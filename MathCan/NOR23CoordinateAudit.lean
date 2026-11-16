import MathCan.NOR22ModularFutureCommitments
import Mathlib.Data.Finset.Powerset
import Mathlib.Data.Finset.Card

/-!
# NOR-23: exact coordinate audits, hypergeometric budgets and adaptive evasion

An authentic coordinate witness supplies exact target values at a finite
sample of positions. A mismatch proves the candidate false. If k<n, a
world with a changed unchecked coordinate can share *all* revealed witness
values with the original world. If all n positions are checked, agreement
implies full target equality.

The finite counting theorem below computes exact safe/total k-subset
counts. For uniform k-subset sampling fixed after an independent
r-coordinate attack, the resulting exact miss fraction is
choose(n-r,k)/choose(n,k). Authentication and uniform randomness are
outside this mathematical model and explicit applied assumptions.
-/

namespace MathCan.NOR23CoordinateAudit

universe u v

variable {Coordinate : Type u}
variable {Public : Type v}

/-- True when the candidate agrees with an external truthful target witness
    on every coordinate explicitly selected for checking. -/
def agreesOn (checked : Finset Coordinate)
    (candidate target : Coordinate → Int) : Prop :=
  ∀ i ∈ checked, candidate i = target i

/-- Witness mismatch on a checked coordinate always refutes an exact
    proposed output, regardless of the difference's magnitude. -/
theorem checked_disagreement_definitively_rejects
    (checked : Finset Coordinate)
    (candidate target : Coordinate → Int)
    (i : Coordinate) (hi : i ∈ checked)
    (different : candidate i ≠ target i) :
    ¬ agreesOn checked candidate target := by
  intro h
  exact different (h i hi)

/-- More exact-coordinate queries preserve any agreement already proven. -/
theorem audit_agreement_monotone
    (small big : Finset Coordinate)
    (candidate target : Coordinate → Int)
    (subset : small ⊆ big)
    (matches : agreesOn big candidate target) :
    agreesOn small candidate target := by
  intro i hi
  exact matches i (subset hi)

/-- An authentic audit of every coordinate is equivalent to exact equality
    of the entire target function. -/
theorem complete_exact_audit_iff_target_equality
    [Fintype Coordinate]
    (candidate target : Coordinate → Int) :
    agreesOn (Finset.univ : Finset Coordinate) candidate target ↔
      candidate = target := by
  classical
  constructor
  · intro h
    funext i
    exact h i (Finset.mem_univ i)
  · intro h
    subst target
    intro i _
    rfl

/-- A single unseen coordinate permits a distinct alternate future that
    passes every sampled exact witness equality. -/
theorem invisible_single_coordinate_override
    (checked : Finset Coordinate)
    (original : Coordinate → Int)
    (j : Coordinate) (unseen : j ∉ checked) :
    ∃ altered : Coordinate → Int,
      altered ≠ original ∧ agreesOn checked original altered := by
  classical
  let altered : Coordinate → Int :=
    fun i => if i = j then original i + 1 else original i
  refine ⟨altered, ?_, ?_⟩
  · intro same
    have h : altered j = original j := congrFun same j
    have heq : original j + 1 = original j := by
      simpa [altered] using h
    omega
  · intro i hi
    have hij : i ≠ j := by
      intro h
      exact unseen (h ▸ hi)
    change original i = altered i
    simp [altered, hij]

/-- Every budget strictly smaller than the finite coordinate universe
    leaves at least one coordinate uninspected. -/
theorem strict_subfull_budget_has_unseen_coordinate
    [Fintype Coordinate]
    (checked : Finset Coordinate)
    (budget : checked.card < Fintype.card Coordinate) :
    ∃ j : Coordinate, j ∉ checked := by
  classical
  by_contra hnone
  have every : ∀ j : Coordinate, j ∈ checked := by
    intro j
    by_contra hj
    exact hnone ⟨j, hj⟩
  have included : (Finset.univ : Finset Coordinate) ⊆ checked := by
    intro j _
    exact every j
  have countBound : Fintype.card Coordinate ≤ checked.card := by
    simpa using (Finset.card_le_card included)
  omega

/-- An informed adversary can choose a one-coordinate alteration after
    seeing any strict-subfull audit budget and evade all exact checks. -/
theorem adaptive_attacker_has_undetected_alternate_future
    [Fintype Coordinate]
    (checked : Finset Coordinate)
    (original : Coordinate → Int)
    (budget : checked.card < Fintype.card Coordinate) :
    ∃ altered : Coordinate → Int,
      altered ≠ original ∧ agreesOn checked original altered := by
  obtain ⟨j, unseen⟩ :=
    strict_subfull_budget_has_unseen_coordinate checked budget
  exact invisible_single_coordinate_override checked original j unseen

/-- An authenticated witness signal returns the actual coefficient at
    inspected coordinates and no information elsewhere. -/
noncomputable def revealedCoordinates
    (checked : Finset Coordinate)
    (target : Coordinate → Int) : Coordinate → Option Int := by
  classical
  exact fun i => if i ∈ checked then some (target i) else none

/-- Two distinct targets agreeing on all checked positions supply the
    same entire witness transcript to the public verifier. -/
theorem identical_audit_transcripts_of_checked_agreement
    (checked : Finset Coordinate)
    (a b : Coordinate → Int)
    (matches : agreesOn checked a b) :
    revealedCoordinates checked a = revealedCoordinates checked b := by
  classical
  funext i
  by_cases hi : i ∈ checked
  · simp [revealedCoordinates, hi, matches i hi]
  · simp [revealedCoordinates, hi]

/-- Exact coordinate testimony cannot identify different hidden worlds
    when their public sources and revealed coordinate values coincide.
    A selector that can abstain still cannot be exact on both. -/
theorem identical_public_and_partial_witness_worlds
    (checked : Finset Coordinate)
    (selector : (Public × (Coordinate → Option Int)) →
      Option (Coordinate → Int))
    (public : Public)
    (a b : Coordinate → Int)
    (matches : agreesOn checked a b)
    (different : a ≠ b) :
    selector (public, revealedCoordinates checked a) ≠ some a ∨
      selector (public, revealedCoordinates checked b) ≠ some b := by
  have same :=
    identical_audit_transcripts_of_checked_agreement checked a b matches
  rw [← same]
  exact MathCan.NOR21ObservationCompleteness.identical_public_worlds_cannot_both_be_future_correct
    selector (public, revealedCoordinates checked a) a b different

/-- The exact count of distinct k-coordinate challenge sets from an
    n-coordinate universe equals the binomial coefficient choose(n,k). -/
theorem total_k_coordinate_challenges
    (universe : Finset Coordinate) (k : Nat) :
    (Finset.powersetCard k universe).card =
      Nat.choose universe.card k := by
  exact Finset.card_powersetCard k universe

/-- The number of k-subsets that avoid a fixed r-subset attack is exactly
    choose(n-r,k). The attacker subset is fixed before the draw. -/
theorem fixed_attack_undetected_challenge_count
    (universe altered : Finset Coordinate)
    (isSubset : altered ⊆ universe)
    (k : Nat) :
    (Finset.powersetCard k (universe \ altered)).card =
      Nat.choose (universe.card - altered.card) k := by
  classical
  calc
    (Finset.powersetCard k (universe \ altered)).card =
      Nat.choose (universe \ altered).card k :=
        Finset.card_powersetCard k (universe \ altered)
    _ = Nat.choose (universe.card - altered.card) k := by
      rw [Finset.card_sdiff_of_subset isSubset]

/-- The exact fraction of uniformly drawn k-subsets that miss a fixed
    r-subset attack, expressed as a rational ratio of finite counts.
    The applied experiment restricts to 0 ≤ k ≤ n, so the denominator
    (choose(n,k)) is positive. -/
theorem exact_hypergeometric_miss_fraction
    (universe altered : Finset Coordinate)
    (isSubset : altered ⊆ universe)
    (k : Nat) :
    ((Finset.powersetCard k (universe \ altered)).card : ℚ) /
      ((Finset.powersetCard k universe).card : ℚ) =
    (Nat.choose (universe.card - altered.card) k : ℚ) /
      (Nat.choose universe.card k : ℚ) := by
  rw [fixed_attack_undetected_challenge_count universe altered isSubset k,
      total_k_coordinate_challenges universe k]

#print axioms checked_disagreement_definitively_rejects
#print axioms audit_agreement_monotone
#print axioms complete_exact_audit_iff_target_equality
#print axioms invisible_single_coordinate_override
#print axioms strict_subfull_budget_has_unseen_coordinate
#print axioms adaptive_attacker_has_undetected_alternate_future
#print axioms identical_audit_transcripts_of_checked_agreement
#print axioms identical_public_and_partial_witness_worlds
#print axioms total_k_coordinate_challenges
#print axioms fixed_attack_undetected_challenge_count
#print axioms exact_hypergeometric_miss_fraction

end MathCan.NOR23CoordinateAudit
