# Releasing: routine changes vs CRAN submission

Not every change is a release. Match the ceremony to the change — most work is
the inner loop, dev housekeeping is occasional, and a CRAN submission is rare.
CRAN policy and release tooling change: verify the current
[CRAN Repository Policy](https://cran.r-project.org/web/packages/policies.html)
and the current [R Packages release workflow](https://r-pkgs.org/release.html)
before a submission.

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

CRAN asks maintainers to space ordinary updates roughly one or two months
apart. Fold thin, non-urgent patches into the next substantive release; urgent
compatibility or correctness fixes still justify a prompt patch, explained in
`cran-comments.md` when unusually close to the previous submission.

## Tier 3 — CRAN release runbook

Run this ordered procedure only when actually submitting to CRAN.

### 1. Start from green
```r
devtools::test()              # fast feedback
devtools::check()             # 0 errors, 0 warnings; resolve or explain notes
```

Do not run `update.packages()` against the maintainer's global library. Use the
package's lockfile or an isolated release library, then update dependencies
deliberately. Query CRAN for the currently published version and inspect its
current check results; do not infer either from local tags or `DESCRIPTION`.

Before changing release state, start from a clean tree. Remote builders, CRAN
submission, GitHub releases/tags, pushes, and destructive revdep cleanup cross
external or destructive boundaries: an agent must obtain the user's
authorization before performing them.

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
revdepcheck::revdep_reset()              # destructive: confirm before running
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

Also rebuild README and pkgdown when their sources, exports, or reference index
changed. Audit `DESCRIPTION`, `NEWS.md`, `README`, `_pkgdown.yml`,
`cran-comments.md`, and workflow annotations as one release surface. Only list
test environments in `cran-comments.md` that were freshly run for this release
candidate.

### 7. cran-comments.md
Populate with submission notes, test environments, the actual check result, an
explanation for every remaining NOTE, and the revdep summary:

```markdown
## Submission
- <bullets matching this release's NEWS.md entries>

## Test environments
- <CI / local / win-builder environments>

## R CMD check results
0 errors | 0 warnings | <N> notes

* <Explain each remaining NOTE; omit this bullet when N is zero.>

## revdepcheck results
We checked N reverse dependencies, comparing R CMD check results across the
CRAN and dev versions.
 * 0 new problems
 * 0 packages failed to check
```

### 8. Submit

Commit the finalized release candidate locally and verify that the working tree
is clean. The submitted SHA must include the version, NEWS, documentation, and
release metadata changes above.

```r
devtools::submit_cran()   # or devtools::release() for the guided flow
```

Preserve the generated `CRAN-SUBMISSION` file while the submission is pending.
It records the submitted version and exact SHA, so no earlier manual SHA record
is authoritative. The file is build-ignored and ephemeral, but should not be
committed or casually deleted.

### 9. Post-acceptance
- Run `usethis::use_github_release()` so the GitHub release tags the exact SHA
  recorded in `CRAN-SUBMISSION`; successful release creation removes that file.
- Bump `DESCRIPTION` to the next dev version (`<next>.9000`), commit, and push.
- Revisit CRAN check results after binaries and additional flavors finish.

## Common CRAN gotchas

- **Agent files in the tarball.** Ensure `^AGENTS\.md$`, `^CLAUDE\.md$`, and
  `^\.claude$` are in `.Rbuildignore` — otherwise the check fails. (Same for
  `^README\.Rmd$`, `^data-raw$`, `^_pkgdown\.yml$`, `^\.github$`.)
- **Undocumented exported functions.** Stub/internal methods that are exported
  still need a roxygen title; add `@keywords internal` to keep them out of the
  index while satisfying the check.
- **Broken URLs.** win-builder validates URLs; fix dead links pre-submission.
- **Stale revdep run.** Always `revdep_reset()` before `revdep_check()`.
- **Development validation in the tarball.** Keep large raw fixtures, live
  reference checks, and generation scripts build-ignored, but ship
  self-contained tests and the small fixtures needed to support public
  correctness claims.
- **Tagging the wrong commit.** Do not hand-tag whichever commit is current
  after acceptance; use the SHA recorded at submission time.

## Acceptable vs fixable NOTEs

- **Acceptable**: "New submission" (first submission); "Days since last update"
  (too-frequent updates); non-ASCII in data with `Encoding: UTF-8` declared.
- **Fix before submitting**: "no visible binding" (use `.data$col` + import);
  "undefined global functions" (add imports); oversized package.
