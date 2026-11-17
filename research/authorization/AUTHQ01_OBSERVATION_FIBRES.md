# AUTHQ-01: observation-relative authorization

**Status:** candidate Lean proof, awaiting the destination repository's Lean 4.35.0 CI. Mathematical scope: a deterministic authorization predicate and an observation function.

For world `s`, action `a`, observation `o(s)`, and supplied authorization predicate `Auth(s,a)`, an observation-only classifier exists if and only if

`o(s) = o(t) => Auth(s,a) = Auth(t,a)` for all states, pairs and actions,

provided the observation is surjective onto its declared output type. The equivalence is proved constructively except for choosing a representative of each observation fibre. Equal visible observations and opposite duties force *any* deterministic classifier to err on at least one member of the pair. With equal independent assignment to the two worlds, accuracy is at most one half for the binary fixed-action decision; that probabilistic interpretation is a paper-level consequence, not a Lean probability theorem.

The Lean file `MathCan/AuthorizationQuotient.lean` includes a two-state collision witness and a fully informative inspection witness. A coarsening lemma formalizes that discarding information cannot repair an authorization collision.

**Connection to current repositories**

- `MathCan/ObservableQuotient.lean` factors state transitions through observation fibres. AUTHQ-01 factors *authorization* through the same concept.
- `MathCan/NOR21ObservationCompleteness.lean` gives a generic impossibility result for different correct futures with the same public observations.
- `MoralityLabAI/Control-Harness` can construct matched authorization twins and offer an authenticated inspection action.
- `MoralityLabAI/EvalMath` should measure action, refusal and error independently, using FSI-01 clusters and a sealed evaluation set.
- `sadasant/organon` separates Capability, Permission, and PermissionExercise. Here `Auth` is externally supplied and must be mapped to an explicitly selected institutional predicate; this theorem never decides which institution is legitimate.

**Next experimental gate:** build paired authorization worlds sharing the uninspected view, then add a trustworthy inspection that makes the pivotal fact visible. Compare the same frozen controller under hidden versus revealed conditions. Retain always-abstain, always-retain, and signed-rule lookup baselines. Do not promote a result before cluster-level power and sealed readout checks.
