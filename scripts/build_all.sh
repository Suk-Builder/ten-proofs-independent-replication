#!/bin/bash
# Sequential build of all ten-proofs targets. Usage: build_all.sh /path/to/ten-proofs
set -u
TP="${1:?usage: build_all.sh /path/to/ten-proofs}"
cd "$TP"
export PATH="$HOME/.elan/bin:$PATH"
for t in MulticolorTriangleRamsey NonSoficGroup CompactnessAndDegeneracy Permanent \
         ConnesRigidity EhrhartVolumeInequality SpherePacking QuantumParallelRepetition \
         MetricCodes GapCVP; do
  echo "===== START $t $(date -Is) ====="
  /usr/bin/time -f "WALL %es MAXRSS %MKB" lake build "$t"
  echo "===== END $t rc=$? $(date -Is) ====="
done
