# Validation: make the package's claim falsifiable

Validation starts with what each function claims to be. Do not manufacture an
"oracle" to satisfy a checklist, and do not let a credible reference
implementation become the only specification.

## Decide whether a posture ledger is warranted

Most package functions make ordinary software claims: given documented input,
they return a documented value or condition. Test those contracts directly; do
not classify every parser, formatter, API wrapper, or convenience helper as a
novel method.

Use a development validation ledger when a function makes a substantive
methodological, numerical, statistical, or equivalence claim. Record one of
these postures for each applicable function:

- **Replication**: claims to implement an established method or reproduce
  another implementation. Equivalence evidence is required when a credible
  reference exists. If it cannot be demonstrated, weaken the public claim.
- **Novel**: has no credible software referent. Lean on definitions, derived
  cases, invariants, simulation, and empirical recovery.
- **Mixed**: replicates some behavior but deliberately extends or corrects
  other behavior. Record the boundary and test both agreement and divergence.

Posture is per applicable function, not necessarily per package. If a ledger is
warranted, keep a short policy and pointer in `AGENTS.md`; keep the details in
an R-build-ignored file such as `dev/validation.md` or
`tools/validation/README.md`, and add that path to `.Rbuildignore`. State
material validation promises and deliberate divergences in user-facing
documentation.

A useful ledger has these columns:

| Function | Posture | Claim | Evidence | Reference version | Deliberate divergence |
|---|---|---|---|---|---|

## Assemble independent evidence

Evidence serves different roles; it is not a single total ranking.

- **Definition**: published formulae, proofs, and worked examples establish
  what is meant. Prefer primary literature when available.
- **Calibration**: credible independent implementations test equivalence. Pin
  their versions and record how fixtures were generated.
- **Logical behavior**: closed-form cases, invariants, symmetry, identity,
  scale, permutation, and degenerate cases expose errors that ordinary examples
  can conceal.
- **Empirical behavior**: simulations from known processes test recovery,
  uncertainty, and asymptotics, especially for novel methods.
- **Regression**: static fixtures and object-level comparisons prevent later
  drift after correctness has been established.

Credibility is contextual: maintenance status, authorship, tests, literature
use, and agreement among independently written implementations all matter.
Never substitute an obscure implementation of unknown provenance for missing
evidence.

## Use an oracle without turning it into the specification

For replication work:

1. Pin the reference implementation and its dependency versions.
2. Generate static fixtures with a reproducible script under `tools/` or
   another build-ignored development directory.
3. Ship self-contained tests using those fixtures or independently derived
   expected values.
4. Put optional live cross-language checks behind explicit dependency and
   environment skips; do not make package checks depend on network access or an
   undeclared runtime.
5. Add invariants and adversarial special cases independently of the oracle.

If an invariant conflicts with the oracle, stop and investigate. Agreement
demonstrates replication; it does not prove correctness.

For an intentional departure, replace broad equivalence with a
**version-bounded divergence test**. Assert the package's intended result on a
minimal counterexample, record the reference versions that differ, and explain
why. This prevents a later refactor from silently restoring the legacy behavior
or drifting to a third result.

## The working tree is not the shipped package

`devtools::test()` runs against development files. `R CMD build` applies
`.Rbuildignore`; `devtools::check()` then tests the resulting tarball. A test can
pass locally and fail—or disappear—after build filtering.

Use two layers:

- **Shipped tests** are self-contained and rely only on files present in the
  built package. Store required small fixtures under `tests/testthat/` or
  `inst/`, as appropriate.
- **Development validation** may use build-ignored generation scripts, external
  runtimes, large raw fixtures, or live oracle comparisons. Its output must feed
  shipped static tests when it supports a public correctness claim.

Inspect the tarball file list when `.Rbuildignore`, fixtures, or test helpers
change. A green working-tree suite never replaces a package check.

## Refactor with a stable-version net

For a behavior-preserving refactor or optimization:

1. Install the latest published release into an isolated temporary library. If
   none exists, use the latest relevant tag or an explicitly recorded baseline
   commit and record that provenance.
2. Run representative public calls in a clean session and save baseline
   objects plus warnings, errors, and printed behavior that form the contract.
3. Run the development version in a separate clean session on the same inputs.
4. Compare complete objects with `waldo::compare()` or carefully configured
   `all.equal()`: values, classes, names, dimensions, attributes, and nested
   components all count.
5. Benchmark old and new installations under the same data and environment;
   report distributions, not a single timing.

This matters especially when replacing grouped data workflows: a rewrite can
be numerically identical while dropping S3 classes, grouping metadata, or
custom attributes.

## Validate failures as part of the method

Validate inputs in this order when applicable: type, shape, finiteness, domain,
then structural properties. Test realistic degeneracies, not only wrong types.
A confident answer from an undefined or empty case is often more dangerous than
an error. Error messages should identify the likely user mistake and the form
of valid input.
