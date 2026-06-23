---
name: review
description: Multi-dimensional code review. Triggers on /forge:review or PR review. Correctness, security, performance, type safety, tests, standards.
allowed-tools: Read, Grep, Glob, Bash(git diff:*), Bash(git log:*)
---

# forge:review

## Checklist

| Category | Checks |
|----------|--------|
| Correctness | Logic errors, off-by-one, null, race conditions, edge cases |
| Security | Hardcoded secrets, SQLi, XSS, SSRF, missing auth, IDOR |
| Performance | N+1, unbounded loops, blocking async, memory leaks |
| Type safety | any, unsafe casts, missing return types, unvalidated input |
| Tests | Missing coverage, mocks hiding real behavior, no edge cases |
| Standards | Matches CLAUDE.md: naming, error handling, logging |

## Severity

| Level | Gate |
|-------|------|
| CRITICAL | Block merge |
| HIGH | Fix before merge |
| MEDIUM | Recommended |
| LOW | Optional |

## Output

```
[SEVERITY] category - Title
File: path:line
Problem: one sentence
Fix: concrete approach

Decision: BLOCK | REQUEST CHANGES | APPROVE WITH NOTES | APPROVE

Canonical verdict enum (use exactly these labels):
BLOCK: any CRITICAL finding
REQUEST CHANGES: any HIGH finding or validation failure
APPROVE WITH NOTES: only MEDIUM/LOW findings
APPROVE: no findings, validation passes
CRITICAL: N  HIGH: N  MEDIUM: N  LOW: N
```
