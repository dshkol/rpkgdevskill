#' Select Columns Matching a Pattern
#'
#' Selects columns whose names match a regular expression pattern.
#'
#' @param data A data frame.
#' @param pattern Regular expression pattern to match column names.
#' @param ignore.case Logical. Should the match be case-insensitive?
#'   Default is `FALSE`.
#'
#' @returns A data frame with only matching columns.
#'
#' @export
#'
#' @examples
#' df <- data.frame(var_a = 1, var_b = 2, other = 3)
#' select_matches(df, "^var")
#' select_matches(df, "VAR", ignore.case = TRUE)
select_matches <- function(data, pattern, ignore.case = FALSE) {
  if (!is.data.frame(data)) {
    stop("`data` must be a data frame", call. = FALSE)
  }

  if (!is.character(pattern) || length(pattern) != 1) {
    stop("`pattern` must be a single character string", call. = FALSE)
  }

  # Use tidyselect::matches() for pattern-based selection
  dplyr::select(data, dplyr::matches(pattern, ignore.case = ignore.case))
}
