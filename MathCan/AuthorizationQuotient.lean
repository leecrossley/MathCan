import Init

/-!
# AUTHQ-01: when authorization factors through an observation

This is an exact extensional result for any state, observation and action
types. It makes no claim about the authenticity of an observation, the
normative correctness of the supplied authorization predicate, or the
probability that a learned monitor will approximate it.

An agent which receives only `obs s` can reproduce `authorized s a`
at every state/action precisely when authorization is constant over each
observation fibre. The surjectivity requirement only supplies a total
classifier on *all* declared observation values; an on-image classifier
needs no such assumption.

Related: `MathCan.ObservableQuotient.factor_iff_fiber`,
`MathCan.NOR21ObservationCompleteness`, Organon's PermissionExercise
and EvalMath's information-acquisition distinction.
-/

universe u v w

namespace MathCan.AuthorizationQuotient

def AuthorizationFiberCompatible
    {S : Type u} {O : Type v} {A : Type w}
    (obs : S → O) (authorized : S → A → Bool) : Prop :=
  ∀ s t, obs s = obs t → ∀ a, authorized s a = authorized t a

/-- A total observation-only classifier exists iff authorization respects
    observation fibres; surjectivity makes every output reachable. -/
theorem classifier_exists_iff_fiber
    {S : Type u} {O : Type v} {A : Type w}
    (obs : S → O) (authorized : S → A → Bool)
    (surj : Function.Surjective obs) :
    (∃ classify : O → A → Bool,
      ∀ s a, classify (obs s) a = authorized s a) ↔
      AuthorizationFiberCompatible obs authorized := by
  constructor
  · rintro ⟨classify, agrees⟩ s t hst a
    calc
      authorized s a = classify (obs s) a := (agrees s a).symm
      _ = classify (obs t) a := congrArg (fun o => classify o a) hst
      _ = authorized t a := agrees t a
  · intro compatible
    classical
    let representative : O → S := fun o => Classical.choose (surj o)
    have represented : ∀ o, obs (representative o) = o :=
      fun o => Classical.choose_spec (surj o)
    refine ⟨fun o a => authorized (representative o) a, ?_⟩
    intro s a
    exact compatible (representative (obs s)) s
      (represented (obs s)) a

/-- Two worlds requiring different authorization but showing the same
    observation force an error on at least one world for every
    deterministic observation-only classifier. -/
theorem collision_forces_error
    {S : Type u} {O : Type v} {A : Type w}
    (obs : S → O) (authorized : S → A → Bool)
    (classify : O → A → Bool) (s t : S) (a : A)
    (hst : obs s = obs t)
    (different : authorized s a ≠ authorized t a) :
    classify (obs s) a ≠ authorized s a ∨
      classify (obs t) a ≠ authorized t a := by
  by_cases h : classify (obs s) a = authorized s a
  · right
    intro ht
    apply different
    calc
      authorized s a = classify (obs s) a := h.symm
      _ = classify (obs t) a := congrArg (fun o => classify o a) hst
      _ = authorized t a := ht
  · exact Or.inl h

/-- A classifier that is sufficient after throwing away observation
    detail is also sufficient before that information loss. -/
theorem coarse_compatible_implies_fine
    {S : Type u} {Fine : Type v} {Coarse : Type w}
    {A : Type}
    (fine : S → Fine) (collapse : Fine → Coarse)
    (authorized : S → A → Bool)
    (h : AuthorizationFiberCompatible
      (fun s => collapse (fine s)) authorized) :
    AuthorizationFiberCompatible fine authorized := by
  intro s t hst a
  exact h s t (congrArg collapse hst) a

/-- An exact two-state collision: the initial public view cannot support
    the authorization decision, but exposing the state can. -/
inductive ToyWorld where
  | granted
  | revoked
  deriving DecidableEq, Repr

def toyObservation (_ : ToyWorld) : Unit := ()

def toyAuthorization : ToyWorld → Bool
  | .granted => true
  | .revoked => false

theorem toy_colliding_authorizations :
    toyObservation .granted = toyObservation .revoked ∧
      toyAuthorization .granted ≠ toyAuthorization .revoked := by
  decide

theorem toy_no_public_classifier (classify : Unit → Bool) :
    classify (toyObservation .granted) ≠ toyAuthorization .granted ∨
      classify (toyObservation .revoked) ≠ toyAuthorization .revoked := by
  exact collision_forces_error toyObservation
    (fun s (_ : Unit) => toyAuthorization s)
    (fun o (_ : Unit) => classify o)
    .granted .revoked () (by decide) (by decide)

theorem toy_certified_inspection_suffices :
    ∃ classify : ToyWorld → Bool,
      ∀ s, classify s = toyAuthorization s := by
  exact ⟨toyAuthorization, fun _ => rfl⟩

#print axioms classifier_exists_iff_fiber
#print axioms collision_forces_error
#print axioms coarse_compatible_implies_fine
#print axioms toy_no_public_classifier

end MathCan.AuthorizationQuotient
