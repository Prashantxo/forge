---
name: refine
description: Code simplification without behavior change. Triggers on /forge:refine. Removes duplication, improves naming, flattens nesting, deletes dead code.
allowed-tools: Read, Write, Edit, Grep, Glob, Bash(git diff:*)
---

# forge:refine

## What to fix

| Issue | Action |
|-------|--------|
| 3+ identical blocks | Extract named function |
| Unclear name | Rename to describe what it holds/does |
| Nesting > 3 levels | Flatten with early returns |
| Boolean flag arg | Split into two functions |
| Function > 30 lines | Extract named sub-functions |
| Commented-out code | Delete (lives in git) |
| Unused imports/vars | Delete |
| Inconsistent style | Align to surrounding code |

## Process

- One type of change per step
- Run tests after each step
- On failure: revert that step, move on
- Scope: only changed files unless asked

## Output

```
FORGE REFINE - <files>
file:line - what changed and why
Tests: N PASS  Behavior: unchanged
```
