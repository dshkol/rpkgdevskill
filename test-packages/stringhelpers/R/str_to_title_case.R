#' Convert String to Title Case
#'
#' Converts a string to title case, capitalizing the first letter of each word.
#' Optionally preserves small words (articles, prepositions) in lowercase.
#'
#' @param x A character vector.
#' @param strict Logical. If `TRUE`, lowercases all letters before title-casing.
#'   Default is `TRUE`.
#'
#' @returns A character vector in title case.
#'
#' @export
#'
#' @examples
#' str_to_title_case("hello world")
#' str_to_title_case("THE QUICK BROWN FOX")
#' str_to_title_case("already Title Case", strict = FALSE)
str_to_title_case <- function(x, strict = TRUE) {
  if (!is.character(x)) {
    stop("`x` must be a character vector", call. = FALSE)
  }

  vapply(x, function(s) {
    if (strict) {
      s <- tolower(s)
    }
    # Split into words
    words <- strsplit(s, "\\s+")[[1]]
    # Capitalize first letter of each word
    words <- vapply(words, function(w) {
      if (nchar(w) == 0) return(w)
      paste0(toupper(substr(w, 1, 1)), substr(w, 2, nchar(w)))
    }, character(1), USE.NAMES = FALSE)
    paste(words, collapse = " ")
  }, character(1), USE.NAMES = FALSE)
}
