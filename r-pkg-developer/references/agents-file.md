# AGENTS.md: the convention persistence layer

The single highest-value artifact for agentic package maintenance is a file
that records the package's conventions, commands, and hard-won pitfalls so a
future agent conforms instead of re-deriving (and mis-deriving) them. Generate
it during greenfield setup and grow it during brownfield work.

This is the link between the two modes: **greenfield decides and records;
brownfield reads and follows.** A convention that lives only in the agent's head
during creation is lost the moment the session ends.

## File layout: `AGENTS.md` + thin `CLAUDE.md` + `.Rbuildignore`

`AGENTS.md` is the emerging cross-tool standard and is the source of truth.
Claude Code reads `CLAUDE.md`, so add a one-line shim that includes it:

```markdown
<!-- CLAUDE.md -->
See @AGENTS.md
```

**The closed loop — do this the moment either file is created:** add them to
`.Rbuildignore`, or the agent artifacts the skill just produced will fail the
`R CMD check` the skill teaches later. This is a documented CRAN rejection cause.

```r
usethis::use_build_ignore(c("AGENTS.md", "CLAUDE.md", ".claude"))
```

Resulting `.Rbuildignore` entries:

```
^AGENTS\.md$
^CLAUDE\.md$
^\.claude$
```

## Skeleton

Generate this structure, filling each section from the resolved conventions
(see [conventions.md](conventions.md)) and the detected toolchain. Keep it
short — it is read on every task, so every line must earn its place.

```markdown
# AGENTS.md

Guidance for agents working **on** this package (not for users calling it).

## Constraints
<!-- Facts from DESCRIPTION, not taste. These gate everything below. -->
- R floor: <from DESCRIPTION `Depends: R (>= x.y)`; e.g. R >= 4.1 means the
  native pipe and `\()` are available but the `_` placeholder is not>
- Dependency policy: <e.g. "tidyverse-flavored, rlang/cli allowed" OR
  "zero recursive dependencies — do NOT add to Imports/Depends">

## Conventions
<!-- The resolved taste choices, each with its reason. Edit a line to re-point
     all future agent work. -->
- Style: <tidyverse | base>-flavored (default — chosen because <reason>).
  To change: tell the agent or edit this line.
- Assignment: `<-`   | Pipe: `|>`   | Anon fn: `\()` one-liners else `function()`
- Element access: `$`   | Naming: snake_case
- Errors: `cli::cli_abort()`
- Formatter: air (`air.toml`). Run `air format .` after every edit.

## Commands
<!-- The inner-loop ladder — narrow to the tightest test that covers the change. -->
- Run code:        Rscript -e "devtools::load_all(); <code>"
- All tests:       Rscript -e "devtools::test()"
- One file:        Rscript -e "devtools::test(filter = '^<name>')"
- Active file:     Rscript -e "devtools::test_active_file('R/<name>.R')"
- Single test:     Rscript -e "devtools::test_active_file('R/<name>.R', desc = '<desc>')"
- Document:        Rscript -e "devtools::document()"
- Check:           Rscript -e "devtools::check()"
- Format:          air format .
- Release runbook: see references/release.md (only when actually releasing)

## Source vs generated
<!-- Never hand-edit the generated files. Edit the source and regenerate. -->
- Generated (do not edit): NAMESPACE, man/*.Rd, README.md (from README.Rmd)
- Edit the source instead:  roxygen comments -> man/; README.Rmd -> README.md

## Changelog (NEWS.md)
- One single-line bullet per user-facing change (no line wrapping).
- Function name early in the bullet; reference the issue number in parens.
- Order bullets alphabetically by function name; non-function bullets first.
- Skip: internal refactors, small doc fixes, fixes to unreleased dev bugs.

## Pitfalls
<!-- Seeded empty. Append package-specific gotchas as they are discovered,
     with a PR/issue reference so the rationale survives. -->
```

## Generation rules

- **Fill, don't template.** Every `<placeholder>` is resolved from the package
  before writing — never ship the angle-bracket prompts.
- **Only include sections that apply.** No NEWS.md in the package → drop the
  Changelog section rather than inventing rules for a file that doesn't exist.
- **Detect the toolchain for Commands.** testthat vs tinytest, `devtools` vs a
  `Makefile`, air vs styler — the command block must match what the package
  actually uses.
- **State the default in chat too.** When a convention was defaulted rather than
  detected, say so when you create the file ("defaulting to base-R style because
  there are zero Imports — say the word to switch"). Visible and reversible
  beats a silent decision or a blocking prompt.
- **Keep the core tight; link out depth.** `AGENTS.md` is loaded on every task,
  so it is overhead until it prevents a mistake. Hold the always-read core to
  roughly the skeleton above. When architecture notes or the Pitfalls section
  grow past about a screen, move the detail into a linked reference doc (e.g.
  `vignettes/`, a `dev/` note, or a `docs/` page) and leave a pointer — a long,
  trusted file that gets skimmed is worse than a short one that gets read.

## The override mechanism

A defaulted convention is easy to change in two equivalent ways:

1. **Tell the agent** — "use tidyverse style" — and it updates the
   `## Conventions` block and conforms going forward.
2. **Edit the labeled line** in `## Conventions` directly.

Because brownfield reads that block as law, editing one line re-points all
future agent work. That is what makes "pick a default" safe: the default is
never hidden and never sticky.

## Brownfield maintenance

When working on a package that already has an `AGENTS.md`:

- **Read it as law.** Follow the recorded conventions even if they differ from
  your own defaults. If the package says `=` and `[[` and no pipes, use them.
- **Grow the Pitfalls section.** When you hit a non-obvious gotcha (a resize
  bug, a load-order trap, a mocking constraint), append a bullet with a PR or
  issue reference so the next agent inherits the lesson.
- **Keep it honest.** If a convention changed, update the file in the same
  change — a stale `AGENTS.md` is worse than none, because it is trusted.

When a package has **no** `AGENTS.md`, fall back to detecting conventions from
existing code (see [conventions.md](conventions.md)), and offer to scaffold one.
