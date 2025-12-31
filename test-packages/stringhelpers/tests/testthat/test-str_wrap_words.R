test_that("str_wrap_words wraps at specified width", {
  result <- str_wrap_words("hello world foo bar", width = 12)
  expect_match(result, "\n")
  lines <- strsplit(result, "\n")[[1]]
  expect_true(all(nchar(lines) <= 12))
})
test_that("str_wrap_words respects indent", {
  result <- str_wrap_words("hello world", width = 80, indent = 4)
  expect_match(result, "^    ")
})

test_that("str_wrap_words respects exdent", {
  result <- str_wrap_words("hello world foo bar baz", width = 15, exdent = 2)
  lines <- strsplit(result, "\n")[[1]]
  if (length(lines) > 1) {
    expect_match(lines[2], "^  ")
  }
})

test_that("str_wrap_words works with vectors", {
  result <- str_wrap_words(c("short", "also short"), width = 80)
  expect_length(result, 2)
})

test_that("str_wrap_words errors on non-character input", {
  expect_error(str_wrap_words(123), "`x` must be a character vector")
})

test_that("str_wrap_words errors on invalid width", {
  expect_error(str_wrap_words("hello", width = 0), "`width` must be a positive")
  expect_error(str_wrap_words("hello", width = -5), "`width` must be a positive")
})
