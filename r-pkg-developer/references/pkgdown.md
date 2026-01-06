# pkgdown Website Generation

Build a documentation website for your R package using pkgdown.

> **This is OPTIONAL.** Your package works perfectly without a website. Consider pkgdown when you want to increase visibility, make documentation more accessible, or prepare for wider distribution.

## When to Consider pkgdown

- Package is public or will be shared beyond your team
- You have vignettes that would benefit from web presentation
- You want searchable function reference documentation
- Preparing for CRAN submission (professional appearance)

## Quick Setup

### GitHub Pages (Recommended)

One command sets up automated deployment:

```r
usethis::use_pkgdown_github_pages()
```

This creates:
- `_pkgdown.yml` configuration file
- `.github/workflows/pkgdown.yaml` GitHub Actions workflow
- Configures GitHub Pages deployment
- Adds site URL to DESCRIPTION

Your site rebuilds automatically on every push to main/master.

### Local/Manual Setup

For non-GitHub projects or local preview:

```r
usethis::use_pkgdown()      # Initial setup
pkgdown::build_site()        # Build and preview locally
```

The site generates in `docs/` by default.

## Files Created

| File | Purpose |
|------|---------|
| `_pkgdown.yml` | Site configuration |
| `.github/workflows/pkgdown.yaml` | Auto-deployment (GitHub only) |
| `docs/` | Generated site (local builds) |

Also updates:
- `DESCRIPTION` - adds URL field
- `.Rbuildignore` - excludes pkgdown files from package
- `.gitignore` - may exclude `docs/` depending on setup

## Site Structure

pkgdown transforms your package into a website:

| Package Component | Website Section |
|-------------------|-----------------|
| `README.md` or `index.md` | Home page |
| `man/*.Rd` files | Reference (function docs) |
| `vignettes/*.Rmd` | Articles |
| `NEWS.md` | Changelog |

## Configuration (_pkgdown.yml)

### Minimal Configuration

```yaml
url: https://username.github.io/packagename/

template:
  bootstrap: 5
```

> **Important**: Always set `url` for correct cross-linking between pages.

### Reference Organization

Group functions by topic instead of alphabetical listing:

```yaml
reference:
  - title: "Data Import"
    desc: "Functions for reading data"
    contents:
      - read_data
      - import_csv
      - starts_with("read_")

  - title: "Data Transformation"
    contents:
      - transform
      - matches("^transform_")

  - title: "Utilities"
    contents:
      - ends_with("_util")
```

**Selection helpers:**
- `starts_with("prefix")` - functions starting with prefix
- `ends_with("suffix")` - functions ending with suffix
- `matches("regex")` - functions matching regex pattern
- `contains("text")` - functions containing text

### Home Page

By default, `README.md` becomes the home page. For a different home page:

```yaml
home:
  title: "My Package"
  description: "One-line description"
```

Or create `index.md` in the package root for completely custom content.

**Adding a logo:**

Place `logo.png` in `man/figures/` and reference in DESCRIPTION:

```
Logo: man/figures/logo.png
```

### Articles (Vignettes)

Vignettes automatically become articles. Control their organization:

```yaml
articles:
  - title: "Getting Started"
    navbar: ~
    contents:
      - packagename  # Vignette named after package becomes "Get Started"

  - title: "Advanced Topics"
    contents:
      - advanced-usage
      - customization
```

> **Tip**: Name your introductory vignette after your package (e.g., `vignettes/mypackage.Rmd`). pkgdown automatically creates a "Get Started" navbar link.

**Articles vs Vignettes:**
- Vignettes: included in package, available via `vignette("name")`
- Articles: website-only, use `usethis::use_article("name")` for content not needed in installed package

### News/Changelog

Format `NEWS.md` with level-one headings for versions:

```markdown
# packagename 1.2.0

## New features
- Added `new_function()` for X

## Bug fixes
- Fixed issue with Y (#123)

# packagename 1.1.0
...
```

### Navbar Customization

```yaml
navbar:
  structure:
    left: [intro, reference, articles, tutorials, news]
    right: [search, github]
  components:
    github:
      icon: fab fa-github
      href: https://github.com/username/package
```

## Customization

### Bootswatch Themes

Choose from Bootstrap 5 themes:

```yaml
template:
  bootstrap: 5
  bootswatch: flatly  # or: cerulean, cosmo, darkly, journal, lumen, etc.
```

Preview themes at [bootswatch.com](https://bootswatch.com/).

### Light/Dark Mode

```yaml
template:
  light-switch: true  # Adds theme toggle
```

### Custom CSS

Create `pkgdown/extra.css`:

```css
/* Custom styles */
.page-header {
  background-color: #3498db;
}
```

Reference in config:

```yaml
template:
  includes:
    in_header: pkgdown/extra.css
```

### Footer

```yaml
footer:
  structure:
    left: developed_by
    right: built_with
```

## Deployment Workflow

### Automatic (GitHub Actions)

After `use_pkgdown_github_pages()`:

1. Push to main/master branch
2. GitHub Actions builds site automatically
3. Site deploys to GitHub Pages
4. Available at `https://username.github.io/packagename/`

### Manual Local Build

```r
# Full site rebuild
pkgdown::build_site()

# Faster iteration on specific parts
pkgdown::build_reference()        # Function docs only
pkgdown::build_articles()         # Vignettes only
pkgdown::build_reference_index()  # Just the reference index
pkgdown::build_home()             # Home page only
```

### Preview Before Deployment

```r
pkgdown::preview_site()
```

Opens the local site in your browser.

## Integration with Package Development

### Recommended Workflow

1. Set up pkgdown after basic package structure is ready
2. Configure reference grouping as you add functions
3. Add vignettes that become articles
4. Customize appearance before public release

### With GitHub Actions CI

Your `.github/workflows/` might have both:
- `R-CMD-check.yaml` - runs on every PR
- `pkgdown.yaml` - builds site on main branch only

This keeps site updates separate from package checks.

## Troubleshooting

### Common Issues

**"Error: object 'x' not found" during build:**
- Ensure all packages in examples are in Imports or Suggests
- Check that `@examples` code actually runs

**Vignettes not appearing:**
- Verify `.Rmd` files are in `vignettes/`
- Check YAML frontmatter includes `vignette:` field
- Ensure Suggests includes `knitr` and `rmarkdown`

**Reference index shows wrong groupings:**
- Run `pkgdown::build_reference_index()` after editing `_pkgdown.yml`
- Check function names match exactly (case-sensitive)

**Site not updating on GitHub:**
- Verify GitHub Pages is enabled in repository settings
- Check GitHub Actions workflow completed successfully
- Ensure `gh-pages` branch exists

### Checking Configuration

```r
# Validate _pkgdown.yml
pkgdown::check_pkgdown()
```

## Quick Reference

| Task | Command |
|------|---------|
| Initial setup (GitHub) | `usethis::use_pkgdown_github_pages()` |
| Initial setup (local) | `usethis::use_pkgdown()` |
| Build full site | `pkgdown::build_site()` |
| Build reference only | `pkgdown::build_reference()` |
| Preview locally | `pkgdown::preview_site()` |
| Validate config | `pkgdown::check_pkgdown()` |
