# Raw verification records

Recorded 2026-10-11, machine: Ryzen 5 5600 / 32 GB / kernel 7.0.0-38,
Lean v4.32.0 (8c9756b), Mathlib 81a5d25, ten-proofs HEAD `94bc0feb`.

## Kernel axiom audits (completed)

All outputs below are verbatim `#print axioms` results.

```
$ decl = ErdosProblems.MulticolourTriangleRamsey.erdos_problem_183_explicit  (MulticolorTriangleRamsey.lean)
'ErdosProblems.MulticolourTriangleRamsey.erdos_problem_183_explicit' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]

$ decl = SoficGroups.SourceTopLevelCompressionFinal.exists_finitelyPresented_nonsofic_group  (NonSoficGroup.lean)
'SoficGroups.SourceTopLevelCompressionFinal.exists_finitelyPresented_nonsofic_group' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]

$ decl = CompactnessConjecture.quantitativeCompactnessCounterexample  (CompactnessAndDegeneracy.lean)
'CompactnessConjecture.quantitativeCompactnessCounterexample' depends on axioms: [propext, Classical.choice, Quot.sound]

$ decl = TwoDegenerateGraphs.twoDegenerateExtremalCounterexample  (CompactnessAndDegeneracy.lean)
'TwoDegenerateGraphs.twoDegenerateExtremalCounterexample' depends on axioms: [propext, Classical.choice, Quot.sound]

$ decl = PermanentFormulaLowerBound.permanent_rational_formula_logarithmic_lower_bound  (Permanent.lean)
'PermanentFormulaLowerBound.permanent_rational_formula_logarithmic_lower_bound' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```

**Verdict: 5/5 match upstream's claimed triple `[propext, Classical.choice, Quot.sound]` exactly.**

## Static source scan (all 10 files)

```
CLEAN MulticolorTriangleRamsey
CLEAN CompactnessAndDegeneracy
CLEAN Permanent
CLEAN NonSoficGroup
CLEAN ConnesRigidity
CLEAN SpherePacking
CLEAN EhrhartVolumeInequality
CLEAN QuantumParallelRepetition
CLEAN MetricCodes
CLEAN GapCVP
```

Pattern scanned: `\b(sorry|admit)\b | native_decide | ^\s*axiom  | unsafe ` — zero hits in 548,215 lines.

## Build log (serial queue excerpts + earlier runs)

```
===== START CompactnessAndDegeneracy 14:30:01 =====
===== END   CompactnessAndDegeneracy rc=0 14:30:05      (up-to-date re-verify)
===== START Permanent                14:30:05 =====
WALL 115.02s MAXRSS 7685672KB
===== END   Permanent                rc=0 14:32:00 =====
===== START ConnesRigidity           14:32:00 =====

(earlier, separate runs)
✔ [8655/8656] Built MulticolorTriangleRamsey (135s) — Build completed successfully (8656 jobs)
✔ [8655/8656] Built NonSoficGroup (87s)             — Build completed successfully (8656 jobs)
```

## Pending

Remaining builds & audits will be appended as they complete; this file is
append-only per verification session.

## Session 2 update (2026-10-11 14:45)

```
$ decl = ConnesRigidity.exists_infinite_pairwise_nonisomorphic_propertyT_icc_groups_with_isomorphic_factors  (ConnesRigidity.lean)
'ConnesRigidity.exists_infinite_pairwise_nonisomorphic_propertyT_icc_groups_with_isomorphic_factors' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]

build: ===== END ConnesRigidity rc=0 14:39:59 =====  WALL 478.37s MAXRSS 7304376KB
```

**Running total: 6/11 builds, 6/6 axiom audits exact-match.**

## Session 3 — final (2026-10-11 15:15–15:30)

### Full serial build queue (watched by an independent monitor agent, 2-min polling)

```
CompactnessAndDegeneracy  rc=0    3.84s    0.89 GB   (up-to-date re-verify)
Permanent                 rc=0  115.02s    7.33 GB
ConnesRigidity            rc=0  478.37s    6.97 GB
EhrhartVolumeInequality   rc=0  203.96s    7.22 GB
SpherePacking             rc=0  201.50s    8.03 GB
QuantumParallelRepetition rc=0  705.22s   12.85 GB
MetricCodes               rc=0  685.19s   14.36 GB
GapCVP                    rc=0  304.84s   14.68 GB
ALL DONE 2026-10-11 15:14:59 CST — queue wall clock 44m58s, zero failures, zero OOM, zero stalls
```

Monitor found no `oom|killed` in dmesg; min available RAM 12 GB; all compile
processes 277%–527% CPU. Only upstream hint: one info-level
`Try this: [apply] abel_nf` suggestion (MetricCodes.lean:91886) — cosmetic.

### Full kernel axiom audit (12/12 declarations, script `scripts/audit_axioms.sh`)

```
OK   GapCVP.Comparator.gapCVP400IsNPHard
OK   ConnesRigidity.exists_infinite_pairwise_nonisomorphic_propertyT_icc_groups_with_isomorphic_factors
OK   MetricCodes.Spherical.HigherHierarchy.strict_hierarchy
OK   SoficGroups.SourceTopLevelCompressionFinal.exists_finitelyPresented_nonsofic_group
OK   CompactnessConjecture.quantitativeCompactnessCounterexample
OK   Ehrhart.Volume.ehrhart_volume_inequality_for_sets
OK   TwoDegenerateGraphs.twoDegenerateExtremalCounterexample
OK   ErdosProblems.MulticolourTriangleRamsey.erdos_problem_183_explicit
OK   PackingBounds.sharpFullCohnElkiesManuscriptConclusions
OK   PermanentFormulaLowerBound.permanent_rational_formula_logarithmic_lower_bound
OK   MetricCodes.Johnson.binaryRate_lt_mrrw
OK   QuantumParallelRepetition.distributionUniformExponential
audit exit code: 0
```

Every declaration depends **only** on `[propext, Classical.choice, Quot.sound]` —
matching upstream `formalization.yaml` claims exactly. No `sorryAx`, no
`Lean.ofReduceBool`, no custom axioms.

### Rebuild-from-scratch spot check

Deleted `Permanent.olean` and `EhrhartVolumeInequality.olean`, rebuilt:

```
Permanent   WALL 107.08s  rc=0
Ehrhart     WALL  97.98s  rc=0
```
Both deterministic reproductions succeeded.

## Final verdict of this verification session

**11/11 targets compile; 12/12 headline declarations kernel-audit clean;
10/10 sources static-clean; 2/2 rebuilds reproduce.** Upstream's claims
(`sorry_count: 0`, standard axiom triple) are **independently confirmed** for
the ten-proofs artifact set at HEAD `94bc0feb`.

Independent re-review by separate agents: see `results/independent_review.md`.

## Session 4 — independent review B, rebuild-type (2026-10-11)

Reviewer B (separate agent, no access to other reviewers' reports) performed a
delete-and-rebuild spot check on a **different pair** of certificates than the
main session used (SpherePacking + MulticolorTriangleRamsey):

```
SpherePacking              (55,616 lines): rc=0, wall 148.5 s, peak 9.54 GB
MulticolorTriangleRamsey   ( 3,053 lines): rc=0, wall  11.9 s, peak 6.50 GB
```

- **sha256 of rebuilt oleans: bit-identical** to pre-deletion baseline
  (`9bd55892…`, `1bd5feb2…`); full `sha256sum -c` over all 10 oleans: 10/10.
  The other 8 oleans untouched. Lean compilation determinism holds on this machine.
- Quantity check vs README claims: SpherePacking 201 s vs 148.5 s = 1.35× (same
  order). MulticolorTriangleRamsey 135 s vs 11.9 s = 11.3× — **flagged**; root
  cause: the 135 s figure was the *first* build including the `Comparator`
  dependency (8656 jobs), not the single-module time. README row 1 annotated
  accordingly (warm time 12 s).

**Reviewer B verdict: reproducible, PASS.**
