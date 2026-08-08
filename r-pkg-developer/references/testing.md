# Testing with testthat

## Setup

```r
usethis::use_testthat(3)  # Initialize with edition 3
```

Creates:
- `tests/testthat/` directory
- `tests/testthat.R` runner
- Adds testthat to Suggests in DESCRIPTION

## Test File Structure

```
R/foofy.R                    tests/testthat/test-foofy.R
```

Create test files:
```r
usethis::use_test("foofy")   # Creates test-foofy.R
```

## Basic Test Structure

```r
test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

test_that("can handle edge cases", {
  expect_equal(0 * 100, 0)
  expect_equal(-1 * -1, 1)
})
```

## Common Expectations

### Equality
```r
expect_equal(actual, expected)           # With numeric tolerance
expect_identical(actual, expected)       # Exact match
expect_equal(actual, expected, ignore_attr = TRUE) # Deliberately ignore attributes
```

### Logical
```r
expect_true(x > 0)
expect_false(is.null(x))
expect_null(result)
```

> **Prefer a specific expectation over `expect_true()`/`expect_false()`.** A
> specific expectation gives a far better failure message: `expect_gt(x, 0)`
> reports the actual value, whereas `expect_true(x > 0)` only says `FALSE is not
> TRUE`. Reach for `expect_equal()`, `expect_gt()`, `expect_type()`,
> `expect_length()`, etc. first.

### Errors and Warnings

Use a condition class when the failure category is the contract. Add a snapshot
only when the complete wording is intentional user-facing behavior worth
reviewing. Do not snapshot every condition by default.

```r
expect_error(my_fun(-1), class = "mypkg_invalid_argument")
expect_snapshot(my_fun(-1), error = TRUE) # only if wording is also contractual
```

Match on a condition **class** (stable) rather than message text when you only
need to assert the *kind* of failure:

```r
expect_error(bad_input(), class = "error_class")
expect_no_error(good_input())
expect_no_warning(clean_fun())
```

Avoid treating a convenient message fragment as the behavioral contract.

### Object Properties
```r
expect_type(x, "double")
expect_s3_class(df, "data.frame")
expect_s4_class(obj, "MyS4Class")
expect_length(vec, 10)
expect_named(list(a = 1), "a")
```

### Pattern Matching
```r
expect_match(string, "pattern")
expect_output(print(x), "expected output")
```

### Comparisons
```r
expect_lt(x, 10)       # Less than
expect_lte(x, 10)      # Less than or equal
expect_gt(x, 0)        # Greater than
expect_gte(x, 0)       # Greater than or equal
```

## Snapshot Testing

For complex output that's hard to specify:
```r
test_that("output format is correct", {
  expect_snapshot(my_complex_output())
})
```

Creates `tests/testthat/_snaps/test-file.md` with recorded output.

Review snapshots individually. Never run a blanket accept merely to make a
suite green:
```r
testthat::snapshot_review()    # Inspect each semantic change
```

Snapshot variants:
```r
expect_snapshot_value(x, style = "json")
expect_snapshot_error(bad_input())
expect_snapshot_output(print(obj))
```

## Test Fixtures

### Setup/Teardown
```r
test_that("file operations work", {
  # Setup
  tmp <- tempfile()
  writeLines("test", tmp)

  # Teardown on exit (even if test fails)
  withr::defer(unlink(tmp))

  # Test
  expect_equal(readLines(tmp), "test")
})
```

### Shared Setup
Create `tests/testthat/helper.R` for shared setup code.

Create `tests/testthat/setup.R` for setup that runs once per test file.

## Test Helpers

Create reusable helpers in `tests/testthat/helper-*.R`:
```r
# tests/testthat/helper-data.R
make_test_data <- function() {
  data.frame(x = 1:10, y = rnorm(10))
}
```

> **Never put top-level code in a `test-*.R` file outside a `test_that()`
> block.** Shared objects and helpers belong in `helper.R` / `helper-*.R` (or
> `setup.R`), not loose in a test file.

## Mocking

Use `testthat::local_mocked_bindings()` to replace a binding for the duration of
a test:

```r
test_that("handles API failure", {
  local_mocked_bindings(fetch_data = function(...) stop("network down"))
  expect_snapshot(get_records(), error = TRUE)
})
```

> **Avoid the `.package` argument to `local_mocked_bindings()`.** It reaches into
> another package's namespace, which is poor practice and fragile. Instead, wrap
> the external call in a small mockable function *in your own package* and mock
> that. See `?local_mocked_bindings`.

```r
# In your package: a thin, mockable wrapper
get_time <- function() Sys.time()

# In a test: mock your wrapper, not base::Sys.time
local_mocked_bindings(get_time = function() as.POSIXct("2026-01-01"))
```

## Skip Tests

```r
test_that("requires internet", {
  skip_if_offline()
  # test code
})

test_that("platform specific", {
  skip_on_os("windows")
  # unix-only test
})

test_that("needs package", {
  skip_if_not_installed("ggplot2")
  # test with ggplot2
})

# Other skips
skip_on_cran()
skip_on_ci()
skip_if(condition, "reason")
```

## Running Tests

Narrow to the **tightest loop** that exercises your change; run the full suite
only before finishing. Widen one rung at a time:

```r
# Tightest → widest
devtools::test_active_file("R/foofy.R", desc = "handles NA")  # single test
devtools::test_active_file("R/foofy.R")                       # one file
devtools::test(filter = "^foofy")                             # files by prefix
devtools::test()                                              # whole suite (Ctrl/Cmd+Shift+T)
```

The full suite still targets the working tree. Finish with
`devtools::check()` so tests run from the built package after `.Rbuildignore`
has been applied. Read [validation.md](validation.md) whenever fixtures,
cross-language checks, or generated reference values are involved.

## Method and implementation validation

For functions that make methodological, numerical, statistical, or equivalence
claims, choose tests from the claim rather than a generic coverage target:

- Replications need credible equivalence checks plus independently specified
  invariants and special cases.
- Novel methods need definition-derived cases and simulation of known behavior.
- Deliberate departures need a minimal, version-bounded divergence test.
- Refactors need complete-object comparisons against an isolated install of the
  latest release, relevant tag, or recorded baseline commit; compare attributes
  and classes, not values alone.

For ordinary utilities, test the documented input/output and condition
contracts without creating a methodological posture ledger.

See [validation.md](validation.md) for the evidence model and fixture layout.

## Test Coverage

```r
# Setup
usethis::use_coverage()

# Run coverage
covr::package_coverage()

# Coverage report
covr::report()
```

## Best Practices

1. **One concept per test** - Test one behavior in each `test_that()`
2. **Descriptive names** - Test names should read like sentences
3. **Mirror R/ structure** - `R/foo.R` → `tests/testthat/test-foo.R`
4. **Test edge cases** - Empty, missing, non-finite, boundary, and structurally
   degenerate inputs according to the documented domain
5. **Test errors** - Verify functions fail appropriately
6. **Use fixtures** - Avoid duplicating test setup
7. **Keep tests fast** - Slow tests discourage running them

## Example Test File

```r
# tests/testthat/test-calculations.R

test_that("add() sums two numbers", {
  expect_equal(add(1, 2), 3)
  expect_equal(add(-1, 1), 0)
  expect_equal(add(0, 0), 0)
})

test_that("add() handles NA", {
  expect_equal(add(1, NA), NA_real_)
  expect_equal(add(NA, NA), NA_real_)
})

test_that("add() errors on non-numeric", {
  # Class match for the *kind* of failure; snapshot for the message wording.
  expect_error(add("a", 1), class = "error_non_numeric")
  expect_snapshot(add("a", 1), error = TRUE)
})

test_that("add() output has correct structure", {
  result <- add(1, 2)
  expect_type(result, "double")
  expect_length(result, 1)
})
```
