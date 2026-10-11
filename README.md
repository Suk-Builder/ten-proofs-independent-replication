# Independent Verification of OpenAI's `ten-proofs` Lean Certificates

Independent compilation and axiom-audit of the Lean certificates in
[`openai/ten-proofs`](https://github.com/openai/ten-proofs) (the machine-checkable
artifacts accompanying [*Ten Advances in Mathematics and Theoretical Computer
Science*](https://openai.com/index/ten-advances-in-mathematics/), OpenAI, Aug 1 2026).

**This is not affiliated with or endorsed by OpenAI.**

## Status

| # | Result | File | Build | Static scan | Axiom audit | Wall time |
|---|---|---|---|---|---|---|
| 1 | Multicolor triangle Ramsey (Erdős #183) | `MulticolorTriangleRamsey.lean` | ✅ | ✅ clean | ✅ `[propext, Classical.choice, Quot.sound]` | 135 s |
| 2 | Non-sofic groups exist | `NonSoficGroup.lean` | ✅ | ✅ clean | ✅ `[propext, Classical.choice, Quot.sound]` | 87 s |
| 3 | Quantitative compactness counterexample | `CompactnessAndDegeneracy.lean` | ✅ | ✅ clean | ✅ `[propext, Classical.choice, Quot.sound]` | — |
| 4 | Two-degenerate graphs counterexample | `CompactnessAndDegeneracy.lean` | ✅ | ✅ clean | ✅ `[propext, Classical.choice, Quot.sound]` | — |
| 5 | Permanent formula lower bound | `Permanent.lean` | ✅ | ✅ clean | ✅ `[propext, Classical.choice, Quot.sound]` | 115 s |
| 6 | Connes rigidity disproof | `ConnesRigidity.lean` | ✅ (478 s) | ✅ clean | ✅ `[propext, Classical.choice, Quot.sound]` | 478 s |
| 7 | Ehrhart volume inequality | `EhrhartVolumeInequality.lean` | ⏳ building | ✅ clean | — | — |
| 8 | Sharp Cohn–Elkies sphere packing | `SpherePacking.lean` | ⏳ | ✅ clean | — | — |
| 9 | Quantum parallel repetition | `QuantumParallelRepetition.lean` | ⏳ | ✅ clean | — | — |
| 10 | Binary/spherical codes (MRRW) | `MetricCodes.lean` | ⏳ | ✅ clean | — | — |
| 11 | GapCVP₄₀₀ NP-hardness | `GapCVP.lean` | ⏳ | ✅ clean | — | — |

**Progress: 6/11 builds, 6/6 axiom audits passed (as of last update).**
Raw logs in [`logs/`](logs/), live table in [`results/results.md`](results/results.md).

## What we check (and what we don't)

Per certificate, three independent checks (see [`docs/METHOD.md`](docs/METHOD.md)):

1. **Compilation**: `lake build <target>` exits 0 under Lean `v4.32.0` + Mathlib
   `v4.32.0` (commit `81a5d25`) on stock hardware (Ryzen 5 5600, 32 GB RAM).
2. **Static scan**: no `sorry`, `admit`, `native_decide`, top-level `axiom`, `unsafe`
   in the source (grep-based; script in `scripts/static_scan.sh`).
3. **Axiom audit**: `#print axioms <main-declaration>` for every headline theorem
   named in upstream `formalization.yaml`; output must be exactly
   `[propext, Classical.choice, Quot.sound]` — no `sorryAx`, no `Lean.ofReduceBool`,
   no custom axioms.

**What this does NOT establish**: that the formal theorem statements match the
human-readable paper claims (that is what the upstream `ComparatorChallenges`
target partially addresses — see upstream `README`); soundness of Lean's kernel
itself; or anything about the ~719-manuscript `openai/math` collection (separate,
much larger artifact, not compiled here).

## Reproduce

```bash
git clone https://github.com/openai/ten-proofs.git
cd ten-proofs
lake update            # pins mathlib 81a5d25 / toolchain v4.32.0
lake build <Target>    # ~1–10 min per target after mathlib is built
```

Our audit scripts: [`scripts/`](scripts/). Environment details:
[`PROVENANCE.md`](PROVENANCE.md).

## Notes on upstream provenance

`openai/ten-proofs` republishes as a **parentless root commit with no git
history** (its single commit message is `.`). Community preservation archives
exist (e.g. [`chcaru/ten-proofs-archive`](https://github.com/chcaru/ten-proofs-archive)).
We pin our verification to HEAD `94bc0feb6a9ff12c7d31d6de640a725c9d43d2b6`
(clone of 2026-10-10). Upstream `formalization.yaml` claims `sorry_count: 0` and
the standard axiom triple for all main results; our audits so far **confirm**
those claims independently.

## Authorship

Verification performed by an **AI agent** (OpenCode coding agent) at the
direction of the repository owner, who provided hardware, environment setup,
and problem selection. See [`docs/METHOD.md`](docs/METHOD.md) for limitations.
Upstream content is © OpenAI, Apache-2.0; our additions are MIT.
