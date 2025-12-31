test_that("clamp constrains values to range", {
  expect_equal(clamp(c(-5, 5, 15), min_val = 0, max_val = 10), c(0, 5, 10))
})

test_that("clamp works with only min", {
  expect_equal(clamp(c(-5, 0, 5), min_val = 0), c(0, 0, 5))
})

test_that("clamp works with only max", {
  expect_equal(clamp(c(5, 10, 15), max_val = 10), c(5, 10, 10))
})

test_that("clamp preserves NA values", {
  expect_equal(clamp(c(1, NA, 3), min_val = 0, max_val = 2), c(1, NA, 2))
})

test_that("clamp handles Inf values", {
  expect_equal(clamp(c(-Inf, 0, Inf), min_val = -10, max_val = 10), c(-10, 0, 10))
})

test_that("clamp errors on non-numeric x", {
  expect_error(clamp("hello"), "`x` must be numeric")
})

test_that("clamp errors on invalid min_val", {
  expect_error(clamp(1:5, min_val = "a"), "`min_val` must be a single numeric")
  expect_error(clamp(1:5, min_val = c(1, 2)), "`min_val` must be a single numeric")
})

test_that("clamp errors on invalid max_val", {
  expect_error(clamp(1:5, max_val = "a"), "`max_val` must be a single numeric")
})

test_that("clamp errors when min > max", {
  expect_error(clamp(1:5, min_val = 10, max_val = 5), "cannot be greater than")
})
