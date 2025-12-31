#' Extract Numeric Values from Strings
#'
#' Extracts all numeric values (including decimals and negative numbers)
#' from a character string.
#'
#' @param x A character string.
#' @param simplify Logical. If `TRUE` and only one number is found, return
#'   a numeric scalar instead of a list. Default is `FALSE`.
#'
#' @returns A list of numeric vectors, one element per input string.
#'   If `simplify = TRUE` and the input is length 1 with exactly one match,
#'   returns a numeric scalar.
#'
#' @export
#'
#' @examples
#' str_extract_numbers("The price is $19.99")
#' str_extract_numbers("Coordinates: -122.4, 37.8")
#' str_extract_numbers(c("a1b2", "c3d4"))
str_extract_numbers <- function(x, simplify = FALSE) {
  if (!is.character(x)) {
    stop("`x` must be a character vector", call. = FALSE)
  }

  pattern <- "-?\\d+\\.?\\d*"
  matches <- regmatches(x, gregexpr(pattern, x))
  result <- lapply(matches, function(m) {
    if (length(m) == 0 || (length(m) == 1 && m == "")) {
      numeric(0)
    } else {
      as.numeric(m)
    }
  })

  if (simplify && length(result) == 1 && length(result[[1]]) == 1) {
    return(result[[1]])
  }

  result
}
