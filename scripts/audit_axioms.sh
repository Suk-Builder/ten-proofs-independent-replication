#!/bin/bash
# Kernel-level axiom audit of every headline declaration vs upstream claims.
# Usage: audit_axioms.sh /path/to/ten-proofs   (requires targets built)
set -u
TP="${1:?usage: audit_axioms.sh /path/to/ten-proofs}"
cd "$TP"; export PATH="$HOME/.elan/bin:$PATH"
declare -A D=(
 [PackingBounds.sharpFullCohnElkiesManuscriptConclusions]=SpherePacking
 [MetricCodes.Johnson.binaryRate_lt_mrrw]=MetricCodes
 [MetricCodes.Spherical.HigherHierarchy.strict_hierarchy]=MetricCodes
 [PermanentFormulaLowerBound.permanent_rational_formula_logarithmic_lower_bound]=Permanent
 [SoficGroups.SourceTopLevelCompressionFinal.exists_finitelyPresented_nonsofic_group]=NonSoficGroup
 [ConnesRigidity.exists_infinite_pairwise_nonisomorphic_propertyT_icc_groups_with_isomorphic_factors]=ConnesRigidity
 [Ehrhart.Volume.ehrhart_volume_inequality_for_sets]=EhrhartVolumeInequality
 [QuantumParallelRepetition.distributionUniformExponential]=QuantumParallelRepetition
 [GapCVP.Comparator.gapCVP400IsNPHard]=GapCVP
 [ErdosProblems.MulticolourTriangleRamsey.erdos_problem_183_explicit]=MulticolorTriangleRamsey
 [CompactnessConjecture.quantitativeCompactnessCounterexample]=CompactnessAndDegeneracy
 [TwoDegenerateGraphs.twoDegenerateExtremalCounterexample]=CompactnessAndDegeneracy
)
rc=0
for decl in "${!D[@]}"; do
  lib="${D[$decl]}"; tmp=$(mktemp /tmp/audit_XXXX.lean)
  printf 'import %s\n#print axioms %s\n' "$lib" "$decl" > "$tmp"
  out=$(timeout 600 lake env lean "$tmp" 2>&1); rm -f "$tmp"
  if echo "$out" | tr -d ' \n' | grep -qF '[propext,Classical.choice,Quot.sound]'; then
    echo "OK   $decl"
  else
    echo "FAIL $decl"; echo "$out" | head -5; rc=1
  fi
done
exit $rc
