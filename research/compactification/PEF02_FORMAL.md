# PEF-02 pure mathematics: robust suffix margins and prior leakage

**Companion applied reference:** [Compactification-Theory PEF02_DERIVATION.md](https://github.com/MoralityLabAI/Compactification-Theory/blob/feat/pef01-selfsimilar-precision-frontier-20261115/research/precision_entropy_frontier/PEF02_DERIVATION.md).

The same OpenAI math pairing as PEF-01, #148 (entropy-rate dimension
for self-similar measures) and #140 (memory and precision in Gaussian
regression), motivates independent finite statements. No manuscript-level
theorem is imported as an axiom or asserted for trained transformers.

For integer k>=1, depth L>=t>=1, with M=2^k, state

    x_L=(M-1)sum_i b_i M^i/M^L,

the exact minimum real gap between states with different t-newest-bit
suffixes is

    g(k,L,t)=(M-2)/M^t + 1/M^L.

The exact analog noise tolerance for arbitrary |e|<=epsilon is
2epsilon < g. At equality two adjacent class intervals touch, proving
sharpness. If every recurrent step suffers arbitrary additive noise
bounded by eta, the end-state deviation is at most
eta sum_(i=0)^(L-1) M^-i. After an additional final B-bit floor
quantizer, the sufficient readout robustness condition is

    2eta sum_i M^-i + 2^-B <= g.

The separation proof uses the earliest differing retained digit: the
leading digit contribution is (M-1)M^-r; all lower retained digits can
offset at most M^-r - M^-t. Different suffix starts are separated
by at least (M-1)M^-t. Every older-tail interval has width
M^-t - M^-L, yielding the formula.

For k=2,L=4,t=2, the gap is exactly 33/256. Lean checks the
universal finite history-pair statement and its witness, and verifies
that any integer numerator perturbation radius r<=16 leaves all
suffix clusters strictly separated (33 > 2*16).

For the special integer-base dynamics and floor rounding,
rounding the state after each recurrent step commutes with applying
the floor quantizer at the end:

    floor((floor(z)+C)/M)=floor((z+C)/M)
    for integral C and M>0.

Lean verifies all four-step quaternary histories for B=3 and B=7.
The general all-k theorem is independently checked across a finite
parameter grid and explained algebraically in the applied note.
Nearest-integer rounding has a genuine counterexample at k=2,
B=3, history [1,0,0], where repeated rounding yields 1 and
endpoint-only rounding yields 0.

A four-bit affine gain changes the unnormalized B=3 readout to B=7
on the same orbit and makes it injective while preserving fractal
dimension. Affine range calibration cancels that gain and restores
the original two-visible-bit partition. This shows why raw absolute
precision claims depend on coordinate gauge and integer headroom.

The three-bit Markov source example with persistence 3/4 has weights
9,3,1,3,3,1,3,9 out of 32. Lean checks total mass, balanced newest-bit
marginals, the two MAP witnesses, and a 24/32 observational alignment
between the penultimate input and the newest bit. The newest-bit code
has exact zero direct dependence on older bits under interventions
fixing the newest bit. The Bayes whole-history success is 18/32=9/16,
even though the encoded history capacity is exactly one bit.

This illustrates the general Markov-source theorem. With transition
persistence s and a suffix code exposing t>=1 bits from length L,
the Bayes whole-history rate is max(s,1-s)^(L-t), and its remaining
conditional entropy is (L-t) h2(s). The proofs use reversible
transition variables and independence of the source flips. At t=0
the rate is (1/2)max(s,1-s)^(L-1).

## Formal scope

MathCan/PrecisionEntropyRobust.lean proves finite k=2,L=4
separation and stagewise properties, general Nat interval-margin
arithmetic, plus the finite three-bit biased-source example. The
general power/exponent separation and Bayes formulas above are
paper-level theorems with independent exact finite Python checks;
they are not claimed as universally formalized Lean theorems.

    lake build MathCan
    lake env lean MathCan/PrecisionEntropyRobust.lean
    python -m unittest discover -s tests -p 'test_precision_entropy_robust.py' -v
