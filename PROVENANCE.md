# Provenance & Environment

## Roles (who did what — disclosed per red-team review)

| When | Actor | Action |
|---|---|---|
| 2026-10-10 18:18 | repo owner (env prep) | cloned `openai/ten-proofs` (HEAD `94bc0feb`) |
| 2026-10-10 18:20 | repo owner | fetched/selected elan toolchain `v4.32.0` |
| 2026-10-10 ~18:20–18:55 | repo owner | `lake update` + prebuilt Mathlib `81a5d25` (6.4 GB build dir) |
| 2026-10-10 18:55 | repo owner | first (and, until 10-11, only) build of `CompactnessAndDegeneracy.olean` |
| 2026-10-11 | AI verification session (this repo's author) | builds of the other 9 certificate files, static scans, axiom audits, delete-and-rebuild of `CompactnessAndDegeneracy` (178.8 s), `Permanent` (107 s), `EhrhartVolumeInequality` (98 s); `ComparatorChallenges` build (252 s) |
| 2026-10-11 | AI reviewer B | delete-and-rebuild of `SpherePacking` + `MulticolorTriangleRamsey` (sha256-identical) |
| 2026-10-11 | AI reviewers A & C | replay of scans/audits; adversarial review of all claims (2 severe / 6 medium findings → remediated in this commit) |

**Honesty note**: environment prep and verification share an operator. The
verification is independent **of OpenAI**, and the reviewers executed
independently (separate sessions), but this is not an organizationally
independent replication. Source fingerprints below let any third party check
byte-identity.

## Verified artifact

- Repo: `https://github.com/openai/ten-proofs`
- HEAD at verification: `94bc0feb6a9ff12c7d31d6de640a725c9d43d2b6`
- ⚠ Upstream repo is a **parentless root commit** (message: `.`), i.e. **no git
  history**; provenance from OpenAI's Aug-1 publication to this HEAD rests on
  HTTPS + OpenAI's own repository practices. Community archives:
  [chcaru/ten-proofs-archive](https://github.com/chcaru/ten-proofs-archive),
  [utensil/ten-proofs](https://github.com/utensil/ten-proofs).
- **Byte fingerprints** of all 10 certificate sources and 10 built oleans:
  [`results/sources_sha256_2026-10-11.txt`](results/sources_sha256_2026-10-11.txt).
  Any future verification should diff against these first.

## Toolchain (pinned by upstream `lakefile.toml` / `lean-toolchain`)

| Component | Version | Integrity basis |
|---|---|---|
| Lean | `v4.32.0` (commit `8c9756b`) | elan download over TLS — **binary itself NOT independently verified** (see METHOD, TCB) |
| Mathlib | `81a5d257c8e4` | prebuilt by env prep; correctness cross-checked only insofar as 12 headline theorems typecheck against it |
| Comparator | `07bc4ea40f22` | as fetched by `lake update` |

## Hardware / OS

| Item | Value |
|---|---|
| CPU | AMD Ryzen 5 5600 6-Core |
| RAM | 32 GB |
| Kernel | 7.0.0-38-generic, Ubuntu 24.04 |
| Storage | NVMe |

## Peak resources observed (per-target, `MAXRSS`)

| Target | Wall | Max RSS |
|---|---|---|
| MulticolorTriangleRamsey | 135 s first / 12 s warm | 6.5 GB |
| NonSoficGroup | 87 s | — |
| CompactnessAndDegeneracy | 3.8 s (no-op) → **178.8 s from scratch** | 7.0 GB |
| Permanent | 115 s / rebuild 107 s | 7.33 GB |
| ConnesRigidity | 478 s | 6.97 GB |
| EhrhartVolumeInequality | 204 s / rebuild 98 s | 7.22 GB |
| SpherePacking | 201 s / rebuild 148.5 s | 8.03–9.54 GB |
| QuantumParallelRepetition | 705 s | 12.85 GB |
| MetricCodes | 685 s | 14.36 GB |
| GapCVP | 305 s | 14.68 GB |
| ComparatorChallenges | 252 s | 5.9 GB |

## Audit provenance rules

- Every `#print axioms` output must match the claimed triple
  `[propext, Classical.choice, Quot.sound]` (upstream `formalization.yaml`
  claims `sorry_count: 0` for the 10 certificate files — confirmed here;
  **the 12 `ComparatorChallenges/*.lean` files contain 42 upstream `sorry`
  stubs by design** and are outside the certificate claims).
- Appearance of `sorryAx`, `Lean.ofReduceBool`, or any other axiom = failure.
- Verbatim outputs with per-declaration exit codes:
  [`results/audit_axioms_verbatim_2026-10-11.log`](results/audit_axioms_verbatim_2026-10-11.log).
- The axiom audit covers the **12 headline declarations** named in upstream
  `formalization.yaml` (`status.main_results`); the files contain additional
  supporting lemmas/definitions that were **not** individually audited.
