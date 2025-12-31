## code to prepare `example_data` dataset goes here

# Create a sample dataset about fictional cities
example_data <- data.frame(
  city = c("Alphaville", "Betaburg", "Gammatown", "Deltaville", "Epsilonopolis"),
  population = c(125000, 89000, 234000, 56000, 178000),
  area_km2 = c(45.2, 32.1, 78.5, 23.4, 62.8),
  founded = c(1850, 1923, 1776, 1995, 1888),
  stringsAsFactors = FALSE
)

usethis::use_data(example_data, overwrite = TRUE)
