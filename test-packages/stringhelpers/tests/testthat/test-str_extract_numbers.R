test_that("str_extract_numbers extracts integers", {
  result <- str_extract_numbers("abc123def")
  expect_equal(result[[1]], 123)
})

test_that("str_extract_numbers extracts decimals", {
  result <- str_extract_numbers("price is 19.99")
  expect_equal(result[[1]], 19.99)
})

test_that("str_extract_numbers extracts negative numbers", {
  result <- str_extract_numbers("temperature: -5 degrees")
  expect_equal(result[[1]], -5)
})

test_that("str_extract_numbers extracts multiple numbers", {
  result <- str_extract_numbers("1, 2, 3")
  expect_equal(result[[1]], c(1, 2, 3))
})

test_that("str_extract_numbers returns empty numeric for no matches", {
  result <- str_extract_numbers("no numbers here")
  expect_equal(result[[1]], numeric(0))
})

test_that("str_extract_numbers works with vectors", {
  result <- str_extract_numbers(c("a1", "b2c3"))
  expect_equal(result[[1]], 1)
  expect_equal(result[[2]], c(2, 3))
})

test_that("str_extract_numbers simplify works", {
  result <- str_extract_numbers("just 42", simplify = TRUE)
  expect_equal(result, 42)
  expect_type(result, "double")
})

test_that("str_extract_numbers errors on non-character input", {
  expect_error(str_extract_numbers(123), "`x` must be a character vector")
})
