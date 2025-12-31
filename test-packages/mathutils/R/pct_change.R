#' Calculate Percentage Change
#'
#' Calculates the percentage change between two values or across a vector.
#'
#' @param x Numeric vector or single value (new value).
#' @param from Optional. The reference value for comparison. If NULL,
#'   calculates sequential percentage changes across `x`.
#'
#' @returns If `from` is provided, returns percentage change from `from` to `x`.
#'   If `from` is NULL, returns a vector of sequential percentage changes
#'   (first element is NA).
#'
#' @export
#'
#' @examples
#' # Single comparison
#' pct_change(110, from = 100)  # 10% increase
#' pct_change(90, from = 100)   # 10% decrease
#'
#' # Sequential changes
#' pct_change(c(100, 110, 99))
pct_change <- function(x, from = NULL) {
  # Input validation
  if (!is.numeric(x)) {
    stop("`x` must be numeric", call. = FALSE)
  }

  if (!is.null(from)) {
    if (!is.numeric(from) || length(from) != 1) {
      stop("`from` must be a single numeric value", call. = FALSE)
    }

    if (from == 0) {
      warning("Division by zero: `from` is 0", call. = FALSE)
      return(Inf * sign(x))
    }

    return(((x - from) / from) * 100)
  }

  # Sequential changes
  if (length(x) < 2) {
    return(NA_real_)
  }

  # Check for zeros in denominator (need na.rm for NA handling)
  if (any(x[-length(x)] == 0, na.rm = TRUE)) {
    warning("Division by zero in sequential calculation", call. = FALSE)
  }

  c(NA_real_, diff(x) / x[-length(x)] * 100)
}
