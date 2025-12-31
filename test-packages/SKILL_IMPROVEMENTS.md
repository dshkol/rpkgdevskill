# R Package Developer Skill - Improvement Recommendations

## Summary

Built 5 packages of increasing complexity to test the skill. Overall scores ranged from 7/10 to 9/10, with an average of 7.9/10. The skill provides good foundational guidance but has significant gaps in several areas.

| Package | Complexity | Score | Key Gap Found |
|---------|------------|-------|---------------|
| stringhelpers | Simple | 7.5/10 | Working directory issues, license setup |
| mathutils | Simple | 8/10 | Input validation patterns |
| datapkg | Medium | 8.5/10 | Data workflow directory requirements |
| tidyhelpers | Medium | 7/10 | NSE import instructions (CRITICAL) |
| fullpkg | Complex | 9/10 | Minor docs gaps |

---

## Priority 1: CRITICAL Fixes

These issues caused R CMD check failures or significant workflow blockers.

### 1.1 NSE `.data` Import Instruction

**Location**: SKILL.md, NSE section

**Problem**: Skill says to use `.data$column` but does NOT mention you must add `@importFrom rlang .data` to avoid "no visible binding" R CMD check notes.

**Fix**: Add to NSE section:
```r
# In your function file, add this roxygen tag:
#' @importFrom rlang .data
```

Or add to a package-wide imports file.

### 1.2 Working Directory Requirements

**Location**: SKILL.md, various usethis commands

**Problem**: Many usethis functions (`use_testthat()`, `use_data()`, etc.) fail unless run from within the package directory. The skill doesn't mention this.

**Fix**: Add a clear note:
> **Important**: Most `usethis::use_*()` functions require being run from within the package directory. Either `setwd()` to the package first, or use explicit project paths where supported.

### 1.3 License Setup Clarity

**Location**: SKILL.md, DESCRIPTION template

**Problem**: The template shows `License: \`use_mit_license()\`` which is a placeholder, but users may not realize they need to actually run this command.

**Fix**: Add explicit step after package creation:
```r
# Set your license (required - do this immediately after create_package)
usethis::use_mit_license("Your Name")
# or: usethis::use_gpl3_license()
```

---

## Priority 2: Important Additions

These would significantly improve the skill's usefulness.

### 2.1 Input Validation Patterns

**Location**: New section or add to Best Practices

**Problem**: Skill doesn't cover how to validate function inputs, which is essential for robust packages.

**Add**:
```r
# Common validation patterns
if (!is.character(x)) {
  stop("`x` must be a character vector", call. = FALSE)
}

if (!is.numeric(x) || length(x) != 1) {
  stop("`x` must be a single numeric value", call. = FALSE)
}

# For factor/string arguments with fixed choices
method <- match.arg(method)  # validates against function default

# NA-safe conditionals (IMPORTANT!)
if (any(x == 0, na.rm = TRUE)) {
  # Without na.rm, this fails if x contains NA
}
```

### 2.2 NSE Pattern Decision Guide

**Location**: SKILL.md, expand NSE section

**Problem**: Skill mentions `.data` but doesn't explain when to use different patterns.

**Add**:
| Pattern | Use When | Example |
|---------|----------|---------|
| `.data$col` | Column name is known at code-write time | `dplyr::filter(df, .data$status == "active")` |
| `.data[[col]]` | Column name is in a variable | `dplyr::filter(df, .data[[col_name]] == value)` |
| `{{ var }}` | Passing column name as function argument | `dplyr::select(df, {{ user_col }})` |

Also add `@importFrom rlang .data` requirement!

### 2.3 Data Workflow Clarification

**Location**: references/data.md

**Problems**:
1. Data-raw scripts must be run from package directory
2. Internal data (sysdata.rda) access pattern not shown
3. system.file() for inst/extdata not explained

**Add**:
```r
# Run data-raw scripts from package directory
setwd("path/to/package")
source("data-raw/my_data.R")

# Access internal data (R/sysdata.rda) - just use the variable name
my_internal_lookup$column  # No loading needed

# Access inst/extdata files
path <- system.file("extdata", "file.csv", package = "mypkg")
data <- read.csv(path)
```

### 2.4 Nested Project Handling

**Location**: SKILL.md, Package Creation section

**Problem**: Creating packages in subdirectories causes "nested project" warnings.

**Add**:
```r
# If creating package in a subdirectory of another project:
options(usethis.allow_nested_project = TRUE)
usethis::create_package("subdir/mypkg", open = FALSE)
```

---

## Priority 3: Helpful Enhancements

These would polish the skill further.

### 3.1 Modern dplyr Patterns

**Location**: references/documentation.md or new reference

Add coverage for:
- `dplyr::across()` for column transformations
- `dplyr::where()` for predicate selection
- `dplyr::pick()` for selecting columns

### 3.2 Warning vs Error Guidance

**Location**: Best Practices section

Add guidance on when to use `warning()` vs `stop()`:
- `stop()`: Invalid inputs, impossible operations
- `warning()`: Edge cases that produce valid but possibly unexpected results
- Include `call. = FALSE` for cleaner error messages

### 3.3 Package Documentation Details

**Location**: references/documentation.md

Add:
- `"_PACKAGE"` sentinel explanation (it tells roxygen2 this is package-level docs)
- Cross-reference syntax: `[function()]` links within package, `[pkg::function()]` external
- `@seealso` for related function links

### 3.4 R Version Dependencies

**Location**: Best Practices section

Note that using native pipe `|>` automatically adds R >= 4.1.0 dependency. Consider whether this is acceptable for your package's target audience.

---

## File-Specific Recommendations

### SKILL.md
1. Add nested project handling option
2. Expand NSE section with import requirement
3. Add input validation patterns
4. Clarify license setup as a required step

### references/check.md
1. Add `.data` import as fix for "no visible binding" note
2. Add note about `na.rm = TRUE` in `any()`/`all()` conditionals

### references/data.md
1. Emphasize working directory requirement for data scripts
2. Add internal data access example
3. Add system.file() example for extdata

### references/documentation.md
1. Add `"_PACKAGE"` explanation
2. Document cross-reference syntax more clearly
3. Add `@importFrom` examples beyond rlang

### references/dependencies.md
1. Add `@importFrom rlang .data` as common required import
2. Note R version implications of native pipe

---

## Testing Methodology

Each package was built following the skill's workflow:
1. Create package with `usethis::create_package()`
2. Add functions with roxygen2 documentation
3. Generate docs with `devtools::document()`
4. Set up tests with `usethis::use_testthat(3)`
5. Write tests
6. Run `devtools::check()`
7. Fix any issues
8. Score and document gaps

Total: 141 tests written, 5 packages built, all passing R CMD check with 0E/0W/0N.
