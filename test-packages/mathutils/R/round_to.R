#' Round to Nearest Multiple
#'
#' Rounds values to the nearest multiple of a specified base.
#'
#' @param x A numeric vector.
#' @param to The multiple to round to. Default is 1.
#' @param method Rounding method: "round" (default), "floor", or "ceiling".
#'
#' @returns A numeric vector rounded to the nearest multiple of `to`.
#'
#' @export
#'
#' @examples
#' round_to(c(1.2, 2.7, 3.5), to = 0.5)
#' round_to(c(12, 27, 35), to = 10)
#' round_to(17, to = 5, method = "floor")
#' round_to(17, to = 5, method = "ceiling")
round_to <- function(x, to = 1, method = c("round", "floor", "ceiling")) {
  # Input validation
  if (!is.numeric(x)) {
    stop("`x` must be numeric", call. = FALSE)
  }

  if (!is.numeric(to) || length(to) != 1 || to <= 0) {
    stop("`to` must be a single positive number", call. = FALSE)
  }

  method <- match.arg(method)

  switch(method,
    round = round(x / to) * to,
    floor = floor(x / to) * to,
    ceiling = ceiling(x / to) * to
  )
}
