#' Filter Data Frame If Column Exists
#'
#' Filters a data frame by a column only if that column exists.
#' If the column doesn't exist, returns the data unchanged.
#'
#' @param data A data frame.
#' @param column Character. Name of the column to filter by.
#' @param value The value to filter for.
#'
#' @returns A filtered data frame, or the original if column doesn't exist.
#'
#' @importFrom rlang .data
#' @export
#'
#' @examples
#' df <- data.frame(x = 1:3, y = c("a", "b", "a"))
#' filter_if_exists(df, "y", "a")
#' filter_if_exists(df, "z", "a")  # Returns unchanged
filter_if_exists <- function(data, column, value) {
  if (!is.data.frame(data)) {
    stop("`data` must be a data frame", call. = FALSE)
  }

  if (!column %in% names(data)) {
    return(data)
  }

  # Use .data pronoun to avoid R CMD check notes
  dplyr::filter(data, .data[[column]] == value)
}
