---
name: standards
description: Cross-project coding standards. Triggers on /forge:review or new module setup. Naming, typing, immutability, KISS/DRY/YAGNI, error handling, observability.
allowed-tools: Read, Grep, Glob
---

# forge:standards

## Naming

| Thing | Rule | Good | Bad |
|-------|------|------|-----|
| Variable | What it holds | `activeUserId` | `x`, `data` |
| Boolean | A question | `isAuthenticated` | `auth`, `flag` |
| Function | Verb + noun | `fetchUserById` | `userData`, `doStuff` |
| File | kebab-case | `user-profile.ts` | `UserProfile.ts` |

## Typing

| Rule | Detail |
|------|--------|
| No `any` | No `object`. No untyped returns. |
| Define types first | Before writing function bodies |
| Discriminated unions | For state machines, not boolean flags |

## Principles

| Principle | Rule |
|-----------|------|
| KISS | Simplest solution that passes the tests |
| DRY | 3+ identical blocks → extract a function |
| YAGNI | No abstractions for hypothetical future use |
| Immutability | `const` by default. Never mutate arguments. |

## Error handling

| Rule | Detail |
|------|--------|
| Carry context | What failed, with what input, why |
| No silent swallow | Never `catch (e) {}` |
| 400 vs 500 | User errors vs system errors, never conflate |
| Structured logs | `{ event, userId, input, error }`, no `console.log` in prod |

## Observability (every cross-boundary call)

```
log: { event: "action.start",   traceId, input }
log: { event: "action.success", traceId, durationMs }
log: { event: "action.failed",  traceId, err }
metric: increment action.calls, action.errors
```

Thread `traceId` through every log line.

## Review checklist

- [ ] Names describe what things hold, not how they got there
- [ ] No `any`, no implicit `unknown`
- [ ] No argument mutation
- [ ] No silent error swallowing
- [ ] No dead code or commented-out blocks
- [ ] Structured logs on all external calls
- [ ] Tests for every new function
