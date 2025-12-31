#' Load City Codes Data
#'
#' Loads the city codes CSV file from the package's extdata directory.
#'
#' @returns A data frame with city codes and timezone information.
#'
#' @export
#'
#' @examples
#' codes <- load_city_codes()
#' head(codes)
load_city_codes <- function() {
  path <- system.file("extdata", "city_codes.csv", package = "datapkg")

  if (path == "") {
    stop("Could not find city_codes.csv in package extdata", call. = FALSE)
  }

  utils::read.csv(path, stringsAsFactors = FALSE)
}
