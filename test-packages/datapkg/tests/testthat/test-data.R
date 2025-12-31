test_that("example_data has expected structure", {
  expect_s3_class(example_data, "data.frame")
  expect_equal(nrow(example_data), 5)
  expect_equal(ncol(example_data), 4)
  expect_named(example_data, c("city", "population", "area_km2", "founded"))
})

test_that("example_data has expected types", {
  expect_type(example_data$city, "character")
  expect_type(example_data$population, "double")
  expect_type(example_data$area_km2, "double")
  expect_type(example_data$founded, "double")
})

test_that("load_city_codes returns expected data", {
  codes <- load_city_codes()
  expect_s3_class(codes, "data.frame")
  expect_equal(nrow(codes), 5)
  expect_named(codes, c("city", "code", "timezone"))
})

test_that("get_region returns correct region", {
  expect_equal(get_region("Alphaville"), "North")
  expect_equal(get_region("Gammatown"), "East")
})

test_that("get_region returns NA for unknown city", {
  expect_true(is.na(get_region("Unknown City")))
})

test_that("get_region errors on invalid input", {
  expect_error(get_region(123), "single character string")
  expect_error(get_region(c("A", "B")), "single character string")
})
