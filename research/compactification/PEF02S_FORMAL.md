# PEF-02S: nonautonomous precision schedules and exact gaps

A new mathematical extension of PEF-01/02 motivated by OpenAI/math
#148 (entropy-rate dimension) and #140 (finite memory).
The finite algebra and exact integer proof obligations below are
independent of the general conjectural claims about learned models.

## Mixed-dyadic contraction

Let chronological positive widths k_0,...,k_(L-1) define

    x_(j+1)=[x_j+(2^(k_j)-1)b_j]/2^(k_j).

Write K_r for the cumulative widths of the r most recent contraction
blocks and K=K_L. The exact binary fraction representing x_L consists
of chronological input bits in reverse order, each repeated k_j times:

    x_L = .[b_(L-1) repeated k_(L-1) times]
           [b_(L-2) repeated k_(L-2) times] ... [b_0 repeated k_0 times].

Reading B most significant fractional digits retains exactly the
t most recent input bits, where t is the first block index whose
cumulative size K_t reaches B, capped at L.

The t-bit suffix classes have uniform size 2^(L-t), and full history
becomes distinguishable at B_min=K-k_0+1 (for L>=1).

## New exact theorem

For t>=1 the minimum separation between distinct real-valued
t-suffix classes is

    g = 2^(-K) + min_(1<=r<=t)
                    [(2^(k_(L-r))-2)2^(-K_r)].

For a first difference at retained block r, the start separation is
at least (2^(k_(L-r))-2)2^(-K_r)+2^(-K_t). The unused older tail ranges
over length 2^(-K_t)-2^(-K). Subtracting that length gives the
formula, attained by corresponding extremal suffix/tail choices.

This theorem specializes to the constant-width expression
g=(2^k-2)2^(-kt)+2^(-kL) from PEF-02.

## Order-sensitive finite witness

Consider the same contraction multiset {2,2,4}, total exponent K=8,
and B=6:

| chronological schedule | visible inputs | minimum cross-suffix gap |
| --- | ---: | ---: |
| (2,2,4) | 2 | 9/256 |
| (2,4,2) | 2 | 57/256 |
| (4,2,2) | 3 | fully injective at B=6 |

The middle schedule has 57/9=19/3 times the inter-suffix
separation of the first while storing the same number of bits.
The third schedule needs only B=5 for complete recovery versus
B=7 for the other two. The average contraction K/L is the same.

MathCan/PrecisionEntropySchedule.lean enumerates all eight input
histories and kernel-checks the exact finite suffix classification,
the 9/256 and 57/256 lower bounds and attaining pairs, the sharp
precision thresholds and both stagewise/endpoint floor identities.
No custom axiom is introduced.

The all-schedule formula is proved above and independently tested by
complete exact integer/Fraction enumeration for widths in {1,2,3},
depth up to five and every precision B from 1 through K+1.

See the applied companion:

https://github.com/MoralityLabAI/Compactification-Theory/blob/feat/pef01-selfsimilar-precision-frontier-20261115/research/precision_entropy_frontier/PEF02_SCHEDULE.md

## Boundary of the interpretation

This theorem concerns exact dyadic scalar history codes. Learned
looped layers can have noncommuting Jacobians, direction-changing
singular modes, nonlinear gates and relative-precision arithmetic.
The experiment suggests measuring the **ordered** Jacobian product
and causal history response for each depth, rather than inferring
finite-depth capacity from average singular contraction alone.
