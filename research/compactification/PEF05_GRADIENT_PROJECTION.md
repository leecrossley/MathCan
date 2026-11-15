# PEF-05 | Exact limitations of Euclidean gradient projection

**Applied evidence:** [PEF-05 PR #58](https://github.com/MoralityLabAI/LoopedTransformers/pull/58).
The registered experiment targets the old-history collapse interval
125–150 inferred from the prior PEF-04 optimizer replay, using a
fresh pair-closed split, an original training-only signed-memory
score, the unmodified supervised task optimizer, and a norm-matched
random surgery control.

The gradient projection is designed to keep the first-order
**Euclidean** directional derivative of the signed score from
becoming negative under a gradient-descent update. Two distinct
mathematical obstructions limit what such an intervention proves.

## 1. Preconditioning changes which direction is protected

Let m be the gradient of memory separation M(theta) and g the
task-loss gradient. Under ordinary gradient descent

    Delta_theta = -eta * g

the score changes, to first order, by -eta * <m,g>.
Removing the positive component of g along m imposes
<m,g_projected> <= 0 and therefore gives a first-order
nondecreasing memory score for the *Euclidean SGD velocity*.

An optimizer with a fixed positive diagonal preconditioner P
instead takes

    Delta_theta = -eta * P g,

and the first-order change is -eta * <P^T m,g>.
The score guard must therefore use **P^T m** in gradient space,
or enforce <m,P g_projected> <= 0.

An exact integer counterexample is

    m=(1,1), g=(1,-1), P=diag(2,1).

The Euclidean dot <m,g>=0; the preconditioned dot <m,Pg>=1,
so the adaptive step decreases the memory score despite the
Euclidean first-order guard.

A sufficient algebraic correction in this two-dimensional
example is to replace g=(x,y) by (x-c,y) whenever

    2c >= 2x+y.

It follows that m.P.(x-c,y)<=0. The Lean theorem checks this
for arbitrary integer x,y,c, along with the counterexample.

For general fixed P the minimal-norm Euclidean gradient
correction removes the positive projection onto P^T m:

    g' = g - ((<P^T m,g>)_+ / ||P^T m||^2) * (P^T m).

This calculation is for a frozen linear positive preconditioner.
AdamW uses moving moments and elementwise denominators, so the
full finite update is a nonlinear state-dependent map; its
differential must be evaluated separately.

## 2. Average signed separation need not ensure pairwise memory

The PEF-05 anchor protects a mean signed old-bit separation over
training pairs,

    M(theta) = mean_s <h(1,s)-h(0,s), u>.

Even a strictly positive average can conceal pairs with reversed
signs. The exact witness (+4,-3) has positive aggregate +1 and
one negative pair. Correspondingly a stable or increasing training
margin cannot guarantee perfect paired counterfactual decoding on
unseen suffixes.

A different direction can also preserve the same gradient norm
while changing the sign or magnitude of score influence. The
norm-matched sham controls gradient-magnitude changes; it does not
match task directions or fully isolate nonlinear optimizer dynamics.

The Lean file MathCan/MemoryProjection.lean verifies integer
counterexamples, general linear inequalities for the diagonal
preconditioner and the generic finite-list result that
nonnegative *individual* margins imply a nonnegative aggregate.
These theorems establish mathematical boundaries rather than
empirical neural-model results.

## Measured PEF-05 result

The four-seed PEF-05 hosted study returned the registered negative
decision: 0/3 vulnerable seeds met the rescue threshold, and the
retention-control seed met its noninferiority gate. In the
seed-157 source-only memory anchor, protection increased the
step-150 score to 1.841 compared with 0.541 for sham, while both
arms scored the same 40/48 on fresh h10(01) oldest-bit decoding.
This is consistent with the limitations above. The experiment
does not distinguish adaptive-preconditioner failure from
generalization limitations, and no counterexample implies that
the signed-score direction is useless in every future task.
