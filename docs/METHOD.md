# Method — and its limits

## Three checks

1. **Compilation** (`lake build <target>`, exit 0). Proves: the file is a valid
   Lean 4 / Mathlib development whose stated `theorem`s are accepted by the Lean
   kernel under the pinned toolchain. The kernel is a small trusted computing
   base; compilation is mechanical, not judgement-based.
2. **Static scan** (`scripts/static_scan.sh`). Greps for `sorry`, `admit`,
   `native_decide`, top-level `axiom`, `unsafe`. Fast but **supplementary** —
   grep is not semantics-aware.
3. **Axiom audit** (`scripts/audit_axioms.sh`). For each headline declaration
   named in upstream `formalization.yaml`, emits `#print axioms <decl>` and
   diffs against the claimed triple `[propext, Classical.choice, Quot.sound]`.
   This queries the **kernel's actual dependency graph** and is the
   authoritative check: it would expose `sorryAx` (unfinished proofs),
   `Lean.ofReduceBool` (`native_decide`), and any smuggled custom axiom.

## What this does NOT prove

- **Statement fidelity.** Compilation proves the *formal* theorems are proven;
  it does not prove the formal statements say what the human-readable paper
  claims they say. Upstream's `ComparatorChallenges` (A–J) exist to pin
  statement-level checks; auditing those is **future work here** (see
  grwtsk/openai-math AUDIT.20 — "beyond the two enabled Comparator
  configurations" — independent kernel-level comparator verification is not
  yet complete anywhere public).
- **Metaprogramming soundness.** `run_tac`/custom elaborators execute
  *arbitrary code at elaboration time* (grwtsk AUDIT.09). A proof can be
  kernel-clean while its *construction process* used untrusted code. We
  statically scan for `unsafe`/`native_decide` but a full metaprogramming
  audit is out of scope.
- **Kernel soundness.** We trust Lean 4.32.0's kernel, as does the whole
  Lean/Mathlib community.
- **Any claim about `openai/math` (719 manuscripts).** That collection is a
  separate, much larger artifact; its `lean/` library (122k files) was **not**
  compiled here.

## Why the axiom triple matters

Lean's three standard axioms are consistent with classical mathematics as
practiced (propext = extensionality, Classical.choice = AC, Quot.sound =
quotient soundness). A proof depending only on these is a proof in standard
foundations — the same foundations as Mathlib. Any *extra* axiom would be a
red flag: someone asserting an unproven statement as an axiom to make the
theorem go through.
