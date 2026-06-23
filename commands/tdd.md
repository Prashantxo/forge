---
name: forge:tdd
description: "Forge TDD cycle: write failing tests first, get approval, implement, refactor"
argument-hint: [feature or bug description]
allowed-tools: Read, Write, Edit, Grep, Glob, Bash(npm test:*), Bash(pytest:*), Bash(go test:*), Bash(cargo test:*), Bash(jest:*), Bash(vitest:*)
---

> Read rules/model-adapter.md and select tier before starting.

**Input**: $ARGUMENTS (feature or bug to implement)

---

### Phase 1: READ CONVENTIONS
Read existing test files. Capture:
- Test framework in use (Jest, pytest, go test, etc.)
- Naming pattern (`describe/it`, `test_*`, `func Test*`)
- Where test files live
- Assertion style

### Phase 2: RED (failing tests)
Write tests that describe desired behavior from $ARGUMENTS.
- Test behavior, not implementation
- Name: `should_<behavior>_when_<condition>`
- Cover: happy path, error cases, edge cases (empty, max, concurrent)
- Verify tests **fail** for the right reason

```bash
<test command> 2>&1 | tail -20
```

**STOP HERE. Show tests to user. Do not implement until explicitly approved.**

### Phase 3: GREEN (minimum implementation)
Write the simplest code that makes Phase 2 tests pass.
No extra abstraction. No future-proofing. Pass the tests only.

```bash
<test command> 2>&1 | tail -10
```

All green → proceed. Any red → fix before Phase 4.

### Phase 4: REFACTOR
While keeping tests green:
- Remove duplication
- Improve naming
- Flatten nesting (early returns)
- Delete dead code

Run tests after **every change**. One logical change per step.

### Phase 5: REPORT

```
FORGE TDD — <feature>
=====================
Tests added: N
Red → Green cycles: N
Coverage delta: +X%
Refactor changes:
  - file:line: what changed
Final: all N tests PASS
```
