#!/bin/bash
# Scan all certificate sources for red flags. Usage: static_scan.sh /path/to/ten-proofs
cd "${1:?usage: static_scan.sh /path/to/ten-proofs}"
rc=0
for f in MulticolorTriangleRamsey CompactnessAndDegeneracy Permanent NonSoficGroup \
         ConnesRigidity SpherePacking EhrhartVolumeInequality QuantumParallelRepetition \
         MetricCodes GapCVP; do
  hits=$(grep -nE '\b(sorry|admit)\b|native_decide|^\s*axiom |unsafe ' "$f.lean")
  if [ -n "$hits" ]; then echo "FAIL $f:"; echo "$hits"; rc=1; else echo "CLEAN $f"; fi
done
exit $rc
