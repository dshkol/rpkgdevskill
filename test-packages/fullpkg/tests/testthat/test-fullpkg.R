# Tests for tokenize()
test_that("tokenize splits text into words", {
  result <- tokenize("hello world")
  expect_equal(result[[1]], c("hello", "world"))
})

test_that("tokenize removes punctuation", {
  result <- tokenize("Hello, World!")
  expect_equal(result[[1]], c("hello", "world"))
})

test_that("tokenize lowercases by default", {
  result <- tokenize("HELLO")
  expect_equal(result[[1]], "hello")
})

test_that("tokenize preserves case when lowercase = FALSE", {
  result <- tokenize("HELLO", lowercase = FALSE)
  expect_equal(result[[1]], "HELLO")
})

test_that("tokenize works with multiple texts", {
  result <- tokenize(c("one two", "three four"))
  expect_length(result, 2)
  expect_equal(result[[1]], c("one", "two"))
  expect_equal(result[[2]], c("three", "four"))
})

test_that("tokenize errors on non-character", {
  expect_error(tokenize(123), "must be a character")
})

# Tests for count_words()
test_that("count_words counts frequencies", {
  tokens <- tokenize("hello world hello")
  result <- count_words(tokens)
  expect_equal(result$word[1], "hello")
  expect_equal(result$count[1], 2)
})

test_that("count_words returns sorted by frequency", {
  tokens <- tokenize("a b b b c c")
  result <- count_words(tokens)
  expect_equal(result$count, c(3, 2, 1))
})

test_that("count_words handles empty input", {
  result <- count_words(list())
  expect_equal(nrow(result), 0)
})

test_that("count_words errors on non-list", {
  expect_error(count_words("hello"), "must be a list")
})

# Tests for word_stats()
test_that("word_stats calculates correct totals", {
  tokens <- tokenize("a b c d e")
  result <- word_stats(tokens)
  expect_equal(result$total_words, 5)
  expect_equal(result$unique_words, 5)
})

test_that("word_stats calculates lexical diversity", {
  tokens <- tokenize("a a b b")
  result <- word_stats(tokens)
  expect_equal(result$lexical_diversity, 0.5)
})

test_that("word_stats handles empty input", {
  result <- word_stats(list())
  expect_equal(result$total_words, 0)
  expect_true(is.na(result$lexical_diversity))
})
