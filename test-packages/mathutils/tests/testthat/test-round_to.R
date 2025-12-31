test_that("round_to rounds to specified multiple", {
  expect_equal(round_to(c(1.2, 2.7), to = 0.5), c(1, 2.5))
  expect_equal(round_to(c(12, 27), to = 10), c(10, 30))
})

test_that("round_to floor method works", {
  expect_equal(round_to(17, to = 5, method = "floor"), 15)
  expect_equal(round_to(23, to = 10, method = "floor"), 20)
})

test_that("round_to ceiling method works", {
  expect_equal(round_to(17, to = 5, method = "ceiling"), 20)
  expect_equal(round_to(21, to = 10, method = "ceiling"), 30)
})

test_that("round_to handles NA values", {
  expect_equal(round_to(c(1.2, NA, 2.7), to = 0.5), c(1, NA, 2.5))
})

test_that("round_to default is round", {
  expect_equal(round_to(2.5, to = 1), round_to(2.5, to = 1, method = "round"))
})

test_that("round_to errors on non-numeric x", {
  expect_error(round_to("hello"), "`x` must be numeric")
})

test_that("round_to errors on invalid to", {
  expect_error(round_to(1, to = 0), "single positive number")
  expect_error(round_to(1, to = -1), "single positive number")
  expect_error(round_to(1, to = c(1, 2)), "single positive number")
})

test_that("round_to validates method argument", {
  expect_error(round_to(1, method = "invalid"), "should be one of")
})
