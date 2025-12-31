#' Calculate Word Statistics
#'
#' Computes summary statistics about tokenized text.
#'
#' @param tokens A list of character vectors from [tokenize()].
#'
#' @returns A list with the following elements:
#'   \describe{
#'     \item{total_words}{Total number of words}
#'     \item{unique_words}{Number of unique words}
#'     \item{avg_word_length}{Average word length}
#'     \item{lexical_diversity}{Ratio of unique to total words}
#'   }
#'
#' @seealso [tokenize()] for creating tokens, [count_words()] for
#'   word frequencies.
#'
#' @export
#'
#' @examples
#' tokens <- tokenize("The quick brown fox jumps over the lazy dog")
#' word_stats(tokens)
word_stats <- function(tokens) {
  if (!is.list(tokens)) {
    stop("`tokens` must be a list (output from tokenize())", call. = FALSE)
  }

  all_words <- unlist(tokens)
  total <- length(all_words)

  if (total == 0) {
    return(list(
      total_words = 0L,
      unique_words = 0L,
      avg_word_length = NA_real_,
      lexical_diversity = NA_real_
    ))
  }

  unique_count <- length(unique(all_words))
  avg_length <- mean(nchar(all_words))
  diversity <- unique_count / total

  list(
    total_words = total,
    unique_words = unique_count,
    avg_word_length = avg_length,
    lexical_diversity = diversity
  )
}
