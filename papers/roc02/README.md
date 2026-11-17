# Recurrent observer and source-rule transfer papers

**Current empirical manuscript:** [ROC-02–04 v0.2](ROC02_Observer_Causal_Update_v02_20261117.md) (17 November 2026).

The v0.2 revision includes all ROC-02B/C/E observer and causal data, ROC-03A/B training-competence diagnostics, and the preregistered ROC-04A six-seed permutation-diversity experiment. ROC-04A's primary development-family accuracy gain passes its registered gate (+47.79 percentage points; 6/6 seeds; exact one-sided sign-flip p=1/64), while its separate full-eight-row table competence gate fails (mean exact complete table recovery 11.13%). The original ROC-02 source-family-6/7 test and ROC-04's 384-table independent reserved evaluation remain unopened.

**Previous manuscript:** [ROC-02 v0.1](ROC02_Observer_Causal_Update_v01_20261117.md), preserved as the earlier version with its original ROC-02 and ROC-03 postscript claims.

## Independent checks

- [ROC-02E primary six-seed CSV](ROC02_primary_six_seed_v01.csv) and [exact sign-flip checker](roc02_primary_signflip_v01.py) preserve the registered causal null: p=0.375.
- [ROC-04A six-seed CSV](ROC04A_primary_six_seed_v01.csv) and [exact sign-flip/gate checker](roc04a_primary_signflip_v01.py) reproduce original LoopedTransformers [merged PR #155](https://github.com/MoralityLabAI/LoopedTransformers/pull/155) from byte-identical CSV data.

Run from the repository root:

```bash
python papers/roc02/roc02_primary_signflip_v01.py
python papers/roc02/roc04a_primary_signflip_v01.py
```

The scripts use only the Python standard library. The ROC-04A raw twelve-checkpoint training and case-level test artifacts are in the [hosted full-replay run](https://github.com/MoralityLabAI/LoopedTransformers/actions/runs/44085250022), with SHA-256-indexed source and checkpoint files.

The ROC-04A positive result is a **development-set** transfer finding. A new, frozen ROC-04B confirmatory protocol is required before evaluating the 384 reserved rule identities. Claims about low-rank causal quotient identification require separate physically matched interventions and the ROC-01 Amendment C statistics.
