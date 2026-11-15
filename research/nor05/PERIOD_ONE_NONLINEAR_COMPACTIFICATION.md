# NOR-05: excluding a hidden periodic orbit in a certified recurrent basin

**Date:** November 15, 2026. **Status:** theorem and proof established. Source-locked trained-GRU parameters remain conditional on a successful independent NOR-05 Actions receipt. The result continues NOR-04's true nonlinear invariant-ball certificate and resolves whether its \(F^{12}\) fixed point is genuinely stationary under the original one-step GRU.

## The period-one criterion

Let \(U\subseteq \mathbb R^n\) be convex, let \(F:U\to U\) be \(C^1\), and let \(G=F^L\). Suppose \(B=\overline B(c,R)\subset U\), \(R>0\), is invariant under \(G\), and \(G\) is a contraction there with factor \(K<1\). Denote by \(p\) the unique fixed point of \(G\) inside \(B\). Suppose
\[
\|G(c)-c\|_2\le s,\qquad
\sup_{x\in B}\|DF(x)\|_2\le L_1,\qquad
\|F(c)-c\|_2\le s_1.
\]

**Theorem A (period-one exclusion).** If
\[
\boxed{\ s_1+L_1\frac{s}{1-K}<R,\ }\tag{1}
\]
then \(F(p)=p\). Consequently \(p\) is the unique fixed point of the original one-step map \(F\) inside \(B\), even if \(F\) itself is noncontracting in the ordinary Euclidean operator norm.

*Proof.* NOR-04 gives \(\|p-c\|\le s/(1-K)\). The line segment from \(c\) to \(p\) lies in the convex ball, so the mean value inequality yields
\[
\|F(p)-c\|\le\|F(p)-F(c)\|+\|F(c)-c\|
\le L_1\|p-c\|+s_1<R.
\]
Thus \(F(p)\in B\). Iterates of a single time-independent map commute, so
\[
G(F(p))=F(G(p))=F(p).
\]
This makes \(F(p)\) another fixed point of \(G\) inside \(B\). By uniqueness, \(F(p)=p\). Any fixed point of \(F\) inside \(B\) is also a fixed point of \(G\), so it equals \(p\). \(\square\)

The strict inequality in (1) is a convenient sufficient gate. Using \(\le R\) also suffices for a closed ball. No global one-step contraction is assumed.

## All single-step times now converge

Assume the same recurrent domain \(U\) is a convex invariant cube and \(\|DF(h)\|\le L_{\mathrm{cube}}<\infty\) uniformly on it. Every point of \(B\) remains in the cube along the full nonlinear recurrence. Write the full time index as \(t=Lm+j\) with \(0\le j<L\).

**Theorem B (unstrided nonlinear convergence).** Under Theorem A's hypotheses, for every \(x\in B\),
\[
\boxed{\|F^t(x)-p\|_2
\le L_{\mathrm{cube}}^j K^m\|x-p\|_2.}\tag{2}
\]
*Proof.* Use \(F(p)=p\) and the semigroup law to write
\(F^{Lm+j}(x)-p = F^j(G^m(x))-F^j(p)\).
Each intermediate segment stays in the convex invariant cube; iterating its global Lipschitz bound \(j\) times gives \(\le L_{\mathrm{cube}}^j\|G^m(x)-p\|\). NOR-04's block contraction yields (2). \(\square\)

This is a conclusion about the **actual nonlinear one-step recurrent model** for all integer depths, not about powers of one linearized Jacobian.

### Entire-time \(L_p\) compactification

For \(1<p_0<\infty\), \(p_0\ne2\), \(D>1\), and a finite cutoff \(T\ge1\), set \(M=\max(1,L_{\mathrm{cube}}^{L-1})\). For every \(t\ge T\),
\[
\|F^t x-p\|_2\le 2 R M K^{\lfloor T/L\rfloor}.
\]
Apply the Gaussian Hilbert-to-real-\(L_{p_0}\) isometry, followed by OpenAI Math #094's existential finite-set dimension reduction, to \(\{p,x,Fx,\ldots,F^{T-1}x\}\). Clip all later images to the image of \(p\). The NOR-01 exact stitching argument gives an infinite-horizon metric approximation of *every single-step time*:
\[
\boxed{\sup_{i,j\ge0}
\left|\|\hat x_i-\hat x_j\|_{p_0}
-\|F^i x-F^j x\|_2\right|
\le E_T+4 R M K^{\lfloor T/L\rfloor},}\tag{3}
\]
where \(E_T\) is the finite observed-window additive distortion including the anchor \(p\). Its existential coordinate dimension is bounded by
\(d\le\exp(C_{p_0,D}(\log(T+1))^{\gamma(p_0)})\)
with the exact \(\gamma\) from OpenAI Math #094.

Equation (3) is a local theorem on \(x\in B\). The point \(p\) and the optimal finite-set \(L_p\) map remain existential. The separate OpenAI Math #325 complete Crouzeix inequality continues to give matrix-polynomial estimates on suitably enclosed frozen derivatives, and the NOR-02 curvature filter applies when the numerical-range geometry matches its hypotheses. The nonlinear all-depth conclusion follows from the independently established ball contraction.

## Applied certificate design

The application uses the unchanged 1,000-parameter RRC-25 trained GRU, the rational center \(c\) and \(R=10^{-11}\) from NOR-04, with \(G=F^{12}\). The previously verified block values are
\[
K=928242792263/10^{12},
\quad s=237277631/(2\cdot10^{23}).
\]
A source-locked rational interval trace computes \(s_1\ge\|F(c)-c\|\); a direct one-step Jacobian enclosure over the **whole ball** computes \(L_1\ge\sup_{x\in B}\|DF(x)\|\). Exact rational arithmetic checks (1). A second one-step Jacobian enclosure over the entire invariant cube provides the conservative \(L_{\mathrm{cube}}\) in (2)–(3). The independent executable is [period_one.py](https://github.com/MoralityLabAI/Compactification-Theory/blob/research/nor01-numerical-orbit-sketch-20261115/research/nor01_numerical_orbit_sketch/period_one.py).

A successful receipt will establish that NOR-04's fixed point is a fixed point of the original nonlinear GRU update, resolving its period-one status. No arbitrary natural-language or algebraic input state's membership in the very small certified ball is presumed. Performance gains on the original RRC-25 proof-ranking task remain untested.
