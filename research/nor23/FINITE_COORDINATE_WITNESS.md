# NOR-23: authentic exact-coordinate witnesses and finite audit information

Companion to the registered experiment [Compactification-Theory/NOR-23](https://github.com/MoralityLabAI/Compactification-Theory/blob/research/nor23-randomized-coordinate-audit-20261116/research/nor23_coordinate_audit/REGISTRATION.md), following the merged NOR-21 observation-completeness proof and NOR-22 modular-fingerprint boundary.

The formal module [MathCan/NOR23CoordinateAudit.lean](../../MathCan/NOR23CoordinateAudit.lean) defines an exact witness \`agreesOn S f g\` for candidate target f, true target g and a finite inspected coordinate set S. Its theorems establish:

- Any mismatch at an inspected coordinate is conclusive evidence of an incorrect candidate output.
- Checking every coordinate of a finite target is equivalent to target-function equality.
- Given any uninspected coordinate, construct an explicitly different target that agrees with the original at every inspected position. In particular, any audit budget smaller than the finite universe permits an adaptive one-position evasion.
- Identical complete public input and identical authenticated sampled target coefficients cannot distinguish these two hidden worlds to a deterministic possibly-abstaining selector.
- The **exact number** of k-coordinate samples drawn from an n-coordinate universe is \(\binom{n}{k}\). With a fixed r-coordinate attack, the number of samples that miss every changed coordinate is \(\binom{n-r}{k}\). This gives the exact finite fraction \(\binom{n-r}{k}/\binom{n}{k}\) for uniform k-subset sampling independent of a fixed prior attack.

The combinatorial equation itself is kernel-proven using Mathlib \`Finset.card_powersetCard\` and \`Finset.card_sdiff_of_subset\`, with arbitrary finite coordinate types. Its interpretation as a probability presumes a uniform sampler and an attack chosen independently before sampling. **The Lean model does not prove that an external witness is authentic, that a PRNG is unpredictable, or that real theorem-proving goals belong to the RRC25 program family.** Those assumptions are stated explicitly in the applied preregistration.

The experimental grid samples 12 genuinely distinct synthetic sources, observation degrees 512/1024 and output lengths 769/1537. For each source and audit budget k in {0,1,4,16,64}, it uses 4096 deterministic random k-subsets and two nonzero alteration magnitudes on radii r in {1,4,16}. A blind attack fixes its r altered coordinates before challenge sampling. A stronger informed attacker sees the sample first and can place altered coordinates in the complement. The 12 source identities, not the many paired challenge/world decisions, are the relevant independent-source unit.

The source protocol and success conditions were committed before the first data generation. Any observed outcomes should be appended only after the original fixture and full-grade bytes have been preserved with SHA-256 and passed a separate independent replay audit.
