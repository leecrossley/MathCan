# Recurrent observer and source-rule transfer papers

**Current empirical manuscript:** [ROC-02–04 v0.3](ROC02_Observer_Causal_Update_v03_20261117.md), dated 17 November 2026.

The v0.3 revision incorporates the prospectively registered **ROC-04B independent rule-identity holdout** after the ROC-04A exposed-development result. Twelve frozen original models were evaluated with zero training updates on 384 previously reserved new table permutations. Across six matched model seeds, four-rule training attains 21.09% test answer accuracy and 512-rule training attains 73.05%, a +51.95 percentage-point mean paired gain (6/6 seeds positive; one-sided exact sign-flip p=1/64). The ROC-04B primary gate passes. Its separate complete eight-row reconstruction competence gate fails (11.89% mean; zero of six seeds meet 50% table exactness).

The published ROC-04B protocol documents the first halted source-access attempt and its pre-result checkpoint SHA transcription repair. The original ROC-02 family-6/7 procedural holdout remains unopened. The ROC-04 384-table reserved identities **have now been evaluated** on these fixed checkpoints and are no longer an unused test set for this model cohort.

**Earlier versions:** [v0.2 ROC-02–04A](ROC02_Observer_Causal_Update_v02_20261117.md), with exposed-development transfer, and [v0.1 ROC-02/03](ROC02_Observer_Causal_Update_v01_20261117.md), preserving the earlier observer causal null and training diagnostics.

## Independent arithmetic checks

- [ROC-02E six-seed source CSV](ROC02_primary_six_seed_v01.csv) and [sign-flip checker](roc02_primary_signflip_v01.py), descriptive calibration-family causal test p=0.375.
- [ROC-04A six-seed development CSV](ROC04A_primary_six_seed_v01.csv) and [sign-flip checker](roc04a_primary_signflip_v01.py), registered development rule-transfer result p=0.015625.
- [ROC-04B six-seed reserved-test CSV](ROC04B_reserved_test_by_seed_v01.csv) and [source-blob/sign-flip checker](roc04b_reserved_signflip_v01.py), independent test rule-identity gain p=0.015625.

Run from the MathCan repository root:

```bash
python papers/roc02/roc02_primary_signflip_v01.py
python papers/roc02/roc04a_primary_signflip_v01.py
python papers/roc02/roc04b_reserved_signflip_v01.py
```

The checks use Python's standard library. For full test reproduction, see [ROC-04B merged PR #157](https://github.com/MoralityLabAI/LoopedTransformers/pull/157) and [GitHub Actions run #44087829448](https://github.com/MoralityLabAI/LoopedTransformers/actions/runs/44087829448), which verify the 384 generated exact-oracle cases, all twelve original checkpoint hashes and 4,608 prediction/control records.

Successful rule-identity transfer under a supplied table-to-query route establishes neither complete rule-table reconstruction nor a low-rank mechanistic quotient. A next independent model-seed cohort and ROC-01 Amendment C-compliant physical interventions remain scientifically distinct follow-ups.
