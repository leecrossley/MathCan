# COE-01: chromatic observer dimension and stable probe extension

**Date:** 2026-11-15. **Status:** new, self-contained finite theorem with exact computational witnesses and partial Lean certificates; no claim of priority over the mathematics literature. The theorem is an elementary graph-coding observation presented here for task-relative compactification. Its verification is separate from claims in the two source manuscripts.

## Motivation and source separation

- [OpenAI Math family 098](https://github.com/openai/math/blob/main/lean/docs/098.md), *A doubling Hilbert subset with no finite-dimensional bi-Lipschitz embedding* (September 25, 2026), constructs an obstruction to globally faithful metric dimension reduction, even for compact doubling Hilbert subsets. Its published Lean comparator has a more specific scope than the whole family.
- [OpenAI Math family 332](https://github.com/openai/math/blob/main/preprints/Metric-Markov-Cotype-Two-of-l1-October-5-2026/README.md), *Metric Markov Cotype Two of ℓ1* (October 5, 2026), claims a universal-loss Lipschitz extension from arbitrary Hilbert subsets into ℓ1. The present work uses the distinction between stable forward observables and inverse metric fidelity; it neither assumes the manuscript has been independently certified nor reproduces its deep proof.

The following theorem is proved directly using finite graph coloring, binary codes, and scalar McShane extension, so its truth is independent of those source manuscripts. The fact that it is *new to this repository* is verified; literature-wide mathematical novelty remains unassessed.

## The chromatic observer and extension theorem

Let `G=(V,E)` be a finite simple graph with `n>=1` vertices and chromatic number `χ(G)`. Identify its vertices with unit vectors `e_v` in `H=R^n`, and let `S={0} ∪ {e_v : v∈V}`. A `k`-bit observer is an assignment `c:V→{0,1}^k`. The evaluator distinguishes exactly the edges `uv∈E`: it requires `c(u) ≠ c(v)` for those pairs.

**Theorem COE-1 (exact task-relative dimension).** The minimum number of binary features is

```
                 k_0(G) = ceil(log_2 χ(G)).
```

For any optimal observer there is an extension `F:H→[0,1]^k`, with `F(e_v)=c(v)` and `F(0)=(1/2,...,1/2)`, such that

```
              ||F(x)-F(y)||_∞ ≤ ||x-y||_2.
```

Hence the same extension, viewed in `ℓ1^k`, has Lipschitz constant at most `k`. This explicit factor `k` is only our elementary coordinatewise bound. Family 332's universal ℓ1 extension result concerns arbitrary ℓ1-valued Lipschitz data, and is logically stronger.

*Proof.* A separating observer assigns distinct binary words across every edge; treating each distinct word as a color gives a proper coloring using at most `2^k` colors, so `χ(G)≤2^k`. Conversely, give vertices an optimal χ-coloring and encode each color with `k_0` bits. For the extension, set `f_j(e_v)=c(v)_j` and `f_j(0)=1/2`. Distances between different spokes equal `√2`, and each spoke is unit distance from zero. Thus each coordinate `f_j` is 1-Lipschitz on `S`. Define

```
 F_j(x) = clip_[0,1] ( min_{s∈S} [ f_j(s) + ||x-s||_2 ] ).
```

The infimum of 1-Lipschitz cones is 1-Lipschitz and agrees with `f_j` on `S`; clipping preserves both properties. Taking the maximum over coordinates proves the result. ∎

**Theorem COE-2 (robust coding bounds).** Let `k_r(G)` be the fewest bits in an observer satisfying `d_H(c(u),c(v))≥r` on every tested edge. Then, for every integer `r≥1`,

```
  ceil(log_2 χ(G)) ≤ k_r(G) ≤ r * ceil(log_2 χ(G)).
```

The upper bound repeats every bit of an optimal `k_0` observer `r` times. An observer with margin `r` survives any `r-1` feature erasures on all tested edges. For `r=2t+1`, the radius-`t` Hamming error balls around the endpoints of each edge are disjoint, so an evaluator that knows the tested pair can recover its identity after at most `t` flips.

For each clique of size `m`, the ordinary sphere-packing inequality supplies the **necessary** condition

```
       m * sum_{j=0}^t binom(k,j) ≤ 2^k
```

at a `2t+1` flip margin. This is a clique-specific obstruction, with no claim that the graph's chromatic number can replace `m` in the sphere-packing expression.

*Proof.* A margin-r observer separates edges, yielding the first inequality. Bit repetition gives the second. Removing fewer than r positions leaves at least one difference. Two radius-t Hamming balls intersect only if their centers have distance at most 2t, by the triangle inequality. On a clique, all m balls are pairwise disjoint, each of cardinality `sum binom(k,j)`. ∎

**Finite sharp cell.** For `G=K6`, one-bit separation has exact width 3. Under one-bit flip tolerance (`r=3`) the exact width is **6**. A five-bit code would need `6*(1+5)=36` positions for disjoint radius-one balls inside `2^5=32` available positions, impossible. The six six-bit words `0,7,25,30,42,45` have pairwise Hamming distance at least three. The Lean module checks their range, pairwise margins and the integer packing obstruction; the general packing lemma is written here.

## Scope and limitations

The graph represents **evaluator-relevant pairs**, rather than all Hilbert distances. Two vertices with the same observer code may be geometrically separated, and the extended observer need not have a Lipschitz inverse. The construction is thus compatible with the obstruction in family 098. Finite-dimensional ℓ1 extension with optimal universal constant, all graphs' robust coding numbers and the genuine compact doubling construction of family 098 remain separate questions.

## Reproduce

The companion reference in `MoralityLabAI/Compactification-Theory/research/chromatic_observer_gym_v1` implements exact graph coloring, minimal robust observer search, the explicit extension and regression tests. Its deterministic suite enumerates all 64 simple graphs on four vertices. The MathCan Lean module uses the repository's `leanprover/lean4:v4.35.0` `Init` toolchain and reports the transitive axioms of each finite lemma. Source results are not imported as axioms.
