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
expect_equivalent(actual, expected)      # Ignore attributes
```

### Logical
```r
expect_true(x > 0)
expect_false(is.null(x))
expect_null(result)
```

### Errors and Warnings
```r
expect_error(stop("oops"))
expect_error(bad_input(), class = "error_class")
expect_error(my_fun(-1), "must be positive")

expect_warning(warn_fun())
expect_message(message_fun())

expect_no_error(good_input())
expect_no_warning(clean_fun())
```

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

Review/accept snapshots:
```r
testthat::snapshot_review()    # Interactive review
testthat::snapshot_accept()    # Accept all changes
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

```r
# All tests
devtools::test()           # Ctrl/Cmd + Shift + T

# Single file
testthat::test_file("tests/testthat/test-foofy.R")

# Active file in RStudio
devtools::test_active_file()   # Ctrl/Cmd + T
```

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
4. **Test edge cases** - Empty input, NA values, wrong types
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
  expect_error(add("a", 1), class = "error_non_numeric")
})

test_that("add() output has correct structure", {
  result <- add(1, 2)
  expect_type(result, "double")
  expect_length(result, 1)
})
```
