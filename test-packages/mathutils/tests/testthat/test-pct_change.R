test_that("pct_change calculates percentage from reference", {
  expect_equal(pct_change(110, from = 100), 10)
  expect_equal(pct_change(90, from = 100), -10)
  expect_equal(pct_change(200, from = 100), 100)
})

test_that("pct_change calculates sequential changes", {
  result <- pct_change(c(100, 110, 99))
  expect_true(is.na(result[1]))
  expect_equal(result[2], 10)
  expect_equal(result[3], -10, tolerance = 0.01)
})

test_that("pct_change returns NA for single value with no from", {
  expect_true(is.na(pct_change(100)))
})

test_that("pct_change works with vectors when from provided", {
  expect_equal(pct_change(c(110, 120), from = 100), c(10, 20))
})

test_that("pct_change warns on division by zero with from", {
  expect_warning(result <- pct_change(10, from = 0), "Division by zero")
  expect_equal(result, Inf)
})

test_that("pct_change warns on division by zero in sequential", {
  expect_warning(pct_change(c(0, 10)), "Division by zero")
})

test_that("pct_change handles NA in input", {
  result <- pct_change(c(100, NA, 120))
  expect_true(is.na(result[1]))
  expect_true(is.na(result[2]))
  expect_true(is.na(result[3]))
})

test_that("pct_change errors on non-numeric x", {
  expect_error(pct_change("hello"), "`x` must be numeric")
})

test_that("pct_change errors on invalid from", {
  expect_error(pct_change(100, from = "hello"), "`from` must be a single numeric")
  expect_error(pct_change(100, from = c(1, 2)), "`from` must be a single numeric")
})
