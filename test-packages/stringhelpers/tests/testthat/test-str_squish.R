test_that("str_squish removes leading/trailing whitespace", {
  expect_equal(str_squish("  hello  "), "hello")
  expect_equal(str_squish("\thello\n"), "hello")
})

test_that("str_squish collapses multiple spaces", {
  expect_equal(str_squish("hello   world"), "hello world")
  expect_equal(str_squish("a  b  c"), "a b c")
})

test_that("str_squish works with vectors", {
  input <- c("  a  b  ", "c   d")
  expected <- c("a b", "c d")
  expect_equal(str_squish(input), expected)
})

test_that("str_squish handles empty strings", {
  expect_equal(str_squish(""), "")
  expect_equal(str_squish("   "), "")
})

test_that("str_squish errors on non-character input", {
  expect_error(str_squish(123), "`x` must be a character vector")
  expect_error(str_squish(NULL), "`x` must be a character vector")
})
