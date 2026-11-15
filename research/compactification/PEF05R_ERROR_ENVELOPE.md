# PEF-05R: Discrete error accumulation in recurrent optimizer states

**Source comparison:** LoopedTransformers PEF-05R PR #60 compares
original hosted runs 43687506414 and 43688425647. The same
intervention source blob, originally initialized weights, source
allocation and supervised minibatch stream generated divergent
training checkpoints by step 125. Both registered results remain
negative. Checkpoint SHA256 is therefore the score identity.

This note provides an exact deterministic mathematical bound on
what one can infer from such discrepancies.

Let z_n denote the *full optimizer state*, containing model parameters,
AdamW moments and any data-generator state needed to make the
subsequent update deterministic. Let F_n be the intended update map,
and let G_n be another implementation of the same nominal algorithm.
For a nonnegative state metric d, suppose

  d(F_n(x),F_n(y)) <= L_n d(x,y)
  d(F_n(y),G_n(y)) <= eps_n.

Then the triangle inequality gives

  delta_(n+1) <= L_n delta_n + eps_n.

For constant uniform bounds L_n<=L and eps_n<=eps with L>=0,
the scalar comparison recurrence

  E_0 = delta_0,
  E_(n+1) = L E_n + eps

majorizes delta_n by induction. In closed form:

  E_n = L^n delta_0 + eps sum_(j=0)^(n-1) L^j.

When L>1, a very small per-update discrepancy can produce a much
larger final distance. The upper envelope alone does not imply
that any specific neural optimizer has positive Lyapunov exponent,
that divergence was caused by CPU ISA, or that a particular
trained representation is unstable to perturbations.

For example, with a zero initial difference and one-unit local
error over five steps, the factor-two envelope is 31 units;
a nonexpansive (L=1) bound is five units. These exact finite
instances are kernel-verified.

The file MathCan/GradientStability.lean uses Nat-valued state-error
bounds in scaled fixed integer units. It proves the generic
one-step scalar envelope, monotonicity in the starting error,
the zero-error exact repeatability implication, and the numerical
witnesses. The real-valued metric version above is derived in
the note; the proof does not import a full general metric-space
Lipschitz theorem into Lean.

The PEF-05R program checks source checkpoints and optimizer moments,
reports their relative numerical distances, and tests same-runner
bitwise prefix repeatability. A large observed ratio of final to
initial parameter difference is a **descriptive amplification ratio**;
it is neither an estimated universal Lipschitz constant nor a
proved chaotic instability exponent.
