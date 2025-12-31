#' Collapse Multiple Whitespace Characters
#'
#' Removes leading and trailing whitespace and collapses multiple consecutive
#' whitespace characters into a single space.
#'
#' @param x A character vector.
#'
#' @returns A character vector with whitespace normalized.
#'
#' @export
#'
#' @examples
#' str_squish("  hello   world  ")
#' str_squish(c("  a  b", "c   d  "))
str_squish <- function(x) {
  if (!is.character(x)) {
    stop("`x` must be a character vector", call. = FALSE)
  }
  # Trim leading/trailing whitespace
  x <- trimws(x)
  # Collapse multiple spaces to single space
  gsub("\\s+", " ", x)
}
