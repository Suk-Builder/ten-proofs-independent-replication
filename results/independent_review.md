# Independent review records (3 reviewers, 2026-10-11)

Three separate AI-reviewer sessions were dispatched after the main
verification session completed. Reports were produced blind (reviewers did
not read each other's outputs; reviewer B was additionally ordered not to
read reviewer A's). All three sessions were spawned by the same operator as
the verification session — independence in execution, not organizational
independence. Findings and remediations:

## Reviewer A — replay type

Re-ran `scripts/static_scan.sh` and `scripts/audit_axioms.sh` fresh, plus 2
hand-written `#print axioms` checks independent of our scripts.

- Static scan: 10/10 CLEAN, exit 0 — **matches claims**.
- Axiom audit: 12/12 OK, exit 0, axiom sets equal item-by-item — **matches**.
- Hand-written checks (MulticolorTriangleRamsey main theorem; heaviest file
  GapCVP): verbatim-identical triple, ~3.9 s each — **matches**.
- Build timeline cross-checked via olean mtimes; all within ≤8 s of claims.
- Notes: line count 548,215 includes `All.lean` (10 import lines); upstream
  `ComparatorChallenges/` contains sorries (out of certificate scope);
  actual audit runtime ≈34 s total (task card had over-estimated).

**Verdict: all claims reproducible, zero discrepancies.**

## Reviewer B — rebuild type

Deleted a different pair of oleans (SpherePacking, MulticolorTriangleRamsey —
not overlapping the main session's Permanent/Ehrhart) and rebuilt:

```
SpherePacking            (55,616 lines): rc=0, 148.5 s, peak 9.54 GB
MulticolorTriangleRamsey ( 3,053 lines): rc=0,  11.9 s, peak 6.50 GB
```

- **sha256 of rebuilt oleans bit-identical** to pre-deletion baseline;
  full `sha256sum -c` 10/10; other 8 oleans untouched.
- Flagged: README's 135 s for MulticolorTriangleRamsey was a first-build
  (incl. Comparator dependency) figure, 11.3× the warm single-module time.
  **Remediated**: README row 1 now shows both figures.

**Verdict: reproducible, PASS.**

## Reviewer C — red team

Adversarial audit of every claim. Independently re-ran static scan (10/10
CLEAN) and 4 axiom audits (GapCVP, both CompactnessAndDegeneracy
declarations, NonSoficGroup) — **all verbatim-matched**, and all
build-time numbers cross-checked across README/results/logs.

### Severe (2) — both fixed in this commit

1. **"11/11 builds" was a mis-count** (rows 3/4 share one file → 10 build
   targets; the 11th lakefile target, ComparatorChallenges, had never been
   built), and **`CompactnessAndDegeneracy.olean` had been built by the
   environment-prep step on 10-10, not by the verification session** — the
   "3.8 s re-verify" was a cache no-op, and PROVENANCE's "certificates built
   2026-10-11" contradicted it.
   **Remediation**: CompactnessAndDegeneracy deleted and **rebuilt from
   scratch by the verification session (178.8 s, rc=0, sha256
   `055fdb3b…`)**; ComparatorChallenges target now built too (252 s, rc=0,
   with upstream's 42 sorry stubs disclosed); counts corrected to
   10 files / 12 declarations; PROVENANCE rewritten with a roles table.
2. **"Independent" scope overstated** — clone/toolchain/Mathlib/one olean
   were prepared by the repo owner before verification; reviewers share an
   operator with the verifier; a referenced `independent_review.md` did not
   exist yet.
   **Remediation**: README now carries a "Scope of independent" note
   (independent **of OpenAI**, not organizationally independent) + a
   Roles table; this file is the previously-missing reference, now real.

### Medium (6) — all addressed

1. Six of 12 axiom audits previously had no verbatim output captured
   (script printed only "OK"). → **Remediated**: full verbatim re-run with
   per-declaration exit codes saved as
   [`audit_axioms_verbatim_2026-10-11.log`](audit_axioms_verbatim_2026-10-11.log)
   (12/12 `depends on axioms`, 12/12 exit=0).
2. No sha256 of verified sources; checkout mutable mid-review (a concurrent
   reviewer's delete-rebuild was observable — a real coordination defect).
   → **Remediated**: `sources_sha256_2026-10-11.txt` (21 fingerprints);
   future reviewer coordination must partition files or use isolated clones.
3. Static scan scope not stated (10 of 23 `.lean` files; challenge files
   contain upstream sorries). → **Remediated**: scope stated in README +
   METHOD.
4. Monitor covered only the last ~28 min of the 45-min build queue; "watched
   by independent monitor" implied full coverage. → **Remediated**: results
   now say the monitor watched from 14:46; the first ~17 min are evidenced by
   the queue log alone.
5. TCB statement incomplete (toolchain binaries, Mathlib authenticity via
   TLS only). → **Remediated**: METHOD "TCB beyond the kernel" added;
   PROVENANCE marks integrity basis per component.
6. Reproduce recipe used `lake update` (re-resolution) — clarified: pins are
   exact revs; we did not re-resolve; sources sha256 provided for
   byte-identity checks.

### Minor (7) — accepted

GB/GiB wording, "dependency warm-up" phrasing, challenge count (12, not 10),
Comparator listed in toolchain table (clarified as dependency), hardcoded
declaration list (verified 1:1 against upstream), scan pattern tab-variants,
log fragments without headers — all acknowledged; low impact.

## Net effect

Red team's own fair-side finding stands: **the substantive result survives**
— all 10 certificate files compile, all 12 headline declarations depend only
on the standard axiom triple, and upstream's `sorry_count: 0` claim is
accurate for the certificate files. After remediation, every number in
README/PROVENANCE/METHOD is traceable to a raw log or fingerprint file in
this repository.
