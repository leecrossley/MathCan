# PEF-03 | Noncommuting Jacobian products and history interventions

The finite affine PEF-01/02S experiments had scalar contraction
schedules. For a learned recurrent hidden state in dimension d, use

    h_(j+1) = F_j(h_j, u_j).

Let J_j = D_h F_j(h_j,u_j), and B_j = D_u F_j(h_j,u_j).
Provided the maps are differentiable, the exact local causal input
derivative at history time j obeys the chain rule

    D_(u_j) h_L = J_(L-1) J_(L-2) ... J_(j+1) B_j.

Every Jacobian is evaluated at the actual state on the frozen
trajectory. This identity must be checked against independent
full-recurrence autograd or an analytic derivative. A full binary
input flip is a finite nonlinear intervention; the local derivative
need not predict its full magnitude.

A basic exact witness is provided by two planar shears:

    U(x,y)=(x+y,y), D(x,y)=(x,x+y).

Both have eigenvalues (1,1), determinant one, and identical
singular-value multisets, since D=U^T. Their ordered products
have different directional gains for the same input tangent:

    U(D(1,0))=(2,1), ||.||^2=5,
    D(U(1,0))=(1,1), ||.||^2=2.

The commutator is the diagonal map

    (U∘D - D∘U)(x,y)=(x,-y).

This directly shows why the multiset of per-visit local spectral
data cannot determine a history-specific perturbation gain.
The corresponding example is exact over the integers; its
statements are certified by MathCan/OrderedTangent.lean.

The [PEF-03 empirical benchmark](https://github.com/MoralityLabAI/LoopedTransformers/pull/50)
implements a trained 16-dimensional tied attention block and measures
J_j and B_j at the actual visited states, compares the ordered product
against a separately recomputed full-recurrence JVP, and reports both
local tangent and controlled finite input-bit interventions.

Lean scope: the explicit integer shears, general coordinate
commutator, witness squared norms and area preservation are formally
proved. The general nonlinear chain rule above is a standard
calculus identity stated in this note, not an assertion of a
universally formalized Fréchet derivative theorem in this module.
