# PEF-04: exact pair-closed counterfactual design

**Experimental source:** [LoopedTransformers PEF-04](https://github.com/MoralityLabAI/LoopedTransformers/pull/55),
a prospective six-seed test of earliest-history retention after two
natural recurrent iterations.

For every recent seven-bit suffix s, the pair of length-eight
histories (false,s) and (true,s) is assigned together to exactly
one dataset split. In a balanced evaluation cohort of N such pairs,
any prediction of the oldest bit based only on the seven-bit suffix
is the same on both members. It therefore obtains **exactly N
correct answers out of 2N** and **zero pairs where both answers are
correct**. This is a deterministic finite counting identity.

The source-only baseline is thus 24/48 in PEF-04's 24 heldout pairs,
with zero jointly correct pairs. This result requires pair
closure, equal weighting of both histories and a predictor that
depends only on their identical recent suffix. It does not claim
that a recurrent hidden state in fact satisfies such a factorization.

If a fixed decoder trained on an independent split correctly
predicts **both** oldest-bit labels for one matched pair, the two
observed hidden states must differ. This certifies a causal
contrast in the hidden representation for that pair because
all seven newer inputs and both continuation bits are held fixed.
It cannot by itself identify a unique neuron or circuit.

Lean scope: MathCan/PairedHistory.lean proves the generic finite-list
identity, impossibility of joint oldest-bit recovery under
suffix-only prediction, and state separation implied by paired
correct decoding. The source experiment has its own independently
pinned train, probe, and heldout split.

The result is a design and identifiability theorem; learned-model
accuracy must be measured by the separate prospective neural
experiment and is not implied by the Lean proofs.
