# Claude Rules for aws-sdk-smalltalk

Rules files in this directory are auto-loaded by Claude Code when editing files
matching the `paths:` globs in each file's frontmatter.

## Layout

| File | Scope | Reusable? |
|------|-------|-----------|
| `pharo-syntax.md` | Pharo syntax, naming, formatting, Tonel layout, Metacello baseline convention | Yes — copy as-is |
| `rest-api-patterns.md` | Patterns for wrapping a Signature-V4-signed HTTP/REST API (Zinc: request building, signing, JSON/XML responses, error handling) | Yes — copy as-is (snippets use this project as a worked example) |
| `testing.md` | SUnit conventions (setUp/tearDown, naming, assertions) plus this project's actual bimodal testing reality (pure-unit vs. live DynamoDB-Local integration tests) | Mostly — copy the generic parts, drop the DynamoDB-specific detail |
| `project-conventions.md` | Everything specific to THIS project (inconsistent class prefixes, packages, protocol names, config defaults, known baseline gaps) | No — rewrite per project |

## Reusing in Another Smalltalk Project

1. Copy `pharo-syntax.md` unchanged.
2. Copy `rest-api-patterns.md` if the project wraps an HTTP/JSON or HTTP/XML
   REST API (for a C-library wrapper, use a `uffi-patterns.md` instead — see
   e.g. `duckdb-smalltalk`).
3. Copy `testing.md`'s generic sections (setUp/tearDown, naming, assertions);
   rewrite the "two existing test styles" section to match the target
   project's actual testing reality instead of assuming either "always live"
   or "always stubbed".
4. Write a new `project-conventions.md` for the target project, covering at
   least:
   - class prefix(es) and package layout (call out inconsistency explicitly if
     it exists — don't paper over it)
   - custom protocol names (if any)
   - resource/config defaults and error hierarchy
   - any known gaps between the baseline/dependency declarations and actual
     runtime usage
5. Adjust `paths:` globs if the source layout differs from `src/<Package>/`.

## Conventions for Editing Rules Files

- Write in **English**.
- Cite primary sources where they exist (official docs, class comments, e.g.
  `src/AWS-Core/SignatureV4.class.st`).
- No speculation — record only verified facts; write "reason unknown" or omit.
- Only include code examples that have passed local tests (or are quoted
  verbatim from source already in the repository).
