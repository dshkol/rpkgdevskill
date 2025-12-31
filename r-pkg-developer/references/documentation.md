# Function Documentation with roxygen2

## Basic Structure

```r
#' Title in Sentence Case
#'
#' A longer description of what the function does. Can span
#' multiple lines. Explain the purpose and behavior.
#'
#' @param x Description of parameter x.
#' @param y Description of parameter y. Default is `NULL`.
#'
#' @returns Description of what the function returns.
#'
#' @export
#' @examples
#' my_function(1, 2)
#' my_function(x = 5, y = 10)
my_function <- function(x, y = NULL) {
  # function body
}
```

## Essential Tags

### @param
Document each parameter:
```r
#' @param x A numeric vector.
#' @param na.rm Logical. Remove NA values? Default `FALSE`.
#' @param ... Additional arguments passed to [stats::lm()].
```

Document multiple related params together:
```r
#' @param x,y Numeric vectors of equal length.
```

### @returns
Always describe what the function returns:
```r
#' @returns A tibble with columns `name` and `value`.
#' @returns A character vector of file paths.
#' @returns Invisibly returns the input `x`.
#' @returns `NULL`, called for side effects.
```

### @export
Makes function available to users:
```r
#' @export
```
Omit for internal functions.

### @examples
Executable code demonstrating usage:
```r
#' @examples
#' # Basic usage
#' my_function(1:10)
#'
#' # With options
#' my_function(1:10, na.rm = TRUE)
#'
#' # Using pipe
#' mtcars |> my_function()
```

For code that shouldn't run:
```r
#' @examples
#' \dontrun{
#' # Requires API key
#' fetch_data("endpoint")
#' }
```

Conditional examples:
```r
#' @examplesIf interactive()
#' # Opens browser
#' browse_url("https://example.com")
```

### @seealso
Link to related functions:
```r
#' @seealso [other_function()] for related functionality.
#' @seealso [dplyr::filter()] for filtering data.
```

### @family
Group related functions:
```r
#' @family data manipulation functions
```

## Linking

### Within package
```r
#' See [my_other_function()] for details.
#' Uses [internal_helper()] internally.
```

### Other packages
```r
#' Similar to [dplyr::mutate()].
#' Wraps [stats::lm()].
```

### Vignettes
```r
#' See `vignette("getting-started")` for more examples.
```

## Formatting

### Inline code
```r
#' Set `x = TRUE` to enable.
#' Returns a `data.frame`.
```

### Code blocks
````r
#' ```
#' # Multi-line code example
#' x <- 1
#' y <- 2
#' ```
````

### Lists
```r
#' Supported formats:
#' * CSV files
#' * Excel files (`.xlsx`)
#' * JSON files
```

Numbered:
```r
#' Steps:
#' 1. Load data
#' 2. Transform
#' 3. Export
```

### Bold/italic
```r
#' **Important**: This is critical.
#' *Note*: This is emphasized.
```

## Documenting Datasets

```r
#' Dataset Title
#'
#' Description of the dataset and its source.
#'
#' @format A data frame with 100 rows and 5 variables:
#' \describe{
#'   \item{id}{Unique identifier}
#'   \item{name}{Character. Person's name}
#'   \item{value}{Numeric. Measurement value}
#' }
#' @source <https://example.com/data>
"dataset_name"
```

## Documenting Package

Create `R/package-name-package.R`:
```r
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom rlang .data
## usethis namespace: end
NULL
```

## Inheritance

### Inherit parameters
```r
#' @inheritParams other_function
#' @param z An additional parameter.
```

### Inherit all
```r
#' @inherit other_function
```

### Inherit specific
```r
#' @inherit other_function params returns
```

## Multiple Functions in One Topic

```r
#' Title for Both Functions
#'
#' @param x Input.
#' @rdname function_group
#' @export
function_a <- function(x) { }

#' @rdname function_group
#' @export
function_b <- function(x) { }
```

## Workflow

```r
# After editing roxygen comments:
devtools::document()    # Ctrl/Cmd + Shift + D

# Preview documentation:
?my_function

# Check all documentation:
devtools::check_man()
```
