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
