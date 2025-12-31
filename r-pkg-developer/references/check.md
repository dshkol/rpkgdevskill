# R CMD check Reference

## Running Checks

```r
devtools::check()       # Full check (Ctrl/Cmd + Shift + E)
devtools::check_man()   # Documentation only
devtools::test()        # Tests only
```

## Check Results

- **ERROR**: Must fix. Package won't install.
- **WARNING**: Must fix for CRAN. May cause problems.
- **NOTE**: Review carefully. Some acceptable, some not.

## Common Issues and Fixes

### DESCRIPTION

| Issue | Fix |
|-------|-----|
| Non-standard license | Use `use_mit_license()` or standard license |
| Invalid Authors@R | Use `person()` function properly |
| Missing fields | Add required fields (Title, Description, etc.) |
| Invalid package name | Use letters, numbers, periods only |

### R Code

| Issue | Fix |
|-------|-----|
| `no visible binding for global variable` | Use `.data$col` AND add `@importFrom rlang .data` (see below) |
| `no visible global function definition` | Add `@importFrom pkg fun` or use `pkg::fun()` |
| Using `T`/`F` instead of `TRUE`/`FALSE` | Spell out fully |
| Non-ASCII characters | Use `\uXXXX` escapes in code |
| `:::` usage | Request export or copy function |
| `missing value where TRUE/FALSE needed` | Use `na.rm = TRUE` in `any()`, `all()` when input may contain NA |

> **CRITICAL for dplyr/tidyr users**: Using `.data$col` alone is NOT enough. You MUST also add `@importFrom rlang .data` to at least one function's roxygen comments, otherwise R CMD check will still fail with "no visible binding" notes.

### Documentation

| Issue | Fix |
|-------|-----|
| Undocumented arguments | Add `@param` for all arguments |
| Missing `@returns` | Document return value |
| Cross-reference not found | Check spelling, use `[pkg::fun()]` syntax |
| Examples error | Fix code or use `\dontrun{}` |
| Missing documentation | Add roxygen comments to all exports |

### NAMESPACE

| Issue | Fix |
|-------|-----|
| Object not exported | Add `@export` tag |
| Importing from unspecified package | Add to Imports in DESCRIPTION |
| S3 method not registered | Use `@export` or `@method` |

### Tests

| Issue | Fix |
|-------|-----|
| Test failure | Fix test or code |
| Missing test dependency | Add to Suggests |
| Tests take too long | Optimize or skip on CRAN |

### Data

| Issue | Fix |
|-------|-----|
| Data too large | Compress or reduce size |
| Non-ASCII in data | Set `Encoding: UTF-8` in DESCRIPTION |
| Undocumented data | Add roxygen docs in `R/data.R` |

### Vignettes

| Issue | Fix |
|-------|-----|
| Vignette error | Fix code or use `eval = FALSE` |
| Missing dependency | Add to Suggests |
| `inst/doc` inconsistent | Delete and rebuild |

## Handling NOTEs

### Acceptable NOTEs
- "New submission" (first CRAN submission)
- "Days since last update" (too frequent updates)
- Non-ASCII in data with UTF-8 encoding declared

### Fix these NOTEs
- "no visible binding" - Use `.data$col` from rlang
- "undefined global functions" - Add imports
- "package size" - Reduce data/docs size

## Fixing NSE "no visible binding" Notes

When using dplyr/tidyr, you'll get "no visible binding for global variable" notes. Here's how to fix them:

### Recommended: Use `.data` pronoun with import

```r
#' My dplyr function
#'
#' @importFrom rlang .data
#' @export
my_function <- function(df) {
  dplyr::filter(df, .data$col1 > 0)
}
```

**Both parts are required:**
1. Use `.data$col` syntax in your code
2. Add `@importFrom rlang .data` to roxygen comments

The import only needs to appear once in your package (in any function), but the `.data$col` syntax must be used everywhere you reference columns.

### Alternative: globalVariables (less preferred)

```r
# In R/globals.R
utils::globalVariables(c("col1", "col2", "col3"))
```

This works but requires listing every column name, making it error-prone and hard to maintain.

## Continuous Integration

```r
# Set up GitHub Actions
usethis::use_github_action_check_standard()
```

Checks on multiple platforms:
- Windows (latest R)
- macOS (latest R)
- Ubuntu (latest R, R-devel, R-oldrel)

## Pre-CRAN Checklist

```r
# Final checks before submission
devtools::check(remote = TRUE, manual = TRUE)

# Check reverse dependencies (if updating)
revdepcheck::revdep_check()

# Spell check
spelling::spell_check_package()

# URL validation
urlchecker::url_check()
```

## Check Workflow

```r
# 1. Quick check during development
devtools::check()

# 2. Check documentation specifically
devtools::check_man()

# 3. Run tests
devtools::test()

# 4. Full check before release
devtools::check(cran = TRUE)

# 5. Check on win-builder
devtools::check_win_devel()
devtools::check_win_release()

# 6. Submit to CRAN
devtools::release()
```

## Ignoring Files

Files to exclude from package:
```r
usethis::use_build_ignore("notes.md")
usethis::use_build_ignore("^data-raw$", escape = FALSE)
```

Creates/updates `.Rbuildignore`:
```
^.*\.Rproj$
^\.Rproj\.user$
^LICENSE\.md$
^README\.Rmd$
^data-raw$
^_pkgdown\.yml$
^\.github$
```

## Environment Variables

For checks requiring credentials:
```r
# In tests
skip_if(Sys.getenv("API_KEY") == "", "API_KEY not set")

# In vignettes
eval = Sys.getenv("API_KEY") != ""
```

## Common check() Arguments

```r
devtools::check(
  document = TRUE,      # Run document() first
  cran = TRUE,          # CRAN-like settings
  remote = TRUE,        # Check remotes
  manual = TRUE,        # Build manual
  vignettes = TRUE,     # Build vignettes
  args = c("--as-cran") # Additional args
)
```
