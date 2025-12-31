test_that("filter_if_exists filters when column exists", {
  df <- data.frame(x = 1:3, y = c("a", "b", "a"))
  result <- filter_if_exists(df, "y", "a")
  expect_equal(nrow(result), 2)
  expect_equal(result$x, c(1, 3))
})

test_that("filter_if_exists returns unchanged when column missing", {
  df <- data.frame(x = 1:3)
  result <- filter_if_exists(df, "z", "a")
  expect_equal(result, df)
})

test_that("filter_if_exists errors on non-data.frame", {
  expect_error(filter_if_exists(1:5, "x", 1), "must be a data frame")
})

test_that("summarize_by groups and summarizes", {
  df <- data.frame(group = c("A", "A", "B"), value = c(1, 2, 3))
  result <- summarize_by(df, group, value)
  expect_equal(nrow(result), 2)
  expect_equal(result$summary_value, c(1.5, 3))
})

test_that("summarize_by works with custom function", {
  df <- data.frame(group = c("A", "A", "B"), value = c(1, 2, 3))
  result <- summarize_by(df, group, value, .fn = sum)
  expect_equal(result$summary_value, c(3, 3))
})

test_that("mutate_if_numeric transforms numeric columns", {
  df <- data.frame(x = c(1, 4, 9), y = c("a", "b", "c"))
  result <- mutate_if_numeric(df, sqrt)
  expect_equal(result$x, c(1, 2, 3))
  expect_equal(result$y, c("a", "b", "c"))
})

test_that("select_matches selects by pattern", {
  df <- data.frame(var_a = 1, var_b = 2, other = 3)
  result <- select_matches(df, "^var")
  expect_equal(names(result), c("var_a", "var_b"))
})

test_that("select_matches handles case insensitive", {
  df <- data.frame(VAR_a = 1, VAR_b = 2, other = 3)
  result <- select_matches(df, "^var", ignore.case = TRUE)
  expect_equal(names(result), c("VAR_a", "VAR_b"))
})

test_that("select_matches errors on invalid pattern", {
  df <- data.frame(x = 1)
  expect_error(select_matches(df, c("a", "b")), "single character string")
})
