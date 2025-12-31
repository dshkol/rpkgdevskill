#' Normalize Values to 0-1 Range
#'
#' Scales numeric values to fall within the 0-1 range using min-max
#' normalization.
#'
#' @param x A numeric vector.
#' @param na.rm Logical. Should NA values be ignored when computing
#'   min/max? Default is `TRUE`.
#'
#' @returns A numeric vector scaled to 0-1 range. Returns `NA` for any
#'   input NA values.
#'
#' @details
#' If all values in `x` are identical, returns 0.5 for all values
#' (or NA for NA inputs).
#'
#' @export
#'
#' @examples
#' normalize(c(0, 50, 100))
#' normalize(c(1, 2, 3, NA))
normalize <- function(x, na.rm = TRUE) {
  # Input validation
  if (!is.numeric(x)) {
    stop("`x` must be numeric", call. = FALSE)
  }

  if (length(x) == 0) {
    return(numeric(0))
  }

  x_min <- min(x, na.rm = na.rm)
  x_max <- max(x, na.rm = na.rm)

  # Handle case where all values are the same
  if (x_min == x_max) {
    result <- rep(0.5, length(x))
    result[is.na(x)] <- NA
    return(result)
  }

  # Handle infinite values
  if (is.infinite(x_min) || is.infinite(x_max)) {
    warning("Infinite values present, normalization may produce unexpected results",
            call. = FALSE)
  }

  (x - x_min) / (x_max - x_min)
}
