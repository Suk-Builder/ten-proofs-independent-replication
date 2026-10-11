# Independent Verification of OpenAI's `ten-proofs` Lean Certificates

Compilation and kernel-level axiom audit of the Lean certificates in
[`openai/ten-proofs`](https://github.com/openai/ten-proofs) (the machine-checkable
artifacts accompanying [*Ten Advances in Mathematics and Theoretical Computer
Science*](https://openai.com/index/ten-advances-in-mathematics/), OpenAI, Aug 1 2026).

**This is not affiliated with or endorsed by OpenAI.**

> **Scope of "independent" (precise):** independent **of OpenAI** — no OpenAI
> personnel, code, or infrastructure participated; all builds and audits were
> re-executed from public sources on non-OpenAI hardware. It is **not**
> independent of the environment in another sense: the machine, toolchain and
> prebuilt Mathlib were set up by the repository owner (see
> [Roles](#roles-and-provenance-of-this-verification)), and the reviewing
> agents were spawned by the same operator. Who-did-what is disclosed in
> [`PROVENANCE.md`](PROVENANCE.md) — judge accordingly.

## Roles and provenance of this verification

| Step | When | Who |
|---|---|---|
| `ten-proofs` clone, elan toolchains, prebuilt Mathlib (81a5d25) | 2026-10-10 18:18–18:55 | repo owner (environment prep) |
| `CompactnessAndDegeneracy.olean` (first build) | 2026-10-10 18:55 | repo owner (environment prep) — **superseded**: deleted and rebuilt from scratch by the verification session on 2026-10-11 (178.8 s, sha256 recorded) |
| Builds of the other 9 certificate files, static scans, axiom audits, rebuild spot-checks (Permanent/Ehrhart/CompactnessAndDegeneracy) | 2026-10-11 | AI verification session (this repo's author) |
| Rebuild spot-check (SpherePacking/MulticolorTriangleRamsey) | 2026-10-11 | AI reviewer B |
| Replay review (scripts re-run), red-team review of all claims | 2026-10-11 | AI reviewers A and C |

All agents were spawned by the same operator; the reviews are independent in
execution (separate sessions, no shared reports, one reviewer ordered not to
read others' outputs) but not organizationally. Source/olean sha256
fingerprints are recorded so that any future party can verify they are
auditing the same bytes.

## Status

| # | Result | File | Build | Static scan | Axiom audit | Wall time |
|---|---|---|---|---|---|---|
| 1 | Multicolor triangle Ramsey (Erdős #183) | `MulticolorTriangleRamsey.lean` | ✅ | ✅ clean | ✅ `[propext, Classical.choice, Quot.sound]` | 135 s (first build incl. Comparator dep); 12 s warm (reviewer B) |
| 2 | Non-sofic groups exist | `NonSoficGroup.lean` | ✅ | ✅ clean | ✅ `[propext, Classical.choice, Quot.sound]` | 87 s |
| 3 | Quantitative compactness counterexample | `CompactnessAndDegeneracy.lean` | ✅ | ✅ clean | ✅ `[propext, Classical.choice, Quot.sound]` | **178.8 s rebuild-from-scratch** (this session, sha256 recorded) |
| 4 | Two-degenerate graphs counterexample | `CompactnessAndDegeneracy.lean` | ✅ | ✅ clean | ✅ `[propext, Classical.choice, Quot.sound]` | — |
| 5 | Permanent formula lower bound | `Permanent.lean` | ✅ | ✅ clean | ✅ `[propext, Classical.choice, Quot.sound]` | 115 s; **rebuild-from-scratch 107 s** |
| 6 | Connes rigidity disproof | `ConnesRigidity.lean` | ✅ | ✅ clean | ✅ `[propext, Classical.choice, Quot.sound]` | 478 s |
| 7 | Ehrhart volume inequality | `EhrhartVolumeInequality.lean` | ✅ | ✅ clean | ✅ `[propext, Classical.choice, Quot.sound]` | 204 s; **rebuild-from-scratch 98 s** |
| 8 | Sharp Cohn–Elkies sphere packing | `SpherePacking.lean` | ✅ | ✅ clean | ✅ `[propext, Classical.choice, Quot.sound]` | 201 s; rebuild (reviewer B) 148.5 s |
| 9 | Quantum parallel repetition | `QuantumParallelRepetition.lean` | ✅ | ✅ clean | ✅ `[propext, Classical.choice, Quot.sound]` | 705 s |
| 10 | Binary/spherical codes (MRRW) | `MetricCodes.lean` | ✅ | ✅ clean | ✅ `[propext, Classical.choice, Quot.sound]` | 685 s |
| 11 | GapCVP₄₀₀ NP-hardness | `GapCVP.lean` | ✅ | ✅ clean | ✅ `[propext, Classical.choice, Quot.sound]` | 305 s |
| — | ComparatorChallenges (statement-level checks, upstream scaffolding) | `ComparatorChallenges/*.lean` | ✅ | ⚠ 42 `sorry` stubs — **by upstream design**, disclosed | n/a | 252 s |

**Final: 10/10 certificate files build (12/12 headline declarations kernel-audit exact-match vs upstream claims); ComparatorChallenges target builds (upstream's own sorry scaffolding, disclosed); 10/10 certificate files static-clean; 4 rebuild-from-scratch spot-checks (3 by main session incl. all of CompactnessAndDegeneracy, 1 by reviewer B), olean sha256 recorded.**
Raw logs in [`logs/`](logs/), verbatim axiom outputs in [`results/audit_axioms_verbatim_2026-10-11.log`](results/audit_axioms_verbatim_2026-10-11.log), sha256 fingerprints in [`results/sources_sha256_2026-10-11.txt`](results/sources_sha256_2026-10-11.txt), three independent reviews in [`results/independent_review.md`](results/independent_review.md).

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
lake update            # fetches deps at the exact revs pinned in lake-manifest.json
                       # (mathlib 81a5d25 / toolchain v4.32.0); we did NOT re-resolve
lake build <Target>    # ~1–10 min per target after mathlib is built
sha256sum *.lean       # compare against results/sources_sha256_2026-10-11.txt
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
