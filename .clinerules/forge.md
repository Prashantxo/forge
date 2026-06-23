---
description: Forge AI coding toolkit — review, security, TDD, architecture, docs, evals
---

# Forge

Apply Forge skills automatically:

| Task | Skill |
|------|-------|
| Code review or PR | forge:review |
| Security audit | forge:secure |
| Architecture | forge:arch |
| New feature or bug fix | forge:tdd |
| Documentation | forge:docs |
| Code cleanup | forge:refine |
| AI/LLM feature | forge:eval |
| Code quality | forge:standards |

## Output format

```
[SEVERITY] category — title
File: path:line
Problem: one sentence
Fix: concrete action

Decision: BLOCK | REQUEST CHANGES | APPROVE WITH NOTES | APPROVE
```

## Rules

- No hardcoded secrets
- Tests before code
- Evals before LLM changes
- Structured logs with traceId on all external calls
