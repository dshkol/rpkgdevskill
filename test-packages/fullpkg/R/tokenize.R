#' Tokenize Text into Words
#'
#' Splits text into individual words, removing punctuation and
#' optionally converting to lowercase.
#'
#' @param text Character vector of text to tokenize.
#' @param lowercase Logical. Convert to lowercase? Default is `TRUE`.
#'
#' @returns A list of character vectors, one per input text element.
#'
#' @seealso [count_words()] for counting word frequencies,
#'   [word_stats()] for summary statistics.
#'
#' @export
#'
#' @examples
#' tokenize("Hello, World!")
#' tokenize(c("First sentence.", "Second one."))
tokenize <- function(text, lowercase = TRUE) {
  if (!is.character(text)) {
    stop("`text` must be a character vector", call. = FALSE)
  }

  lapply(text, function(t) {
    # Remove punctuation
    t <- gsub("[[:punct:]]", "", t)
    # Optionally lowercase
    if (lowercase) t <- tolower(t)
    # Split on whitespace
    words <- strsplit(t, "\\s+")[[1]]
    # Remove empty strings
    words[nzchar(words)]
  })
}
