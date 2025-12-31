#' Get Region for a City
#'
#' Looks up the region for a given city using internal package data.
#'
#' @param city Character. Name of the city to look up.
#'
#' @returns Character. The region name, or NA if city not found.
#'
#' @export
#'
#' @examples
#' get_region("Alphaville")
#' get_region("Gammatown")
get_region <- function(city) {
  if (!is.character(city) || length(city) != 1) {
    stop("`city` must be a single character string", call. = FALSE)
  }

  # region_lookup is internal data from R/sysdata.rda
  idx <- match(city, region_lookup$city)

  if (is.na(idx)) {
    return(NA_character_)
  }

  region_lookup$region[idx]
}
