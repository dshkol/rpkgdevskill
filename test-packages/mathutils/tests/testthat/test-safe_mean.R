test_that("safe_mean calculates mean correctly", {
  expect_equal(safe_mean(c(1, 2, 3)), 2)
  expect_equal(safe_mean(1:10), 5.5)
})

test_that("safe_mean handles NA with na.rm = TRUE", {
  expect_equal(safe_mean(c(1, 2, NA, 4), na.rm = TRUE), 7/3)
})

test_that("safe_mean returns NA when na.rm = FALSE and NAs present", {
  expect_true(is.na(safe_mean(c(1, 2, NA), na.rm = FALSE)))
})

test_that("safe_mean warns about NAs when na.warn = TRUE", {
  expect_warning(safe_mean(c(1, NA, 3), na.warn = TRUE), "1 NA value")
  expect_warning(safe_mean(c(1, NA, NA), na.warn = TRUE), "2 NA value")
})

test_that("safe_mean warns for empty input", {
  expect_warning(result <- safe_mean(numeric(0)), "length 0")
  expect_true(is.nan(result))
})

test_that("safe_mean accepts logical input", {
  expect_equal(safe_mean(c(TRUE, FALSE, TRUE)), 2/3)
})

test_that("safe_mean errors on non-numeric input", {
  expect_error(safe_mean("hello"), "must be numeric or logical")
  expect_error(safe_mean(list(1, 2)), "must be numeric or logical")
})
