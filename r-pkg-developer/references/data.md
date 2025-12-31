# Including Data in Packages

## Overview

| Type | Location | User Access | Use Case |
|------|----------|-------------|----------|
| Exported | `data/` | Yes | Example datasets |
| Internal | `R/sysdata.rda` | No | Lookup tables, constants |
| Raw | `inst/extdata/` | Yes | CSV, JSON, other formats |

## Exported Data (`data/`)

### Creating data
```r
# Create preparation script
usethis::use_data_raw("dataset_name")
```

This creates `data-raw/dataset_name.R`:
```r
## code to prepare `dataset_name` dataset goes here

# Load/create your data
dataset_name <- read.csv("source.csv")

# Clean and process
dataset_name <- dataset_name |>
  dplyr::filter(!is.na(value)) |>
  dplyr::mutate(date = as.Date(date))

# Save to data/
usethis::use_data(dataset_name, overwrite = TRUE)
```

### Enable lazy loading
In DESCRIPTION:
```
LazyData: true
```

### Document the dataset
Create `R/data.R`:
```r
#' Short Dataset Title
#'
#' Description of the dataset, its source, and potential uses.
#'
#' @format A data frame with 100 rows and 5 variables:
#' \describe{
#'   \item{id}{Integer. Unique identifier.}
#'   \item{name}{Character. Person's name.}
#'   \item{value}{Numeric. Measurement in units.}
#'   \item{category}{Factor. Category with levels A, B, C.}
#'   \item{date}{Date. Observation date.}
#' }
#' @source \url{https://example.com/data}
#' @examples
#' head(dataset_name)
#' summary(dataset_name$value)
"dataset_name"
```

## Internal Data (`R/sysdata.rda`)

For data used by functions but not exported:
```r
# In data-raw/internal_data.R
lookup_table <- data.frame(
  code = c("A", "B", "C"),
  value = c(1, 2, 3)
)

state_codes <- c("CA", "NY", "TX")

# Save all internal data together
usethis::use_data(lookup_table, state_codes, internal = TRUE)
```

Access in package functions (no loading needed - just use the variable name):
```r
#' Look up a value
#' @export
my_function <- function(code) {
  # lookup_table is available directly from R/sysdata.rda
  lookup_table$value[lookup_table$code == code]
}
```

> **Note**: Internal data objects are automatically available to all functions in your package. You don't need to load or import them - just use the variable name directly. They are NOT available to package users.

## Raw Data Files (`inst/extdata/`)

For non-R data formats:
```
inst/extdata/
├── example.csv
├── config.json
└── template.xlsx
```

Access in package:
```r
#' Get path to example file
#'
#' @param file File name. If NULL, returns all available files.
#' @returns Path to file in package installation.
#' @export
#' @examples
#' my_example("example.csv")
my_example <- function(file = NULL) {
  if (is.null(file)) {
    dir(system.file("extdata", package = "mypackage"))
  } else {
    system.file("extdata", file, package = "mypackage", mustWork = TRUE)
  }
}
```

Users access with:
```r
path <- my_example("example.csv")
data <- read.csv(path)
```

## Data Size Limits

CRAN guidelines:
- Total package < 5 MB
- `data/` directory < 1 MB

### Compression options
```r
# Test compression methods
tools::checkRdaFiles("data/")

# Use best compression
usethis::use_data(dataset, compress = "xz")  # Best compression
usethis::use_data(dataset, compress = "bzip2")  # Good balance
usethis::use_data(dataset, compress = "gzip")  # Fast, less compression
```

### Large datasets
For datasets > 1 MB:
- Create a separate data package
- Host externally and download on demand
- Provide subset in package, full data elsewhere

## Workflow

```r
# 1. Create preparation script (run from package directory!)
usethis::use_data_raw("mydata")

# 2. Edit data-raw/mydata.R to prepare data

# 3. Run script to generate data/mydata.rda
#    IMPORTANT: Must run from package directory
source("data-raw/mydata.R")

# 4. Document in R/data.R

# 5. Regenerate documentation
devtools::document()

# 6. Test data loads correctly
devtools::load_all()
head(mydata)
```

> **Working Directory**: The data preparation script MUST be run from within the package directory. `usethis::use_data()` looks for the package structure relative to the current directory. If you get "not an R package" errors, use `setwd("path/to/package")` first.

## Best Practices

1. **Always keep source** - Store preparation scripts in `data-raw/`
2. **One object per file** - `data/foo.rda` contains only `foo`
3. **Document everything** - Every exported dataset needs roxygen docs
4. **Use UTF-8** - Set `Encoding: UTF-8` in DESCRIPTION
5. **Minimize size** - Compress well, subset if needed
6. **Version data** - Track data changes in NEWS.md
