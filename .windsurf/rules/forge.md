---
trigger: always_on
---

# Forge — AI Coding Toolkit

Apply Forge skills automatically based on task context.

## Skills

| Task | Skill |
|------|-------|
| Code review, PR review | forge:review |
| Security audit | forge:secure |
| Architecture review or design | forge:arch |
| New feature or bug fix | forge:tdd |
| Documentation | forge:docs |
| Code cleanup | forge:refine |
| AI/LLM feature | forge:eval |
| Code quality check | forge:standards |

## Review output format

```
[SEVERITY] category — title
File: path:line
Problem: one sentence
Fix: concrete action

Decision: BLOCK | REQUEST CHANGES | APPROVE WITH NOTES | APPROVE
CRITICAL: N  HIGH: N  MEDIUM: N  LOW: N
```

## Hard rules

- No hardcoded secrets — environment variables only
- Tests required for all new functionality
- Evals required before changing any LLM prompt
- Human review before executing agent output
- Structured logs with traceId on all external calls
