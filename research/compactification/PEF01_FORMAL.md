# PEF-01: A precision–entropy frontier for finite affine recurrences

**Sources.** This independent finite theorem campaign combines the questions
suggested by OpenAI math #148, *The entropy-rate dimension formula for
self-similar measures on the line* (September 24, 2026), and #140,
*Memory and precision in noiseless Gaussian regression* (September 27, 2026).
The links are retained in the companion applied research note.

## Finite model

Fix k>=1 and M=2^k. For each input b in {0,1}, iterate the contraction

    phi_b(x) = (x + (M-1)b) / M,   x_0=0.

After a uniform length-L binary input history b_0,...,b_(L-1),

    x_L = (M-1) * sum_{i=0}^{L-1} b_i M^i / M^L.

The most recent input b_(L-1) is the leading base-M digit. Observe only

    C_B = floor(2^B * x_L)

where B>=0 is an aligned, absolute fixed-point precision budget.
This model has exact arithmetic and no additive noise or floating-point
relative exponent. Any prediction for real transformers requires a
separately calibrated quantizer and an actual intervention experiment.

## Main theorem: exact finite source-to-code frontier

For every k>=1, L>=0, B>=0, define

    t = min(L, ceil(B/k)).

The 2^L input histories fall into exactly 2^t nonempty C_B fibres,
all of cardinality 2^(L-t). The quantizer distinguishes the t most recent
input bits exactly, and none of the earlier L-t bits.

Proof: in base M, the L orbit digits are either all zero or all one in
binary k-bit blocks. Observing B most significant binary fractional
digits reads floor(B/k) complete base-M digits and, if B mod k > 0,
a nonempty leading part of the next digit. Because the two choices
have binary blocks 00...0 or 11...1, that partial block already
distinguishes the corresponding input bit. Older blocks occur strictly
after the B-bit cut, leaving the prefix unchanged. Every t-bit recent
suffix occurs in 2^(L-t) full histories.

Uniform source history gives exact conditional Shannon entropy

    H(history | C_B) = L - t bits

and optimal full-history Bayes decoding accuracy

    P_correct = 2^(t-L) = |image(C_B)| / 2^L.

For L>=1, full history distinguishability requires B >= k(L-1)+1.
This is an exact finite toy result. Its proof does not invoke the
analytic statements of either OpenAI preprint.

## Relation to the two source themes

The Bernoulli IFS has disjoint branch interiors and dimension 1/k,
consistent with h_RW/chi=(log 2)/(k log 2) in #148. The finite
identity makes explicit that a source with lower dimension can require
more absolute precision bits per recoverable historical input bit.
The finite decoder budget is a different setting from the noiseless
Gaussian regression sample/memory lower bound in #140. The shared
question is how accuracy degrades under a persistent information budget;
we make no claim of transferring #140's Gaussian lower bound.

## Lean scope

MathCan/PrecisionEntropy.lean kernel-checks:
- depth-four exact normal forms and suffix equivalence at B=3, B=6;
- 4-to-1, 2-to-1, and injective readout fibres at B=3,6,7;
- binary depth-four two-bit observation fibres;
- arithmetic threshold B >= 2L-1 for all positive Nat depths, and its
  strict lower-bound consequence;
- finite bounds on recoverable depth and one-step precision growth.

The general all-k finite counting theorem is proved in this note and
independently checked over a bounded parameter grid using exact
integer arithmetic and rational recurrence in the applied repository.
No sorry and no custom theorem-level axioms are introduced.

## Reproduce

    lake build MathCan
    lake env lean MathCan/PrecisionEntropy.lean
    python -m unittest discover -s tests -p test_precision_entropy.py -v

The companion CPU-only oracle/experiment is under
MoralityLabAI/Compactification-Theory/research/precision_entropy_frontier/.
