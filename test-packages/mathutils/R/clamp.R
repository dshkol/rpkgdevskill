#' Constrain Values to a Range
#'
#' Clamps values to be within a specified minimum and maximum range.
#' Values below the minimum are set to the minimum, values above the
#' maximum are set to the maximum.
#'
#' @param x A numeric vector.
#' @param min_val Minimum allowed value. Default is `-Inf`.
#' @param max_val Maximum allowed value. Default is `Inf`.
#'
#' @returns A numeric vector with values constrained to the specified range.
#'
#' @export
#'
#' @examples
#' clamp(c(-5, 0, 5, 10, 15), min_val = 0, max_val = 10)
#' clamp(1:10, max_val = 5)
clamp <- function(x, min_val = -Inf, max_val = Inf) {
  # Input validation
  if (!is.numeric(x)) {
    stop("`x` must be numeric", call. = FALSE)
  }

  if (!is.numeric(min_val) || length(min_val) != 1) {
    stop("`min_val` must be a single numeric value", call. = FALSE)
  }

  if (!is.numeric(max_val) || length(max_val) != 1) {
    stop("`max_val` must be a single numeric value", call. = FALSE)
  }

  if (min_val > max_val) {
    stop("`min_val` cannot be greater than `max_val`", call. = FALSE)
  }

  pmax(pmin(x, max_val), min_val)
}
