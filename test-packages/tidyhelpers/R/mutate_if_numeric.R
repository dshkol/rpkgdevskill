#' Apply Function to Numeric Columns
#'
#' Applies a transformation function to all numeric columns in a data frame.
#'
#' @param data A data frame.
#' @param .fn Function to apply to numeric columns. Default is `identity`.
#'
#' @returns A data frame with transformed numeric columns.
#'
#' @export
#'
#' @examples
#' df <- data.frame(x = 1:3, y = c("a", "b", "c"), z = 4:6)
#' mutate_if_numeric(df, sqrt)
#' mutate_if_numeric(df, function(x) x * 2)
mutate_if_numeric <- function(data, .fn = identity) {
  if (!is.data.frame(data)) {
    stop("`data` must be a data frame", call. = FALSE)
  }

  # Use dplyr::across with where() for column selection
  dplyr::mutate(data, dplyr::across(dplyr::where(is.numeric), .fn))
}
