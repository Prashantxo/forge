---
name: forge:docs
description: "Forge documentation generator: README, API reference, architecture doc, or runbook. Reads actual code."
argument-hint: [target file/module | blank for README]
allowed-tools: Read, Write, Grep, Glob, Bash(git log:*)
---

> Read rules/model-adapter.md and select tier before starting.

**Input**: $ARGUMENTS (optional: path or doc type)

---

### Phase 1: READ
Read the target code. Never document behavior you haven't verified.
```bash
git log --oneline -10  # recent context
```

### Phase 2: SELECT DOC TYPE
| Trigger | Type |
|---------|------|
| $ARGUMENTS blank or "readme" | README |
| $ARGUMENTS is a function/class path | API reference |
| $ARGUMENTS is "arch" | Architecture doc |
| $ARGUMENTS is "runbook" | Runbook |

### Phase 3: GENERATE

**README** structure:
1. One-line description (what it does, not what it is)
2. Problem it solves (why it exists)
3. Quick start: working in under 2 min
4. Key features (3-5 bullets, no marketing fluff)
5. Configuration reference (table: var, type, default, description)
6. Contributing guide

**API reference** per function/endpoint:
- Signature with types
- What it does (behavior, not implementation)
- Parameters: name, type, required, description
- Return value with type and example
- Error cases with codes
- Working code example (must run as-is)

**Architecture doc**:
- ASCII diagram
- Component responsibilities (1 sentence each)
- Data flows
- External dependencies with versions
- Key design decisions (link to ADRs)

**Runbook** per operation:
- When to use
- Prerequisites
- Numbered steps with exact commands
- Expected output at each step
- Rollback procedure
- Escalation path

### Phase 4: VALIDATE
Every code block: confirm it runs. Every API example: confirm params match source.
No TODO placeholders. No guessed behavior.
