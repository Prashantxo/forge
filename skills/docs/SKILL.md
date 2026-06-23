---
name: docs
description: Documentation generation. Triggers on /forge:docs. Reads actual code to produce README, API reference, architecture doc, or runbook. Never guesses.
allowed-tools: Read, Write, Grep, Glob, Bash(git log:*)
---

# forge:docs

## Doc type

| Trigger | Output |
|---------|--------|
| Blank or "readme" | README |
| Function/class path | API reference |
| "arch" | Architecture doc |
| "runbook" | Runbook |

## README sections

| Section | Rule |
|---------|------|
| Description | One line: what it does (not what it is) |
| Why | Problem solved (mandatory) |
| Quick start | Working in < 2 min, exact commands |
| Features | 3-5 bullets, no marketing words |
| Config | Table: variable / type / default / description |
| Contributing | How to add skill, agent, command |

## API reference (per function)

Signature with full types, behavior (what not how), params (name/type/required/desc), returns (type+example), errors (all codes), working example (runs as-is).

## Quality gates

- Every code block has language tag and actually runs
- No TODO placeholders
- Version-pin all install commands
- Verify every behavior before documenting it
