#' Wrap Text at Word Boundaries
#'
#' Wraps text to a specified width, breaking only at word boundaries.
#' Preserves existing line breaks.
#'
#' @param x A character vector.
#' @param width Maximum line width. Default is 80.
#' @param indent Number of spaces to indent the first line. Default is 0.
#' @param exdent Number of spaces to indent subsequent lines. Default is 0.
#'
#' @returns A character vector with text wrapped.
#'
#' @export
#'
#' @examples
#' long_text <- "This is a long piece of text that should be wrapped."
#' str_wrap_words(long_text, width = 20)
#' str_wrap_words(long_text, width = 30, indent = 2)
str_wrap_words <- function(x, width = 80, indent = 0, exdent = 0) {

  if (!is.character(x)) {
    stop("`x` must be a character vector", call. = FALSE)
  }
  if (!is.numeric(width) || width < 1) {
    stop("`width` must be a positive number", call. = FALSE)
  }

  vapply(x, function(s) {
    strwrap(s, width = width, indent = indent, exdent = exdent) |>
      paste(collapse = "\n")
  }, character(1), USE.NAMES = FALSE)
}
