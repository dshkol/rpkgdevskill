test_that("normalize scales to 0-1", {
  expect_equal(normalize(c(0, 50, 100)), c(0, 0.5, 1))
  expect_equal(normalize(c(10, 20, 30)), c(0, 0.5, 1))
})

test_that("normalize handles negative values", {
  expect_equal(normalize(c(-10, 0, 10)), c(0, 0.5, 1))
})

test_that("normalize returns 0.5 for constant values", {
  expect_equal(normalize(c(5, 5, 5)), c(0.5, 0.5, 0.5))
})

test_that("normalize handles NA values", {
  result <- normalize(c(0, NA, 100))
  expect_equal(result[1], 0)
  expect_true(is.na(result[2]))
  expect_equal(result[3], 1)
})

test_that("normalize returns empty for empty input", {
  expect_equal(normalize(numeric(0)), numeric(0))
})

test_that("normalize warns about infinite values", {
  expect_warning(normalize(c(1, Inf)), "Infinite values")
})

test_that("normalize errors on non-numeric", {
  expect_error(normalize("hello"), "`x` must be numeric")
})
