#' Calculate Mean with NA Handling Options
#'
#' Calculates the arithmetic mean with flexible handling of NA values and
#' informative error messages for edge cases.
#'
#' @param x A numeric vector.
#' @param na.rm Logical. Should NA values be removed? Default is `TRUE`.
#' @param na.warn Logical. Should a warning be issued if NAs are present?
#'   Default is `FALSE`.
#'
#' @returns A single numeric value representing the mean.
#'
#' @export
#'
#' @examples
#' safe_mean(c(1, 2, 3, NA))
#' safe_mean(c(1, 2, 3, NA), na.warn = TRUE)
#' safe_mean(1:10)
safe_mean <- function(x, na.rm = TRUE, na.warn = FALSE) {
  # Input validation

if (!is.numeric(x) && !is.logical(x)) {
    stop("`x` must be numeric or logical", call. = FALSE)
  }

  if (length(x) == 0) {
    warning("Input has length 0, returning NaN", call. = FALSE)
    return(NaN)
  }

  # Handle NAs
  n_na <- sum(is.na(x))
  if (n_na > 0 && na.warn) {
    warning(sprintf("%d NA value(s) present in input", n_na), call. = FALSE)
  }

  mean(x, na.rm = na.rm)
}
