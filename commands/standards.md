---
name: forge:standards
description: "Forge coding standards review: naming, typing, error handling, observability, KISS/DRY/YAGNI."
argument-hint: [file-path | blank for changed files]
allowed-tools: Read, Grep, Glob, Bash(git diff:*)
---

> Read rules/model-adapter.md and select tier before starting.

**Input**: $ARGUMENTS

---

## Mode

If $ARGUMENTS is a file path → review that file.
Else → review all files changed in current diff.

---

## Phase 1: GATHER

```bash
git diff --name-only HEAD
```

If $ARGUMENTS is a path, read that file directly.
No files → stop: "Nothing to review."

---

## Phase 2: REVIEW

Apply `forge:standards` skill.

| Category | Checks |
|----------|--------|
| Naming | Descriptive names, kebab-case files, verb+noun functions |
| Typing | No `any`, no implicit returns, types defined before bodies |
| Principles | KISS, DRY (3+ duplicates → extract), YAGNI, const by default |
| Error handling | Context in errors, no silent catch, 400 vs 500 |
| Observability | Structured logs with traceId on all cross-boundary calls |
| Dead code | No commented-out blocks, no unused variables |

---

## Phase 3: REPORT

```
FORGE STANDARDS — <date>
========================
Decision: PASS | PASS WITH NOTES | FAIL

[SEVERITY] file:line - Title
Problem: ...
Fix: ...
```

| Verdict | Condition |
|---------|-----------|
| PASS | No violations |
| PASS WITH NOTES | Only LOW/style issues |
| FAIL | Any naming, typing, or error-handling violation |
