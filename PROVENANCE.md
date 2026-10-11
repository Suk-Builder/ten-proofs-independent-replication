# Provenance & Environment

## Verified artifact

- Repo: `https://github.com/openai/ten-proofs` (Lean certificates for
  [OpenAI, *Ten Advances in Mathematics and TCS*, 2026-08-01](https://openai.com/index/ten-advances-in-mathematics/))
- HEAD at verification: `94bc0feb6a9ff12c7d31d6de640a725c9d43d2b6`
- ⚠ Upstream repo is a **parentless root commit** (message: `.`), i.e. **no git
  history**; changes between releases are not tracked by upstream. Community
  archives: [chcaru/ten-proofs-archive](https://github.com/chcaru/ten-proofs-archive),
  [utensil/ten-proofs](https://github.com/utensil/ten-proofs).

## Toolchain (all pinned by upstream `lakefile.toml` / `lean-toolchain`)

| Component | Version |
|---|---|
| Lean | `v4.32.0` (commit `8c9756b28d64dab099da31a4c09229a9e6a2ef35`) |
| Mathlib | `v4.32.0`, commit `81a5d257c8e4` ("chore: bump toolchain to v4.32.0") |
| Comparator | `leanprover/comparator` `07bc4ea40f22` |
| Other deps | batteries, aesop, proofwidgets, Qq, plausible, LeanSearchClient, importGraph, Cli, lean4export, Lean4Checker (per `lake-manifest.json`) |

## Hardware / OS

| Item | Value |
|---|---|
| CPU | AMD Ryzen 5 5600 6-Core |
| RAM | 32 GB (31.25 GiB) |
| Kernel | 7.0.0-38-generic, Ubuntu 24.04 |
| Storage | NVMe |
| Dates | mathlib prebuilt 2026-10-10/11; certificates built 2026-10-11 |

## Peak resources observed

- `Permanent` (27,563 lines): wall 115 s, **max RSS ≈ 7.5 GB**
- `MulticolorTriangleRamsey` (3,053 lines): wall 135 s (incl. dependency warm-up)
- `NonSoficGroup` (34,440 lines): wall 87 s

## Audit provenance rules

- Every `#print axioms` output must be compared against upstream's claimed
  triple `[propext, Classical.choice, Quot.sound]` (from `formalization.yaml`,
  which also claims `sorry_count: 0`).
- Any appearance of `sorryAx`, `Lean.ofReduceBool`, `Classical.choice`-only
  shortcuts beyond the triple, or **any other axiom** = audit failure.
- Static scan is supplementary (grep can miss generated identifiers); the
  `#print axioms` check is the authoritative one because it queries the kernel's
  own dependency graph.
