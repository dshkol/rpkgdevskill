# R Package Developer Skill

A reusable agent skill for developing R packages with the devtools ecosystem,
with conventions for validation, maintenance, and CRAN releases.

## What This Skill Does

When activated, this skill helps an agent with:

- Creating new R packages with proper structure
- Writing functions with roxygen2 documentation
- Setting up and running testthat tests
- Managing package dependencies
- Building vignettes
- Creating package websites with pkgdown (optional)
- Preparing packages for CRAN submission
- Fixing R CMD check errors and warnings
- Validating replicated and novel methods with claim-appropriate evidence
- Preserving behavior across refactors and multi-branch integration

## Installation

Clone this repo and copy the skill directory to your Claude Code skills location:

```bash
# For personal use (available across all projects)
cp -r r-pkg-developer ~/.claude/skills/

# Or for a specific project (available to anyone using that repo)
cp -r r-pkg-developer /path/to/your/project/.claude/skills/
```

Then restart Claude Code to load the skill.

For Codex, copy the same directory into `$CODEX_HOME/skills/` (or
`~/.codex/skills/` when `CODEX_HOME` is unset). The optional
`agents/openai.yaml` supplies Codex-facing display metadata.

## Skill Contents

### Skill Directory (`r-pkg-developer/`)
- `SKILL.md` - Main skill file with overview and core guidance

### Reference Documentation (`r-pkg-developer/references/`)
- `agents-file.md` - Persisting conventions and operational facts for agents
- `conventions.md` - Detecting, choosing, and enforcing package conventions
- `description.md` - DESCRIPTION file fields and licensing
- `documentation.md` - roxygen2 tags and patterns
- `testing.md` - testthat expectations and test patterns
- `validation.md` - Validation posture, reference implementations, invariants, artifact checks, and regression nets
- `dependencies.md` - Imports vs Suggests, NAMESPACE management
- `data.md` - Including datasets in packages
- `vignettes.md` - Long-form documentation
- `pkgdown.md` - Package website generation
- `check.md` - Fixing R CMD check issues
- `release.md` - Routine development and CRAN release runbook

### Test Packages (`test-packages/`)
Example packages demonstrating skill capabilities:
- `mathutils` - Basic numeric utility functions
- `stringhelpers` - String manipulation functions
- `datapkg` - Package with included datasets
- `tidyhelpers` - Functions using tidy evaluation (tidyverse style)
- `fullpkg` - Complete package with vignettes and pkgdown config (base R style)

## Usage

The skill triggers automatically when a supported agent detects R package
development tasks such as:

- Creating or editing DESCRIPTION files
- Writing roxygen2 documentation
- Working with testthat tests
- Running R CMD check
- Managing package dependencies
- Setting up pkgdown websites
- Validating a port or a statistical or numerical implementation
- Refactoring or optimizing while preserving public behavior
- Integrating multiple R package feature branches
- Preparing and verifying a CRAN release

## Key Workflow Commands

```r
usethis::create_package("mypackage")       # Create package
devtools::load_all()                       # Load for testing
devtools::document()                       # Generate docs
devtools::test()                           # Run tests
devtools::check()                          # Check package
usethis::use_pkgdown_github_pages()        # Setup website (optional)
```

## License

MIT
