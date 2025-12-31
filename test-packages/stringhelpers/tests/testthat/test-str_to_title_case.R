test_that("str_to_title_case capitalizes first letter of words", {
  expect_equal(str_to_title_case("hello world"), "Hello World")
})

test_that("str_to_title_case lowercases in strict mode", {
  expect_equal(str_to_title_case("HELLO WORLD"), "Hello World")
})

test_that("str_to_title_case preserves case in non-strict mode", {
  expect_equal(str_to_title_case("hELLO wORLD", strict = FALSE), "HELLO WORLD")
})

test_that("str_to_title_case handles single word", {
  expect_equal(str_to_title_case("hello"), "Hello")
})

test_that("str_to_title_case handles empty string", {
  expect_equal(str_to_title_case(""), "")
})

test_that("str_to_title_case works with vectors", {
  result <- str_to_title_case(c("hello", "world"))
  expect_equal(result, c("Hello", "World"))
})

test_that("str_to_title_case errors on non-character input", {
  expect_error(str_to_title_case(123), "`x` must be a character vector")
})
