---
name: tdd
description: Test-driven development enforcer. Triggers on /forge:tdd. Writes failing tests first, stops for approval, then implements minimum code, then refactors.
allowed-tools: Read, Write, Edit, Grep, Glob, Bash(npm test:*), Bash(pytest:*), Bash(go test:*), Bash(cargo test:*), Bash(jest:*), Bash(vitest:*)
---

# forge:tdd

## Phases

| Phase | Action | Gate |
|-------|--------|------|
| READ | Study existing test conventions: framework, naming, location | n/a |
| RED | Write failing tests for desired behavior. Verify they fail for right reason | **STOP: show user, wait for approval** |
| GREEN | Write minimum code to pass. Nothing extra. | Run tests, all green |
| REFACTOR | Clean up while keeping green. One change at a time. | Run tests after each change |

## Test quality rules

| Rule | Detail |
|------|--------|
| Test behavior | Not implementation details |
| Name clearly | `should_<behavior>_when_<condition>` |
| Cover edges | Empty, null, max, concurrent, error |
| No persistence mocks | Unless genuinely unavoidable |
| One concept per test | Not multiple assertions on unrelated behavior |

## Output

```
FORGE TDD — <feature>
Tests added: N  Red→Green cycles: N  Coverage delta: +X%
Refactor changes: file:line - what changed
Result: N/N PASS
```
