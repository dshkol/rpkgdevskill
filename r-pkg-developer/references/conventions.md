# Conventions: detect, record, enforce

A package's coding conventions are not a matter for the agent to *choose* on a
whim — they must be **chosen once and then recorded**, so that every later edit
(by a human or an agent) conforms instead of guessing. Guessing is where
tidyverse defaults get wrongly imposed on a base-R package, or a `|>` gets
introduced into a package that must run on old R.

The guiding principle:

> **Agnostic on taste, ruthless on consistency and correctness.**

The skill does not have an opinion about whether a package should use `<-` or
`=`, the pipe or not, tidyverse or base. It has a strong opinion that whatever
was chosen is followed consistently, is valid on the package's declared R
version, and is written down where the next agent will read it (see
[agents-file.md](agents-file.md)).

## Resolution order

Resolve each convention from the first source that answers. **Do not ask the
user what an earlier source already settles.**

1. **Existing code.** If `R/*.R` already exists, detect and mirror it. This is
   what lets brownfield work even when no `AGENTS.md` was hand-written.
2. **Declared constraints in `DESCRIPTION`.** These are facts, not taste, and
   they *gate* taste (see the R-floor table below). `Depends: R (>= 4.0)`
   forbids the native pipe no matter what anyone prefers. The `Imports` list
   reveals the dependency philosophy: dplyr/rlang present → tidyverse idiom is
   already in play; zero `Imports` → base idiom.
3. **The user's stated preference**, if they gave one.
4. **A constraint-derived default**, for a brand-new package where 1–3 are
   silent. Infer from purpose, do not interrogate: a thin dplyr wrapper →
   tidyverse-flavored; a zero-dependency utility → base-flavored. State the
   pick in one line and write it into `AGENTS.md` where the user can flip it.

Only ask the user when 1–4 are all silent *and* the choice actually matters —
and then ask **one** question (tidyverse-flavored vs base-flavored), because
that single fork cascades into dependency policy, NSE handling, pipe, and
formatter config.

## Correctness vs taste

| Layer | Negotiable? | Examples |
|-------|-------------|----------|
| **Correctness** | No — derived from the package's own declarations | Syntax must be valid on the R floor; never hand-edit generated files; `R CMD check` passes before "done" |
| **Process** | No — but the *tool* can vary | A formatter is configured and runs; conventions are recorded and then followed without mixing |
| **Taste** | Yes — detect or default, then record | `<-`/`=`, pipe choice, naming, error-signaling style, framework |

The skill is opinionated about the first two rows and silent on the third.

## R floor gates syntax (not a preference)

Read the package's declared floor — `Depends: R (>= x.y)` in `DESCRIPTION` —
first. That declared value is the only thing that gates syntax; never assume a
fixed number. The feature→version facts below are stable language facts:

| Feature | Requires | Below the floor, use |
|---------|----------|----------------------|
| Native pipe `\|>` | R 4.1 | `%>%` if magrittr is imported, else intermediate variables / nested calls |
| Lambda `\(x) ...` | R 4.1 | `function(x) ...` |
| Pipe placeholder `\|> f(y = _)` | R 4.2 | a named intermediate variable |
| Placeholder extraction `_$x`, `_[["x"]]` | R 4.3 | extract into a variable first |

When the floor is R 3.x, none of the above are available — `function()` and no
native pipe.

**Choosing a floor for a new package.** When greenfield has no declared floor to
read, default to the *acknowledged community floor at the time of creation*
rather than any number hard-coded here — the common convention is the current R
release plus the previous few minor versions, and it drifts upward over time.
Record the chosen floor in `DESCRIPTION` and `AGENTS.md` so later work honors it.

## Style axes to detect and record

These are the dimensions an `AGENTS.md` `## Conventions` block should pin down.
For each, detect from existing code if present, otherwise default per the
resolved flavor, then record the choice **with its reason**.

| Axis | Tidyverse-flavored | Base-flavored | How to detect in `R/` |
|------|--------------------|---------------|------------------------|
| Assignment | `<-` | often `=` | ratio of `<-` to `=` at line starts |
| Pipe | `\|>` (R≥4.1) or `%>%` | none / intermediate vars | grep `\|>`, `%>%` |
| Anonymous fn | `\()` one-liners, else `function()` | `function()` | grep `\\(` vs `function(` |
| Element access | `$` | `[[` (no partial matching) | grep `\$` vs `[[` density |
| Naming | `snake_case` | `snake_case` or `dot.case` | scan exported names |
| Namespacing | `pkg::fun()` + `@importFrom` for operators | `pkg::fun()` | grep `::` vs `importFrom` |
| Error signaling | `cli::cli_abort()` / `rlang::abort()` | `stop(call. = FALSE)` | grep call sites |
| Formatter | air (`air.toml`) | air or styler, or none | presence of `air.toml` / `.lintr` |
| Tests | testthat edition 3 | testthat or tinytest | `tests/` layout, `DESCRIPTION` `Config/testthat/edition` |

The **reason** matters as much as the choice. "Base R because zero recursive
dependencies — do not add `Imports`" is what stops the next agent from
"improving" the package by reaching for rlang. Recording the *why*, not just
the *what*, is the difference between an `AGENTS.md` that holds the line and one
that gets ignored.

## Enforcement

Once conventions are resolved and recorded:

- New code matches the recorded style — no mixing within a package.
- Generated files are never hand-edited (see the source-vs-generated list in
  [agents-file.md](agents-file.md)).
- The formatter runs after every edit.
- Syntax stays within the R floor.
- `R CMD check` is clean before a change is called done.
