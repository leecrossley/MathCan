# PEF-03G | Exact nonlinear causal-interaction decomposition

The posthoc frozen-model
[PEF-03G](https://github.com/MoralityLabAI/LoopedTransformers/blob/research/pef03-frozen-attention-history-20261115/research/pef03/PEF03G_POSTHOC.md)
compares the naturally generated oldest-bit counterfactual with
head-rowspace-only and head-nullspace-only hybrid transplants.

For any four outputs Y0 (original), YD (natural donor),
YR (row-only transplant), and YN (null-only transplant),

    D_natural = YD - Y0
    D_row = YR - Y0
    D_null = YN - Y0
    I = YD - YR - YN + Y0,

the **exact identity** is

    D_natural = D_row + D_null + I.

No linearity or smoothness assumption appears in this algebra. In
particular, separate hybrid-state effects need not sum to the
on-manifold natural counterfactual. Their deviation is measured by I.

For an additive readout F(x,y)=3x+5y+1, changing the x and y
components independently gives I=0. For a coupled readout F(x,y)=xy,
using the four states (0,0),(1,0),(0,1),(1,1) gives Y0=0,
YR=0, YN=0, YD=1, and I=1. All of the output change is interaction.

This is directly relevant to the observed seed-17 PEF-03 result:
the natural oldest-bit flip changes the predicted task class only
2/52 times; an early-visit rowspace transplant changes it 19/52
times and a nullspace transplant changes it 14/52 times. The
mean final-logit L2 magnitude of I is 6.285. These metrics have
different nonlinear directions and should not be treated as
additive attribution scores.

A final *linear* head W obeys W(h+v)=W(h) whenever W(v)=0.
An intermediate recurrent update A can rotate head-invisible
directions into head-visible ones whenever WA(v) is nonzero.
The already formalized shear witness in OrderedTangent.lean
gives an exact two-dimensional example.

MathCan/CausalInteraction.lean proves the universal integer
four-corner identity, additive example, nonlinear multiplicative
witness, terminal head invariance, and one-step reactivation
example. The general high-dimensional neural experiment remains
posthoc and uses frozen model weights, with explicit off-manifold
hybrid-state cautions.

Independent Python tests enumerate finite integer grids.
