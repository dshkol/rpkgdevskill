# Creating Vignettes

## Setup

```r
usethis::use_vignette("getting-started")
```

Creates:
- `vignettes/getting-started.Rmd`
- Adds knitr to VignetteBuilder
- Adds knitr, rmarkdown to Suggests

## Vignette Structure

```yaml
---
title: "Getting Started with mypackage"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Getting Started with mypackage}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---
```

**Important**: `VignetteIndexEntry` must match the title.

## Content Guidelines

### Introduction
```markdown
The mypackage package provides tools for [purpose].
This vignette covers:

- Basic usage
- Common workflows
- Tips and tricks
```

### Code examples
````markdown
```{r}
library(mypackage)

# Basic usage
result <- my_function(data)
head(result)
```
````

### Including plots
````markdown
```{r, fig.width=6, fig.height=4}
plot_data(result)
```
````

## Vignette vs Article

| Feature | Vignette | Article |
|---------|----------|---------|
| Location | `vignettes/` | `vignettes/articles/` |
| Installed | Yes | No |
| CRAN checks | Yes | No |
| Size limits | Yes | No |
| Create with | `use_vignette()` | `use_article()` |

Use articles for:
- Content with large images
- Examples requiring external APIs
- Optional dependencies not on CRAN

```r
usethis::use_article("advanced-examples")
```

## Conditional Execution

### Skip on CRAN
````markdown
```{r, eval = FALSE}
# Code shown but not executed
expensive_computation()
```
````

### Conditional on package
````markdown
```{r, eval = requireNamespace("ggplot2", quietly = TRUE)}
library(ggplot2)
ggplot(data, aes(x, y)) + geom_point()
```
````

### Conditional on environment
````markdown
```{r, include = FALSE}
has_api_key <- Sys.getenv("API_KEY") != ""
```

```{r, eval = has_api_key}
# Only runs if API_KEY is set
fetch_data()
```
````

### Set default for whole vignette
````markdown
```{r, include = FALSE}
knitr::opts_chunk$set(eval = FALSE)
```
````

## Cross-References

### Link to functions
```markdown
Use `my_function()` to process data.
See `?my_function` for details.
```

### Link to other vignettes
```markdown
See `vignette("advanced-topics")` for more details.
```

### Link to external
```markdown
Based on methods from [Smith et al.](https://doi.org/10.1234/example)
```

## Including External Files

### Images
```r
knitr::include_graphics("figures/diagram.png")
```

Store images in `vignettes/figures/`.

### Data files
```r
# File in vignettes/ directory
data <- read.csv("sample-data.csv")
```

### Package data
```r
# Installed package data
path <- system.file("extdata", "example.csv", package = "mypackage")
data <- read.csv(path)
```

## Building Vignettes

```r
# Build single vignette (uses installed package)
rmarkdown::render("vignettes/getting-started.Rmd")

# Build against development version
devtools::build_rmd("vignettes/getting-started.Rmd")

# Install package with vignettes
devtools::install(build_vignettes = TRUE)

# View vignette
vignette("getting-started", package = "mypackage")
```

## Chunk Options

Common options:
```r
echo = FALSE      # Hide code, show output
eval = FALSE      # Show code, don't run
include = FALSE   # Run code, hide everything
results = 'hide'  # Hide text output
fig.show = 'hide' # Hide figures
message = FALSE   # Hide messages
warning = FALSE   # Hide warnings
error = TRUE      # Continue on errors
cache = TRUE      # Cache results
```

## Naming Conventions

- Package intro: `mypackage.Rmd`
- Topics: `topic-name.Rmd`
- Use lowercase with hyphens

Primary vignette named after package gets "Get started" link in pkgdown.

## Best Practices

1. **Start simple** - First vignette should be beginner-friendly
2. **Real examples** - Use realistic data and workflows
3. **Self-contained** - Each vignette should work independently
4. **Keep updated** - Update vignettes when API changes
5. **Watch size** - Large vignettes slow down installation
6. **Test builds** - Ensure vignettes build without errors
7. **Link generously** - Connect to docs and other vignettes

## Troubleshooting

### Vignette not found
```r
# Rebuild vignette index
devtools::build_vignettes()
```

### Dependencies missing
Add all packages used in vignettes to Suggests in DESCRIPTION.

### Slow vignettes
- Cache expensive computations
- Use pre-computed results
- Move to article if CRAN time limits are an issue
