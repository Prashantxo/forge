---
name: forge:refine
description: "Forge code refiner: simplify changed code without altering behavior"
argument-hint: [file path | blank for changed files]
allowed-tools: Read, Write, Edit, Grep, Glob, Bash(git diff:*)
---

> Read rules/model-adapter.md and select tier before starting.

**Input**: $ARGUMENTS (optional: specific file to refine)

---

### Phase 1: SCOPE
```bash
# $ARGUMENTS given: refine that file
# Else: refine recently changed files
git diff --name-only HEAD
```

### Phase 2: READ
Read each target file in full. Identify:
- Duplication (3+ identical blocks)
- Bad names (abbreviations, single letters, misleading verbs)
- Deep nesting (> 3 levels)
- Dead code (unused vars, unreachable branches, commented blocks)
- Inconsistencies with surrounding code style

### Phase 3: REFINE
Apply changes in this order (one type per commit):
1. Extract duplicated logic → named function
2. Rename unclear identifiers
3. Flatten nesting with early returns
4. Delete dead code
5. Align with project conventions

Run tests after each change:
```bash
<test command> 2>/dev/null
```
Any failure → revert that change, move to next item.

### Phase 4: REPORT

```
FORGE REFINE — <files>
======================
Changes:
  file:line - what changed and why
  ...
Tests: PASS (N tests)
Behavior: unchanged
```
