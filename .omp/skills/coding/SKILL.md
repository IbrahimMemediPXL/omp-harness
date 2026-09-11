---
name: coding
description: Build compact, clear, humane, maintainable software through inspection, focused implementation, testing, and review.
---

# Human-centered coding workflow

## Before editing

1. Inspect the repository and identify its language, framework, package manager, formatter, linter, type checker, and test runner.
2. Read relevant configuration, nearby implementation, and nearby tests to learn local conventions.
3. Check Git status and preserve unrelated user changes.
4. State the intended behavior, compatibility constraints, and smallest reasonable implementation.

## During implementation

1. Prefer straightforward, idiomatic code with descriptive domain names and explicit control flow.
2. Keep the implementation compact by removing unnecessary concepts, not by hiding meaning or compressing syntax.
3. Reuse established project patterns before adding a dependency, architectural layer, pattern, abstraction, or extension mechanism.
4. Introduce an abstraction only for a concrete current requirement, demonstrated duplication, or useful dependency boundary.
5. Keep related logic together, separate unrelated responsibilities, and make dependencies explicit.
6. Use early returns to reduce nesting when they improve readability.
7. Extract a function when it names a meaningful concept, isolates complexity, improves testing, or removes demonstrated duplication.
8. Keep trivial one-use logic inline when extraction would make the execution path harder to follow.
9. Validate external input at boundaries and provide actionable error messages without silently swallowing failures.
10. Comment the reason, constraint, or trade-off behind non-obvious code; do not narrate self-explanatory statements.
11. Do not mix unrelated cleanup or speculative future work into the requested change.

## Validation and review

1. Format changed code and run relevant targeted tests.
2. Run the available type checker, linter, and broader tests when the affected surface requires them.
3. Review the diff for unclear names, deep nesting, dense expressions, accidental complexity, unnecessary abstractions, hidden coupling, and unrelated changes.
4. Verify that public behavior, configuration errors, CLI help, and user-facing failures remain clear and actionable.
5. Confirm that new behavior is covered by tests at the most appropriate level without overfitting to implementation details.
6. Report what changed, commands run, failures, assumptions, and anything that could not be tested.

Never hide test failures or remove unrelated user changes.
