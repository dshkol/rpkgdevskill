# Releasing: routine changes vs CRAN submission

Not every change is a release. Match the ceremony to the change — most work is
the inner loop, dev housekeeping is occasional, and a CRAN submission is rare.

## Tier 1 — routine change (the common case)

A bug fix or feature that is *not* being shipped to CRAN today:

1. Edit code (conform to the recorded conventions).
2. `air format .`
3. Run the **tightest test** that covers the change, widening only as needed:
   `test_active_file(..., desc=)` → `test_active_file()` → `test(filter=)` → `test()`.
4. `devtools::document()` if roxygen changed.
5. Add a one-line `NEWS.md` bullet for any **user-facing** change.
6. `devtools::check()` — clean before calling it done.

That is the whole loop. Do not bump versions, run revdep, or touch
`cran-comments.md` for routine work.

## Tier 2 — dev-version housekeeping

The development version carries a `.9000` suffix (e.g. `1.2.0.9000`). Bump it
when you want to mark a development milestone or signal a breaking change to
users tracking the dev version. The user-facing version stays untouched until
release.

## Tier 3 — CRAN release runbook

Run this ordered procedure only when actually submitting to CRAN.

### 1. Start from green
```r
update.packages(ask = FALSE)  # avoid masking failures that surface in CI
devtools::test()              # fast feedback
devtools::check()             # must be 0 errors | 0 warnings | 0 notes
```

### 2. Bump the version
Set `Version:` in `DESCRIPTION` to the release version and **drop the `.9000`
dev suffix** (e.g. `1.2.0.9000` → `1.2.0`). Set the `Date:` field if present to
the submission date.

### 3. Migrate NEWS.md
- Move items under the dev header (e.g. `# pkg (development version)`) into a
  new section headed by the release version.
- Add a fresh, empty dev header at the top for the next cycle.

### 4. Reverse dependency checks (if the package has revdeps)
```r
revdepcheck::revdep_reset()              # ALWAYS reset a prior run first
revdepcheck::revdep_check(num_workers = 4)
```
Results land in `revdep/README.md`. Pre-existing errors present in *both* old
and new are not regressions; only *new* problems block release.

### 5. win-builder
```r
devtools::check_win_devel()
```
Results arrive by email in ~15–30 min. Address new NOTEs/WARNINGs. win-builder
also validates URLs — fix dead links before submitting.

### 6. Final local check
```r
devtools::check(remote = TRUE, manual = TRUE)   # or: R CMD check --as-cran
spelling::spell_check_package()
urlchecker::url_check()
```

### 7. cran-comments.md
Populate with submission notes, test environments, the `0 errors | 0 warnings
| 0 notes` result, and the revdep summary:

```markdown
## Submission
- <bullets matching this release's NEWS.md entries>

## Test environments
- <CI / local / win-builder environments>

## R CMD check results
0 errors | 0 warnings | 0 notes

## revdepcheck results
We checked N reverse dependencies, comparing R CMD check results across the
CRAN and dev versions.
 * 0 new problems
 * 0 packages failed to check
```

### 8. Submit
```r
devtools::submit_cran()   # or devtools::release() for the guided flow
```

### 9. Post-acceptance
- Create a GitHub release tagged `v<x.y.z>`.
- Bump `DESCRIPTION` to the next dev version (`<next>.9000`) and commit.

## Common CRAN gotchas

- **Agent files in the tarball.** Ensure `^AGENTS\.md$`, `^CLAUDE\.md$`, and
  `^\.claude$` are in `.Rbuildignore` — otherwise the check fails. (Same for
  `^README\.Rmd$`, `^data-raw$`, `^_pkgdown\.yml$`, `^\.github$`.)
- **Undocumented exported functions.** Stub/internal methods that are exported
  still need a roxygen title; add `@keywords internal` to keep them out of the
  index while satisfying the check.
- **Broken URLs.** win-builder validates URLs; fix dead links pre-submission.
- **Stale revdep run.** Always `revdep_reset()` before `revdep_check()`.
- **Tests bloating the tarball.** If snapshot artifacts are large, exclude the
  test directory from the build tarball at submission time and restore it after
  so CI keeps running the suite.

## Acceptable vs fixable NOTEs

- **Acceptable**: "New submission" (first submission); "Days since last update"
  (too-frequent updates); non-ASCII in data with `Encoding: UTF-8` declared.
- **Fix before submitting**: "no visible binding" (use `.data$col` + import);
  "undefined global functions" (add imports); oversized package.
