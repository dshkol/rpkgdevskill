#' Summarize Data by Group
#'
#' Groups data by specified columns and calculates summary statistics.
#' Uses tidy evaluation to accept column names as bare symbols.
#'
#' @param data A data frame.
#' @param group_col Column to group by (unquoted).
#' @param value_col Column to summarize (unquoted).
#' @param .fn Summary function to apply. Default is `mean`.
#'
#' @returns A summarized data frame with columns for group and summary value.
#'
#' @export
#'
#' @examples
#' df <- data.frame(
#'   group = c("A", "A", "B", "B"),
#'   value = c(1, 2, 3, 4)
#' )
#' summarize_by(df, group, value)
#' summarize_by(df, group, value, .fn = sum)
summarize_by <- function(data, group_col, value_col, .fn = mean) {
  if (!is.data.frame(data)) {
    stop("`data` must be a data frame", call. = FALSE)
  }

  # Use {{ }} (curly-curly) for tidy evaluation
  data |>
    dplyr::group_by({{ group_col }}) |>
    dplyr::summarize(
      summary_value = .fn({{ value_col }}, na.rm = TRUE),
      .groups = "drop"
    )
}
