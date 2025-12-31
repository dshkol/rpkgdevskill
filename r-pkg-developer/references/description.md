# DESCRIPTION File Reference

## Required Fields

```
Package: mypackage
Title: One-Line Description in Title Case
Version: 0.1.0
Authors@R:
    person("First", "Last", email = "email@example.com", role = c("aut", "cre"),
           comment = c(ORCID = "0000-0000-0000-0000"))
Description: A paragraph describing the package. Must be at least one sentence.
    Continuation lines must be indented by 4 spaces. Maximum 80 characters per line.
License: MIT + file LICENSE
```

## Field Guidelines

### Package
- Must match directory name
- Letters, numbers, and periods only
- Must start with a letter
- At least 2 characters

### Title
- Plain text, Title Case
- No period at end
- Max ~65 characters
- Wrap package/API names in single quotes

### Version
- Format: major.minor.patch (e.g., 1.2.3)
- Development versions: 0.0.0.9000, increment 9001, 9002...
- First release: 0.1.0 or 1.0.0

### Authors@R
Roles:
- `aut`: Author (wrote significant code)
- `cre`: Maintainer (exactly one required)
- `ctb`: Contributor
- `cph`: Copyright holder
- `fnd`: Funder

### Description
- One paragraph minimum
- Wrap package names in single quotes
- Define acronyms
- Avoid "A package for..." (redundant)

### License
Common choices:
- `MIT + file LICENSE` (permissive, requires LICENSE file)
- `GPL-3` (copyleft)
- `GPL (>= 3)` (GPL 3 or later)
- `CC0` (public domain, for data packages)

Setup functions:
```r
use_mit_license()
use_gpl3_license()
use_cc0_license()
```

## Optional Fields

```
URL: https://github.com/user/package, https://user.github.io/package
BugReports: https://github.com/user/package/issues
Encoding: UTF-8
LazyData: true
Roxygen: list(markdown = TRUE)
RoxygenNote: 7.3.0
VignetteBuilder: knitr
Config/testthat/edition: 3
```

## Dependencies

### Imports (required at runtime)
```
Imports:
    dplyr (>= 1.0.0),
    ggplot2,
    rlang
```

### Suggests (optional/development)
```
Suggests:
    covr,
    knitr,
    rmarkdown,
    testthat (>= 3.0.0)
```

### Depends (rarely needed)
```
Depends:
    R (>= 4.0.0)
```
Only use for minimum R version. Avoid for package dependencies.

### LinkingTo (C/C++ headers)
```
LinkingTo:
    Rcpp
```

## Version Specifications

- `package` - any version
- `package (>= 1.0.0)` - minimum version (most common)
- `package (>= 1.0.0, < 2.0.0)` - version range (rarely needed)

Be conservative with minimum versions. Only specify when using features introduced in that version.

## Adding Dependencies

```r
use_package("dplyr")                    # Adds to Imports
use_package("testthat", type = "Suggests")  # Adds to Suggests
use_dev_package("pkgload")              # Development dependency
```
