#' Count Word Frequencies
#'
#' Counts the frequency of each word in tokenized text.
#'
#' @param tokens A list of character vectors from [tokenize()].
#'
#' @returns A data frame with columns `word` and `count`, sorted by
#'   frequency (descending).
#'
#' @seealso [tokenize()] for creating tokens, [word_stats()] for
#'   summary statistics.
#'
#' @export
#'
#' @examples
#' tokens <- tokenize("hello world hello")
#' count_words(tokens)
count_words <- function(tokens) {
  if (!is.list(tokens)) {
    stop("`tokens` must be a list (output from tokenize())", call. = FALSE)
  }

  # Flatten all tokens
  all_words <- unlist(tokens)

  if (length(all_words) == 0) {
    return(data.frame(word = character(0), count = integer(0)))
  }

  # Count frequencies
  counts <- table(all_words)
  result <- data.frame(
    word = names(counts),
    count = as.integer(counts),
    stringsAsFactors = FALSE
  )

  # Sort by count descending
  result[order(result$count, decreasing = TRUE), ]
}
